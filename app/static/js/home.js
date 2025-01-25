document.addEventListener("DOMContentLoaded", () => {
    // Seleciona todos os links da sidebar
    const navLinks = document.querySelectorAll(".nav-link");
    // Seleciona todas as divs de conteúdo
    const sections = ["cards-place", "cadastro-place", "habito-place"];

    // Função para exibir a seção correspondente e esconder as outras
    const showSection = (sectionId) => {
        sections.forEach((id) => {
            const section = document.getElementById(id);
            if (id === sectionId) {
                section.style.display = ""; // Mostra a seção
            } else {
                section.style.display = "none"; // Oculta as outras
            }
        });
    };

    // Adiciona o evento de clique para cada link da sidebar
    navLinks.forEach((link) => {
        link.addEventListener("click", (event) => {
            event.preventDefault(); // Evita o comportamento padrão do link
            // Remove a classe "active" de todos os links
            navLinks.forEach((nav) => nav.classList.remove("active"));
            // Adiciona a classe "active" ao link clicado
            link.classList.add("active");

            // Obtém o ID da seção a ser exibida a partir do atributo href do link
            const targetSection = link.getAttribute("href").substring(1); // Remove o '#' do href
            showSection(targetSection); // Exibe a seção correspondente
        });
    });

    // Exibe a seção inicial (cards-place) ao carregar a página
    showSection("cards-place");
});

document.addEventListener("DOMContentLoaded", () => {
    const priorityButtons = document.querySelectorAll("#priority-buttons button");
    const hiddenInput = document.getElementById("prioridade");
    const form = document.querySelector("form");

    // Função para marcar o botão como selecionado
    const setActiveButton = (button) => {
        // Remove a classe "active" de todos os botões
        priorityButtons.forEach((btn) => btn.classList.remove("active"));
        // Adiciona a classe "active" ao botão clicado
        button.classList.add("active");
        // Define o valor do input oculto com o valor do botão selecionado
        hiddenInput.value = button.getAttribute("data-value");
    };

    // Adiciona um evento de clique em cada botão
    priorityButtons.forEach((button) => {
        button.addEventListener("click", () => setActiveButton(button));
    });

    // Validação no envio do formulário
    form.addEventListener("submit", (event) => {
        if (!hiddenInput.value) {
            event.preventDefault(); // Impede o envio do formulário
            alert("Por favor, selecione uma prioridade antes de enviar o formulário.");
        }
    });
});
