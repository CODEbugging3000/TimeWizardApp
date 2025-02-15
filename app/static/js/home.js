document.addEventListener("DOMContentLoaded", () => {
    // Lista de IDs das seções da página
    const sections = ["cards-place", "cadastro-place", "habito-place", "perfil-place", "edit-tarefa-place"];

    // Função para mostrar a seção desejada e esconder as outras
    const showSection = (sectionId) => {
        sections.forEach((id) => {
            const section = document.getElementById(id);
            if (section) {
                section.style.display = id === sectionId ? "" : "none";
            }
        });
    };

    // Adiciona evento de clique nos links da sidebar (se houver)
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
        profileButton.addEventListener("click", () => {
            showSection("perfil-place");
        });
    }

    // Seleciona todos os botões de edição
    const editTaskButtons = document.querySelectorAll("button .edit-task-button");

    // Adiciona o evento de clique para cada botão
    editTaskButtons.forEach(button => {
        button.addEventListener("click", () => {
            // Recupera o ID da tarefa do botão clicado
            const tarefaId = button.getAttribute("data-value");
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
            document.querySelector("#edit-tarefa-form #data_limite").value = tarefaDataLimite;

            // Exibe a seção de edição
            showSection("edit-tarefa-place");
        });
    });
    // Exibe a seção inicial ao carregar a página
    showSection("cards-place");

    // Validação de formulário do cadastro de tarefa
    const formularios = document.querySelectorAll("form.needs-validation"); // Pega todos os formulários com essa classe
    formularios.forEach(formulario => {
        const prioridadeInput = formulario.querySelector("#prioridade");
        const botoesPrioridade = formulario.querySelectorAll("#priority-buttons button");

        // Adiciona evento aos botões de prioridade
        botoesPrioridade.forEach(botao => {
            botao.addEventListener("click", () => {
                // Atualiza o campo hidden com a prioridade selecionada
                prioridadeInput.value = botao.getAttribute("data-value");

                // Remove a classe "active" de todos os botões e adiciona no selecionado
                botoesPrioridade.forEach(btn => btn.classList.remove("active"));
                botao.classList.add("active");
            });
        });

        // Validação no envio do formulário
        formulario.addEventListener("submit", (event) => {
            if (!prioridadeInput.value) {
                event.preventDefault(); // Impede o envio do formulário
                alert("Por favor, selecione uma prioridade antes de enviar o formulário.");
            }
        });
    });
});
