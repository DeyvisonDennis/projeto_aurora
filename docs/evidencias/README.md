# Evidências — Rede Comercial Aurora

Esta pasta deve conter capturas de tela e evidências visuais do sistema em execução.

## Como Gerar as Evidências

Siga os passos abaixo para capturar as evidências necessárias para a apresentação:

### 1. Container Docker em execução

Execute no terminal:
```bash
cd infra/docker
docker-compose up -d
docker ps
```
**Capturar:** Print do terminal mostrando `aurora-db` com status `Up`.

### 2. Dashboard sem filtros (dados globais)

Acesse `http://localhost:8000` e capture:
- Os 8 KPIs com valores reais
- As 4 primeiras tabelas analíticas visíveis na tela

### 3. Filtro ativo — por Filial

No dashboard, selecione uma filial (ex: "Aurora Matriz") e capture:
- Os KPIs mostrando valores menores (filtrados)
- A tabela de faturamento mensal com dados apenas da filial selecionada

### 4. Filtro ativo — por Categoria

No dashboard, selecione uma categoria (ex: "Informática") e capture:
- Indicadores filtrados apenas para produtos de Informática

### 5. Filtro ativo — por Período

Configure Data Inicial: `2024-01-01` e Data Final: `2024-03-31` e capture:
- Os KPIs mostrando dados apenas do 1º trimestre

### 6. Tabela 5 — Margem Bruta Detalhada

Capture a tabela "Margem Bruta por Mês, Filial e Categoria" com:
- Dados sem filtro (visão completa cruzada)
- Badges coloridos de margem visíveis

### 7. Exportação CSV

Clique no botão "⬇ CSV" de qualquer tabela e capture:
- O arquivo sendo baixado (barra de downloads do browser)
- O arquivo aberto no Excel (opcional, demonstra BOM UTF-8 funcionando)

### 8. Swagger/API Docs

Acesse `http://localhost:8000/docs` e capture:
- Lista de todos os endpoints disponíveis

---

## Checklist de Evidências

- [ ] `01_docker_container_running.png` — Container em execução
- [ ] `02_dashboard_sem_filtro.png` — Dashboard completo sem filtros
- [ ] `03_filtro_filial.png` — Filtro por filial ativo
- [ ] `04_filtro_categoria.png` — Filtro por categoria ativo
- [ ] `05_filtro_periodo.png` — Filtro por período ativo
- [ ] `06_tabela_margem_detalhada.png` — 5ª tabela com margem cruzada
- [ ] `07_export_csv.png` — Download do CSV sendo realizado
- [ ] `08_api_swagger.png` — Documentação Swagger da API
