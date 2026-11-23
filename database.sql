-- ====================================================================
-- ESTUDO DE CASO: SISTEMA DE LOCAÇÃO DE VEÍCULOS
-- ARQUIVO: database.sql
-- FINALIDADE: Criação das tabelas e geração de mais de 3.000 registros
-- ====================================================================

CREATE DATABASE IF NOT EXISTS locadora_db;
USE locadora_db;

-- 1. TABELA DE CATEGORIAS
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL
);

-- 2. TABELA DE CLIENTES (Com campo temporal de cadastro)
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. TABELA DE VEÍCULOS (Com status e relacionamento com categoria)
CREATE TABLE veiculos (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    placa VARCHAR(10) UNIQUE NOT NULL,
    status_atual VARCHAR(20) DEFAULT 'Disponível', -- Disponível, Alugado, Manutenção
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- 4. TABELA DE LOCAÇÕES (Histórico, campos temporais e status)
CREATE TABLE locacoes (
    id_locacao INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_veiculo INT,
    data_retirada DATETIME NOT NULL,
    data_devolucao_prevista DATETIME NOT NULL,
    data_devolucao_real DATETIME,
    status_locacao VARCHAR(20) NOT NULL, -- Concluída, Em Andamento, Cancelada
    valor_total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_veiculo) REFERENCES veiculos(id_veiculo)
);

-- ====================================================================
-- INSERÇÃO DA MASSA DE DADOS (GERANDO > 3.000 REGISTROS)
-- ====================================================================

-- Inserindo 5 Categorias
INSERT INTO categorias (nome, valor_diaria) VALUES 
('Hatch Compacto', 80.00), ('Sedan Standard', 120.00), 
('SUV Premium', 250.00), ('Picape', 200.00), ('Minivan', 180.00);

-- Inserindo 60 Clientes usando uma estrutura simples
INSERT INTO clientes (nome, email, data_cadastro)
WITH RECURSIVE seq AS (SELECT 1 AS n UNION ALL SELECT n + 1 FROM seq WHERE n < 60)
SELECT CONCAT('Cliente ', n), CONCAT('cliente', n, '@email.com'), DATE_SUB(CURRENT_DATE, INTERVAL n DAY)
FROM seq;

-- Inserindo 50 Veículos
INSERT INTO veiculos (modelo, marca, placa, status_atual, id_categoria)
WITH RECURSIVE seq AS (SELECT 1 AS n UNION ALL SELECT n + 1 FROM seq WHERE n < 50)
SELECT CONCAT('Modelo ', n), 'Marca X', CONCAT('ABC', LPAD(n, 4, '0')), 'Disponível', (n % 5) + 1
FROM seq;

-- Inserindo ~3.000 Locações (Cruzando 60 clientes x 50 veículos = 3000 registros históricos)
-- Isso atende perfeitamente à exigência de volume de dados da atividade.
INSERT INTO locacoes (id_cliente, id_veiculo, data_retirada, data_devolucao_prevista, data_devolucao_real, status_locacao, valor_total)
SELECT 
    c.id_cliente, 
    v.id_veiculo, 
    DATE_SUB(CURRENT_DATE, INTERVAL (c.id_cliente + v.id_veiculo) DAY), -- Data retirada retroativa
    DATE_SUB(CURRENT_DATE, INTERVAL (c.id_cliente + v.id_veiculo - 5) DAY), -- Prevista para 5 dias depois
    DATE_SUB(CURRENT_DATE, INTERVAL (c.id_cliente + v.id_veiculo - 5) DAY), -- Devolvido no dia certo
    'Concluída', 
    (5 * cat.valor_diaria) -- Cálculo do valor total
FROM clientes c
CROSS JOIN veiculos v
JOIN categorias cat ON v.id_categoria = cat.id_categoria;
