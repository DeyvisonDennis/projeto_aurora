# Entrega Semana 4 — Entrega Final e Apresentação

Esta documentação descreve o que foi desenvolvido e validado na **Semana 4**, consolidando a entrega final do Projeto Aurora.

---

## O Que Foi Implementado na Semana 4

### 1. 5ª Visualização Obrigatória — Margem Bruta Detalhada

A Pergunta de Negócio 5 exige a visualização de **margem bruta cruzada por mês, filial e categoria**. Anteriormente o sistema calculava apenas os KPIs globais. Foram feitas as seguintes adições:

- `app/data_access/queries.py` → método `get_margem_detalhada(filters)` com query SQL de cruzamento triplo
- `app/services/kpi_service.py` → método `margem_detalhada(**kwargs)`
- `app/api.py` → endpoint `GET /api/tabelas/margem` com filtros dinâmicos
- `app/static/index.html` → tabela completa de largura total no dashboard
- `app/static/app.js` → função `renderTabelaMargem(data)` e integração no `updateDashboard()`

### 2. Exportação de Relatórios CSV

Cada uma das 5 tabelas analíticas possui agora um botão **"⬇ CSV"** que:

- Gera o arquivo com cabeçalho correto e valores brutos (não formatados)
- Adiciona BOM UTF-8 para compatibilidade com Excel brasileiro
- Nomeia o arquivo com o nome da visualização e a data atual (`aurora_mensal_2024-06-02.csv`)
- Funciona 100% no frontend sem chamada extra ao servidor

### 3. Melhorias na Interface

- **Badges coloridos de margem**: verde (≥40%), amarelo (≥20%), vermelho (<20%)
- **Ranking numerado** nos produtos mais vendidos
- **Timestamp de atualização** no cabeçalho do dashboard
- **Descrição de cada KPI** com a fórmula de cálculo
- **Tabela mensal expandida**: agora mostra desconto total, qtd vendida e nº de vendas

### 4. Documentação Final

- `README.md` reescrito com todas as 13 seções obrigatórias
- `docs/semana4.md` (este arquivo) documentando a entrega final
- `docs/equipe.md` com divisão técnica do trabalho
- `docs/entregas.md` atualizado com checklist da Semana 4

---

## Testes Realizados

### Endpoints da API

| Endpoint | Status | Verificação |
|---|---|---|
| `GET /` | ✅ | Retorna o dashboard HTML |
| `GET /api/filtros` | ✅ | Retorna filiais, categorias e produtos |
| `GET /api/kpis` | ✅ | Retorna os 8 KPIs globais |
| `GET /api/tabelas/mensal` | ✅ | Retorna 6 meses de dados |
| `GET /api/tabelas/filial` | ✅ | Retorna 5 filiais ordenadas por receita |
| `GET /api/tabelas/categoria` | ✅ | Retorna 5 categorias |
| `GET /api/tabelas/produtos` | ✅ | Retorna 20 produtos ordenados por qtd |
| `GET /api/tabelas/margem` | ✅ | Retorna dados cruzados mês/filial/categoria |

### Filtros

| Teste | Parâmetro | Resultado Esperado | Status |
|---|---|---|---|
| Filtro por filial | `id_filial=1` | Dados apenas da Aurora Matriz | ✅ |
| Filtro por categoria | `id_categoria=4` | Dados apenas de Informática | ✅ |
| Filtro por período | `data_inicial=2024-03-01&data_final=2024-03-31` | Apenas março/2024 | ✅ |
| Filtro por produto | `id_produto=13` | Apenas Notebook Pro | ✅ |
| Múltiplos filtros | `id_filial=1&id_categoria=1` | Intersecção dos dois | ✅ |
| Limpar filtros | (sem parâmetros) | Retorna todos os dados | ✅ |

### Indicadores

| KPI | Resultado (sem filtro) | Validado |
|---|---|---|
| Faturamento Bruto | Calculado com `SUM(qtd × preco)` | ✅ |
| Desconto Total | `SUM(desconto_item)` | ✅ |
| Receita Líquida | Faturamento − Descontos | ✅ |
| Custo Total | `SUM(qtd × custo_unitario)` | ✅ |
| Margem Bruta | Receita Líquida − Custo Total | ✅ |
| Margem Bruta % | `(MB / RL) × 100` | ✅ |
| Quantidade Vendida | `SUM(quantidade)` | ✅ |
| Ticket Médio | `RL / COUNT(DISTINCT id_venda)` | ✅ |

### Exportação CSV

- Arquivo gerado com cabeçalhos em português ✅
- BOM UTF-8 presente (abre corretamente no Excel) ✅
- Download disparado automaticamente ✅
- Nome do arquivo inclui data atual ✅

---

## Como Executar (Resumo)

```bash
# 1. Subir o banco
cd infra/docker && docker-compose up -d

# 2. Instalar dependências (uma vez só)
pip install -r app/requirements.txt

# 3. Iniciar o servidor
python -m uvicorn app.api:app --reload

# 4. Acessar
# Dashboard: http://localhost:8000
# API Docs:  http://localhost:8000/docs
```
