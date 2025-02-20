<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="../../static/icons/favicon.ico">
    <link rel = "stylesheet" href = "../../static/bootstrap-5.3.3-dist/css/bootstrap.min.css">
    <link href="../../static/css/home.css" rel="stylesheet" type="text/css" >
    <title>Time Wizard App</title>
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
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <div class="d-flex gap-2">
                    <button type="button" id="profile-button" class="btn btn-outline-light d-flex align-items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
                            <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0"/>
                            <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8m8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1"/>
                        </svg>
                        Perfil
                    </button>
                    <a href="/logout" style="padding-right: 10px;">
                        <button type="button" class="btn btn-outline-light">Logout</button>
                    </a>
                </div>
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

            <div id="cards-place" class="col-10">
                <div class="habito-hoje">
                    <h2 class="mb-4 text-center">Hábitos</h2>
                    <div class="cards-place col-10">
                        % if not habitos:
                            <div class="card mb-3" style="width: 18rem;">
                                <div class="card-body">
                                    <h5 class="card-title">Nenhum hábito cadastrado</h5>
                                </div>
                            </div>
                        % end
                        % for habito in habitos:
                            <div class="card mb-3" style="width: 18rem;">
                                <div class="card-body">
                                    <div class="card-head d-flex justify-content-between">
                                        % for tarefa in tarefas:
                                            % if habito.id_tarefa == tarefa.id:
                                                <h5 class="card-title">{{tarefa.titulo}}</h5>
                                                % if tarefa.prioridade.lower() == "muito alta":
                                                    <span class="badge text-bg-danger text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "alta":
                                                    <span class="badge text-bg-warning text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "media":
                                                    <span class="badge text-bg-primary text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "baixa":
                                                    <span class="badge text-bg-info text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "muito baixa":
                                                    <span class="badge text-bg-secondary text-center">{{tarefa.prioridade}}</span>
                                                % end
                                            % end
                                        % end
                                    </div>
                                    <div class="card-body">
                                        <h5>{{habito.dias_da_semana}}</h5>
                                        <h6>{{habito.horario}}</h6>
                                    </div>
                                </div>
                            </div>
                        % end
                    </div>
                </div>
                <h2 class = "mb-4 text-white text-center">Tarefas</h2>
                <div id="tarefas-place" class="cards-place row">
                    % if not tarefas:
                        <div class="card align-self-center mb-3">
                            <div class="card-body">
                                <h5 class="card-title text-center align-self-center">Nenhuma tarefa cadastrada</h5>
                            </div>
                        </div>
                    % else:
                        <div id="todo-place" class=" col-4 p-3 rounded shadow-sm text-center text-white"><h4> Pendente </h4>
                            % for tarefa in tarefas:
                                % if tarefa.status == 'todo':
                                    <div id="tarefa-{{tarefa.id}}" class="card">
                                        <div class="card-body">
                                            <div class="card-head d-flex justify-content-between">
                                                <h5 id="titulo-{{tarefa.id}}" class="card-title">{{tarefa.titulo}}</h5>
                                                <button href="#edit-tarefa-place" data-value="{{tarefa.id}}" class="edit-task-button btn btn-outline-light" type="button"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil" viewBox="0 0 16 16">
                                                    <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325"/>
                                                </svg></button>
                                            </div>
                                            <p id="descricao-{{tarefa.id}}" class="card-text">{{tarefa.description}}</p>
                                        </div>
                                        <ul class="list-group list-group-flush">
                                            <li class="list-group-item">Prioridade: 
                                                % if tarefa.prioridade.lower() == "muito alta":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-danger text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "alta":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-warning text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "media":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-primary text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "baixa":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-info text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "muito baixa":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-secondary text-center">{{tarefa.prioridade}}</span>
                                                % end
                                            </li>
                                            <li id="tempo-{{tarefa.id}}" class="list-group-item d-flex">Tempo estimado: {{tarefa.tempo}} minutos </li>
                                            <li id="data-limite-{{tarefa.id}}" class="list-group-item d-flex">Data limite: {{tarefa.data_limite}} </li>
                                        </ul>
                                        <div class="card-body">
                                            <p class="card-text-tags">Tags:</p>
                                            <a id="tags-{{tarefa.id}}" class="hidden" style="display: none;">{{tarefa.tags}}</a>
                                            % for tag in tarefa.tags.split(','):
                                                <a  href="#" class="card-link">{{tag}}</a>
                                            % end
                                            <div class="row">
                                                <div class="col-9 text-center align-self-center">
                                                    Status:
                                                    % if tarefa.status == "todo":
                                                        <span  id="status-{{tarefa.id}}" class="badge text-bg-danger">Pendente</span>
                                                    % elif tarefa.status == "doing":
                                                        <span  id="status-{{tarefa.id}}" class="badge text-bg-warning">Em andamento</span>
                                                    % elif tarefa.status == "done":
                                                        <span  id="status-{{tarefa.id}}" class="badge text-bg-success">Concluído</span>
                                                    % end
                                                </div>
                                                <div class="col-3 text-center align-self-center">
                                                    <button id="delete-task-{{tarefa.id}}" type="button" data-value="{{tarefa.id}}" class="btn delete-task btn-outline-danger">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash3" viewBox="0 0 16 16">
                                                            <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5M11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47M8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5"/>
                                                        </svg>
                                                    </button>
                                                </div>
                                            </div>
                                            <button id="start-task-{{tarefa.id}}" type="button" data-value="{{tarefa.id}}" class="btn start-task btn-outline-light col-12 mt-2">Começar tarefa</button>
                                        </div>
                                    </div>
                                % end
                            % end
                        </div>
                        <div id="doing-place" class=" col-4 p-3 rounded shadow-sm text-center text-white"><h4> Em andamento </h4>
                            % for tarefa in tarefas:
                                % if tarefa.status == "doing":
                                    <div id="tarefa-{{tarefa.id}}" class="card">
                                        <div class="card-body">
                                            <div class="card-head d-flex justify-content-between">
                                                <h5 id="titulo-{{tarefa.id}}" class="card-title">{{tarefa.titulo}}</h5>
                                                <button  href="#edit-tarefa-place" data-value="{{tarefa.id}}" class="edit-task-button btn btn-outline-light" type="button"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil" viewBox="0 0 16 16">
                                                    <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325"/>
                                                </svg></button>
                                            </div>
                                            <p id="descricao-{{tarefa.id}}" class="card-text">{{tarefa.description}}</p>
                                        </div>
                                        <ul class="list-group list-group-flush">
                                            <li class="list-group-item">Prioridade: 
                                                % if tarefa.prioridade.lower() == "muito alta":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-danger text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "alta":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-warning text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "media":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-primary text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "baixa":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-info text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "muito baixa":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-secondary text-center">{{tarefa.prioridade}}</span>
                                                % end
                                            </li>
                                            <li id="tempo-{{tarefa.id}}" class="list-group-item d-flex">Tempo estimado: {{tarefa.tempo}} minutos </li>
                                            <li id="data-limite-{{tarefa.id}}" class="list-group-item d-flex">Data limite: {{tarefa.data_limite}} </li>
                                        </ul>
                                        <div class="card-body">
                                            <p class="card-text-tags">Tags:</p>
                                            <a id="tags-{{tarefa.id}}" class="hidden" style="display: none;">{{tarefa.tags}}</a>
                                            % for tag in tarefa.tags.split(','):
                                                <a  href="#" class="card-link">{{tag}}</a>
                                            % end
                                            <div class="row">
                                                <div class="col-9 text-center align-self-center">
                                                    Status:
                                                    % if tarefa.status == "todo":
                                                        <span id="status-{{tarefa.id}}" class="badge text-bg-danger">Pendente</span>
                                                    % elif tarefa.status == "doing":
                                                        <span id="status-{{tarefa.id}}" class="badge text-bg-warning">Em andamento</span>
                                                    % elif tarefa.status == "done":
                                                        <span id="status-{{tarefa.id}}" class="badge text-bg-success">Concluído</span>
                                                    % end
                                                </div>
                                                <div class="col-3 text-center align-self-center">
                                                    <button id="delete-task-{{tarefa.id}}" type="button" data-value="{{tarefa.id}}" class="btn delete-task btn-outline-danger">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash3" viewBox="0 0 16 16">
                                                            <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5M11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47M8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5"/>
                                                        </svg>
                                                    </button>
                                                </div>
                                            </div>
                                            <button id="finish-task-{{tarefa.id}}" type="button" data-value="{{tarefa.id}}" class="btn finish-task btn-outline-light col-12 mt-2">Finalizar Tarefa</button>
                                        </div>
                                    </div>
                                % end
                            % end
                        </div>
                        <div id="done-place" class="col-4 p-3 rounded shadow-sm text-center text-white"> <h4> Concluído </h4>
                            % for tarefa in tarefas:
                                % if tarefa.status == "done":
                                    <div id="tarefa-{{tarefa.id}}" class="card">
                                        <div class="card-body">
                                            <div class="card-head d-flex justify-content-between">
                                                <h5 id="titulo-{{tarefa.id}}" class="card-title">{{tarefa.titulo}}</h5>
                                                <button   href="#edit-tarefa-place" data-value="{{tarefa.id}}" class="edit-task-button btn btn-outline-light" type="button"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil" viewBox="0 0 16 16">
                                                    <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325"/>
                                                </svg></button>
                                            </div>
                                            <p id="descricao-{{tarefa.id}}" class="card-text">{{tarefa.description}}</p>
                                        </div>
                                        <ul class="list-group list-group-flush">
                                            <li class="list-group-item">Prioridade: 
                                                % if tarefa.prioridade.lower() == "muito alta":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-danger text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "alta":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-warning text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "media":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-primary text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "baixa":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-info text-center">{{tarefa.prioridade}}</span>
                                                % elif tarefa.prioridade.lower() == "muito baixa":
                                                    <span id="prioridade-{{tarefa.id}}" class="badge text-bg-secondary text-center">{{tarefa.prioridade}}</span>
                                                % end
                                            </li>
                                            <li id="tempo-{{tarefa.id}}" class="list-group-item d-flex">Tempo estimado: {{tarefa.tempo}} minutos </li>
                                            <li id="data-limite-{{tarefa.id}}" class="list-group-item d-flex">Data limite: {{tarefa.data_limite}} </li>
                                        </ul>
                                        <div class="card-body">
                                            <p class="card-text-tags">Tags:</p>
                                            <a id="tags-{{tarefa.id}}" class="hidden" style="display: none;">{{tarefa.tags}}</a>
                                            % for tag in tarefa.tags.split(','):
                                                <a  href="#" class="card-link">{{tag}}</a>
                                            % end
                                            <div class="row">
                                                <div class="col-9 text-center align-self-center">
                                                    Status:
                                                    % if tarefa.status == "todo":
                                                        <span id="status-{{tarefa.id}}" class="badge text-bg-danger">Pendente</span>
                                                    % elif tarefa.status == "doing":
                                                        <span id="status-{{tarefa.id}}" class="badge text-bg-warning">Em andamento</span>
                                                    % elif tarefa.status == "done":
                                                        <span id="status-{{tarefa.id}}" class="badge text-bg-success">Concluído</span>
                                                    % end
                                                </div>
                                                <div class="col-3 text-center align-self-center">
                                                    <button id="delete-task-{{tarefa.id}}" type="button" data-value="{{tarefa.id}}" class="btn delete-task btn-outline-danger">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash3" viewBox="0 0 16 16">
                                                            <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5M11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47M8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5"/>
                                                        </svg>
                                                    </button>
                                                </div>
                                            </div>
                                            <button id="done-task-{{tarefa.id}}" type="button" data-value="{{tarefa.id}}" class="btn btn-success col-12 mt-2">Tarefa Concluída</button>
                                        </div>
                                    </div>
                                % end
                            % end
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
                        <div id="priority-buttons" class="d-flex grid gap-3 priority-buttons-cadastro"> 
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
                        <input id="form-data-limite" type="datetime-local" name="data_limite" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="tags" class="form-label">Tags:</label>
                        <input type="text" name="tags" class="form-control" placeholder="Ex: trabalho, pessoal, estudo" required>
                    </div>
                    <button type="submit" class="btn btn-success w-100">Cadastrar</button>
                </form>
            </div>

            <div id="habito-place" class="flex-column col-10 bg-dark" style="display: none;">
                <h2>Cadastrar Hábito</h2>
                <form id="form-habito" action="/add-habito" method="POST">
                    <div class="mb-3">
                        <label for="nome" class="form-label"><h5>Qual tarefa você quer trasnsformar em hábito? </h5></label>
                        % for tarefa in tarefas:
                            <div id="tarefa-cad-habito-{{tarefa.id}}" class="form-check">
                                <input class="btn-check btn-outline-light" type="radio" name="tarefa_id" id="tarefa{{tarefa.id}}" value="{{tarefa.id}}" required>
                                <label class="btn btn-outline-light" for="tarefa{{tarefa.id}}">
                                    {{tarefa.titulo}}
                                </label>
                            </div>
                        % end

                        % if not tarefas:
                            <div class="alert alert-danger" role="alert">
                                Nenhuma tarefa cadastrada
                            </div>
                        % end
                        <label for="dias"><h5> Quais dias da semana que deseja realizar a tarefa:</h5></label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="segunda" name="segunda">
                            <label class="form-check-label">Segunda-feira</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="terca" name="terca">
                            <label class="form-check-label">Terça-feira</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="quarta" name="quarta">
                            <label class="form-check-label">Quarta-feira</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="quinta" name="quinta">
                            <label class="form-check-label">Quinta-feira</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="sexta" name="sexta">
                            <label class="form-check-label">Sexta-feira</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="sabado" name="sabado">
                            <label class="form-check-label">Sabado</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="domingo" name="domingo">
                            <label class="form-check-label">Domingo</label>
                        </div>
                    </div>
                    <label for="horario">Horário:</label>
                    <input type="time" id="horario" name="horario" required>
                    <br>
                    <button type="submit" class="btn btn-success w-100 mt-2">Cadastrar</button>
                </form>
            </div>

            <div id="perfil-place" class="flex-column col-10 bg-dark" style="display: none;">
                <div class="card" style="width: 18rem;">
                    <div class="card-body">
                        <h5 class="card-title">Perfil</h5>
                        <p class="card-text">Nome: {{user.name}}</p>
                        <p id="user" data-value="{{user.email}}" class="card-text">Email: {{user.email}}</p>
                        <p class="card-text">Senha: ***********</p>
                        <p class="card-text">XP: {{user.xp}}</p>
                        <button type="button" class="btn btn-secondary">Editar</button>
                    </div>
                </div>
            </div>

            <div id="edit-tarefa-place" class="flex-column col-10 bg-dark" style="display: none;">
                <h2>Editar Tarefa</h2>
                <form id="edit-tarefa-form" action="/edit-tarefa" method="POST" class="needs-validation">
                    <div class="mb-3">
                        <label for="titulo" class="form-label" >Título:</label>
                        <input id ="titulo" type="text" name="titulo" class="form-control" placeholder="Ex: Enviar email para o chefe" required>
                    </div>
                    <div class="mb-3">
                        <label for="descricao" class="form-label">Descrição:</label>
                        <textarea id ="descricao" name="descricao" class="form-control" rows="3" placeholder="Ex: Explicar o motivo da ausência na reunião" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="prioridade" class="form-label">Prioridade:</label>
                        <div id="priority-buttons" class="d-flex grid gap-3 priority-buttons-edit"> 
                            <button type="button" class="btn btn-outline-danger" data-value="muito alta">Muito Alta</button>
                            <button type="button" class="btn btn-outline-warning" data-value="alta">Alta</button>
                            <button type="button" class="btn btn-outline-primary" data-value="media">Média</button>
                            <button type="button" class="btn btn-outline-info" data-value="baixa">Baixa</button>
                            <button type="button" class="btn btn-outline-secondary" data-value="muito baixa">Muito Baixa</button>
                        </div>
                        <input id ="prioridade" type="hidden" name="prioridade" id="prioridade" required>
                    </div>
                    <div class="mb-3">
                        <label for="tempo" class="form-label">Tempo estimado para realização da tarefa:</label>
                        <div class="input-group">
                            <input id="tempo" type="number" name="tempo" class="form-control" placeholder="Ex: 30" required>
                            <span class="input-group-text">minutos</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="data" class="form-label">Data limite:</label>
                        <input id="form-data-limite" type="datetime-local" name="data_limite" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="tags" class="form-label">Tags:</label>
                        <input type="text" name="tags" class="form-control" placeholder="Ex: trabalho, pessoal, estudo, saúde" required>
                    </div>
                    <input id="id_tarefa" type="hidden" name="tarefa_id" value="">
                    <button type="submit" class="btn btn-success w-100">Editar</button>
                </form>
            </div>
        </div>
    </main>
    <footer class="bg-dark text-white text-center py-3">
        <p class="mb-0">&copy; 2025 Time Wizard. Todos os direitos reservados. </p>
    </footer>
    <script src="../../static/bootstrap-5.3.3-dist/js/bootstrap.min.js"></script>
    <script src="/static/js/websocket/socket.io.min.js"></script>
    <script src="../../static/js/home.js"></script>
</body>
</html>