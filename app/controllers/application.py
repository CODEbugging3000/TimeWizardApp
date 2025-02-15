from datetime import datetime
from bottle import template
import uuid

from ..models.habito import Habito
from .SQLite import BancodeDados
from ..models.tarefa import Tarefa
from ..models.usuario import User


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
        self._db.criar_tabelas()

    def render(self,page, **kwargs):
        content = self.pages.get(page, self.helper)
        return content(**kwargs)

    def helper(self):
        return template('app/views/html/helper')

    def index(self):
        return template('app/views/html/index')
    
    def login(self):
        return template('app/views/html/login')
    
    def home(self, section_id):
        return template('app/views/html/home', tarefas = self.listar_tarefas(section_id), habitos = self.listar_habitos(section_id), user = self.dados_do_usuario(section_id)) # passa o metodo listar_tarefas e listar_habitos que retornam uma lista de objetos
    
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

    def verify_section_id(self, section_id):
        return self._db.get_id(section_id)
    
    def add_tarefa(self, section_id, titulo, description, prioridade, tempo, data_limite, tags):
        tarefa = Tarefa(id, titulo, description, prioridade, tempo, data_limite, tags, "todo")
        if self.verify_section_id(section_id) == "":
            return False
        else:
            email = self._db.get_email_by_section_id(section_id)
            self._db.inserir_tarefa(email, tarefa.titulo, tarefa.description, tarefa.prioridade, tarefa.tempo, tarefa.data_limite, tarefa.tags, tarefa.status, tarefa.xp)
            return True
    
    def listar_tarefas(self, section_id):
        email = self._db.get_email_by_section_id(section_id)
        tarefas = self._db.listar_tarefas(email) # retorna uma lista de tuplas 
        # Converte tuplas para objetos Tarefa
        lista_tarefas = []
        for tarefa in tarefas:
            data_limite_formatada = datetime.strptime(tarefa[6], "%Y-%m-%dT%H:%M").strftime("%d/%m/%Y - %H:%M")
            lista_tarefas.append(
                Tarefa(
                    id=tarefa[0],
                    # pula o email
                    titulo=tarefa[2],
                    description=tarefa[3],
                    prioridade=tarefa[4],
                    tempo=tarefa[5],
                    data_limite=data_limite_formatada,  # Data formatada
                    tags=tarefa[7],
                    status=tarefa[8],
                )
            )
        return lista_tarefas

    def add_habito(self, section_id, id_tarefa, dias_da_semana, horario):
        habito = Habito(id, id_tarefa, dias_da_semana, horario)
        if self.verify_section_id(section_id) == "":
            return False
        else:
            return self._db.inserir_habito(habito.id_tarefa, habito.dias_da_semana, habito.horario)

    def listar_habitos(self, section_id):
        habitos = self._db.listar_habitos(section_id)
        lista_de_habitos = []
        for habito in habitos:
            lista_de_habitos.append(
                Habito(
                    id_habito=habito[0],
                    id_tarefa=habito[1],
                    dias_da_semana=habito[2],
                    horario=habito[3]
                )
            )
        return lista_de_habitos # retorna uma lista de objetos Habito 

    def dados_do_usuario(self, section_id):
        email = self._db.get_email_by_section_id(section_id)
        tupla_usuario = self._db.get_usuario(email)
        user = User(tupla_usuario[1], tupla_usuario[2], tupla_usuario[3], tupla_usuario[4]) # email, senha, nome e xp
        return user

    def logout(self, section_id):
        if self._db.delete_session(section_id):
            return True
        else:
            return False
        
    
    def delete_tarefa(self, section_id, id_tarefa):
        email = self._db.get_email_by_section_id(section_id)
        return self._db.delete_tarefa(email, id_tarefa)
    

    def edit_tarefa(self, section_id, id_tarefa, titulo, description, prioridade, tempo, data_limite, tags):
        email = self._db.get_email_by_section_id(section_id)
        return self._db.edit_tarefa(email, id_tarefa, titulo, description, prioridade, tempo, data_limite, tags)