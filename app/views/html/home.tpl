<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="../../static/icons/favicon.ico">
    <link rel = "stylesheet" href = "../../static/bootstrap-5.3.3-dist/css/bootstrap.min.css">
    <link href="../../static/css/home.css" rel="stylesheet" type="text/css" >
    <title>Time Wizard</title>
</head>
<body>
    <header>
        <nav class="navbar navbar-expand-lg bg-body-tertiary" data-bs-theme="dark">
            <div class="container-fluid">
                <a class="navbar-brand text-center" href="/home">
                    <img src="../../static/img/LogoTimeWizard.png" alt="Logo" width="90" height="72" class="d-inline-block">
                    Time Wizard
                </a>
            </div>
        </nav>
    </header>

    <main class="container-fluid">
        <div class="row">
            <nav class="nav flex-column row nav-tabs sidebar bg-dark d-flex col-2">
                <a id="hoje" class="nav-link active" href="#cards-place">Hoje</a>
                <a id="add-tarefa" class="nav-link" href="#cadastro-place">Cadastrar Tarefas</a>
                <a id="add-habito" class="nav-link" href="#habito-place">Cadastrar Hábitos</a>
            </nav>

            
            <div id="cards-place" class="col-10"> <!-- Mexer dps (tirar o style) -->
                <div class="habito-hoje">
                    <h2>Hábitos</h2>
                </div>
                <div id="tarefas-place" class="cards-place">
                    % for tarefa in tarefas:
                        <div class="card" style="width: 18rem;">
                            <div class="card-body">
                                <div class="card-head d-flex">
                                    <h5 class="card-title">{{tarefa.titulo}}</h5>
                                    <button class="btn btn-secondary"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil" viewBox="0 0 16 16">
                                        <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325"/>
                                    </svg></button>
                                </div>
                                <p class="card-text">{{tarefa.description}}</p>
                            </div>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item">Prioridade: {{tarefa.prioridade}}</li>
                                <li class="list-group-item">Tempo estimado: {{tarefa.tempo}} minutos</li>
                                <li class="list-group-item">Data limite: {{tarefa.data_limite}}</li>
                            </ul>
                            <div class="card-body">
                                <p class="card-text">Tags:</p>
                                % for tag in tarefa.tags.split(','):
                                    <a href="#" class="card-link">{{tag}}</a>
                                % end
                            </div>
                        </div>
                    % end
                </div>
            </div>

            <div id="cadastro-place" class="col-10 bg-dark" style="display: none;">
                <h2 class="mb-4">Cadastrar Tarefa</h2>
                <form id="form-tarefa" action="/add-tarefa" method="POST" class="needs-validation">
                    <div class="mb-3">
                        <label for="titulo" class="form-label" >Título:</label>
                        <input type="text" name="titulo" class="form-control" placeholder="Ex: Enviar email para o chefe" required>
                    </div>
                    <div class="mb-3">
                        <label for="descricao" class="form-label">Descrição:</label>
                        <textarea name="descricao" class="form-control" rows="3" placeholder="Ex: Explicar o motivo da ausência na reunião" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="prioridade" class="form-label">Prioridade:</label>
                        <div id="priority-buttons" class="d-flex grid gap-3"> 
                            <button type="button" class="btn btn-outline-danger" data-value="muito alta">Muito Alta</button>
                            <button type="button" class="btn btn-outline-warning" data-value="alta">Alta</button>
                            <button type="button" class="btn btn-outline-primary" data-value="media">Média</button>
                            <button type="button" class="btn btn-outline-info" data-value="baixa">Baixa</button>
                            <button type="button" class="btn btn-outline-secondary" data-value="muito baixa">Muito Baixa</button>
                        </div>
                        <input type="hidden" name="prioridade" id="prioridade" required>
                    </div>
                    <div class="mb-3">
                        <label for="tempo" class="form-label">Tempo estimado para realização da tarefa:</label>
                        <div class="input-group">
                            <input type="number" name="tempo" class="form-control" placeholder="Ex: 30" required>
                            <span class="input-group-text">minutos</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="data" class="form-label">Data limite:</label>
                        <input type="datetime-local" name="data_limite" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="tags" class="form-label">Tags:</label>
                        <input type="text" name="tags" class="form-control" placeholder="Ex: trabalho, pessoal, estudo" required>
                    </div>
                    <button type="submit" class="btn btn-success w-100">Cadastrar</button>
                </form>
            </div>

            
            <div id="habito-place" class="cadastro-habito flex-column col-10 bg-dark" style="display: none;">
                <h2>Cadastrar Hábito</h2>
                <form id="form-habito" action="/add-habito" method="POST">
                    <div class="mb-3">
                        <label for="nome" class="form-label"><h5>Qual tarefa você quer trasnsformar em hábito? </h5></label>
                        % for tarefa in tarefas:
                            <div class="form-check">
                                <input class="btn-check btn-outline-light" type="radio" name="tarefa_id" id="tarefa{{tarefa.id}}" value="{{tarefa.id}}" required>
                                <label class="btn btn-outline-light" for="tarefa{{tarefa.id}}">
                                    {{tarefa.titulo}}
                                </label>
                            </div>
                        % end
                    </div>
                    <button type="submit" class="btn btn-secondary">Cadastrar</button>
                </form>
            </div>

        </div>
    </main>
    <footer class="bg-dark text-white text-center py-3">
        <p class="mb-0">&copy; 2025 Time Wizard. Todos os direitos reservados. </p>
    </footer>
    <script src="../../static/bootstrap-5.3.3-dist/js/bootstrap.min.js"></script>
    <script src="../../static/js/home.js"></script>
</body>
</html>