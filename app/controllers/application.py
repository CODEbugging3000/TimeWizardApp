from bottle import template
from .SQLite import BancodeDados
import uuid

class Application():

    def __init__(self):
        self.pages = {
            'helper': self.helper,
            'index': self.index,
            'login': self.login,
            'cadastrar': self.cadastrar,
            'home': self.home
        }
        self._db = BancodeDados()

    def render(self,page):
        content = self.pages.get(page, self.helper)
        return content()

    def helper(self):
        return template('app/views/html/helper')

    def index(self):
        return template('app/views/html/index')
    
    def login(self):
        return template('app/views/html/login')
    
    def home(self):
        return template('app/views/html/home')

    def cadastrar(self):
        return template('app/views/html/cadastrar')

    def checar_login(self, email, senha):
        verify = self._db.check_login(email, senha)
        if type(verify) is tuple:
            user = verify[0]
            password = verify[1]
            if user == email and password == senha:
                section_id = str(uuid.uuid4())
                self._db.insert_session(section_id, user)
                return True, section_id # Usuário encontrado e senha correta
            else:
                return [False] # Usuário encontrado, mas senha incorreta
        elif verify[0] is None:
            return None # Usuário não encontrado
        else:
            return False # Usuário encontrado, mas senha incorreta

    def fazer_cadastro(self, email, senha, nome):
        verify = self._db.verificar_usuario(email, senha)
        if type(verify) is tuple:
            return False # Usuário já cadastrado
        else:
            return self._db.cadastrar_usuario(email, senha, nome)
