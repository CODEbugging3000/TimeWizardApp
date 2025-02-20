class Tarefa:
    """
    Objeto do tipo Tarefa para armazenamento de tarefas
    """
    def __init__(self, id, titulo, description, prioridade, tempo, data_limite, tags, status):
        self.id = id
        self.titulo = titulo
        self.description = description
        self.prioridade = prioridade
        self.tempo = tempo
        self.data_limite = data_limite
        self.tags = tags
        self.status = status
        self.xp = self.calcular_xp(self.prioridade.lower())

    def calcular_xp(self, prioridade):
        if prioridade == "muito baixa":
            return 5
        elif prioridade == "baixa":
            return 10
        elif prioridade == "media":
            return 15
        elif prioridade == "alta":
            return 20
        elif prioridade == "muito alta":
            return 25
