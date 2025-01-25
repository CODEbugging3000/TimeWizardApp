from queue import Empty
import sqlite3
class BancodeDados:
    _instance = None  # Singleton para garantir uma única conexão
    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super().__new__(cls, *args, **kwargs)
            cls._instance._conn = sqlite3.connect('meu_banco.db')
            cls._instance._cursor = cls._instance._conn.cursor()
        return cls._instance

    def criar_tabelas(self):
        self._cursor.execute("""
            CREATE TABLE IF NOT EXISTS usuarios (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                email TEXT NOT NULL,
                senha TEXT NOT NULL,
                nome TEXT NOT NULL
            )
        """)
        self._cursor.execute("""
            CREATE TABLE IF NOT EXISTS sessoes (
                section_id TEXT PRIMARY KEY,
                email TEXT,
                FOREIGN KEY (email) REFERENCES usuarios (email)
            )
        """)
        self._conn.commit()

    def cadastrar_usuario(self, email, senha, nome):
        try:
            self._cursor.execute("INSERT INTO usuarios (email, senha, nome) VALUES (?, ?, ?)", (email, senha, nome))
            self._conn.commit()
            self.criar_tabela_de_tarefas(email)
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
        if self._cursor.fetchone() is Empty:
            return ""
        else:
            return section_id[0]

    def criar_tabela_de_tarefas(self, email):
        email = self.email_split(email)
        self._cursor.execute(f"""
            CREATE TABLE IF NOT EXISTS tarefas_de_{email} (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                titulo TEXT,
                descricao TEXT,
                prioridade TEXT,
                tempo INTEGER,
                data_limite DATETIME,
                tags TEXT
            )
        """)
        self._conn.commit()

    def inserir_tarefa(self, email, titulo, descricao, prioridade, tempo, data_limite, tags):
        email = self.email_split(email)
        self._cursor.execute(f"""
            INSERT INTO tarefas_de_{email} (titulo, descricao, prioridade, tempo, data_limite, tags)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (titulo, descricao, prioridade, int(tempo), data_limite, tags))
        self._conn.commit()

    def get_email_by_section_id(self, section_id):
        self._cursor.execute("SELECT email FROM sessoes WHERE section_id = ?", (section_id,))
        return self._cursor.fetchone()[0]

    def email_split(self, email):
        for i in email:
            if i == "@":
                email = email.split("@")[0]
        return email
    
    def listar_tarefas(self, email):
        email = self.email_split(email)
        self._cursor.execute(f"SELECT * FROM tarefas_de_{email}")
        return self._cursor.fetchall() # retorna lista com tuplas