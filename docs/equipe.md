# Divisão Técnica do Trabalho — Equipe Aurora

## Integrantes e Responsabilidades

---

### Ryan Charles Daldegan Reis
**Papel:** Desenvolvedor Backend

**Responsabilidades Técnicas:**
- Desenvolvimento do backend em Python com FastAPI (`app/api.py`)
- Implementação da camada de acesso a dados (`app/data_access/queries.py`)
- Implementação dos filtros dinâmicos nas consultas SQL
- Criação do serviço de KPIs (`app/services/kpi_service.py`)
- Integração entre banco de dados e API REST
- Adição do endpoint `/api/tabelas/margem` na Semana 4

**Arquivos Principais:**
- `app/api.py`
- `app/data_access/queries.py`
- `app/services/kpi_service.py`
- `app/config/database.py`

---

### Deyvison Dennis Antônio Lucas
**Papel:** Desenvolvedor de Banco de Dados

**Responsabilidades Técnicas:**
- Modelagem do banco de dados relacional (DER, normalização)
- Criação do script SQL completo (`db/init/cria_banco.sql`)
- Definição das tabelas, constraints e chaves estrangeiras
- Geração da massa de dados (120 vendas, 5 filiais, 5 categorias, 20 produtos)
- Criação das 5 queries analíticas que respondem às perguntas de negócio
- Documentação do modelo de banco (`db/docs/modelo_banco.md`)

**Arquivos Principais:**
- `db/init/cria_banco.sql`
- `db/docs/modelo_banco.md`

---

### Vitor Epifânio de Assis Azevedo
**Papel:** Desenvolvedor Frontend

**Responsabilidades Técnicas:**
- Desenvolvimento do dashboard HTML/CSS/JS (`app/static/`)
- Design do sistema de KPI cards com glassmorphism e dark mode
- Implementação dos filtros dinâmicos no frontend com auto-reload
- Renderização das tabelas analíticas via JavaScript
- Implementação da exportação CSV (Semana 4)
- Adição de badges de margem coloridos e ranking de produtos (Semana 4)
- Garantia de responsividade mobile

**Arquivos Principais:**
- `app/static/index.html`
- `app/static/app.js`
- `app/static/style.css`

---

### Milleny Evan
**Papel:** Analista de Qualidade e Documentação

**Responsabilidades Técnicas:**
- Elaboração e execução dos casos de teste (`docs/testes_semana3.md`)
- Validação dos KPIs calculados contra queries SQL diretas
- Documentação das entregas semanais (`docs/entregas.md`, `docs/semana2.md`, etc.)
- Identificação e reporte de bugs entre integrações
- Revisão da documentação final do README

**Arquivos Principais:**
- `docs/testes_semana3.md`
- `docs/entregas.md`
- `docs/semana4.md`
- `docs/equipe.md`

---

### Yasmin Isabelli Callazans
**Papel:** Engenheira de Infraestrutura

**Responsabilidades Técnicas:**
- Configuração do Docker e Docker Compose (`infra/docker/docker-compose.yml`)
- Mapeamento de volumes para carga automática do SQL
- Documentação de execução da infraestrutura (`infra/docker/README.md`)
- Configuração das variáveis de ambiente (`app/.env`)
- Garantia da reprodutibilidade do ambiente pelo professor
- Suporte ao gerenciamento do repositório Git

**Arquivos Principais:**
- `infra/docker/docker-compose.yml`
- `infra/docker/README.md`
- `app/.env`
- `app/requirements.txt`

---

## Dificuldades Técnicas Enfrentadas

### 1. Filtros Dinâmicos no SQL
**Problema:** Inserir cláusulas `WHERE` dinamicamente sem expor o sistema a SQL Injection e sem quebrar as queries que já tinham `GROUP BY` ou `ORDER BY`.  
**Solução:** Implementamos o método `_execute_query()` que constrói a cláusula `WHERE` inserindo-a antes do `GROUP BY` ou `ORDER BY`, usando parâmetros parametrizados do `psycopg2`.

### 2. Compatibilidade do CSV com Excel
**Problema:** Arquivos CSV exportados sem BOM (Byte Order Mark) UTF-8 abriam com caracteres corrompidos no Excel brasileiro.  
**Solução:** Adicionamos `'\uFEFF'` ao início do conteúdo do blob antes de criar a URL de download.

### 3. Carga Automática do SQL no Docker
**Problema:** O PostgreSQL só executa scripts da pasta `/docker-entrypoint-initdb.d` quando o volume está vazio. Reiniciar o container sem `down -v` não recarregava os dados.  
**Solução:** Documentamos claramente o uso de `docker-compose down -v` para reinicialização limpa.

### 4. Filtro WHERE sem GROUP BY
**Problema:** A query de KPIs globais não tem `GROUP BY`, então a lógica de inserção do `WHERE` antes do `GROUP BY` não funcionava.  
**Solução:** Adicionamos uma condição `else` no método que simplesmente concatena o `WHERE` ao final da query quando não há `GROUP BY` nem `ORDER BY`.

---

## Contribuição na Apresentação

| Integrante | Parte da Apresentação |
|---|---|
| Ryan Charles | Explica a arquitetura técnica e o backend (FastAPI, endpoints, filtros) |
| Deyvison Dennis | Apresenta o banco de dados, modelo ER e as queries das 5 perguntas |
| Vitor Epifânio | Demonstra o dashboard ao vivo: filtros, KPIs, tabelas e export CSV |
| Milleny Evan | Apresenta os testes realizados e valida os KPIs calculados |
| Yasmin Isabelli | Demonstra o Docker, container em execução e infraestrutura |
