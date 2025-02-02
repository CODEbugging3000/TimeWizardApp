class Habito:
    """" Objeto do tipo Habito para armazenamento de tarefas de habito """
    def __init__(self, id_habito, id_tarefa, dias_da_semana, horario):
        # Adiciona o atributo específico de Habito
        self.dias_da_semana = dias_da_semana 
        self.id_habito = id_habito
        self.id_tarefa = id_tarefa
        self.horario = horario
        