# 🛒 Modelagem de Banco de Dados - E-commerce

## 📋 Descrição do Projeto

Este projeto apresenta a **modelagem conceitual e lógica** de um banco de dados para sistema de **E-commerce**, desenvolvido como parte do desafio de projeto da DIO (Digital Innovation One). O esquema foi refinado e aprimorado seguindo as melhores práticas de modelagem de dados, implementando regras de negócio específicas e otimizações para performance.

## 🎯 Objetivo do Desafio

Refinar o modelo de banco de dados apresentado, implementando os seguintes requisitos específicos:

### ✅ Requisitos Implementados:

1. **👥 Cliente PJ e PF**
   - Uma conta pode ser **Pessoa Física (PF)** ou **Pessoa Jurídica (PJ)**
   - **Não é possível** ter as duas informações simultaneamente
   - Implementado através de **subtipagem** com tabelas específicas

2. **💳 Múltiplas Formas de Pagamento**
   - Cada cliente pode ter **cadastradas várias formas de pagamento**
   - Relacionamento **1:N** entre Cliente e Forma de Pagamento
   - Suporte para: Cartão de Crédito, Débito, PIX, Boleto, Transferência

3. **📦 Sistema de Entrega Completo**
   - **Status de entrega** com estados bem definidos
   - **Código de rastreio** para acompanhamento
   - **Histórico completo** de mudanças de status
   - Estados: Aguardando Coleta, Coletado, Em Trânsito, Saiu para Entrega, Entregue

## 🏗️ Arquitetura do Banco de Dados

### 📊 Principais Entidades:

- **🏢 Fornecedor**: Gestão de fornecedores com CNPJ único
- **📱 Produto**: Catálogo de produtos com categorias e preços
- **👤 Cliente**: Tabela principal com subtipagem PF/PJ
- **💰 Forma de Pagamento**: Múltiplas opções por cliente
- **🛍️ Pedido**: Gestão completa de pedidos com status
- **📦 Estoque**: Controle de estoque por localização
- **📋 Histórico de Status**: Rastreamento de mudanças

### 🔗 Relacionamentos Principais:

- **N:N** entre Fornecedor ↔ Produto
- **1:N** entre Cliente → Forma de Pagamento
- **N:N** entre Pedido ↔ Produto
- **N:N** entre Produto ↔ Estoque
- **1:N** entre Pedido → Histórico de Status

## 🚀 Características Técnicas

### ⚡ Otimizações Implementadas:

- **13 Índices estratégicos** para consultas frequentes
- **Triggers automáticos** para cálculo de totais e histórico
- **Views personalizadas** para relatórios
- **Constraints avançadas** com validações de negócio
- **Campos calculados** para subtotais automáticos

### 🛡️ Validações e Segurança:

- **CHECK constraints** para valores positivos
- **ENUM types** para padronização de status
- **Validação de formato** para CPF/CNPJ
- **Campos de auditoria** (criação/atualização)
- **Integridade referencial** com CASCADE apropriados

## 📁 Estrutura do Projeto

```
📂 Modelagem Ecommerce/
├── 📄 README.md                    # Documentação do projeto
├── 🗃️ Script DDL.sql              # Script original de criação
├── 🗃️ Script DDL Melhorado.sql    # Versão otimizada e completa
└── 📂 Modelagem/                   # Diagramas conceituais
```

## 🔧 Como Executar

### Pré-requisitos:
- MySQL 8.0+ ou MariaDB 10.4+
- Cliente MySQL (Workbench, phpMyAdmin, ou CLI)

### Passos para Instalação:

1. **Clone o repositório:**
```bash
git clone https://github.com/Beto1821/MOdelagem-SQL-Workbench.git
cd MOdelagem-SQL-Workbench
```

2. **Execute o script melhorado:**
```sql
-- Conecte ao MySQL e execute:
source Script\ DDL\ Melhorado.sql
```

3. **Verifique a criação:**
```sql
USE `E-commerce`;
SHOW TABLES;
```

## 📊 Views Disponíveis

### 🔍 Consultas Pré-configuradas:

- **`vw_cliente_completo`**: Dados unificados de clientes PF/PJ
- **`vw_relatorio_vendas`**: Relatório completo de vendas
- **`vw_controle_estoque`**: Monitoramento de estoque com alertas

## 🎯 Diferenciais Implementados

### 💡 Inovações Além do Solicitado:

1. **🤖 Automação Completa**
   - Cálculo automático de totais
   - Registro automático de mudanças de status
   - Controle de estoque com alertas

2. **📈 Performance Otimizada**
   - Índices compostos para consultas complexas
   - Views materiializadas para relatórios
   - Estrutura normalizada até 3FN

3. **🔒 Segurança Avançada**
   - Validações de formato de documentos
   - Constraints de integridade robustas
   - Auditoria completa de alterações

## 🏆 Resultados Alcançados

✅ **Modelo totalmente normalizado** seguindo boas práticas  
✅ **Requisitos do desafio 100% implementados**  
✅ **Performance otimizada** com índices estratégicos  
✅ **Automação inteligente** com triggers  
✅ **Documentação completa** e profissional  

## 👨‍💻 Desenvolvedor

**Roberto Beto**  
🔗 [GitHub](https://github.com/Beto1821)  
📧 beto1821uol.com.br

---

### 📌 Nota sobre o Desafio

Este projeto foi desenvolvido como parte do curso de **Análise de Dados** da DIO/Randstad, demonstrando competências em:
- Modelagem conceitual e lógica de dados
- Implementação de regras de negócio complexas
- Otimização de performance em bancos de dados
- Documentação técnica profissional

**⭐ Se este projeto foi útil, considere dar uma estrela no repositório!**
