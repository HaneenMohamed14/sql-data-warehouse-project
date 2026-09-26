-- =========================================================
-- Central Superstore Data Warehouse
-- 04 - Silver Layer
-- =========================================================

USE Central_Superstore;
GO

-- =========================================================
-- Create Silver Table
-- =========================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.tables t
    JOIN sys.schemas s
        ON t.schema_id = s.schema_id
    WHERE s.name = 'silver'
      AND t.name = 'central_superstore'
)
BEGIN
    CREATE TABLE silver.central_superstore (
        order_id        VARCHAR(50),
        order_date      DATE,
        ship_date       DATE,
        ship_mode       VARCHAR(50),
        customer_id     VARCHAR(50),
        customer_name   VARCHAR(255),
        segment         VARCHAR(50),
        country         VARCHAR(100),
        city             VARCHAR(100),
        state            VARCHAR(100),
        postal_code     VARCHAR(20),
        region          VARCHAR(50),
        product_id      VARCHAR(50),
        category        VARCHAR(100),
        sub_category    VARCHAR(100),
        product_name    VARCHAR(255),
        sales           DECIMAL(10,2),
        quantity        INT,
        discount        DECIMAL(5,2),
        profit          DECIMAL(10,2)
    );
END;
GO

-- =========================================================
-- Reload Silver Layer with Cleaned and Typed Data
-- =========================================================

TRUNCATE TABLE silver.central_superstore;

INSERT INTO silver.central_superstore (
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit
)
SELECT
    TRIM(order_id),
    TRY_CONVERT(DATE, order_date, 101),
    TRY_CONVERT(DATE, ship_date, 101),
    TRIM(ship_mode),
    TRIM(customer_id),
    TRIM(customer_name),
    TRIM(segment),
    TRIM(country),
    TRIM(city),
    TRIM(state),
    TRIM(postal_code),
    TRIM(region),
    TRIM(product_id),
    TRIM(category),
    TRIM(sub_category),
    TRIM(product_name),
    TRY_CONVERT(DECIMAL(10,2), sales),
    TRY_CONVERT(INT, quantity),
    TRY_CONVERT(DECIMAL(5,2), discount),
    TRY_CONVERT(DECIMAL(10,2), profit)
FROM bronze.central_superstore;
GO
