const socket = io('http://localhost:8080');  // Endereço do servidor Socket.IO
socket.on('connect', () => {
    console.log('Conexão estabelecida com o servidor Socket.IO');
});
socket.on('connect_error', (error) => {
    console.error('Erro na conexão com o servidor:', error);
});
socket.on('task_started', (tarefa_id) => {
    startTask(tarefa_id['task_id']);
    console.log(`Tarefa iniciada: ${tarefa_id['task_id']}`);
});
socket.on('task_finished', (tarefa_id) => {
    finishTask(tarefa_id['task_id']);
    console.log(`Tarefa finalizada: ${tarefa_id['task_id']}`);
})
socket.on('recycle_task', (tarefa_id) => {
    recycleTask(tarefa_id['task_id']);
    console.log(`Tarefa reciclada: ${tarefa_id['task_id']}`);
})
socket.on('task_deleted', (tarefa_id) => {
    deleteTask(tarefa_id['task_id']);
    console.log(`Tarefa deletada: ${tarefa_id['task_id']}`);
})

const user = document.querySelector('#user').getAttribute('data-value');

// Função para mostrar a seção desejada e esconder as outras
const showSection = (sectionId) => {
    // Lista de IDs das seções da página
    const sections = ["cards-place", "cadastro-place", "habito-place", "perfil-place", "edit-tarefa-place"];
    sections.forEach((id) => {
        const section = document.getElementById(id);
        if (section) {
            section.style.display = id === sectionId ? "" : "none";
        }
    });
};

document.addEventListener("DOMContentLoaded", () => {

    // Adiciona evento de clique nos links da sidebar
    const navLinks = document.querySelectorAll(".nav-link");
    navLinks.forEach((link) => {
        link.addEventListener("click", (event) => {
            event.preventDefault();
            navLinks.forEach((nav) => nav.classList.remove("active"));
            link.classList.add("active");

            const targetSection = link.getAttribute("href").substring(1);
            showSection(targetSection);
        });
    });

    // Adiciona evento de clique no botão "Perfil"
    const profileButton = document.querySelector("#profile-button");
    if (profileButton) {
        profileButton.addEventListener("click", () => showSection("perfil-place"));
    }

    // Define a data mínima como o dia atual
    const dataAtual = new Date();
    const dataMinima = dataAtual.toISOString().slice(0, 16); // Pega data e hora no formato YYYY-MM-DDTHH:MM

    const validarFormulario = (formulario) => {
        const prioridadeInput = formulario.querySelector("#prioridade");
        const botoesPrioridade = formulario.querySelectorAll("#priority-buttons button");
        const dataLimiteInput = formulario.querySelector('#form-data-limite');

        if (dataLimiteInput) dataLimiteInput.min = dataMinima;

        botoesPrioridade.forEach(botao => {
            botao.addEventListener("click", () => {
                prioridadeInput.value = botao.getAttribute("data-value");
                botoesPrioridade.forEach(btn => btn.classList.remove("active"));
                botao.classList.add("active");
            });
        });

        formulario.addEventListener("submit", (event) => {
            if (dataLimiteInput && dataLimiteInput.value <= dataMinima) {
                event.preventDefault();
                alert("A data limite deve ser posterior à data e hora atual.");
            }
            if (!prioridadeInput.value) {
                event.preventDefault();
                alert("Por favor, selecione uma prioridade antes de enviar o formulário.");
            }
        });
    };

    // Validação de formulário do cadastro de tarefa e edição
    document.querySelectorAll("form.needs-validation").forEach(formulario => validarFormulario(formulario));

    // Exibe a seção inicial ao carregar a página
    showSection("cards-place");
    updateEventListeners();
});

function startTask(id_tarefa) {
    const taskCard = document.querySelector(`#tarefa-${id_tarefa}`);
    const pendingColumn = document.querySelector('#todo-place');
    const inProgressColumn = document.querySelector('#doing-place');
    // muda o status
    const span = document.querySelector(`#status-${id_tarefa}`);
    span.classList.remove('text-bg-danger');
    span.classList.add('text-bg-warning');
    span.textContent = 'Em andamento';

    // muda o texto e ID do botão de começar para finalizar
    const button = document.querySelector(`#start-task-${id_tarefa}`);
    button.textContent = 'Finalizar Tarefa';
    button.setAttribute('id', `finish-task-${id_tarefa}`);
    //retira a classe start-task
    button.classList.remove('start-task');
    button.classList.add('finish-task');

    // muda o card da tarefa de lugar
    pendingColumn.removeChild(taskCard);
    inProgressColumn.appendChild(taskCard);

    updateEventListeners();
}

function finishTask(id_tarefa) {
    const taskCard = document.querySelector(`#tarefa-${id_tarefa}`);
    const inProgressColumn = document.querySelector('#doing-place');
    const doneColumn = document.querySelector('#done-place');

    // muda o status
    const span = document.querySelector(`#status-${id_tarefa}`);
    span.classList.remove('text-bg-warning');
    span.classList.add('text-bg-success');
    span.textContent = 'Concluida';

    // muda o texto e ID do botão de finalizar para iniciar
    const button = document.querySelector(`#finish-task-${id_tarefa}`);
    button.classList.remove('finish-task');
    button.classList.add('recycle-task');
    button.textContent = 'Reciclar Tarefa';
    button.setAttribute('id', `done-task-${id_tarefa}`);

    // muda o card da tarefa de lugar
    inProgressColumn.removeChild(taskCard);
    doneColumn.appendChild(taskCard);

    updateEventListeners();
}

function recycleTask(id_tarefa) {
    const taskCard = document.querySelector(`#tarefa-${id_tarefa}`);
    const doneColumn = document.querySelector('#done-place');
    const todoColumn = document.querySelector('#todo-place');

    // muda o status
    const span = document.querySelector(`#status-${id_tarefa}`);
    span.classList.remove('text-bg-success');
    span.classList.add('text-bg-danger');
    span.textContent = 'Pendente';

    // muda o texto e ID do botão de reciclar para iniciar
    const button = document.querySelector(`#done-task-${id_tarefa}`);
    button.classList.remove('recycle-task');
    button.classList.add('start-task');
    button.textContent = 'Iniciar Tarefa';
    button.setAttribute('id', `start-task-${id_tarefa}`);

    // muda o card da tarefa de lugar
    doneColumn.removeChild(taskCard);
    todoColumn.appendChild(taskCard);

    updateEventListeners();
}

function deleteTask(id_tarefa) {
    const taskCard = document.querySelector(`#tarefa-${id_tarefa}`);
    taskCard.remove();

    const taskCheck = document.querySelector(`#tarefa-cad-habito-${id_tarefa}`);
    taskCheck.remove();

    updateEventListeners();
}

function editTask(tarefaId) {
    console.log(`Tarefa selecionada para edição: ${tarefaId}`); // Verifica se o ID correto está sendo capturado

    // Recupera os dados da tarefa
    const tarefaTitulo = document.querySelector(`#titulo-${tarefaId}`).textContent;
    const tarefaDescricao = document.querySelector(`#descricao-${tarefaId}`).textContent;
    const tarefaPrioridade = document.querySelector(`#prioridade-${tarefaId}`).textContent;
    const tarefaTempo = document.querySelector(`#tempo-${tarefaId}`).textContent.split(": ")[1];
    const tarefaDataLimite = document.querySelector(`#data-limite-${tarefaId}`).textContent.split(": ")[1];

    // Preenche os campos do formulário com os dados da tarefa
    document.querySelector("#edit-tarefa-form #id_tarefa").value = tarefaId;
    document.querySelector("#edit-tarefa-form #titulo").value = tarefaTitulo;
    document.querySelector("#edit-tarefa-form #descricao").value = tarefaDescricao;

    // Adiciona a classe "active" ao botão de prioridade correspondente
    const botoesPrioridade = document.querySelectorAll("#priority-buttons .priority-buttons-edit button");
    botoesPrioridade.forEach(botao => {
        if (botao.getAttribute("data-value") === tarefaPrioridade.toLowerCase()) {
            botao.classList.add("active");
        } else {
            botao.classList.remove("active");
        }
    });
    document.querySelector("#edit-tarefa-form #prioridade").value = tarefaPrioridade;
    document.querySelector("#edit-tarefa-form #tempo").value = tarefaTempo;
    document.querySelector("#edit-tarefa-form #form-data-limite").value = tarefaDataLimite;

    // Exibe a seção de edição
    showSection("edit-tarefa-place");
}

function updateEventListeners() {
    //função para iniciar Tarefa
    const startTaskButtons = document.querySelectorAll('.start-task');
    startTaskButtons.forEach(button => {
        button.addEventListener('click', () => {
            const tarefaId = button.getAttribute('data-value');
            socket.emit('start_task', user, tarefaId);
        });
    });

    //função para finalizar Tarefa
    const finishTaskButtons = document.querySelectorAll('.finish-task');
    finishTaskButtons.forEach(button => {
        button.addEventListener('click', () => {
            const tarefaId = button.getAttribute('data-value');
            socket.emit('finish_task', user, tarefaId);
        });
    });

    //função para reciclar Tarefa
    const recycleTaskButtons = document.querySelectorAll('.recycle-task');
    recycleTaskButtons.forEach(button => {
        button.addEventListener('click', () => {
            const tarefaId = button.getAttribute('data-value');
            socket.emit('recycle_task', user, tarefaId);
        });
    });

    //função para editar Tarefa
    const editTaskButtons = document.querySelectorAll('.edit-task-button');
    editTaskButtons.forEach(button => {
        button.addEventListener('click', () => {
            const tarefaId = button.getAttribute('data-value');
            data = editTask(tarefaId);
            socket.emit('edit_task', user, tarefaId, data);
        });
    });

    //função para deletar Tarefa
    const deleteTaskButtons = document.querySelectorAll('.delete-task');
    deleteTaskButtons.forEach(button => {
        button.addEventListener('click', () => {
            const tarefaId = button.getAttribute('data-value');
            socket.emit('delete_task', user, tarefaId);
        });
    });
}