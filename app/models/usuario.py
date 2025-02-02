class User(object):
    """
    Classe Usuário que representa um usuário do sistema
    """
    def __init__(self, email, password, name, xp):
        self.email = email
        self.password = password
        self.name = name
        self.xp = xp
    