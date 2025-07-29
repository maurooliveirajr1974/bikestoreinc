# Análise de Dados - Sistema de Vendas e Produção

## 📋 Visão Geral do Projeto

Este projeto consiste na criação de consultas PL/SQL para análise de dados de um sistema integrado de vendas e produção, baseado no modelo de dados fornecido.

## 🎯 Objetivos

Desenvolver consultas SQL para identificar:
1. Clientes sem compras realizadas
2. Produtos nunca vendidos
3. Produtos sem estoque
4. Vendas agrupadas por marca e loja
5. Funcionários não associados a pedidos

## 🔍 Processo de Investigação e Desenvolvimento

### 1. Análise do Modelo de Dados

#### **Módulo Sales (Vendas)**
- **customers**: Dados dos clientes
- **orders**: Pedidos realizados
- **order_items**: Itens dos pedidos
- **staffs**: Funcionários
- **stores**: Lojas

#### **Módulo Production (Produção)**
- **products**: Catálogo de produtos
- **categories**: Categorias de produtos
- **brands**: Marcas
- **stocks**: Controle de estoque

#### **Relacionamentos Identificados**
- customers ↔ orders (1:N)
- orders ↔ order_items (1:N)
- products ↔ order_items (1:N)
- stores ↔ orders (1:N)
- staffs ↔ orders (1:N)
- products ↔ stocks (1:N)
- brands ↔ products (1:N)
- categories ↔ products (1:N)

### 2. Estratégias de Consulta Desenvolvidas

#### **Consulta 1: Clientes sem Compras**
- **Abordagem**: LEFT JOIN entre customers e orders
- **Lógica**: Identificar registros onde o customer_id não existe na tabela orders
- **Filtro**: WHERE o.customer_id IS NULL

#### **Consulta 2: Produtos Não Vendidos**
- **Abordagem**: LEFT JOIN entre products e order_items
- **Lógica**: Produtos que nunca aparecem na tabela order_items
- **Complemento**: Incluir informações de marca e categoria para melhor análise

#### **Consulta 3: Produtos Sem Estoque**
- **Abordagem**: INNER JOIN entre products, stocks e stores
- **Lógica**: Filtrar produtos onde quantity = 0 ou IS NULL
- **Detalhamento**: Mostrar por loja para análise localizada

#### **Consulta 4: Vendas por Marca e Loja**
- **Abordagem**: Múltiplos INNER JOINs com GROUP BY
- **Métricas calculadas**:
  - Quantidade de vendas (COUNT)
  - Total de unidades vendidas (SUM)
  - Valor total (considerando descontos)
- **Ordenação**: Por loja e quantidade de vendas

#### **Consulta 5: Funcionários sem Pedidos**
- **Abordagem**: LEFT JOIN entre staffs e orders
- **Lógica**: Funcionários que nunca processaram pedidos
- **Informações adicionais**: Status ativo/inativo e loja

### 3. Considerações Técnicas

#### **Tratamento de NULLs**
- Uso consistente de IS NULL para identificar ausências
- Consideração de valores NULL em campos de quantidade

#### **Performance**
- Uso de índices implícitos nas chaves primárias e estrangeiras
- ORDER BY para resultados organizados
- Evitado uso de subconsultas desnecessárias

#### **Integridade dos Dados**
- Verificação de relacionamentos obrigatórios
- Validação de consistência entre módulos

### 4. Desafios Encontrados

#### **Relacionamentos Complexos**
- Navegação entre módulos Sales e Production
- Múltiplas tabelas intermediárias (order_items como ponte)

#### **Cálculos de Vendas**
- Consideração de descontos na fórmula de receita
- Agregações em múltiplos níveis (item, pedido, loja)

#### **Dados Ausentes**
- Tratamento de produtos sem estoque cadastrado
- Funcionários inativos vs. sem atividade

### 5. Consultas Complementares

Além das consultas solicitadas, foram criadas consultas adicionais para:
- Verificação de integridade dos dados
- Resumo geral de vendas por loja
- Identificação de inconsistências

## 🚀 Como Executar

```sql
-- Execute as consultas individualmente ou em sequência
-- Certifique-se de que todas as tabelas estão criadas e populadas
-- Verifique os relacionamentos de chave estrangeira

-- Para melhor performance, considere criar índices em:
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_stocks_product_id ON stocks(product_id);
```

## 📊 Resultados Esperados

Cada consulta retornará:
1. **Clientes sem compras**: Lista completa com dados de contato
2. **Produtos não vendidos**: Catálogo com marca e categoria
3. **Produtos sem estoque**: Detalhamento por loja
4. **Vendas por marca/loja**: Métricas de performance
5. **Funcionários inativos**: Lista para análise de recursos humanos

## 🔧 Possíveis Melhorias

- Implementação de procedures para execução automatizada
- Criação de views para consultas frequentes
- Implementação de logs de auditoria
- Parâmetros dinâmicos para filtros específicos

## 📝 Observações

- As consultas foram testadas considerando a estrutura do modelo fornecido
- Campos marcados com asterisco (*) são chaves primárias
- Relacionamentos foram inferidos baseados na nomenclatura e estrutura
- Considerar validação com dados reais antes da implementação em produção
