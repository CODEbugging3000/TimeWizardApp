import sqlite3
from bcrypt import hashpw, gensalt, checkpw
class BancodeDados:
    _instance = None  # Singleton para garantir uma única conexão
    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super().__new__(cls, *args, **kwargs)
            cls._instance._conn = sqlite3.connect('app/controllers/db/meu_banco.db')
            cls._instance._cursor = cls._instance._conn.cursor()
        return cls._instance

    def criar_tabelas(self):
        self._cursor.execute("""
            CREATE TABLE IF NOT EXISTS usuarios (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                email TEXT NOT NULL,
                senha TEXT NOT NULL,
                nome TEXT NOT NULL,
                xp INTEGER DEFAULT 0 -- XP inicia em 0
            )
        """)
        self._cursor.execute("""
            CREATE TABLE IF NOT EXISTS sessoes (
                section_id TEXT PRIMARY KEY,
                email TEXT,
                FOREIGN KEY (email) REFERENCES usuarios (email)
            )
        """)
        self._cursor.execute("""
            CREATE TABLE IF NOT EXISTS tarefas(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                email TEXT NOT NULL,
                titulo TEXT,
                descricao TEXT,
                prioridade TEXT,
                tempo INTEGER,
                data_limite DATETIME,
                tags TEXT,
                status TEXT,
                xp INTEGER
            )
        """)
        self._cursor.execute("""
            CREATE TABLE IF NOT EXISTS habitos (
                id_habito INTEGER PRIMARY KEY AUTOINCREMENT,
                id_tarefa INTEGER,
                dias_da_semana TEXT,
                horario TEXT,
                FOREIGN KEY (id_tarefa) REFERENCES tarefas (id)
            )
        """)
        self._conn.commit()

    def cadastrar_usuario(self, email, senha, nome):
        try:
            self._cursor.execute("INSERT INTO usuarios (email, senha, nome) VALUES (?, ?, ?)", (email, senha, nome))
            self._conn.commit()
            return True
        except sqlite3.IntegrityError:
            return False

    def verificar_usuario(self, email, senha):
        self._cursor.execute("SELECT email, senha FROM usuarios WHERE email = ? AND senha = ?", (email, senha))
        resposta = self._cursor.fetchone()
        if type(resposta) is tuple:
            return resposta
        else:
            return None

    def usuario_ja_existe(self, email):
        self._cursor.execute("SELECT * FROM usuarios WHERE email = ?", (email,))
        if self._cursor.fetchone() is None:
            return False
        else:
            return True

    def fechar_conexao(self):
        self._conn.close()
        BancodeDados._instance = None

    def check_login(self, email, senha):
        verify = self.verificar_usuario(email, senha)
        if verify:
            user = self.verificar_usuario(email, senha)[0]
            password = self.verificar_usuario(email, senha)[1]
            return (user, password)
        else:
            return [None] # Usuário não encontrado

    def insert_session(self, section_id, user):
        self._cursor.execute("INSERT INTO sessoes (section_id, email) VALUES (?, ?)", (section_id, user))
        self._conn.commit()

    def get_id(self, section_id):
        self._cursor.execute("SELECT section_id FROM sessoes WHERE section_id = ?", (section_id,))
        if type(self._cursor.fetchone()) is not tuple:
            return ""
        else:
            return section_id[0]

    def inserir_tarefa(self, email, titulo, descricao, prioridade, tempo, data_limite, tags, status, xp):
        self._cursor.execute("""
            INSERT INTO tarefas (email, titulo, descricao, prioridade, tempo, data_limite, tags, status, xp)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (email, titulo, descricao, prioridade, int(tempo), data_limite, tags, status, xp))
        self._conn.commit()

    def get_email_by_section_id(self, section_id):
        self._cursor.execute("SELECT email FROM sessoes WHERE section_id = ?", (section_id,))
        result = self._cursor.fetchone()
        if result is None:
            return None
        else:
            return result[0]

    def listar_tarefas(self, email):
        self._cursor.execute(f"SELECT * FROM tarefas WHERE email = '{email}'")
        return self._cursor.fetchall() # retorna lista com tuplas

    def inserir_habito(self, id_tarefa, dias_da_semana, horario):
        try:
            self._cursor.execute("""
                INSERT INTO habitos (id_tarefa, dias_da_semana, horario)
                VALUES (?, ?, ?)
            """, (id_tarefa, dias_da_semana, horario))
            self._conn.commit()
            return True
        except sqlite3.IntegrityError:
            return False

    def listar_habitos(self, section_id):
        email = self.get_email_by_section_id(section_id)
        self._cursor.execute(
        "SELECT * FROM habitos WHERE id_tarefa IN (SELECT id FROM tarefas WHERE email = ?)", (email,)
        )
        resposta = self._cursor.fetchall()
        return resposta
    
    def get_usuario(self, email):
        self._cursor.execute("SELECT * FROM usuarios WHERE email = ?", (email,))
        return self._cursor.fetchone()

    def delete_session(self, section_id):
        try:
            self._cursor.execute("DELETE FROM sessoes WHERE section_id = ?", (section_id,))
            self._conn.commit()
            return True
        except sqlite3.IntegrityError:
            return False
        
    def delete_tarefa(self, email, id_tarefa):
        try:
            self._cursor.execute("DELETE FROM tarefas WHERE email = ? AND id = ?", (email, id_tarefa))
            self._conn.commit()
            return True
        except sqlite3.IntegrityError:
            return False
        
    def edit_tarefa(self, email, id_tarefa, titulo, descricao, prioridade, tempo, data_limite, tags):
        try:
            self._cursor.execute("""
                UPDATE tarefas
                SET titulo = ?, descricao = ?, prioridade = ?, tempo = ?, data_limite = ?, tags = ?
                WHERE email = ? AND id = ?
            """, (titulo, descricao, prioridade, int(tempo), data_limite, tags, email, id_tarefa))
            self._conn.commit()
            return True
        except sqlite3.IntegrityError:
            return False
        