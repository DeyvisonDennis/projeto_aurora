# Rede Comercial Aurora — Sistema de Análise Comercial

> **Entrega Final — Semana 4** | Disciplina: Projeto de Sistemas

## Integrantes do Grupo

| Nome | Responsabilidade Principal |
|---|---|
| Ryan Charles Daldegan Reis | Backend (FastAPI, Queries SQL, Filtros) |
| Deyvison Dennis Antônio Lucas | Banco de Dados (Modelagem, Scripts SQL, Carga de Dados) |
| Vitor Epifânio de Assis Azevedo | Frontend (HTML, CSS, JavaScript, Dashboard) |
| Milleny Evan | Documentação e Testes |
| Yasmin Isabelli Callazans | Infraestrutura (Docker, docker-compose) |

---

## 1. Objetivo Técnico da Solução

Construir uma **aplicação web analítica** capaz de:

- Carregar dados comerciais estruturados em banco de dados relacional (PostgreSQL)
- Calcular e apresentar os 8 indicadores comerciais obrigatórios
- Permitir filtragem dinâmica por período, filial, categoria e produto
- Apresentar 5 visualizações analíticas em formato tabular interativo
- Exportar relatórios em CSV diretamente pelo browser
- Responder às 5 perguntas de negócio da Rede Comercial Aurora

---

## 2. Tecnologias Utilizadas

| Camada | Tecnologia | Versão |
|---|---|---|
| Banco de Dados | PostgreSQL | 17 (imagem Docker `postgres`) |
| Infraestrutura | Docker + Docker Compose | v2+ |
| Backend | Python + FastAPI | 3.x / FastAPI 0.111+ |
| Driver de BD | psycopg2-binary | 2.9+ |
| Servidor ASGI | uvicorn | 0.29+ |
| Frontend | HTML5 + CSS Vanilla + JavaScript | ES2020 |
| Fonte | Inter (Google Fonts) | — |

---

## 3. Justificativa da Arquitetura

A solução adota uma arquitetura **cliente-servidor em 3 camadas**:

```
Browser (Frontend) ←→ FastAPI (Backend) ←→ PostgreSQL (Banco)
```

**Por que FastAPI?**
- Desenvolvimento rápido com tipagem e documentação automática (Swagger em `/docs`)
- Servir o frontend como arquivos estáticos sem servidor separado
- Suporte nativo a Query Parameters para filtros dinâmicos

**Por que PostgreSQL?**
- SGBD relacional robusto, ideal para dados transacionais
- Suporte excelente a funções de janela, agregações e formatação de datas
- Amplamente usado em produção, garantindo conformidade com requisitos

**Por que JavaScript Vanilla (sem frameworks)?**
- Sem dependências externas — funciona em qualquer browser moderno
- Zero configuração de build
- Fácil de auditar e entender pelo professor

---

## 4. Estrutura de Pastas

```
projeto_aurora/
├── app/
│   ├── config/
│   │   └── database.py         # Configuração de conexão com o BD
│   ├── data_access/
│   │   └── queries.py          # Consultas SQL e filtros dinâmicos
│   ├── services/
│   │   └── kpi_service.py      # Regras de negócio e KPIs
│   ├── static/
│   │   ├── index.html          # Dashboard (frontend)
│   │   ├── app.js              # Lógica JS do dashboard
│   │   └── style.css           # Estilos do dashboard
│   ├── api.py                  # Rotas FastAPI (backend)
│   ├── main.py                 # CLI de testes (legado)
│   ├── requirements.txt        # Dependências Python
│   └── .env                    # Variáveis de ambiente
├── db/
│   ├── init/
│   │   └── cria_banco.sql      # Script completo (DDL + DML + Consultas)
│   └── docs/
│       └── modelo_banco.md     # Documentação do modelo de dados
├── infra/
│   └── docker/
│       ├── docker-compose.yml  # Orquestração do container PostgreSQL
│       └── README.md           # Instruções do Docker
└── docs/
    ├── entregas.md             # Checklist de entregas por semana
    ├── equipe.md               # Divisão técnica do trabalho
    ├── semana2.md              # Documentação da Semana 2
    ├── semana3.md              # Documentação da Semana 3
    ├── semana4.md              # Documentação da Semana 4 (entrega final)
    ├── testes_semana3.md       # Evidências de testes da Semana 3
    └── evidencias/
        └── README.md           # Guia de evidências
```

---

## 5. Modelo do Banco de Dados

### Diagrama ER

```
filial ──< venda >──── item_venda >── produto ──< categoria
              └── (id_filial)    └── (id_venda)   └── (id_produto)  └── (id_categoria)
```

### Descrição das Tabelas

| Tabela | Descrição |
|---|---|
| `filial` | Unidades da rede comercial (5 registros) |
| `categoria` | Categorias de produtos (5 registros) |
| `produto` | Catálogo de produtos com custo unitário (20 registros) |
| `venda` | Cabeçalho das vendas: filial e data (120 registros) |
| `item_venda` | Itens de cada venda: produto, quantidade, preço e desconto |

### Campos Relevantes

| Tabela | Campo | Tipo | Descrição |
|---|---|---|---|
| `produto` | `custo_unitario` | DECIMAL(10,2) | Custo de aquisição do produto |
| `item_venda` | `preco_unitario` | DECIMAL(10,2) | Preço de venda praticado |
| `item_venda` | `quantidade` | INT | Unidades vendidas |
| `item_venda` | `desconto_item` | DECIMAL(10,2) | Desconto em reais aplicado ao item |
| `venda` | `data_venda` | DATE | Data da transação |

---

## 6. Instruções para Subir o SGBD (Docker)

### Pré-requisitos
- Docker Desktop instalado e em execução
- Git (para clonar o repositório)

### Executar pela primeira vez

```bash
# Na raiz do projeto, navegue para a pasta do Docker:
cd infra/docker

# Suba o container do PostgreSQL:
docker-compose up -d
```

O container `aurora-db` iniciará e carregará **automaticamente** o script `db/init/cria_banco.sql`, criando todas as tabelas e inserindo os dados.

### Reiniciar do zero (limpar dados)

```bash
cd infra/docker
docker-compose down -v
docker-compose up -d
```

### Verificar se está funcionando

```bash
docker ps
# Deve mostrar: aurora-db   postgres   Up
```

### Credenciais do banco

| Parâmetro | Valor |
|---|---|
| Host | `localhost` |
| Porta | `5432` |
| Banco | `aurora_comercial` |
| Usuário | `postgres` |
| Senha | `postgres_password` |

---

## 7. Instruções para Executar a Aplicação

### Pré-requisitos
- Python 3.9+ instalado
- Container Docker do banco em execução (ver seção 6)

### Passo 1 — Instalar dependências

```bash
# Execute na raiz do projeto (onde está a pasta app/)
pip install -r app/requirements.txt
```

### Passo 2 — Iniciar o servidor

```bash
python -m uvicorn app.api:app --reload
```

### Passo 3 — Acessar o dashboard

Abra no seu navegador:

```
http://localhost:8000
```

A documentação interativa da API (Swagger) está disponível em:

```
http://localhost:8000/docs
```

---

## 8. Indicadores e Fórmulas

| Indicador | Fórmula |
|---|---|
| **Faturamento Bruto** | `SUM(quantidade × preco_unitario)` |
| **Desconto Total** | `SUM(desconto_item)` |
| **Receita Líquida** | `SUM((quantidade × preco_unitario) - desconto_item)` |
| **Custo Total** | `SUM(quantidade × custo_unitario)` |
| **Margem Bruta** | `Receita Líquida - Custo Total` |
| **Margem Bruta (%)** | `(Margem Bruta / Receita Líquida) × 100` |
| **Quantidade Vendida** | `SUM(quantidade)` |
| **Ticket Médio** | `Receita Líquida / COUNT(DISTINCT id_venda)` |

> **Nota:** A margem bruta percentual usa `NULLIF(Receita Líquida, 0)` no denominador para evitar divisão por zero. O ticket médio é calculado por número de pedidos (vendas), não por item.

---

## 9. Filtros Disponíveis

Os filtros são aplicados como **query parameters** na API e afetam todos os indicadores e visualizações simultaneamente:

| Filtro | Parâmetro | Tipo | Exemplo |
|---|---|---|---|
| Data Inicial | `data_inicial` | DATE | `2024-01-01` |
| Data Final | `data_final` | DATE | `2024-06-30` |
| Filial | `id_filial` | INT | `1` (Aurora Matriz) |
| Categoria | `id_categoria` | INT | `4` (Informática) |
| Produto | `id_produto` | INT | `13` (Notebook Pro) |

Os filtros são **combinados** com `AND` dinâmico na camada de queries. Filtros vazios são ignorados.

---

## 10. Visualizações Analíticas

| # | Visualização | Pergunta de Negócio | Endpoint |
|---|---|---|---|
| 1 | Faturamento total por mês | P1 | `GET /api/tabelas/mensal` |
| 2 | Receita líquida por filial | P2 | `GET /api/tabelas/filial` |
| 3 | Receita líquida por categoria | P3 | `GET /api/tabelas/categoria` |
| 4 | Ranking de produtos mais vendidos | P4 | `GET /api/tabelas/produtos` |
| 5 | Margem bruta por mês, filial e categoria | P5 | `GET /api/tabelas/margem` |

Todas as tabelas suportam os filtros obrigatórios e possuem botão de **exportação CSV** integrado.

---

## 11. As 5 Perguntas de Negócio

| Pergunta | Onde visualizar | Query SQL |
|---|---|---|
| **P1.** Qual o faturamento total por mês? | Tabela "Faturamento por Mês" | `db/init/cria_banco.sql` (linha 543) |
| **P2.** Qual a receita líquida por filial? | Tabela "Receita por Filial" | `db/init/cria_banco.sql` (linha 562) |
| **P3.** Qual a receita líquida por categoria? | Tabela "Receita por Categoria" | `db/init/cria_banco.sql` (linha 589) |
| **P4.** Quais os produtos mais vendidos? | Tabela "Ranking de Produtos" | `db/init/cria_banco.sql` (linha 613) |
| **P5.** Qual a margem bruta por mês, filial e categoria? | Tabela "Margem Bruta Detalhada" | `db/init/cria_banco.sql` (linha 633) |

---

## 12. Limitações Conhecidas

- A exportação de PDF não foi implementada (apenas CSV); o professor pode converter o CSV via Excel ou LibreOffice
- O sistema não possui autenticação — trata-se de um dashboard interno para demonstração acadêmica
- Os dados são estáticos (Janeiro a Junho de 2024); não há inserção em tempo real
- O filtro de produto e filial são mutuamente exclusivos no sentido de que não há filtro por "produto dentro de filial" — ambos se aplicam ao mesmo join

## 13. Melhorias Futuras

- Implementar gráficos interativos (Chart.js ou D3.js)
- Adicionar exportação em PDF via biblioteca `weasyprint` ou `reportlab`
- Autenticação de usuário para acesso ao dashboard
- Paginação nas tabelas com muitos resultados
- Inserção dinâmica de novos dados via formulário
- Deploy em nuvem (Railway, Render ou AWS)
