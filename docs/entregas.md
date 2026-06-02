# Entregas do Projeto

Este documento funciona como um checklist do que foi entregue no repositório.

## Índice de Entregas

- **Semana 1:**
  - [x] Criação do repositório
  - [x] Docker e inicialização do banco ([Instruções do Docker](../infra/docker/README.md))
  - [x] Modelagem inicial e scripts SQL ([Modelo de Banco de Dados](../db/docs/modelo_banco.md))

- **Semana 2:**
  - [x] Carga de dados (massa para testes: 120 vendas, 5 filiais, 20 produtos)
  - [x] Consultas SQL (5 relatórios/perguntas de negócio)
  - [x] Camada Técnica de Acesso aos Dados (Filtros e App Python)
  - [x] [Documentação Semana 2](semana2.md)

- **Semana 3:**
  - [x] Aplicação web com Frontend e Backend (FastAPI)
  - [x] Indicadores visuais em Cards (8 KPIs obrigatórios)
  - [x] 4 Tabelas Analíticas com Filtros dinâmicos funcionais
  - [x] Resiliência a queda de banco de dados
  - [x] [Documentação de Execução](semana3.md) e [Testes](testes_semana3.md)

- **Semana 4 — Entrega Final:**
  - [x] 5ª Visualização obrigatória: Margem por Mês/Filial/Categoria (`/api/tabelas/margem`)
  - [x] Exportação de relatórios em formato CSV (botão em cada tabela)
  - [x] Tabela mensal expandida com desconto, qtd vendida e nº de vendas
  - [x] Badges coloridos de margem percentual (verde/amarelo/vermelho)
  - [x] Timestamp de última atualização no dashboard
  - [x] README.md completo com documentação final (13 seções)
  - [x] [Documentação Semana 4](semana4.md)
  - [x] [Divisão Técnica do Trabalho](equipe.md)
  - [x] [Evidências](evidencias/README.md)

## Checklist dos Requisitos Finais Obrigatórios

### Infraestrutura
- [x] Arquivo Docker Compose (`infra/docker/docker-compose.yml`)
- [x] Instrução clara de execução (`infra/docker/README.md`)
- [x] Script SQL completo com DDL + DML + Queries (`db/init/cria_banco.sql`)

### Banco de Dados
- [x] Filiais (5 registros)
- [x] Categorias (5 registros)
- [x] Produtos com custo unitário (20 registros)
- [x] Vendas com datas (120 registros)
- [x] Itens de venda com preços e descontos

### Indicadores Obrigatórios
- [x] Faturamento bruto
- [x] Desconto total
- [x] Receita líquida
- [x] Custo total
- [x] Margem bruta
- [x] Margem bruta percentual
- [x] Quantidade vendida
- [x] Ticket médio

### Filtros Obrigatórios
- [x] Período (data inicial / data final)
- [x] Filial
- [x] Produto
- [x] Categoria

### Visualizações Obrigatórias
- [x] Faturamento total por mês (P1)
- [x] Receita líquida por filial (P2)
- [x] Receita líquida por categoria (P3)
- [x] Ranking de produtos mais vendidos (P4)
- [x] Margem bruta por mês, filial e categoria (P5)

### Aplicação
- [x] Interface web utilizável pelo professor
- [x] Dashboard com dados reais do banco

### Documentação
- [x] Objetivo técnico da solução
- [x] Tecnologias utilizadas
- [x] Justificativa da arquitetura
- [x] Estrutura de pastas
- [x] Modelo do banco
- [x] Descrição das tabelas
- [x] Instruções para subir o SGBD
- [x] Instruções para executar a aplicação
- [x] Indicadores e fórmulas
- [x] Filtros
- [x] Visualizações
- [x] Limitações conhecidas
- [x] Melhorias futuras
