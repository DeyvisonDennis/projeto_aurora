-- =================================================================================
-- Projeto de Sistemas: Rede Comercial Aurora
-- Script Inicial de Criação de Banco de Dados, Carga e Consultas Analíticas
-- =================================================================================

-- 1. CRIAÇÃO DAS TABELAS

CREATE TABLE filial (
    id_filial SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL
);

CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    id_categoria INT NOT NULL,
    custo_unitario DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
);

CREATE TABLE venda (
    id_venda SERIAL PRIMARY KEY,
    id_filial INT NOT NULL,
    data_venda DATE NOT NULL,
    CONSTRAINT fk_venda_filial FOREIGN KEY (id_filial) REFERENCES filial (id_filial)
);

CREATE TABLE item_venda (
    id_item SERIAL PRIMARY KEY,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    desconto_item DECIMAL(10, 2) DEFAULT 0.00,
    CONSTRAINT fk_item_venda_venda FOREIGN KEY (id_venda) REFERENCES venda (id_venda),
    CONSTRAINT fk_item_venda_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto)
);

-- 2. CARGA DE DADOS INICIAIS (MOCK)

INSERT INTO filial (nome, cidade, estado) VALUES
('Aurora Matriz', 'São Paulo', 'SP'),
('Aurora Sul', 'Curitiba', 'PR'),
('Aurora Nordeste', 'Recife', 'PE');

INSERT INTO categoria (nome) VALUES
('Eletrônicos'),
('Eletrodomésticos'),
('Móveis');

-- Produtos e seus custos de aquisição/produção
INSERT INTO produto (nome, id_categoria, custo_unitario) VALUES
('Smartphone XYZ', 1, 800.00),     -- Cat 1
('Notebook Pro', 1, 2500.00),      -- Cat 1
('Geladeira Frost Free', 2, 1800.00), -- Cat 2
('Micro-ondas 30L', 2, 350.00),    -- Cat 2
('Sofá Retrátil 3 Lugares', 3, 900.00),-- Cat 3
('Mesa de Jantar 6 cadeiras', 3, 600.00); -- Cat 3

-- Vendas distribuídas em meses diferentes
INSERT INTO venda (id_filial, data_venda) VALUES
(1, '2023-10-15'),
(2, '2023-10-20'),
(3, '2023-10-25'),
(1, '2023-11-05'),
(2, '2023-11-12'),
(3, '2023-11-18'),
(1, '2023-12-02'),
(2, '2023-12-10'),
(3, '2023-12-15');

-- Itens de Venda
-- venda 1 (SP, Out)
INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario, desconto_item) VALUES
(1, 1, 2, 1200.00, 50.00),   -- Faturamento 2400, Custo 1600, Receita Liq 2350
(1, 4, 1, 500.00, 0.00);     -- Faturamento 500, Custo 350, Receita Liq 500

-- venda 2 (PR, Out)
INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario, desconto_item) VALUES
(2, 3, 1, 2500.00, 100.00),
(2, 5, 1, 1500.00, 50.00);

-- venda 3 (PE, Out)
INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario, desconto_item) VALUES
(3, 2, 1, 3800.00, 200.00);

-- venda 4 (SP, Nov)
INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario, desconto_item) VALUES
(4, 1, 3, 1200.00, 100.00),
(4, 6, 2, 900.00, 50.00);

-- venda 5 (PR, Nov)
INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario, desconto_item) VALUES
(5, 4, 2, 500.00, 20.00);

-- venda 6 (PE, Nov)
INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario, desconto_item) VALUES
(6, 3, 2, 2500.00, 300.00);

-- venda 7 (SP, Dez)
INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario, desconto_item) VALUES
(7, 2, 2, 3800.00, 400.00),
(7, 5, 2, 1500.00, 100.00);

-- venda 8 (PR, Dez)
INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario, desconto_item) VALUES
(8, 6, 1, 900.00, 0.00);

-- venda 9 (PE, Dez)
INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario, desconto_item) VALUES
(9, 1, 5, 1150.00, 250.00);


-- =================================================================================
-- 3. CONSULTAS PARA RESPONDER ÀS PERGUNTAS DE NEGÓCIO OBRIGATÓRIAS
-- =================================================================================

-- PERGUNTA 1: Qual foi o faturamento total por mês?
-- Nota: Faturamento Bruto = quantidade_vendida * preco_unitario
SELECT 
    TO_CHAR(v.data_venda, 'YYYY-MM') AS mes,
    SUM(iv.quantidade * iv.preco_unitario) AS faturamento_bruto_total
FROM 
    venda v
JOIN 
    item_venda iv ON v.id_venda = iv.id_venda
GROUP BY 
    TO_CHAR(v.data_venda, 'YYYY-MM')
ORDER BY 
    mes;


-- PERGUNTA 2: Quais filiais tiveram maior receita líquida no período analisado?
-- Nota: Receita Líquida = Faturamento Bruto - Desconto Total
SELECT 
    f.nome AS filial,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida_total
FROM 
    filial f
JOIN 
    venda v ON f.id_filial = v.id_filial
JOIN 
    item_venda iv ON v.id_venda = iv.id_venda
GROUP BY 
    f.nome
ORDER BY 
    receita_liquida_total DESC;


-- PERGUNTA 3: Quais categorias de produto geraram maior receita líquida?
SELECT 
    c.nome AS categoria,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida_total
FROM 
    categoria c
JOIN 
    produto p ON c.id_categoria = p.id_categoria
JOIN 
    item_venda iv ON p.id_produto = iv.id_produto
GROUP BY 
    c.nome
ORDER BY 
    receita_liquida_total DESC;


-- PERGUNTA 4: Quais produtos tiveram maior quantidade vendida?
SELECT 
    p.nome AS produto,
    SUM(iv.quantidade) AS quantidade_total_vendida
FROM 
    produto p
JOIN 
    item_venda iv ON p.id_produto = iv.id_produto
GROUP BY 
    p.nome
ORDER BY 
    quantidade_total_vendida DESC;


-- PERGUNTA 5: Como a margem bruta varia por mês, filial e categoria?
-- Nota: Margem Bruta = Receita Líquida - Custo Total
--       Custo Total = quantidade * custo_unitario
SELECT 
    TO_CHAR(v.data_venda, 'YYYY-MM') AS mes,
    f.nome AS filial,
    c.nome AS categoria,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida,
    SUM(iv.quantidade * p.custo_unitario) AS custo_total,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario) AS margem_bruta,
    ROUND(
        ( (SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario)) / 
        NULLIF(SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item), 0) ) * 100, 2
    ) AS margem_bruta_percentual
FROM 
    venda v
JOIN 
    filial f ON v.id_filial = f.id_filial
JOIN 
    item_venda iv ON v.id_venda = iv.id_venda
JOIN 
    produto p ON iv.id_produto = p.id_produto
JOIN 
    categoria c ON p.id_categoria = c.id_categoria
GROUP BY 
    TO_CHAR(v.data_venda, 'YYYY-MM'),
    f.nome,
    c.nome
ORDER BY 
    mes, filial, categoria;

-- =================================================================================
-- EXTRA: EXEMPLO DE CONSULTA COM TODOS OS INDICADORES (Visão Global)
-- =================================================================================
/*
SELECT 
    SUM(iv.quantidade * iv.preco_unitario) AS faturamento_bruto,
    SUM(iv.desconto_item) AS desconto_total,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida,
    SUM(iv.quantidade * p.custo_unitario) AS custo_total,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario) AS margem_bruta,
    ROUND(
        ( (SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario)) / 
        NULLIF(SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item), 0) ) * 100, 2
    ) AS margem_bruta_percentual,
    SUM(iv.quantidade) AS quantidade_vendida,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) / COUNT(DISTINCT v.id_venda) AS ticket_medio
FROM 
    venda v
JOIN 
    item_venda iv ON v.id_venda = iv.id_venda
JOIN 
    produto p ON iv.id_produto = p.id_produto;
*/
