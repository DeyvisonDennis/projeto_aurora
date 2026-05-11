# Modelo Técnico do Banco de Dados

Este documento descreve a estrutura do banco de dados desenvolvido para a **Rede Comercial Aurora**, projetada para responder às perguntas de negócio e calcular os indicadores comerciais obrigatórios.

## Tabelas

### 1. filial
- **Finalidade Técnica:** Armazenar os dados das unidades da rede comercial, permitindo filtrar e agrupar vendas por localidade.
- **Campos:**
  - `id_filial` (INT): Identificador único da filial.
  - `nome` (VARCHAR): Nome da filial.
  - `cidade` (VARCHAR): Cidade onde está localizada.
  - `estado` (VARCHAR): Estado onde está localizada.
- **Chave Primária:** `id_filial`
- **Relacionamentos:** 1 filial pode possuir N vendas (`1:N` com `venda`).

### 2. categoria
- **Finalidade Técnica:** Agrupar produtos para análises de rentabilidade por segmento/categoria.
- **Campos:**
  - `id_categoria` (INT): Identificador único da categoria.
  - `nome` (VARCHAR): Nome da categoria.
- **Chave Primária:** `id_categoria`
- **Relacionamentos:** 1 categoria pode ter N produtos (`1:N` com `produto`).

### 3. produto
- **Finalidade Técnica:** Catálogo dos produtos vendidos, contendo o custo unitário que é fundamental para calcular a Margem Bruta e o Custo Total.
- **Campos:**
  - `id_produto` (INT): Identificador único do produto.
  - `nome` (VARCHAR): Nome ou descrição do produto.
  - `id_categoria` (INT): Referência à qual categoria pertence.
  - `custo_unitario` (DECIMAL): Custo de aquisição/produção da unidade.
- **Chave Primária:** `id_produto`
- **Chaves Estrangeiras:** `id_categoria` (referencia `categoria(id_categoria)`)
- **Relacionamentos:** 1 produto pode estar presente em N itens de venda (`1:N` com `item_venda`).

### 4. venda
- **Finalidade Técnica:** Registrar o cabeçalho das transações comerciais (o "recibo" ou "cupom"), vinculando a filial e a data/período em que ocorreu.
- **Campos:**
  - `id_venda` (INT): Identificador único da transação.
  - `id_filial` (INT): Referência da filial onde ocorreu a venda.
  - `data_venda` (DATE): Data da transação. Serve como base para extrair períodos (mês, ano).
- **Chave Primária:** `id_venda`
- **Chaves Estrangeiras:** `id_filial` (referencia `filial(id_filial)`)
- **Relacionamentos:** 1 venda pode ter N itens (`1:N` com `item_venda`).

### 5. item_venda
- **Finalidade Técnica:** Registrar o detalhe de cada produto incluído em uma venda específica. É a tabela onde se calculam Faturamento Bruto, Desconto Total, Receita Líquida, Ticket e Volumes de venda no nível mais granular.
- **Campos:**
  - `id_item` (INT): Identificador único da linha do item vendido.
  - `id_venda` (INT): Referência à venda (cabeçalho).
  - `id_produto` (INT): Referência ao produto vendido.
  - `quantidade` (INT): Volume de unidades vendidas.
  - `preco_unitario` (DECIMAL): Preço de venda praticado para aquela unidade.
  - `desconto_item` (DECIMAL): Total de desconto aplicado sobre aquele conjunto de itens na venda específica.
- **Chave Primária:** `id_item`
- **Chaves Estrangeiras:** 
  - `id_venda` (referencia `venda(id_venda)`)
  - `id_produto` (referencia `produto(id_produto)`)
- **Relacionamentos:** N itens pertencem a 1 venda; N itens referenciam 1 produto.

## Observações Importantes
- **Período Temporal:** A granularidade temporal é baseada na coluna `data_venda` da tabela `venda`. Funções como `EXTRACT(MONTH FROM data_venda)` ou `TO_CHAR(data_venda, 'YYYY-MM')` podem ser utilizadas para análises de calendário/período (mês a mês).
- **Descontos:** O desconto foi modelado no nível do item (`desconto_item`) para que o cálculo da receita líquida por produto ou categoria possa ser exato e sem a necessidade de rateios complexos do desconto global de uma venda.
- **Custo e Margem:** O custo unitário armazenado na tabela `produto` é multiplicado pela `quantidade` na tabela `item_venda` nas consultas (Queries), de modo a extrair a **Margem Bruta** daquela operação específica sem redundância de dados.
