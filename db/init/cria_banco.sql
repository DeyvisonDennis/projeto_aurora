-- =================================================================================
-- Projeto de Sistemas: Rede Comercial Aurora
-- Script Inicial de Criação de Banco de Dados, Carga e Consultas Analíticas (Semana 2)
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

-- Filiais
INSERT INTO filial (nome, cidade, estado) VALUES
('Aurora Matriz', 'São Paulo', 'SP'),
('Aurora Sul', 'Curitiba', 'PR'),
('Aurora Nordeste', 'Recife', 'PE'),
('Aurora Minas', 'Belo Horizonte', 'MG'),
('Aurora Centro', 'Goiânia', 'GO');

-- Categorias
INSERT INTO categoria (nome) VALUES
('Eletrônicos'),
('Eletrodomésticos'),
('Móveis'),
('Informática'),
('Celulares');

-- Produtos
INSERT INTO produto (nome, id_categoria, custo_unitario) VALUES
('TV LED 50', 1, 1500.00),
('Home Theater', 1, 600.00),
('Caixa de Som BT', 1, 150.00),
('Fone de Ouvido', 1, 50.00),
('Geladeira Frost Free', 2, 1800.00),
('Micro-ondas 30L', 2, 350.00),
('Fogão 4 Bocas', 2, 450.00),
('Máquina de Lavar', 2, 1200.00),
('Sofá Retrátil 3 Lugares', 3, 900.00),
('Mesa de Jantar 6 cadeiras', 3, 600.00),
('Cadeira de Escritório', 3, 250.00),
('Guarda-Roupa Casal', 3, 700.00),
('Notebook Pro', 4, 2500.00),
('Mouse Sem Fio', 4, 30.00),
('Teclado Mecânico', 4, 150.00),
('Monitor 24', 4, 500.00),
('Smartphone XYZ', 5, 800.00),
('Smartphone ABC', 5, 1200.00),
('Carregador Rápido', 5, 40.00),
('Capa Protetora', 5, 10.00);

-- Vendas
INSERT INTO venda (id_filial, data_venda) VALUES
(1, '2024-01-07'),
(5, '2024-01-07'),
(1, '2024-02-10'),
(4, '2024-01-21'),
(4, '2024-03-12'),
(2, '2024-04-28'),
(4, '2024-04-11'),
(2, '2024-05-10'),
(1, '2024-06-23'),
(3, '2024-01-29'),
(1, '2024-06-09'),
(5, '2024-03-23'),
(2, '2024-06-17'),
(3, '2024-04-22'),
(1, '2024-05-11'),
(5, '2024-05-27'),
(3, '2024-01-28'),
(1, '2024-04-23'),
(1, '2024-01-24'),
(2, '2024-04-07'),
(4, '2024-03-14'),
(5, '2024-05-15'),
(2, '2024-04-13'),
(1, '2024-06-07'),
(5, '2024-03-21'),
(1, '2024-01-03'),
(5, '2024-06-29'),
(2, '2024-03-08'),
(3, '2024-03-13'),
(3, '2024-01-14'),
(2, '2024-06-12'),
(5, '2024-01-10'),
(1, '2024-03-31'),
(3, '2024-02-10'),
(2, '2024-02-21'),
(5, '2024-04-12'),
(3, '2024-04-21'),
(4, '2024-01-01'),
(1, '2024-03-17'),
(2, '2024-06-06'),
(4, '2024-06-21'),
(5, '2024-03-26'),
(2, '2024-02-07'),
(5, '2024-01-19'),
(2, '2024-02-15'),
(5, '2024-04-19'),
(3, '2024-03-01'),
(5, '2024-04-29'),
(3, '2024-04-09'),
(2, '2024-06-08'),
(1, '2024-01-22'),
(4, '2024-03-05'),
(1, '2024-03-30'),
(5, '2024-02-09'),
(3, '2024-02-12'),
(3, '2024-05-27'),
(3, '2024-05-16'),
(4, '2024-02-15'),
(1, '2024-03-12'),
(3, '2024-05-22'),
(4, '2024-05-22'),
(2, '2024-03-19'),
(3, '2024-03-19'),
(5, '2024-06-01'),
(3, '2024-06-27'),
(3, '2024-02-17'),
(4, '2024-01-19'),
(3, '2024-01-22'),
(4, '2024-04-23'),
(2, '2024-06-09'),
(5, '2024-04-30'),
(5, '2024-06-18'),
(1, '2024-01-16'),
(4, '2024-03-10'),
(1, '2024-06-21'),
(4, '2024-06-11'),
(5, '2024-01-10'),
(1, '2024-02-18'),
(1, '2024-06-10'),
(1, '2024-04-28'),
(3, '2024-05-10'),
(2, '2024-01-18'),
(4, '2024-02-08'),
(4, '2024-01-12'),
(2, '2024-05-08'),
(2, '2024-01-20'),
(1, '2024-06-07'),
(3, '2024-02-28'),
(1, '2024-04-23'),
(2, '2024-03-03'),
(3, '2024-04-27'),
(3, '2024-06-12'),
(4, '2024-03-11'),
(1, '2024-06-04'),
(1, '2024-03-20'),
(3, '2024-02-12'),
(4, '2024-05-22'),
(5, '2024-04-07'),
(4, '2024-06-28'),
(2, '2024-04-09'),
(2, '2024-04-02'),
(3, '2024-01-16'),
(2, '2024-01-18'),
(5, '2024-01-01'),
(2, '2024-05-30'),
(3, '2024-05-11'),
(5, '2024-03-18'),
(5, '2024-06-11'),
(5, '2024-02-25'),
(1, '2024-01-24'),
(2, '2024-05-22'),
(1, '2024-04-15'),
(1, '2024-03-30'),
(5, '2024-06-17'),
(5, '2024-06-17'),
(5, '2024-06-01'),
(1, '2024-03-10'),
(3, '2024-01-12'),
(3, '2024-03-24'),
(2, '2024-02-03');

-- Itens de Venda
INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario, desconto_item) VALUES
(1, 8, 3, 2000.00, 744.40),
(1, 20, 3, 40.00, 11.06),
(1, 5, 1, 2800.00, 205.15),
(2, 18, 1, 2100.00, 0.00),
(2, 14, 2, 80.00, 0.00),
(3, 11, 2, 450.00, 79.19),
(3, 9, 2, 1600.00, 0.00),
(3, 5, 3, 2800.00, 456.50),
(3, 7, 2, 800.00, 0.00),
(4, 20, 3, 40.00, 13.94),
(4, 12, 2, 1300.00, 0.00),
(4, 7, 1, 800.00, 0.00),
(5, 12, 1, 1300.00, 0.00),
(5, 6, 3, 600.00, 0.00),
(5, 20, 3, 40.00, 13.62),
(5, 18, 3, 2100.00, 0.00),
(6, 9, 1, 1600.00, 85.14),
(6, 18, 2, 2100.00, 0.00),
(6, 8, 1, 2000.00, 288.58),
(6, 11, 3, 450.00, 0.00),
(7, 5, 3, 2800.00, 0.00),
(7, 9, 2, 1600.00, 0.00),
(7, 20, 2, 40.00, 0.00),
(7, 8, 2, 2000.00, 0.00),
(8, 3, 3, 300.00, 106.24),
(8, 2, 3, 1100.00, 290.93),
(8, 4, 2, 120.00, 0.00),
(8, 5, 3, 2800.00, 0.00),
(9, 18, 2, 2100.00, 0.00),
(10, 14, 1, 80.00, 0.00),
(10, 6, 3, 600.00, 180.11),
(10, 15, 1, 350.00, 0.00),
(11, 17, 2, 1500.00, 0.00),
(11, 7, 3, 800.00, 0.00),
(11, 5, 3, 2800.00, 0.00),
(12, 1, 1, 2200.00, 303.16),
(12, 4, 1, 120.00, 11.83),
(12, 12, 1, 1300.00, 0.00),
(12, 10, 3, 1100.00, 0.00),
(13, 18, 3, 2100.00, 0.00),
(13, 6, 1, 600.00, 0.00),
(13, 9, 3, 1600.00, 0.00),
(13, 17, 3, 1500.00, 0.00),
(14, 4, 2, 120.00, 25.29),
(14, 8, 3, 2000.00, 342.60),
(14, 19, 3, 90.00, 15.32),
(14, 3, 1, 300.00, 0.00),
(15, 9, 1, 1600.00, 0.00),
(15, 16, 3, 900.00, 0.00),
(16, 8, 1, 2000.00, 186.21),
(16, 16, 2, 900.00, 0.00),
(16, 14, 3, 80.00, 27.68),
(16, 7, 3, 800.00, 216.63),
(17, 7, 3, 800.00, 0.00),
(17, 20, 2, 40.00, 7.70),
(18, 2, 3, 1100.00, 0.00),
(19, 6, 2, 600.00, 0.00),
(19, 14, 2, 80.00, 0.00),
(20, 13, 2, 4000.00, 0.00),
(21, 18, 2, 2100.00, 234.56),
(21, 16, 3, 900.00, 0.00),
(21, 5, 3, 2800.00, 0.00),
(21, 7, 1, 800.00, 0.00),
(22, 2, 1, 1100.00, 0.00),
(22, 17, 1, 1500.00, 0.00),
(23, 19, 1, 90.00, 0.00),
(24, 14, 3, 80.00, 0.00),
(25, 7, 2, 800.00, 0.00),
(25, 11, 3, 450.00, 0.00),
(25, 8, 2, 2000.00, 0.00),
(26, 20, 3, 40.00, 9.18),
(26, 19, 2, 90.00, 0.00),
(26, 4, 1, 120.00, 0.00),
(26, 3, 1, 300.00, 0.00),
(27, 20, 3, 40.00, 0.00),
(27, 17, 2, 1500.00, 0.00),
(27, 1, 1, 2200.00, 0.00),
(28, 4, 3, 120.00, 0.00),
(29, 11, 3, 450.00, 0.00),
(29, 7, 2, 800.00, 0.00),
(30, 14, 2, 80.00, 13.34),
(31, 6, 3, 600.00, 0.00),
(31, 15, 1, 350.00, 50.58),
(31, 18, 3, 2100.00, 0.00),
(32, 19, 2, 90.00, 14.55),
(32, 18, 1, 2100.00, 0.00),
(32, 5, 1, 2800.00, 0.00),
(33, 20, 1, 40.00, 0.00),
(33, 5, 1, 2800.00, 398.86),
(33, 8, 2, 2000.00, 0.00),
(33, 6, 3, 600.00, 0.00),
(34, 13, 1, 4000.00, 0.00),
(35, 12, 1, 1300.00, 0.00),
(35, 10, 2, 1100.00, 0.00),
(35, 8, 1, 2000.00, 0.00),
(35, 18, 2, 2100.00, 0.00),
(36, 1, 1, 2200.00, 0.00),
(36, 4, 2, 120.00, 26.32),
(36, 9, 2, 1600.00, 0.00),
(37, 13, 3, 4000.00, 653.26),
(38, 12, 1, 1300.00, 0.00),
(38, 14, 2, 80.00, 0.00),
(39, 14, 3, 80.00, 15.05),
(39, 11, 2, 450.00, 0.00),
(39, 13, 2, 4000.00, 0.00),
(40, 13, 2, 4000.00, 743.91),
(40, 18, 3, 2100.00, 0.00),
(40, 1, 2, 2200.00, 0.00),
(41, 17, 3, 1500.00, 263.16),
(41, 16, 3, 900.00, 0.00),
(42, 8, 3, 2000.00, 0.00),
(43, 2, 1, 1100.00, 0.00),
(44, 14, 2, 80.00, 0.00),
(44, 19, 1, 90.00, 0.00),
(44, 7, 1, 800.00, 0.00),
(44, 13, 1, 4000.00, 0.00),
(45, 2, 2, 1100.00, 212.22),
(45, 18, 3, 2100.00, 0.00),
(45, 8, 3, 2000.00, 0.00),
(45, 4, 2, 120.00, 0.00),
(46, 6, 1, 600.00, 0.00),
(46, 16, 2, 900.00, 0.00),
(46, 15, 3, 350.00, 0.00),
(46, 9, 1, 1600.00, 92.40),
(47, 11, 1, 450.00, 32.91),
(47, 20, 3, 40.00, 8.57),
(47, 18, 2, 2100.00, 0.00),
(48, 2, 3, 1100.00, 0.00),
(48, 7, 1, 800.00, 0.00),
(48, 14, 3, 80.00, 0.00),
(48, 13, 1, 4000.00, 0.00),
(49, 18, 1, 2100.00, 206.98),
(49, 20, 2, 40.00, 0.00),
(49, 8, 3, 2000.00, 0.00),
(49, 16, 3, 900.00, 261.20),
(50, 13, 3, 4000.00, 0.00),
(51, 5, 2, 2800.00, 0.00),
(51, 15, 1, 350.00, 0.00),
(51, 6, 2, 600.00, 0.00),
(51, 2, 2, 1100.00, 319.26),
(52, 16, 1, 900.00, 0.00),
(53, 3, 1, 300.00, 0.00),
(53, 2, 1, 1100.00, 0.00),
(54, 5, 3, 2800.00, 1216.12),
(54, 16, 2, 900.00, 0.00),
(55, 6, 2, 600.00, 63.08),
(56, 13, 1, 4000.00, 0.00),
(56, 7, 2, 800.00, 0.00),
(56, 3, 3, 300.00, 0.00),
(56, 8, 3, 2000.00, 0.00),
(57, 12, 1, 1300.00, 0.00),
(57, 3, 2, 300.00, 87.65),
(57, 17, 3, 1500.00, 0.00),
(57, 11, 2, 450.00, 0.00),
(58, 20, 2, 40.00, 0.00),
(58, 18, 3, 2100.00, 0.00),
(58, 16, 2, 900.00, 0.00),
(59, 8, 1, 2000.00, 0.00),
(59, 15, 2, 350.00, 49.85),
(59, 13, 2, 4000.00, 0.00),
(59, 11, 3, 450.00, 0.00),
(60, 17, 1, 1500.00, 183.01),
(61, 16, 2, 900.00, 0.00),
(61, 20, 1, 40.00, 3.62),
(62, 16, 2, 900.00, 0.00),
(62, 18, 3, 2100.00, 0.00),
(62, 17, 2, 1500.00, 0.00),
(63, 8, 2, 2000.00, 414.35),
(63, 4, 3, 120.00, 25.79),
(63, 7, 2, 800.00, 174.33),
(64, 4, 1, 120.00, 0.00),
(64, 7, 2, 800.00, 165.46),
(64, 10, 2, 1100.00, 122.00),
(65, 16, 1, 900.00, 0.00),
(65, 4, 2, 120.00, 0.00),
(66, 9, 2, 1600.00, 180.91),
(67, 5, 1, 2800.00, 0.00),
(68, 4, 2, 120.00, 0.00),
(68, 18, 3, 2100.00, 644.22),
(69, 19, 3, 90.00, 0.00),
(69, 14, 3, 80.00, 0.00),
(69, 10, 1, 1100.00, 0.00),
(70, 9, 1, 1600.00, 168.32),
(70, 3, 1, 300.00, 28.52),
(71, 2, 3, 1100.00, 448.67),
(71, 8, 1, 2000.00, 0.00),
(71, 10, 2, 1100.00, 0.00),
(72, 14, 3, 80.00, 15.58),
(72, 4, 2, 120.00, 0.00),
(73, 10, 2, 1100.00, 0.00),
(73, 19, 2, 90.00, 0.00),
(74, 15, 3, 350.00, 0.00),
(74, 3, 2, 300.00, 43.74),
(74, 2, 3, 1100.00, 0.00),
(74, 14, 3, 80.00, 0.00),
(75, 19, 2, 90.00, 0.00),
(75, 2, 2, 1100.00, 0.00),
(75, 6, 1, 600.00, 0.00),
(76, 3, 2, 300.00, 0.00),
(76, 16, 1, 900.00, 0.00),
(76, 12, 2, 1300.00, 0.00),
(76, 14, 2, 80.00, 23.12),
(77, 3, 1, 300.00, 0.00),
(77, 11, 2, 450.00, 0.00),
(77, 9, 1, 1600.00, 0.00),
(77, 19, 3, 90.00, 0.00),
(78, 20, 1, 40.00, 4.20),
(78, 16, 2, 900.00, 0.00),
(78, 15, 3, 350.00, 0.00),
(79, 6, 3, 600.00, 163.44),
(79, 10, 1, 1100.00, 0.00),
(80, 5, 2, 2800.00, 0.00),
(81, 14, 1, 80.00, 0.00),
(81, 16, 1, 900.00, 0.00),
(81, 19, 3, 90.00, 0.00),
(82, 14, 2, 80.00, 0.00),
(82, 11, 2, 450.00, 0.00),
(82, 17, 3, 1500.00, 0.00),
(83, 18, 3, 2100.00, 0.00),
(83, 16, 2, 900.00, 0.00),
(83, 12, 2, 1300.00, 0.00),
(83, 11, 3, 450.00, 119.20),
(84, 16, 3, 900.00, 0.00),
(84, 13, 3, 4000.00, 0.00),
(84, 19, 2, 90.00, 0.00),
(85, 4, 3, 120.00, 0.00),
(85, 15, 1, 350.00, 0.00),
(85, 20, 2, 40.00, 0.00),
(86, 9, 2, 1600.00, 0.00),
(86, 11, 3, 450.00, 0.00),
(86, 13, 2, 4000.00, 0.00),
(86, 3, 2, 300.00, 0.00),
(87, 8, 3, 2000.00, 0.00),
(88, 14, 1, 80.00, 0.00),
(89, 10, 1, 1100.00, 0.00),
(89, 1, 1, 2200.00, 192.47),
(90, 19, 1, 90.00, 0.00),
(90, 6, 2, 600.00, 0.00),
(90, 20, 1, 40.00, 0.00),
(90, 18, 3, 2100.00, 605.52),
(91, 1, 3, 2200.00, 0.00),
(91, 15, 1, 350.00, 0.00),
(91, 10, 2, 1100.00, 0.00),
(92, 9, 2, 1600.00, 0.00),
(92, 15, 1, 350.00, 37.52),
(92, 10, 3, 1100.00, 395.76),
(92, 7, 1, 800.00, 0.00),
(93, 19, 3, 90.00, 0.00),
(94, 10, 3, 1100.00, 247.71),
(94, 8, 3, 2000.00, 0.00),
(94, 12, 3, 1300.00, 0.00),
(94, 19, 3, 90.00, 30.44),
(95, 2, 1, 1100.00, 0.00),
(95, 19, 2, 90.00, 0.00),
(95, 12, 1, 1300.00, 167.25),
(95, 5, 2, 2800.00, 0.00),
(96, 16, 1, 900.00, 0.00),
(96, 10, 1, 1100.00, 161.32),
(96, 11, 3, 450.00, 0.00),
(97, 3, 2, 300.00, 0.00),
(97, 13, 2, 4000.00, 0.00),
(97, 1, 3, 2200.00, 0.00),
(98, 4, 1, 120.00, 0.00),
(98, 8, 3, 2000.00, 0.00),
(98, 16, 3, 900.00, 152.07),
(99, 14, 1, 80.00, 0.00),
(99, 4, 2, 120.00, 0.00),
(99, 5, 1, 2800.00, 388.43),
(100, 12, 2, 1300.00, 0.00),
(100, 18, 2, 2100.00, 0.00),
(100, 14, 2, 80.00, 13.93),
(100, 5, 2, 2800.00, 0.00),
(101, 12, 3, 1300.00, 0.00),
(102, 9, 1, 1600.00, 0.00),
(102, 7, 3, 800.00, 0.00),
(102, 4, 1, 120.00, 10.00),
(102, 15, 1, 350.00, 0.00),
(103, 19, 1, 90.00, 0.00),
(103, 7, 1, 800.00, 0.00),
(104, 5, 2, 2800.00, 0.00),
(104, 20, 1, 40.00, 0.00),
(104, 18, 1, 2100.00, 180.23),
(105, 1, 1, 2200.00, 202.61),
(105, 6, 1, 600.00, 0.00),
(105, 9, 2, 1600.00, 0.00),
(106, 15, 3, 350.00, 117.09),
(107, 1, 2, 2200.00, 0.00),
(107, 2, 2, 1100.00, 0.00),
(107, 16, 2, 900.00, 104.54),
(107, 13, 3, 4000.00, 751.43),
(108, 13, 2, 4000.00, 0.00),
(108, 17, 2, 1500.00, 360.53),
(108, 10, 3, 1100.00, 0.00),
(109, 15, 2, 350.00, 0.00),
(109, 8, 3, 2000.00, 556.06),
(109, 14, 3, 80.00, 34.89),
(109, 11, 3, 450.00, 0.00),
(110, 3, 2, 300.00, 74.33),
(111, 19, 3, 90.00, 0.00),
(112, 14, 3, 80.00, 0.00),
(112, 2, 1, 1100.00, 0.00),
(112, 10, 1, 1100.00, 108.04),
(113, 4, 2, 120.00, 0.00),
(113, 9, 3, 1600.00, 0.00),
(113, 8, 3, 2000.00, 0.00),
(114, 1, 3, 2200.00, 0.00),
(114, 6, 2, 600.00, 0.00),
(114, 9, 1, 1600.00, 0.00),
(115, 3, 3, 300.00, 0.00),
(115, 5, 2, 2800.00, 0.00),
(115, 1, 2, 2200.00, 357.12),
(115, 20, 2, 40.00, 0.00),
(116, 2, 1, 1100.00, 122.96),
(117, 14, 2, 80.00, 16.20),
(117, 16, 2, 900.00, 0.00),
(117, 15, 2, 350.00, 0.00),
(117, 20, 3, 40.00, 0.00),
(118, 13, 1, 4000.00, 578.13),
(118, 2, 1, 1100.00, 0.00),
(119, 1, 2, 2200.00, 0.00),
(120, 18, 1, 2100.00, 0.00),
(120, 8, 3, 2000.00, 311.24),
(120, 17, 1, 1500.00, 0.00),
(120, 12, 3, 1300.00, 0.00);

-- =================================================================================
-- 3. CONSULTAS PARA RESPONDER ÀS PERGUNTAS DE NEGÓCIO OBRIGATÓRIAS
-- =================================================================================

-- PERGUNTA 1: Faturamento total por mês
-- Deve retornar: mês, faturamento bruto, desconto total, receita líquida, quantidade vendida, quantidade de vendas
SELECT 
    TO_CHAR(v.data_venda, 'YYYY-MM') AS mes,
    SUM(iv.quantidade * iv.preco_unitario) AS faturamento_bruto,
    SUM(iv.desconto_item) AS desconto_total,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida,
    SUM(iv.quantidade) AS quantidade_vendida,
    COUNT(DISTINCT v.id_venda) AS quantidade_de_vendas
FROM 
    venda v
JOIN 
    item_venda iv ON v.id_venda = iv.id_venda
GROUP BY 
    TO_CHAR(v.data_venda, 'YYYY-MM')
ORDER BY 
    mes;


-- PERGUNTA 2: Receita líquida por filial
-- Deve retornar: filial, faturamento bruto, desconto total, receita líquida, custo total, margem bruta, margem bruta percentual
SELECT 
    f.nome AS filial,
    SUM(iv.quantidade * iv.preco_unitario) AS faturamento_bruto,
    SUM(iv.desconto_item) AS desconto_total,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida,
    SUM(iv.quantidade * p.custo_unitario) AS custo_total,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario) AS margem_bruta,
    ROUND(
        ( (SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario)) / 
        NULLIF(SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item), 0) ) * 100, 2
    ) AS margem_bruta_percentual
FROM 
    filial f
JOIN 
    venda v ON f.id_filial = v.id_filial
JOIN 
    item_venda iv ON v.id_venda = iv.id_venda
JOIN 
    produto p ON iv.id_produto = p.id_produto
GROUP BY 
    f.nome
ORDER BY 
    receita_liquida DESC;


-- PERGUNTA 3: Receita líquida por categoria
-- Deve retornar: categoria, quantidade vendida, faturamento bruto, receita líquida, margem bruta, margem bruta percentual
SELECT 
    c.nome AS categoria,
    SUM(iv.quantidade) AS quantidade_vendida,
    SUM(iv.quantidade * iv.preco_unitario) AS faturamento_bruto,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario) AS margem_bruta,
    ROUND(
        ( (SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario)) / 
        NULLIF(SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item), 0) ) * 100, 2
    ) AS margem_bruta_percentual
FROM 
    categoria c
JOIN 
    produto p ON c.id_categoria = p.id_categoria
JOIN 
    item_venda iv ON p.id_produto = iv.id_produto
GROUP BY 
    c.nome
ORDER BY 
    receita_liquida DESC;


-- PERGUNTA 4: Produtos mais vendidos
-- Deve retornar: produto, categoria, quantidade vendida, faturamento bruto, receita líquida
SELECT 
    p.nome AS produto,
    c.nome AS categoria,
    SUM(iv.quantidade) AS quantidade_vendida,
    SUM(iv.quantidade * iv.preco_unitario) AS faturamento_bruto,
    SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida
FROM 
    produto p
JOIN 
    categoria c ON p.id_categoria = c.id_categoria
JOIN 
    item_venda iv ON p.id_produto = iv.id_produto
GROUP BY 
    p.nome, c.nome
ORDER BY 
    quantidade_vendida DESC;


-- PERGUNTA 5: Margem bruta por mês, filial e categoria
-- Deve retornar: mês, filial, categoria, receita líquida, custo total, margem bruta, margem bruta percentual
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

