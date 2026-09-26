-- =========================================================
-- Central Superstore Data Warehouse
-- 07 - Gold Views & KPI Reports
-- =========================================================

USE Central_Superstore;
GO

-- =========================================================
-- 1. Monthly KPI Summary
-- =========================================================

CREATE OR ALTER VIEW gold.vw_monthly_kpi_summary
AS
SELECT
    d.year,
    d.month,
    d.month_name,

    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    SUM(f.quantity) AS total_quantity,

    COUNT(DISTINCT f.order_id) AS total_orders,

    CASE
        WHEN SUM(f.sales) = 0 THEN 0
        ELSE SUM(f.profit) / SUM(f.sales) * 100
    END AS profit_margin_percentage

FROM gold.fact_sales f

JOIN gold.dim_date d
    ON f.order_date_key = d.date_key

GROUP BY
    d.year,
    d.month,
    d.month_name;
GO


-- =========================================================
-- 2. Customer Segment KPI
-- =========================================================

CREATE OR ALTER VIEW gold.vw_customer_segment_kpi
AS
SELECT
    c.segment,

    COUNT(DISTINCT c.customer_key) AS total_customers,
    COUNT(DISTINCT f.order_id) AS total_orders,

    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    SUM(f.quantity) AS total_quantity,

    CASE
        WHEN SUM(f.sales) = 0 THEN 0
        ELSE SUM(f.profit) / SUM(f.sales) * 100
    END AS profit_margin_percentage

FROM gold.fact_sales f

JOIN gold.dim_customer c
    ON f.customer_key = c.customer_key

GROUP BY
    c.segment;
GO


-- =========================================================
-- 3. Product Category KPI
-- =========================================================

CREATE OR ALTER VIEW gold.vw_product_category_kpi
AS
SELECT
    p.category,
    p.sub_category,

    COUNT(DISTINCT p.product_key) AS total_products,

    SUM(f.quantity) AS total_quantity,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,

    AVG(f.discount) AS average_discount,

    CASE
        WHEN SUM(f.sales) = 0 THEN 0
        ELSE SUM(f.profit) / SUM(f.sales) * 100
    END AS profit_margin_percentage

FROM gold.fact_sales f

JOIN gold.dim_product p
    ON f.product_key = p.product_key

GROUP BY
    p.category,
    p.sub_category;
GO


-- =========================================================
-- Validation
-- =========================================================

SELECT *
FROM gold.vw_monthly_kpi_summary;

SELECT *
FROM gold.vw_customer_segment_kpi;

SELECT *
FROM gold.vw_product_category_kpi;
GO
