# Requisitos Técnicos

Este documento descreve como o projeto **Rede Comercial Aurora** atende aos requisitos técnicos obrigatórios estipulados para o projeto de sistemas.

## 1. Escopo Comercial
O banco de dados armazena informações estritamente comerciais (filiais, produtos, categorias de produtos, vendas e itens de venda), mantendo o foco analítico exigido (faturamento, receita, margem bruta).

## 2. Indicadores Calculados
A modelagem foi estruturada para permitir o cálculo dos seguintes indicadores sem a necessidade de lógicas complexas no código, apenas com consultas SQL:
1. **Faturamento bruto:** `quantidade * preco_unitario`
2. **Desconto total:** somatório de `desconto_item`
3. **Receita líquida:** `faturamento_bruto - desconto_total`
4. **Custo total:** `quantidade * custo_unitario`
5. **Margem bruta:** `receita_liquida - custo_total`
6. **Margem bruta percentual:** `(margem_bruta / receita_liquida) * 100`
7. **Quantidade vendida:** somatório de `quantidade`
8. **Ticket médio:** `receita_liquida / quantidade_de_vendas`

## 3. Infraestrutura (SGBD)
Optou-se por utilizar o SGBD **PostgreSQL** provisionado através do Docker. O repositório contém a pasta `infra/docker` com as definições para subir a infraestrutura com facilidade.
O banco de dados inicializa mapeando um script SQL automático (`db/init/cria_banco.sql`) que cria todas as tabelas e as popula com uma pequena massa de dados de teste.
