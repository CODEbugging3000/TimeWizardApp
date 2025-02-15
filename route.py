#TODO: Implementar websocket
#TODO: Arrumar edição das tarefas
#TODO: Fazer troca de status das tarefas
#TODO: Implementar encriptação de senhas
#TODO: Arrumar cadastro e login seguros
#TODO: Fazer a gamificação

from app.controllers.application import Application
from bottle import Bottle, route, run, request, static_file
from bottle import redirect, template, response

app = Bottle()
ctl = Application()

#-----------------------------------------------------------------------------
# Rotas:

@app.route('/static/<filepath:path>')
def serve_static(filepath):
    return static_file(filepath, root='./app/static')

@app.route('/helper')
def helper(info= None):
    return ctl.render('helper')

#-----------------------------------------------------------------------------
# Suas rotas aqui:
@app.route('/')
def index():
    return ctl.render('index')

@app.route('/login')
def login():
    return ctl.render('login')

@app.post('/login')
def do_login():
    email = request.forms.email
    senha = request.forms.password
    login = ctl.checar_login(email, senha)
    if login:
        response.set_cookie('account', login[1])
        return redirect('home') # Usuário encontrado e senha correta
    elif login is None:
        return """<h1 style="color:red; text-align: center;">Usuário não encontrado</h1> <div style="text-align: center; align-items: center;"><a href="/login">login</a> <br> <a href="/cadastrar">cadastrar</a></div>""" # Usuário não encontrado
    else:
        return """<h1 style="color:red;">Senha incorreta</h1> <a href="/login">login</a>""" # Usuário encontrado, mas senha incorreta

@app.route('/cadastrar')
def cadastrar():
    return ctl.render('cadastrar')

@app.post('/cadastrar')
def do_cadastrar():
    email = request.forms.email
    senha = request.forms.password
    nome = request.forms.nome
    cadastrou = ctl.fazer_cadastro(email, senha, nome)
    if cadastrou:
        return ctl.render('login')
    else:
        return """<h1 style='color:red;'>Usuário já cadastrado</h1><a href="/login">login</a>"""

@app.route('/home')
def home():
    # Verifica se o usuário está logado
    if 'account' in request.cookies:
        section_id = request.cookies.get('account')
        if ctl.verify_section_id(section_id) != "":
            # Passa o section_id para o método home
            return ctl.render('home', section_id=section_id)
        else: # Caso o usuário não esteja logado
            return """<h1 style='color:red;'>Você não está logado!</h1><a href="/login">Fazer login</a>"""

@app.post('/add-tarefa')
def add_tarefa():
    titulo = request.forms.titulo
    description = request.forms.descricao
    prioridade = request.forms.prioridade
    tempo = request.forms.tempo
    data_limite = request.forms.data_limite
    tags = request.forms.tags
    added = ctl.add_tarefa(request.cookies['account'], titulo, description, prioridade, tempo, data_limite, tags)
    if added:
        return ctl.render('home', section_id=request.cookies['account'])
    else:
        return """<h1 style='color:red;'>Erro ao adicionar tarefa</h1><a href="/home">Voltar</a>"""

@app.post('/add-habito')
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
    added = ctl.add_habito(request.cookies['account'], id_tarefa, dias, horario)
    if added:
        return ctl.render('home', section_id=request.cookies['account'])
    else:
        return """<h1 style='color:red;'>Erro ao adicionar tarefa</h1><a href="/home">Voltar</a>"""

@app.post('/delete-tarefa')
def delete_tarefa():
    id_tarefa = request.forms.tarefa_id
    deleted = ctl.delete_tarefa(request.cookies['account'], id_tarefa)
    if deleted:
        return ctl.render('home', section_id=request.cookies['account'])
    else:
        return """<h1 style='color:red;'>Erro ao deletar tarefa</h1><a href="/home">Voltar</a>"""

@app.post('/edit-tarefa')
def edit_tarefa():
    id_tarefa = request.forms.tarefa_id
    titulo = request.forms.titulo
    description = request.forms.descricao
    prioridade = request.forms.prioridade
    tempo = request.forms.tempo
    data_limite = request.forms.data_limite
    tags = request.forms.tags

    edited = ctl.edit_tarefa(request.cookies['account'], id_tarefa, titulo, description, prioridade, tempo, data_limite, tags)
    if edited:
        return ctl.render('home', section_id=request.cookies['account'])
    else:
        return """<h1 style='color:red;'>Erro ao editar tarefa</h1><a href="/home">Voltar</a>"""


@app.route('/logout')
def logout():
    if ctl.logout(request.cookies['account']):
        response.delete_cookie('account')
        return redirect('/')
    else:
        return """<h1 style='color:red;'>Erro ao fazer logout</h1><a href="/home">Voltar</a>"""
#--------------------------------------------------------------------------------


if __name__ == '__main__':
    run(app, host='0.0.0.0', port=8080, debug=True, reloader=True)
