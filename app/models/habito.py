from app.models.tarefa import Tarefa
class Habito(Tarefa):
    """" Objeto do tipo Habito para armazenamento de tarefas de habito """
    def __init__(self, titulo, description, prioridade, tempo, data_limite, tags, dias_dasemana):
        super().__init__(titulo, description, prioridade, tempo, data_limite, tags) # Chama o construtor da classe pai (Tarefa) para inicializar atributos herdados
        # Adiciona o atributo específico de Habito
        self.dias_dasemana = dias_dasemana 
        
