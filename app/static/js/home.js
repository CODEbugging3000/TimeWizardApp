document.addEventListener("DOMContentLoaded", () => {
    // Lista de IDs das seções da página
    const sections = ["cards-place", "cadastro-place", "habito-place", "perfil-place"];

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
    const profileButton = document.querySelector(".btn-outline-light.d-flex");
    if (profileButton) {
        profileButton.addEventListener("click", () => {
            showSection("perfil-place");
        });
    }

    // Exibe a seção inicial ao carregar a página
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
