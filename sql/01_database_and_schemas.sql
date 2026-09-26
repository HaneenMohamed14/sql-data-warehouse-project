-- =========================================================
-- Central Superstore Data Warehouse
-- 01 - Database & Schemas Setup
-- =========================================================

-- Create Database
IF NOT EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'Central_Superstore'
)
BEGIN
    CREATE DATABASE Central_Superstore;
END;
GO

-- Use Database
USE Central_Superstore;
GO

-- =========================================================
-- Create Schemas
-- =========================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'staging'
)
BEGIN
    EXEC('CREATE SCHEMA staging');
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'bronze'
)
BEGIN
    EXEC('CREATE SCHEMA bronze');
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'silver'
)
BEGIN
    EXEC('CREATE SCHEMA silver');
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'gold'
)
BEGIN
    EXEC('CREATE SCHEMA gold');
END;
GO
