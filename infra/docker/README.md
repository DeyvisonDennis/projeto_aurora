# Infraestrutura: Docker PostgreSQL

Este diretório contém as configurações para provisionar o banco de dados da **Rede Comercial Aurora** localmente via Docker.

## Pré-requisitos
- Ter o Docker e o Docker Compose instalados.

## Como Executar
Abra um terminal (prompt de comando ou powershell), navegue até esta pasta (`infra/docker`) e execute o comando:
```bash
docker-compose up -d
```
Isso fará o download da imagem oficial do PostgreSQL e criará o container chamado `aurora-db`. 
O banco ficará disponível na porta padrão `5432`.

### Informações de Acesso
- **Host:** `localhost` ou `127.0.0.1`
- **Porta:** `5432`
- **Banco de Dados:** `aurora_comercial`
- **Usuário:** `postgres`
- **Senha:** `postgres_password`

### Criação do Banco
Ao iniciar o contêiner pela primeira vez, o Docker executará automaticamente o script `../../db/init/cria_banco.sql` mapeado no volume. Isso garantirá que as tabelas sejam criadas e que a massa de dados inicial seja populada.

## Como Parar
Para interromper a execução sem destruir os dados (desde que não apague o volume anônimo gerado), execute:
```bash
docker-compose stop
```
Para derrubar o container completamente:
```bash
docker-compose down
```
