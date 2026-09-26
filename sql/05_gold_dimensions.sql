-- =========================================================
-- Central Superstore Data Warehouse
-- 05 - Gold Dimensions
-- =========================================================

USE Central_Superstore;
GO

-- =========================================================
-- 1. Customer Dimension
-- =========================================================

IF OBJECT_ID('gold.dim_customer', 'U') IS NOT NULL
    DROP TABLE gold.dim_customer;
GO

CREATE TABLE gold.dim_customer (
    customer_key    INT IDENTITY(1,1) PRIMARY KEY,
    customer_id     VARCHAR(50) NOT NULL,
    customer_name   VARCHAR(255),
    segment         VARCHAR(50)
);
GO

INSERT INTO gold.dim_customer (
    customer_id,
    customer_name,
    segment
)
SELECT
    customer_id,
    MAX(customer_name),
    MAX(segment)
FROM silver.central_superstore
WHERE customer_id IS NOT NULL
GROUP BY customer_id;
GO


-- =========================================================
-- 2. Product Dimension
-- =========================================================

IF OBJECT_ID('gold.dim_product', 'U') IS NOT NULL
    DROP TABLE gold.dim_product;
GO

CREATE TABLE gold.dim_product (
    product_key     INT IDENTITY(1,1) PRIMARY KEY,
    product_id      VARCHAR(50) NOT NULL,
    product_name    VARCHAR(255),
    category        VARCHAR(100),
    sub_category    VARCHAR(100)
);
GO

;WITH ProductVariants AS (
    SELECT
        product_id,
        product_name,
        category,
        sub_category,
        COUNT(*) AS occurrence_count,
        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY
                COUNT(*) DESC,
                product_name ASC
        ) AS rn
    FROM silver.central_superstore
    WHERE product_id IS NOT NULL
    GROUP BY
        product_id,
        product_name,
        category,
        sub_category
)
INSERT INTO gold.dim_product (
    product_id,
    product_name,
    category,
    sub_category
)
SELECT
    product_id,
    product_name,
    category,
    sub_category
FROM ProductVariants
WHERE rn = 1;
GO


-- =========================================================
-- 3. Location Dimension
-- =========================================================

IF OBJECT_ID('gold.dim_location', 'U') IS NOT NULL
    DROP TABLE gold.dim_location;
GO

CREATE TABLE gold.dim_location (
    location_key    INT IDENTITY(1,1) PRIMARY KEY,
    country         VARCHAR(100),
    city            VARCHAR(100),
    state           VARCHAR(100),
    postal_code     VARCHAR(20),
    region          VARCHAR(50)
);
GO

INSERT INTO gold.dim_location (
    country,
    city,
    state,
    postal_code,
    region
)
SELECT DISTINCT
    country,
    city,
    state,
    postal_code,
    region
FROM silver.central_superstore;
GO


-- =========================================================
-- 4. Ship Mode Dimension
-- =========================================================

IF OBJECT_ID('gold.dim_ship_mode', 'U') IS NOT NULL
    DROP TABLE gold.dim_ship_mode;
GO

CREATE TABLE gold.dim_ship_mode (
    ship_mode_key   INT IDENTITY(1,1) PRIMARY KEY,
    ship_mode       VARCHAR(50) NOT NULL
);
GO

INSERT INTO gold.dim_ship_mode (
    ship_mode
)
SELECT DISTINCT
    ship_mode
FROM silver.central_superstore
WHERE ship_mode IS NOT NULL;
GO


-- =========================================================
-- 5. Date Dimension
-- =========================================================

IF OBJECT_ID('gold.dim_date', 'U') IS NOT NULL
    DROP TABLE gold.dim_date;
GO

CREATE TABLE gold.dim_date (
    date_key        INT PRIMARY KEY,
    full_date       DATE NOT NULL,
    year            INT,
    quarter         INT,
    month           INT,
    month_name      VARCHAR(20),
    day              INT,
    day_name        VARCHAR(20)
);
GO

;WITH AllDates AS (
    SELECT order_date AS full_date
    FROM silver.central_superstore
    WHERE order_date IS NOT NULL

    UNION

    SELECT ship_date AS full_date
    FROM silver.central_superstore
    WHERE ship_date IS NOT NULL
)
INSERT INTO gold.dim_date (
    date_key,
    full_date,
    year,
    quarter,
    month,
    month_name,
    day,
    day_name
)
SELECT
    CONVERT(INT, CONVERT(VARCHAR(8), full_date, 112)) AS date_key,
    full_date,
    YEAR(full_date),
    DATEPART(QUARTER, full_date),
    MONTH(full_date),
    DATENAME(MONTH, full_date),
    DAY(full_date),
    DATENAME(WEEKDAY, full_date)
FROM AllDates;
GO


-- =========================================================
-- Validation
-- =========================================================

SELECT COUNT(*) AS customer_rows
FROM gold.dim_customer;

SELECT COUNT(*) AS product_rows
FROM gold.dim_product;

SELECT COUNT(*) AS location_rows
FROM gold.dim_location;

SELECT COUNT(*) AS ship_mode_rows
FROM gold.dim_ship_mode;

SELECT COUNT(*) AS date_rows
FROM gold.dim_date;
GO
