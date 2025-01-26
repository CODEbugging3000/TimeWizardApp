class Tarefa:
    """
    Objeto do tipo Tarefa para armazenamento de tarefas
    """
    def __init__(self, id, titulo, description, prioridade, tempo, data_limite, tags):
        self.id = id
        self.titulo = titulo
        self.description = description
        self.prioridade = prioridade
        self.tempo = tempo
        self.data_limite = data_limite
        self.tags = tags