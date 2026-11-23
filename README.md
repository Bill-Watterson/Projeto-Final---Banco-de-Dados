# 🚗 Projeto Final de Banco de Dados - Sistema de Locadora de Veículos

## 📋 Sobre o Projeto
Este repositório contém a evolução estrutural do banco de dados de um Sistema de Locação de Veículos, unindo os conceitos de modelagem de dados, SQL Avançado e planejamento para integração com Programação Orientada a Objetos (POO).

## 🗄️ Estrutura do Banco de Dados
* **SGBD Utilizado:** MySQL / MariaDB
* **Nome do Banco:** `locadora_db`
* **Total de Tabelas:** 4 (`categorias`, `clientes`, `veiculos`, `locacoes`)
* **Volume de Dados:** Mais de **3.115 registros totais** gerados para testes massivos.
* **Uso de IA:** Utilizada IA (LLM) para auxílio na elaboração da sintaxe de `CROSS JOIN` iterativo, visando atingir a massa de dados superior a 3.000 registros de forma íntegra.

## 📊 Relatórios SQL Propostos
1. **Faturamento por Categoria:** Identifica quais categorias de carro dão mais lucro.
2. **Top 5 Clientes:** Lista os clientes mais fiéis para campanhas de marketing.
3. **Volume por Mês:** Analisa a sazonalidade e quantidade de locações históricas.

## 💻 Integração Futura (POO)
O banco foi preparado para receber o sistema em POO. As principais regras mapeadas são:
* Bloqueio de locação de veículos que não possuam o status "Disponível".
* Cálculo automatizado de diárias instanciando objetos da classe `Categoria`.
* Histórico inalterável para garantir rastreabilidade nas faturas.

## 🚀 Como Executar
1. Clone este repositório.
2. Abra o seu SGBD (MySQL Workbench, DBeaver, XAMPP/phpMyAdmin).
3. Importe ou execute inteiramente o arquivo `database.sql`. O script já cria o banco, as tabelas e insere os 3.115 registros automaticamente.

## 📄 Documentação Completa
Acesse a análise detalhada, o diagrama DER e as queries completas no relatório em PDF:
👉 [Abrir relatorios.pdf](./relatorios.pdf)
