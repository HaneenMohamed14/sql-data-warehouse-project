-- =========================================================
-- Central Superstore Data Warehouse
-- 06 - Gold Fact Table
-- =========================================================

USE Central_Superstore;
GO

-- =========================================================
-- Create Fact Table
-- =========================================================

IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
    DROP TABLE gold.fact_sales;
GO

CREATE TABLE gold.fact_sales (
    sales_key        INT IDENTITY(1,1) PRIMARY KEY,

    order_id         VARCHAR(50) NOT NULL,

    customer_key     INT,
    product_key      INT,
    location_key     INT,
    ship_mode_key    INT,

    order_date_key   INT,
    ship_date_key    INT,

    sales            DECIMAL(10,2),
    quantity         INT,
    discount         DECIMAL(5,2),
    profit           DECIMAL(10,2),

    -- Foreign Keys
    CONSTRAINT FK_fact_customer
        FOREIGN KEY (customer_key)
        REFERENCES gold.dim_customer(customer_key),

    CONSTRAINT FK_fact_product
        FOREIGN KEY (product_key)
        REFERENCES gold.dim_product(product_key),

    CONSTRAINT FK_fact_location
        FOREIGN KEY (location_key)
        REFERENCES gold.dim_location(location_key),

    CONSTRAINT FK_fact_ship_mode
        FOREIGN KEY (ship_mode_key)
        REFERENCES gold.dim_ship_mode(ship_mode_key),

    CONSTRAINT FK_fact_order_date
        FOREIGN KEY (order_date_key)
        REFERENCES gold.dim_date(date_key),

    CONSTRAINT FK_fact_ship_date
        FOREIGN KEY (ship_date_key)
        REFERENCES gold.dim_date(date_key)
);
GO


-- =========================================================
-- Load Fact Table
-- =========================================================

INSERT INTO gold.fact_sales (
    order_id,
    customer_key,
    product_key,
    location_key,
    ship_mode_key,
    order_date_key,
    ship_date_key,
    sales,
    quantity,
    discount,
    profit
)
SELECT
    s.order_id,

    c.customer_key,

    p.product_key,

    l.location_key,

    sm.ship_mode_key,

    od.date_key AS order_date_key,

    sd.date_key AS ship_date_key,

    s.sales,
    s.quantity,
    s.discount,
    s.profit

FROM silver.central_superstore s

LEFT JOIN gold.dim_customer c
    ON s.customer_id = c.customer_id

LEFT JOIN gold.dim_product p
    ON s.product_id = p.product_id

LEFT JOIN gold.dim_location l
    ON s.country = l.country
    AND s.city = l.city
    AND s.state = l.state
    AND s.postal_code = l.postal_code
    AND s.region = l.region

LEFT JOIN gold.dim_ship_mode sm
    ON s.ship_mode = sm.ship_mode

LEFT JOIN gold.dim_date od
    ON s.order_date = od.full_date

LEFT JOIN gold.dim_date sd
    ON s.ship_date = sd.full_date;
GO


-- =========================================================
-- Validation
-- =========================================================

SELECT COUNT(*) AS fact_sales_rows
FROM gold.fact_sales;
GO

SELECT TOP 10 *
FROM gold.fact_sales;
GO
