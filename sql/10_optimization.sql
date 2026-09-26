-- =========================================================
-- Central Superstore Data Warehouse
-- 10 - Query Optimization
-- =========================================================

USE Central_Superstore;
GO


-- =========================================================
-- 1. Index on Fact Table - Order Date
-- =========================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_fact_sales_order_date_key'
      AND object_id = OBJECT_ID('gold.fact_sales')
)
BEGIN
    CREATE INDEX IX_fact_sales_order_date_key
    ON gold.fact_sales(order_date_key);
END;
GO


-- =========================================================
-- 2. Index on Fact Table - Customer
-- =========================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_fact_sales_customer_key'
      AND object_id = OBJECT_ID('gold.fact_sales')
)
BEGIN
    CREATE INDEX IX_fact_sales_customer_key
    ON gold.fact_sales(customer_key);
END;
GO


-- =========================================================
-- 3. Index on Fact Table - Product
-- =========================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_fact_sales_product_key'
      AND object_id = OBJECT_ID('gold.fact_sales')
)
BEGIN
    CREATE INDEX IX_fact_sales_product_key
    ON gold.fact_sales(product_key);
END;
GO


-- =========================================================
-- 4. Index on Customer Dimension
-- =========================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_dim_customer_customer_id'
      AND object_id = OBJECT_ID('gold.dim_customer')
)
BEGIN
    CREATE INDEX IX_dim_customer_customer_id
    ON gold.dim_customer(customer_id);
END;
GO


-- =========================================================
-- 5. Index on Product Dimension
-- =========================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_dim_product_product_id'
      AND object_id = OBJECT_ID('gold.dim_product')
)
BEGIN
    CREATE INDEX IX_dim_product_product_id
    ON gold.dim_product(product_id);
END;
GO


-- =========================================================
-- 6. Covering Index for Sales Analysis
-- =========================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_fact_sales_analysis'
      AND object_id = OBJECT_ID('gold.fact_sales')
)
BEGIN
    CREATE INDEX IX_fact_sales_analysis
    ON gold.fact_sales(order_date_key, product_key)
    INCLUDE (sales, quantity, discount, profit);
END;
GO


-- =========================================================
-- 7. Execution Plan & Statistics
-- =========================================================

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    p.category,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM gold.fact_sales f
JOIN gold.dim_product p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


-- =========================================================
-- 8. Optimized Query Example
-- =========================================================

SELECT
    f.order_date_key,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM gold.fact_sales f
WHERE f.order_date_key BETWEEN 20160101 AND 20161231
GROUP BY f.order_date_key
ORDER BY f.order_date_key;
GO


-- =========================================================
-- 9. Index Information
-- =========================================================

SELECT
    OBJECT_SCHEMA_NAME(i.object_id) AS schema_name,
    OBJECT_NAME(i.object_id) AS table_name,
    i.name AS index_name,
    i.type_desc AS index_type
FROM sys.indexes i
WHERE i.object_id IN (
    OBJECT_ID('gold.fact_sales'),
    OBJECT_ID('gold.dim_customer'),
    OBJECT_ID('gold.dim_product')
)
AND i.name IS NOT NULL
ORDER BY
    table_name,
    index_name;
GO
