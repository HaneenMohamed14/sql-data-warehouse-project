-- =========================================================
-- Central Superstore Data Warehouse
-- 02 - Staging Layer
-- =========================================================

USE Central_Superstore;
GO

-- =========================================================
-- Create Staging Table
-- =========================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.tables t
    JOIN sys.schemas s
        ON t.schema_id = s.schema_id
    WHERE s.name = 'staging'
      AND t.name = 'central_superstore'
)
BEGIN
    CREATE TABLE staging.central_superstore (
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
-- Load Raw Data into Staging
-- =========================================================

TRUNCATE TABLE staging.central_superstore;

BULK INSERT staging.central_superstore
FROM 'C:\Users\Compu House\Downloads\mini prog2\Central_Superstore.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FORMAT = 'CSV',
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    MAXERRORS = 0,
    ERRORFILE = 'C:\Users\Compu House\Downloads\mini prog2\Central_Superstore_err.log'
);
GO
