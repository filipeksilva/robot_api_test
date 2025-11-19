# Robot Framework API Test

Testes automatizados de API utilizando o Robot Framework e Poetry.

### VSCode Plugins
- Python
- Robot Framework Language Server

### Instalação:

1) Instale o Python e o Poetry.
Python: https://www.python.org/downloads/
Poetry:  https://python-poetry.org/docs/#installing-with-the-official-installer

2) Após a instalação, execute este comando na raiz do projeto para criar o ambiente virtual e instalar as dependências.

```
poetry install
```

### Plugin Robot Framework Language Server:
1) Para configurar interpretador Python criado pelo Poetry, execute este comando:

```
poetry run where python
```

2) Copie o caminho do ".exe" localizado em "\AppData\Local\pypoetry\Cache\virtualenvs\".

3) Nas configurações do plugin Robot Framework Language Server, cole o caminho no campo "Robot > Language-server: Python"

### Execução:
Para executar os testes, execute o comando abaixo conforme o ambiente desejado:

Em QA:

``` bash
robot -d log -v env:qa .
```

Em STG:

``` bash
robot -d log -v env:stg .
```

Em PRD:

``` bash
robot -d log -v env:prd .
```