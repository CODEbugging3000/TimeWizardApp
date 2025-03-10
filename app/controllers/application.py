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

    def render(self, page, **kwargs):
        content = self.pages.get(page, self.helper)
        return content(**kwargs)

    def helper(self):
        return template('app/views/html/helper')

    def index(self):
        return template('app/views/html/index')
    
    def login(self, error_mesage = None):
        return template('app/views/html/login', error_mesage = error_mesage)
    
    def home(self, section_id, error_mesage = None):
        return template('app/views/html/home', tarefas = self.listar_tarefas(section_id), habitos = self.listar_habitos(section_id), user = self.dados_do_usuario(section_id), error_mesage = error_mesage) # passa o metodo listar_tarefas e listar_habitos que retornam uma lista de objetos
    
    def cadastrar(self, error_mesage = None):
        return template('app/views/html/cadastrar', error_mesage = error_mesage)

    def checar_login(self, email, senha):
        verify = self._db.check_login(email, senha)
        if type(verify) is tuple:
            user = verify[0]
            section_id = str(uuid.uuid4())
            self._db.insert_session(section_id, user)
            return True, section_id # Usuário encontrado e senha correta
        else:
            return False # Usuário ou senha incorretos
        
    def fazer_cadastro(self, email, senha, nome):
        verify = self._db.usuario_ja_existe(email)
        if not verify:
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
        task = self._db.get_tarefa(id_tarefa)
        tarefa = Tarefa(task[0], task[1], task[2], task[3], task[4], task[5], task[6], task[7])
        habito = Habito(id, tarefa, dias_da_semana, horario)
        if self.verify_section_id(section_id) == "":
            return False
        else:
            return self._db.inserir_habito(habito.tarefa.id, habito.dias_da_semana, habito.horario)

    def listar_habitos(self, section_id):
        habitos = self._db.listar_habitos(section_id)
        lista_de_habitos = []
        
        for habito in habitos:
            lista_de_habitos.append(
                Habito(
                    id_habito=habito[0],
                    tarefa = Tarefa(habito[1], "", "", "", "", "", "", ""),
                    dias_da_semana=habito[2],
                    horario=habito[3]
                )
            )
        return lista_de_habitos # retorna uma lista de objetos Habito 

    def dados_do_usuario(self, section_id):
        email = self._db.get_email_by_section_id(section_id)
        tupla_usuario = self._db.get_usuario(email)
        user = User(tupla_usuario[1], "", tupla_usuario[3], tupla_usuario[4]) # email, senha, nome e xp
        return user

    def logout(self, section_id):
        if self._db.delete_session(section_id):
            return True
        else:
            return False
        

    def edit_tarefa(self, section_id, id_tarefa, titulo, description, prioridade, tempo, data_limite, tags):
        email = self._db.get_email_by_section_id(section_id)
        return self._db.edit_tarefa(email, id_tarefa, titulo, description, prioridade, tempo, data_limite, tags)

    def start_task(self, user, id_tarefa):
        return self._db.start_task(user, id_tarefa)

    def finish_task(self, user, id_tarefa):
        updated = self._db.finish_task(user, id_tarefa)
        if updated:
            xp_tarefa = self._db.get_xp_from_tarefa(id_tarefa)
            self._db.add_xp(user, xp_tarefa)
        return updated
    
    def recycle_task(self, user, id_tarefa):
        return self._db.recycle_task(user, id_tarefa)
    
    def delete_task(self, user, id_tarefa):
        return self._db.delete_task(user, id_tarefa)

    def get_xp_user(self, user):
        return self._db.get_xp_user(user)