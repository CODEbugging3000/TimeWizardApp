from app.controllers.application import Application
from bottle import Bottle, route, run, request, static_file
from bottle import redirect, template, response
from app.controllers.SQLite import BancodeDados

app = Bottle()
ctl = Application()
DB = BancodeDados()
DB.criar_tabelas()
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
        response.set_cookie('account', email)
        return redirect('home') # Usuário encontrado e senha correta
    elif login is None:
        return ctl.render('login') # Usuário não encontrado
    else:
        return ctl.render('<h1 style="color:red;">Senha incorreta</h1>') # Usuário encontrado, mas senha incorreta

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
        return "<h1 style='color:red;'>Usuário ja cadastrado</h1>"

@app.route('/home', method=["GET", "POST"])
def home():
    if request.method == "GET":
        if 'account' in request.cookies:
            return ctl.render('home')
        else:
            return "<h1 style='color:red;'>Voce nao esta logado</h1>"
    elif request.method == "POST":
        pass

#-----------------------------------------------------------------------------


if __name__ == '__main__':
    run(app, host='0.0.0.0', port=8080, debug=True, reloader=True)
