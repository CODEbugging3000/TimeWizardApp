from ..models.tarefa import Tarefa
class Habito(Tarefa):
    """ Objeto do tipo Habito para armazenamento de tarefas de habito.
    Herda de Tarefa, adicionando comportamentos específicos para hábitos. """
    def __init__(self, id_habito, tarefa, dias_da_semana, horario):
        super().__init__(tarefa.id, tarefa.titulo, tarefa.description, tarefa.prioridade, tarefa.tempo, 
                            tarefa.data_limite, tarefa.tags, tarefa.status)
        
        self.id_habito = id_habito
        self.tarefa = tarefa # Composição um hábito contém uma tarefa
        self.dias_da_semana = dias_da_semana 
        self.horario = horario
    
    def __str__(self):
        return f"Habito: {self.id_habito} - Tarefa: {self.id_tarefa} - Dias da semana: {self.dias_da_semana} - Horario: {self.horario}"