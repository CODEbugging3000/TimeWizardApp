# Time Wizard ⏳
![Time Wizard](https://raw.githubusercontent.com/CODEbugging3000/TimeWizardApp/refs/heads/main/app/static/img/Index-preview.png)

Time Wizard é uma aplicação web que permite aos usuários gerenciar melhor seu tempo, combinar produtividade com diversão e atingir seus objetivos com mais eficiência. Permitindo o cadastro de tarefas e hábitos e monitoramento de progresso, o Time Wizard oferece uma abordagem inteligente para o gerenciamento de tempo e aprimoramento de produtividade.
<br>
O projeto foi desenvolvido utilizando o framework web Bottle e o framework de sockets Python-socketio. Além disso, utilizamos o banco de dados SQLite(como protótipo) para armazenar os dados dos usuários e as tarefas cadastradas pelo mesmo.

![Time Wizard](https://raw.githubusercontent.com/CODEbugging3000/TimeWizardApp/refs/heads/main/app/static/img/Home-Preview.jpeg)

![Time Wizard](https://raw.githubusercontent.com/CODEbugging3000/TimeWizardApp/refs/heads/main/app/static/img/AddTask-preview.jpeg)

![Time Wizard](https://raw.githubusercontent.com/CODEbugging3000/TimeWizardApp/refs/heads/main/app/static/img/AddHabit-preview.jpeg)

## Saiba mais sobre o projeto aqui⬇️
![Notion icon](https://img.icons8.com/?size=25&id=HDd694003FZa&format=png&color=000000) [Notion sobre o projeto](https://giant-captain-22a.notion.site/Time-Wizard-161e9b38400e80d1bf11cf399c9a38ba)
<br>

## Como rodar o projeto
### Instalação da linguagem python
[Instalação do Python](https://www.python.org/downloads/)
### No Linux:
1. Instalar o web framework Bottle utilizando o instalador de pacotes do python pip em um ambiente virtual.
```console
    $ pip install bottle eventlet python-socketio
```
2. Executar o arquivo 'route.py', na raiz do projeto.
```console
    $ python3 startserver.py
```
### No windows:
1. Instalar o web framework Bottle utilizando o instalador de pacotes do python pip em um ambiente virtual.
```console
    $ pip install bottle eventlet python-socketio
    $ python startserver.py
```
### No DOCKER:
```console
    $ docker build -t bmvci .
    $ docker run -d -p 8080:8080 -v $(pwd):/app bmvci
```

## Gostou da ideia?
[Contribua com o projeto](https://github.com/CODEbugging3000/TimeWizardApp) se é desenvolvedor ou designer. Agradecemos sua colaboração!
