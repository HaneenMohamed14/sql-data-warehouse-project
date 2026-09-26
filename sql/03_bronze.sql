-- =========================================================
-- Central Superstore Data Warehouse
-- 03 - Bronze Layer
-- =========================================================

USE Central_Superstore;
GO

-- =========================================================
-- Create Bronze Table
-- =========================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.tables t
    JOIN sys.schemas s
        ON t.schema_id = s.schema_id
    WHERE s.name = 'bronze'
      AND t.name = 'central_superstore'
)
BEGIN
    CREATE TABLE bronze.central_superstore (
        bronze_id      INT IDENTITY(1,1) PRIMARY KEY,
        order_id       VARCHAR(255),
        order_date     VARCHAR(255),
        ship_date      VARCHAR(255),
        ship_mode      VARCHAR(255),
        customer_id    VARCHAR(255),
        customer_name  VARCHAR(255),
        segment        VARCHAR(255),
        country        VARCHAR(255),
        city            VARCHAR(255),
        state           VARCHAR(255),
        postal_code     VARCHAR(255),
        region          VARCHAR(255),
        product_id      VARCHAR(255),
        category        VARCHAR(255),
        sub_category    VARCHAR(255),
        product_name    VARCHAR(255),
        sales           VARCHAR(255),
        quantity        VARCHAR(255),
        discount        VARCHAR(255),
        profit          VARCHAR(255)
    );
END;
GO

-- =========================================================
-- Load New Rows from Staging into Bronze
-- =========================================================

INSERT INTO bronze.central_superstore (
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
FROM staging.central_superstore

EXCEPT

SELECT
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
FROM bronze.central_superstore;
GO

-- =========================================================
-- Validation
-- =========================================================

SELECT TOP 10
    order_date,
    ship_date,
    sales,
    quantity,
    discount,
    profit
FROM bronze.central_superstore;

SELECT
    MIN(order_date) AS min_order_date,
    MAX(order_date) AS max_order_date
FROM bronze.central_superstore;
GO
