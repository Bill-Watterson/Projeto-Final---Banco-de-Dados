-- ====================================================================
-- ESTUDO DE CASO: SISTEMA DE LANCHONETE (COMANDAS)
-- ARQUIVO: database.sql
-- ====================================================================

CREATE DATABASE IF NOT EXISTS lanchonete_db;
USE lanchonete_db;

-- 1. TABELA MESA
CREATE TABLE mesa (
    numero INT PRIMARY KEY,
    ocupada BOOLEAN DEFAULT FALSE
);

-- 2. TABELA PRODUTO (Superclasse)
CREATE TABLE produto (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    tipo VARCHAR(20) NOT NULL -- 'SUCO', 'SANDUICHE', 'SALADA'
);

-- 3. SUBCLASSES DE PRODUTO
CREATE TABLE produto_suco (
    codigo INT PRIMARY KEY,
    tamanho VARCHAR(20),
    FOREIGN KEY (codigo) REFERENCES produto(codigo) ON DELETE CASCADE
);

CREATE TABLE produto_sanduiche (
    codigo INT PRIMARY KEY,
    pao VARCHAR(50),
    FOREIGN KEY (codigo) REFERENCES produto(codigo) ON DELETE CASCADE
);

CREATE TABLE produto_salada (
    codigo INT PRIMARY KEY,
    adicional VARCHAR(50),
    FOREIGN KEY (codigo) REFERENCES produto(codigo) ON DELETE CASCADE
);

-- 4. TABELA ATENDIMENTO
CREATE TABLE atendimento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mesa_numero INT,
    status VARCHAR(20) DEFAULT 'aberto', -- aberto, encerrado, cancelado
    data_abertura DATETIME NOT NULL,
    data_fechamento DATETIME,
    FOREIGN KEY (mesa_numero) REFERENCES mesa(numero)
);

-- 5. TABELA PEDIDO
CREATE TABLE pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    atendimento_id INT,
    produto_codigo INT,
    quantidade INT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (atendimento_id) REFERENCES atendimento(id),
    FOREIGN KEY (produto_codigo) REFERENCES produto(codigo)
);

-- 6. TABELA PAGAMENTO
CREATE TABLE pagamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    atendimento_id INT,
    valor DECIMAL(10,2) NOT NULL,
    forma_pagamento VARCHAR(30),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (atendimento_id) REFERENCES atendimento(id)
);

-- ====================================================================
-- INSERÇÃO DA MASSA DE DADOS (GERANDO > 3.000 REGISTROS)
-- ====================================================================

-- Mesas (15 mesas)
INSERT INTO mesa (numero) VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15);

-- Produtos (10 Produtos Variados)
INSERT INTO produto (nome, preco, tipo) VALUES 
('Suco de Laranja', 8.50, 'SUCO'), ('Suco de Uva', 9.00, 'SUCO'),
('X-Salada', 18.00, 'SANDUICHE'), ('X-Bacon', 22.00, 'SANDUICHE'), ('Misto Quente', 12.00, 'SANDUICHE'),
('Salada Tradicional', 15.00, 'SALADA'), ('Salada Tropical', 18.00, 'SALADA'),
('Suco de Limão', 7.50, 'SUCO'), ('X-Tudo', 28.00, 'SANDUICHE'), ('Salada Fit', 20.00, 'SALADA');

INSERT INTO produto_suco (codigo, tamanho) VALUES (1, '500ml'), (2, '500ml'), (8, '300ml');
INSERT INTO produto_sanduiche (codigo, pao) VALUES (3, 'Brioche'), (4, 'Brioche'), (5, 'Forma'), (9, 'Artesanal');
INSERT INTO produto_salada (codigo, adicional) VALUES (6, 'Mel'), (7, 'Leite Condensado'), (10, 'Whey');

-- Gerando 150 Atendimentos retroativos usando CTE recursiva
INSERT INTO atendimento (mesa_numero, status, data_abertura, data_fechamento)
WITH RECURSIVE seq AS (SELECT 1 AS n UNION ALL SELECT n + 1 FROM seq WHERE n < 150)
SELECT 
    (n % 15) + 1, 'encerrado', DATE_SUB(CURRENT_DATE, INTERVAL n DAY), DATE_SUB(CURRENT_DATE, INTERVAL (n-1) DAY)
FROM seq;

-- Gerando 3.000 Pedidos cruzando Atendimentos e Produtos (150 atendimentos * 10 produtos = 1500 linhas, duplicadas = 3000)
INSERT INTO pedido (atendimento_id, produto_codigo, quantidade, valor_total, data_hora)
SELECT 
    a.id, p.codigo, 2, (p.preco * 2), a.data_abertura
FROM atendimento a
CROSS JOIN produto p;

INSERT INTO pedido (atendimento_id, produto_codigo, quantidade, valor_total, data_hora)
SELECT 
    a.id, p.codigo, 1, p.preco, DATE_ADD(a.data_abertura, INTERVAL 1 HOUR)
FROM atendimento a
CROSS JOIN produto p;

-- Pagamentos (Fechando os atendimentos)
INSERT INTO pagamento (atendimento_id, valor, forma_pagamento, data_hora)
SELECT id, 50.00, 'PIX', data_fechamento FROM atendimento;
