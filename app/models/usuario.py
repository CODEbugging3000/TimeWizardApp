from bcrypt import hashpw, gensalt
class User:
    """
    Classe Usuário que representa um usuário do sistema
    """
    def __init__(self, email, password, name, xp):
        self.email = email
        self.password = self.__criptografar_senha(password)
        self.name = name
        self.xp = xp
    
    def __criptografar_senha(self, password: str) -> bytes:
        password = password.encode('utf-8')
        salt = gensalt()
        password = hashpw(password, salt)
        return password

    def __str__(self):
        return f"Usuário: {self.name} - Email: {self.email} - XP: {self.xp}"