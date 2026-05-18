# Entrega Semana 2: Dados, Consultas e Serviços

## 1. Massa de Dados e Indicadores
A massa de dados foi expandida para permitir análises mais realistas. Através do script `db/init/cria_banco.sql` o banco de dados agora inicia com:
- **5 Filiais**
- **5 Categorias**
- **20 Produtos** (com variação de custos e preços)
- **120 Vendas** simuladas entre os meses de Janeiro a Junho de 2024.
- **Itens de Venda** atrelados às vendas contendo descontos aleatórios aplicados em certas vendas para validar os cálculos de Receita Líquida.

Com esta carga inicial as cinco perguntas de negócio obrigatórias podem ser perfeitamente testadas via SQL puro ou utilizando a aplicação.

---

## 2. Camada Técnica de Acesso aos Dados (Aplicação)

Construímos uma aplicação baseada em **Python** que funciona como nossa camada de acesso a dados e interface via linha de comando (CLI). O objetivo é provar o isolamento das camadas:

- **Configuração de conexão:** Isolada em `app/config/database.py`
- **Execução de Consultas:** As consultas complexas e os cálculos de margem foram isolados em `app/data_access/queries.py`
- **Regras de preparação de dados e filtros:** Isolados em `app/services/kpi_service.py`
- **Ponto de Uso / Interface:** A aplicação CLI em `app/main.py`.

### Filtros Técnicos Suportados
Todos os 5 serviços suportam recebimento dinâmico de parâmetros de filtro que alteram ativamente a consulta:
- `data_inicial` e `data_final` (Períodos)
- `id_filial`
- `id_categoria`
- `id_produto`

---

## 3. Como Executar o Banco de Dados

Caso ainda não esteja rodando, inicie o banco de dados via Docker para criar e popular as tabelas:

```bash
# Navegue até a pasta docker
cd infra/docker

# Derrube os containers antigos (e os volumes, para zerar os dados velhos da Semana 1)
docker-compose down -v

# Suba os containers com a nova carga de dados da Semana 2
docker-compose up -d
```

O container do PostgreSQL carregará o arquivo `db/init/cria_banco.sql` automaticamente.

---

## 4. Como Executar a Aplicação (Camada de Acesso a Dados)

1. Certifique-se de que possui o Python 3.x instalado.
2. Navegue até a raiz do projeto (onde está a pasta `app`).
3. Instale as dependências:
   ```bash
   pip install -r app/requirements.txt
   ```
4. Execute o arquivo principal. Ele irá conectar no banco de dados local executando no Docker, injetar os filtros de exemplo, executar as queries e imprimir os relatórios formatados no terminal.
   ```bash
   python app/main.py
   ```
