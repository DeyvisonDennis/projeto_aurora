# Projeto de Sistemas: Rede Comercial Aurora

## Integrantes do Grupo
- Aluno 1
- Aluno 2
- Aluno 3

## Descrição do Projeto
Este projeto tem como objetivo construir uma solução técnica para a **Rede Comercial Aurora**, permitindo consultar, filtrar, calcular e apresentar indicadores comerciais (faturamento, receita líquida, margem bruta, ticket médio, etc.) a partir de uma base de dados estruturada no PostgreSQL.

## Estrutura de Pastas
```text
projeto_aurora/
├─ db/
│  ├─ init/
│  │  └─ cria_banco.sql
│  └─ docs/
│     └─ modelo_banco.md
├─ infra/
│  └─ docker/
│     ├─ docker-compose.yml
│     └─ README.md
├─ docs/
│  ├─ requisitos_tecnicos.md
│  └─ entregas.md
└─ README.md
```

## Instruções Iniciais de Execução
Para executar o banco de dados e aplicar o script de criação inicial:
1. Instale o [Docker Desktop](https://www.docker.com/products/docker-desktop).
2. Acesse a pasta `infra/docker/` e siga as instruções contidas no `README.md` daquela pasta.
3. As instruções detalham como subir o contêiner do banco de dados e como as tabelas são criadas automaticamente através do arquivo `cria_banco.sql`.
