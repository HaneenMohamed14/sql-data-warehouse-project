-- =========================================================
-- Central Superstore Data Warehouse
-- 08 - Stored Procedures
-- =========================================================

USE Central_Superstore;
GO


-- =========================================================
-- 1. KPI Summary by Year Range
-- =========================================================

CREATE OR ALTER PROCEDURE gold.sp_kpi_by_year_range
    @StartYear INT,
    @EndYear INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        d.year,

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

    WHERE d.year BETWEEN @StartYear AND @EndYear

    GROUP BY d.year

    ORDER BY d.year;
END;
GO


-- =========================================================
-- 2. Top Products by Profit
-- =========================================================

CREATE OR ALTER PROCEDURE gold.sp_top_products_by_profit
    @TopN INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopN)
        p.product_id,
        p.product_name,
        p.category,
        p.sub_category,

        SUM(f.sales) AS total_sales,
        SUM(f.quantity) AS total_quantity,
        SUM(f.profit) AS total_profit

    FROM gold.fact_sales f

    JOIN gold.dim_product p
        ON f.product_key = p.product_key

    GROUP BY
        p.product_id,
        p.product_name,
        p.category,
        p.sub_category

    ORDER BY
        total_profit DESC;
END;
GO


-- =========================================================
-- 3. Customer KPI Lookup
-- =========================================================

CREATE OR ALTER PROCEDURE gold.sp_customer_kpi_lookup
    @CustomerID VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        c.customer_id,
        c.customer_name,
        c.segment,

        COUNT(DISTINCT f.order_id) AS total_orders,

        SUM(f.sales) AS total_sales,
        SUM(f.quantity) AS total_quantity,
        SUM(f.profit) AS total_profit,

        CASE
            WHEN SUM(f.sales) = 0 THEN 0
            ELSE SUM(f.profit) / SUM(f.sales) * 100
        END AS profit_margin_percentage

    FROM gold.fact_sales f

    JOIN gold.dim_customer c
        ON f.customer_key = c.customer_key

    WHERE c.customer_id = @CustomerID

    GROUP BY
        c.customer_id,
        c.customer_name,
        c.segment;
END;
GO


-- =========================================================
-- Example Execution
-- =========================================================

-- EXEC gold.sp_kpi_by_year_range
--     @StartYear = 2016,
--     @EndYear = 2017;

-- EXEC gold.sp_top_products_by_profit
--     @TopN = 10;

-- EXEC gold.sp_customer_kpi_lookup
--     @CustomerID = 'CG-12520';
GO
