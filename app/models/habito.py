from app.models.tarefa import Tarefa
class Habito(Tarefa):
    def __init__(self, titulo, description, prioridade, tempo, data_limite, tags, frequencia):
        super().__init__(titulo, description, prioridade, tempo, data_limite, tags) # Chama o construtor da classe pai (Tarefa) para inicializar atributos herdados
        self.frequencia = frequencia # Adiciona o atributo específico de Habito