# Saiba mais sobre o projeto aqui⬇️
[Notion sobre o projeto](https://giant-captain-22a.notion.site/Time-Wizard-161e9b38400e80d1bf11cf399c9a38ba)

<br>

# Como rodar o projeto

## No BASH:

1. Executar o arquivo 'route.py', na raiz do projeto.
```console
    $ python3 route.py
```
## No DOCKER:
```console
    $ docker build -t bmvci .
    $ docker run -d -p 8080:8080 -v $(pwd):/app bmvci
```
