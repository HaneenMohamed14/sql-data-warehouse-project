-- =========================================================
-- Central Superstore Data Warehouse
-- 09 - Analytics Queries
-- =========================================================

USE Central_Superstore;
GO


-- =========================================================
-- Query 01: Total Sales, Profit and Quantity
-- =========================================================

SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales;
GO


-- =========================================================
-- Query 02: Sales and Profit by Category
-- =========================================================

SELECT
    p.category,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM gold.fact_sales f
JOIN gold.dim_product p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC;
GO


-- =========================================================
-- Query 03: Sales by Region
-- =========================================================

SELECT
    l.region,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM gold.fact_sales f
JOIN gold.dim_location l
    ON f.location_key = l.location_key
GROUP BY l.region
ORDER BY total_sales DESC;
GO


-- =========================================================
-- Query 04: Sales by Customer Segment
-- =========================================================

SELECT
    c.segment,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM gold.fact_sales f
JOIN gold.dim_customer c
    ON f.customer_key = c.customer_key
GROUP BY c.segment
ORDER BY total_sales DESC;
GO


-- =========================================================
-- Query 05: Monthly Sales Trend
-- =========================================================

SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM gold.fact_sales f
JOIN gold.dim_date d
    ON f.order_date_key = d.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;
GO


-- =========================================================
-- Query 06: Top 10 Customers by Sales
-- =========================================================

SELECT TOP 10
    c.customer_id,
    c.customer_name,
    c.segment,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM gold.fact_sales f
JOIN gold.dim_customer c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_id,
    c.customer_name,
    c.segment
ORDER BY total_sales DESC;
GO


-- =========================================================
-- Query 07: Top 10 Products by Profit
-- =========================================================

SELECT TOP 10
    p.product_id,
    p.product_name,
    p.category,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM gold.fact_sales f
JOIN gold.dim_product p
    ON f.product_key = p.product_key
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_profit DESC;
GO


-- =========================================================
-- Query 08: Products with Negative Profit
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM gold.fact_sales f
JOIN gold.dim_product p
    ON f.product_key = p.product_key
GROUP BY
    p.product_id,
    p.product_name,
    p.category
HAVING SUM(f.profit) < 0
ORDER BY total_profit;
GO


-- =========================================================
-- Query 09: Average Discount by Category
-- =========================================================

SELECT
    p.category,
    AVG(f.discount) AS average_discount,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM gold.fact_sales f
JOIN gold.dim_product p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY average_discount DESC;
GO


-- =========================================================
-- Query 10: Shipping Performance
-- =========================================================

SELECT
    sm.ship_mode,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM gold.fact_sales f
JOIN gold.dim_ship_mode sm
    ON f.ship_mode_key = sm.ship_mode_key
GROUP BY sm.ship_mode
ORDER BY total_orders DESC;
GO


-- =========================================================
-- Query 11: Customer Lifetime Value
-- =========================================================

SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    SUM(f.sales) AS lifetime_sales,
    SUM(f.profit) AS lifetime_profit,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM gold.fact_sales f
JOIN gold.dim_customer c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_id,
    c.customer_name,
    c.segment
ORDER BY lifetime_sales DESC;
GO


-- =========================================================
-- Query 12: Category Contribution to Total Sales
-- =========================================================

SELECT
    p.category,
    SUM(f.sales) AS category_sales,

    SUM(f.sales) * 100.0 /
    (SELECT SUM(sales)
     FROM gold.fact_sales) AS sales_contribution_percentage

FROM gold.fact_sales f
JOIN gold.dim_product p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY sales_contribution_percentage DESC;
GO


-- =========================================================
-- Query 13: Monthly Sales with CTE
-- =========================================================

;WITH MonthlySales AS (
    SELECT
        d.year,
        d.month,
        SUM(f.sales) AS total_sales,
        SUM(f.profit) AS total_profit
    FROM gold.fact_sales f
    JOIN gold.dim_date d
        ON f.order_date_key = d.date_key
    GROUP BY
        d.year,
        d.month
)
SELECT
    year,
    month,
    total_sales,
    total_profit
FROM MonthlySales
ORDER BY
    year,
    month;
GO


-- =========================================================
-- Query 14: Month-over-Month Sales Growth
-- =========================================================

;WITH MonthlySales AS (
    SELECT
        d.year,
        d.month,
        SUM(f.sales) AS total_sales
    FROM gold.fact_sales f
    JOIN gold.dim_date d
        ON f.order_date_key = d.date_key
    GROUP BY
        d.year,
        d.month
)
SELECT
    year,
    month,
    total_sales,

    LAG(total_sales) OVER (
        ORDER BY year, month
    ) AS previous_month_sales,

    total_sales -
    LAG(total_sales) OVER (
        ORDER BY year, month
    ) AS sales_difference

FROM MonthlySales
ORDER BY
    year,
    month;
GO


-- =========================================================
-- Query 15: Rank Products within Each Category
-- =========================================================

SELECT
    p.category,
    p.product_id,
    p.product_name,
    SUM(f.sales) AS total_sales,

    RANK() OVER (
        PARTITION BY p.category
        ORDER BY SUM(f.sales) DESC
    ) AS product_rank

FROM gold.fact_sales f
JOIN gold.dim_product p
    ON f.product_key = p.product_key

GROUP BY
    p.category,
    p.product_id,
    p.product_name;
GO


-- =========================================================
-- Query 16: Top City by Sales in Each Region
-- =========================================================

;WITH CitySales AS (
    SELECT
        l.region,
        l.city,
        SUM(f.sales) AS total_sales,

        ROW_NUMBER() OVER (
            PARTITION BY l.region
            ORDER BY SUM(f.sales) DESC
        ) AS city_rank

    FROM gold.fact_sales f
    JOIN gold.dim_location l
        ON f.location_key = l.location_key

    GROUP BY
        l.region,
        l.city
)
SELECT
    region,
    city,
    total_sales
FROM CitySales
WHERE city_rank = 1
ORDER BY region;
GO


-- =========================================================
-- Query 17: Customers with Above-Average Sales
-- =========================================================

SELECT
    c.customer_id,
    c.customer_name,
    SUM(f.sales) AS total_sales

FROM gold.fact_sales f
JOIN gold.dim_customer c
    ON f.customer_key = c.customer_key

GROUP BY
    c.customer_id,
    c.customer_name

HAVING SUM(f.sales) >
(
    SELECT AVG(customer_sales)
    FROM (
        SELECT
            SUM(sales) AS customer_sales
        FROM gold.fact_sales
        GROUP BY customer_key
    ) AS CustomerTotals
)

ORDER BY total_sales DESC;
GO


-- =========================================================
-- Query 18: Orders Containing Multiple Products
-- =========================================================

SELECT
    f.order_id,
    COUNT(DISTINCT f.product_key) AS product_count,
    SUM(f.sales) AS order_sales,
    SUM(f.profit) AS order_profit

FROM gold.fact_sales f

GROUP BY f.order_id

HAVING COUNT(DISTINCT f.product_key) > 1

ORDER BY product_count DESC;
GO


-- =========================================================
-- Query 19: Customer Segmentation Based on Sales
-- =========================================================

SELECT
    c.customer_id,
    c.customer_name,

    SUM(f.sales) AS total_sales,

    CASE
        WHEN SUM(f.sales) >= 5000 THEN 'High Value'
        WHEN SUM(f.sales) >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment

FROM gold.fact_sales f
JOIN gold.dim_customer c
    ON f.customer_key = c.customer_key

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY total_sales DESC;
GO


-- =========================================================
-- Query 20: Category Profit Contribution
-- =========================================================

SELECT
    p.category,

    SUM(f.profit) AS category_profit,

    SUM(f.profit) * 100.0 /
    NULLIF(
        (SELECT SUM(profit)
         FROM gold.fact_sales),
        0
    ) AS profit_contribution_percentage

FROM gold.fact_sales f
JOIN gold.dim_product p
    ON f.product_key = p.product_key

GROUP BY p.category

ORDER BY profit_contribution_percentage DESC;
GO
