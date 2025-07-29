-- ============================================================================
-- CONSULTAS PL/SQL - ANÁLISE DE DADOS DE VENDAS E PRODUÇÃO
-- ============================================================================

-- 1) LISTAR TODOS OS CLIENTES QUE NÃO REALIZARAM COMPRAS
-- ============================================================================
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL
ORDER BY c.last_name, c.first_name;

-- ============================================================================
-- 2) LISTAR OS PRODUTOS QUE NÃO FORAM COMPRADOS
-- ============================================================================
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    cat.category_name,
    p.model_year,
    p.list_price
FROM products p
INNER JOIN brands b ON p.brand_id = b.brand_id
INNER JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL
ORDER BY b.brand_name, p.product_name;

-- ============================================================================
-- 3) LISTAR OS PRODUTOS SEM ESTOQUE
-- ============================================================================
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    cat.category_name,
    s.store_name,
    st.quantity AS estoque_atual
FROM products p
INNER JOIN brands b ON p.brand_id = b.brand_id
INNER JOIN categories cat ON p.category_id = cat.category_id
INNER JOIN stocks st ON p.product_id = st.product_id
INNER JOIN stores s ON st.store_id = s.store_id
WHERE st.quantity = 0 OR st.quantity IS NULL
ORDER BY s.store_name, b.brand_name, p.product_name;

-- ============================================================================
-- 4) AGRUPAR QUANTIDADE DE VENDAS POR MARCA E LOJA
-- ============================================================================
SELECT 
    s.store_name AS loja,
    b.brand_name AS marca,
    COUNT(oi.item_id) AS quantidade_vendas,
    SUM(oi.quantity) AS total_unidades_vendidas,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS valor_total_vendas
FROM stores s
INNER JOIN orders o ON s.store_id = o.store_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN brands b ON p.brand_id = b.brand_id
GROUP BY s.store_name, b.brand_name
ORDER BY s.store_name, quantidade_vendas DESC;

-- ============================================================================
-- 5) LISTAR FUNCIONÁRIOS QUE NÃO ESTÃO RELACIONADOS A PEDIDOS
-- ============================================================================
SELECT 
    st.staff_id,
    st.first_name,
    st.last_name,
    st.email,
    st.phone,
    s.store_name,
    CASE 
        WHEN st.active = 1 THEN 'Ativo'
        ELSE 'Inativo'
    END AS status_funcionario
FROM staffs st
INNER JOIN stores s ON st.store_id = s.store_id
LEFT JOIN orders o ON st.staff_id = o.staff_id
WHERE o.staff_id IS NULL
ORDER BY s.store_name, st.last_name, st.first_name;

-- ============================================================================
-- CONSULTAS COMPLEMENTARES PARA ANÁLISE
-- ============================================================================

-- Verificar integridade dos dados - Produtos sem categoria ou marca
SELECT 
    'Produtos sem categoria' AS tipo_problema,
    COUNT(*) AS quantidade
FROM products p
WHERE p.category_id IS NULL OR p.brand_id IS NULL
UNION ALL
SELECT 
    'Produtos sem estoque cadastrado' AS tipo_problema,
    COUNT(*) AS quantidade
FROM products p
LEFT JOIN stocks st ON p.product_id = st.product_id
WHERE st.product_id IS NULL;

-- Resumo geral de vendas por loja
SELECT 
    s.store_name,
    COUNT(DISTINCT o.order_id) AS total_pedidos,
    COUNT(DISTINCT o.customer_id) AS clientes_unicos,
    COUNT(DISTINCT oi.product_id) AS produtos_vendidos,
    SUM(oi.quantity) AS total_itens_vendidos,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS receita_total
FROM stores s
LEFT JOIN orders o ON s.store_id = o.store_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_id, s.store_name
ORDER BY receita_total DESC NULLS LAST;
