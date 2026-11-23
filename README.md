# 🍔 Projeto Final de Dados e POO - Sistema de Lanchonete (Comandas)

## 📋 Sobre o Projeto
Este repositório documenta a evolução do banco de dados de uma Lanchonete, focando no rastreio de comandas (atendimentos) e na forte integração com **Programação Orientada a Objetos**, aplicando conceitos de **Herança** nas tabelas de produtos.

## 🗄️ Estrutura do Banco de Dados
* **SGBD Utilizado:** MySQL
* **Nome do Banco:** `lanchonete_db`
* **Modelagem POO:** Uso da estratégia "Table per Class" para mapear a herança da Superclasse `produto` para as subclasses `produto_suco`, `produto_sanduiche` e `produto_salada`.
* **Volume de Dados:** Mais de **3.150 registros totais** gerados com scripts `CROSS JOIN` para validação de carga pesada.

## 📊 Relatórios SQL Propostos
1. **Faturamento por Mesa:** Analisa ticket médio e rotatividade.
2. **Top Produtos:** Lista as vendas para gestão de estoque e cardápio.
3. **Fluxo de Pagamentos:** Analisa as formas de pagamento usadas pelos clientes.

## 💻 Integração Futura (POO)
* Implementação de polimorfismo nas classes filhas de Produto.
* Atributos derivados gerenciados por métodos da classe (ex: `calcularSaldo()` do Atendimento).
* Validação de regras de negócio, como não permitir abrir atendimento em mesa já ocupada.

## 🚀 Como Executar
1. Clone este repositório.
2. Importe o arquivo `database.sql` no MySQL (Workbench/DBeaver).
3. O script criará as tabelas, relacionamentos (PK/FK) e inserirá toda a massa de dados de teste.

👉 [Leia o Relatório Completo no PDF](./relatorios.pdf)
