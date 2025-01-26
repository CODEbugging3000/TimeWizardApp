class User(object):
    """
    Classe Usuário que representa um usuário do sistema
    """
    def __init__(self, name, password, email, xp):
        self.name = name
        self.email = email
        self.password = password
        self.xp = xp
    