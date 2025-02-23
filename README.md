# Time Wizard
!(https://raw.githubusercontent.com/TimeWizard/TimeWizard/main/static/img/index-preview.png)

## Saiba mais sobre o projeto aqui⬇️
[Notion sobre o projeto](https://giant-captain-22a.notion.site/Time-Wizard-161e9b38400e80d1bf11cf399c9a38ba)
<br>

## Como rodar o projeto
### Instalação do python
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
