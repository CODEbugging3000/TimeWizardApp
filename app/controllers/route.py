#TODO: Fazer a gamificação
#TODO: Arrumar as Models com relacionamento entre habitos e tarefas

from app.controllers.application import Application
from bottle import Bottle, route, run, request, static_file, redirect, template, response
import socketio

#-----------------------------------------------------------------------------
# Rotas:
class App:
    """
    Classe Geral da Aplicação
    """
    def __init__(self):
        # Initialize Bottle
        self.app = Bottle()
        self.setup_routes()
        self.ctl = Application()

        # Initialize Socket.IO server
        self.sio = socketio.Server(async_mode='eventlet')
        self.setup_websocket_events()

        # Create WSGI app
        self.wsgi_app = socketio.WSGIApp(self.sio, self.app)

    def setup_routes(self):
        @self.app.route('/static/<filepath:path>')
        def serve_static(filepath):
            return static_file(filepath, root='./app/static')
        @self.app.route('/helper')
        def helper(info= None):
            return self.ctl.render('helper')
        #-----------------------------------------------------------------------------
        # Suas rotas aqui:
        @self.app.route('/')
        def index():
            return self.ctl.render('index')

        @self.app.route('/login')
        def login():
            return self.ctl.render('login')

        @self.app.post('/login')
        def do_login():
            email = request.forms.email
            senha = request.forms.password
            login = self.ctl.checar_login(email, senha)
            if login:
                response.set_cookie('account', login[1], httponly=True, secure=True, max_age=3600)
                return redirect('home') # Usuário encontrado e senha correta
            else:
                return """<h1 style="color:red; text-align: center;">Usuário ou senha incorretos</h1> <div style="text-align: center; align-items: center;"><a href="/login">login</a> <br> <a href="/cadastrar">cadastrar</a></div>""" # Usuário não encontrado

        @self.app.route('/cadastrar')
        def cadastrar():
            return self.ctl.render('cadastrar')

        @self.app.post('/cadastrar')
        def do_cadastrar():
            email = request.forms.email
            senha = request.forms.password
            nome = request.forms.nome
            cadastrou = self.ctl.fazer_cadastro(email, senha, nome)
            if cadastrou:
                return self.ctl.render('login')
            else:
                return """<h1 style='color:red;'>Usuário já cadastrado</h1><a href="/login">login</a>"""

        @self.app.route('/home')
        def home():
            # Verifica se o usuário está logado
            if 'account' in request.cookies:
                section_id = request.cookies.get('account')
                if self.ctl.verify_section_id(section_id) != "":
                    # Passa o section_id para o método home
                    return self.ctl.render('home', section_id=section_id)
                else: # Caso o usuário não esteja logado
                    return """<h1 style='color:red;'>Você não está logado!</h1><a href="/login">Fazer login</a>"""
            else:
                return """<h1 style='color:red;'> Vocé não está logado!</h1><a href="/login">Fazer login</a>"""

        @self.app.post('/add-tarefa')
        def add_tarefa():
            titulo = request.forms.titulo
            description = request.forms.descricao
            prioridade = request.forms.prioridade
            tempo = request.forms.tempo
            data_limite = request.forms.data_limite
            tags = request.forms.tags
            if request.cookies.get('account') is None:
                return """<h1 style='color:red;'>Erro ao adicionar tarefa</h1><a href="/home">Voltar</a>"""
            else:
                added = self.ctl.add_tarefa(request.cookies['account'], titulo, description, prioridade, tempo, data_limite, tags)
                if added:
                    return self.ctl.render('home', section_id=request.cookies['account'])
                else:
                    return """<h1 style='color:red;'>Erro ao adicionar tarefa</h1><a href="/home">Voltar</a>"""

        @self.app.post('/add-habito')
        def add_habito():
            id_tarefa = request.forms.tarefa_id
            segunda = request.forms.segunda
            terca = request.forms.terca
            quarta = request.forms.quarta
            quinta = request.forms.quinta
            sexta = request.forms.sexta
            sabado = request.forms.sabado
            domingo = request.forms.domingo
            dias_da_semana = [segunda, terca, quarta, quinta, sexta, sabado, domingo]
            dias = ""
            for dia in dias_da_semana:
                if dia != "":
                    dias = dias + ", " + dia
            dias = dias[1:]
            horario = request.forms.horario
            added = self.ctl.add_habito(request.cookies['account'], id_tarefa, dias, horario)
            if added:
                return self.ctl.render('home', section_id=request.cookies['account'])
            else:
                return """<h1 style='color:red;'>Erro ao adicionar tarefa</h1><a href="/home">Voltar</a>"""

        @self.app.post('/edit-tarefa')
        def edit_tarefa():
            id_tarefa = request.forms.tarefa_id
            titulo = request.forms.titulo
            description = request.forms.descricao
            prioridade = request.forms.prioridade
            tempo = request.forms.tempo
            data_limite = request.forms.data_limite
            tags = request.forms.tags
            edited = self.ctl.edit_tarefa(request.cookies['account'], id_tarefa, titulo, description, prioridade, tempo, data_limite, tags)
            if edited:
                return self.ctl.render('home', section_id=request.cookies['account'])
            else:
                return """<h1 style='color:red;'>Erro ao editar tarefa</h1><a href="/home">Voltar</a>"""

        @self.app.route('/logout')
        def logout():
            if self.ctl.logout(request.cookies['account']):
                response.delete_cookie('account')
                return redirect('/')
            else:
                return """<h1 style='color:red;'>Erro ao fazer logout</h1><a href="/home">Voltar</a>"""
        #--------------------------------------------------------------------------------

    def setup_websocket_events(self):
        @self.sio.event
        async def connect(sid, environ):
            print(f'Client connected: {sid}')
            self.sio.emit('connected', {'data': 'Connected'}, room=sid)

        @self.sio.event
        async def disconnect(sid):
            print(f'Client disconnected: {sid}')

        @self.sio.event
        def start_task(sid, user,taskid):
            if self.ctl.start_task(user, taskid):
                self.sio.emit('task_started', {'task_id': taskid, 'data': 'Task started'}, room=sid)


        @self.sio.event
        def finish_task(sid, user, taskid):
            if self.ctl.finish_task(user, taskid):
                self.sio.emit('task_finished', {'task_id': taskid, 'data': 'Task finished'}, room=sid)
    
        @self.sio.event
        def recycle_task(sid, user, taskid):
            if self.ctl.recycle_task(user, taskid):
                self.sio.emit('recycle_task', {'task_id': taskid, 'data': 'Task recycled'}, room=sid)

        @self.sio.event
        def delete_task(sid, user, taskid):
            if self.ctl.delete_task(user, taskid):
                self.sio.emit('task_deleted', {'task_id': taskid, 'data': 'Task deleted'}, room=sid)

        @self.sio.event
        def edit_task(sid, user, taskid):
            if self.ctl.edit_tarefa():
                self.sio.emit('task_edited', {'task_id': taskid, 'data': 'Task deleted'}, room=sid)