<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="icon" type="image/x-icon" href="../../static/icons/favicon.ico">
    <link href="../../static/css/cadastro.css" rel="stylesheet" type="text/css" >
    <title>Cadastro</title>
</head>
<body class="bg-dark" style="height: 100vh;">
    <header class="header">
        <nav class="navbar navbar-expand-lg bg-body-tertiary" data-bs-theme="dark">
        <div class="container-fluid">
            <a class="navbar-brand text-center" href="/">
                <img src="../../static/img/LogoTimeWizard.png" alt="Logo" width="90" height="72" class="d-inline-block">
                Time Wizard
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="/">Home</a>
                </li>
            </ul>
            <div class="d-flex gap-2">
              <a class="nav-link" href="/login">
                  <button type="button" class="btn btn-outline-light">Login</button>
              </a>
              <a class="nav-link" href="/cadastrar">
                <button type="button" class="btn btn-outline-light">Cadastrar</button>
              </a>
            </div>
            </div>
        </div>
    </nav>
    </header>
    <main class="bg-dark text-white d-flex align-items-center">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-6 col-lg-4">
                    <div class="card bg-dark border-light">
                        <div class="card-body">
                            % if error_mesage:
                                <div class="alert alert-danger" role="alert">
                                    {{ error_mesage }} <a href="/login">Login</a>
                                </div>
                            % end
                            <h1 class="text-center text-white mb-4">Cadastrar</h1>
                            <form action="/cadastrar" method="POST">
                                <div class="mb-3">
                                    <label for="email" class="form-label label">E-mail</label>
                                    <input type="email" class="form-control" id="email" name="email" placeholder="Digite seu e-mail" required>
                                </div>
                                <div class="mb-3">
                                    <label for="nome" class="form-label label">Nome</label>
                                    <input type="text" class="form-control" id="nome" name="nome" placeholder="Digite seu nome" required>
                                </div>
                                <div class="mb-3">
                                    <label for="password" class="form-label label">Senha</label>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Digite a senha a ser cadastrada" required>
                                </div>
                                <button type="submit" class="btn btn-purple w-100">Cadastrar</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>