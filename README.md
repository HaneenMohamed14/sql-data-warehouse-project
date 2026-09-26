# Central Superstore Data Warehouse & Analytics

## 📌 Project Overview

This project demonstrates the design and implementation of an end-to-end **Data Warehouse using SQL Server and T-SQL**.

The project transforms raw Superstore sales data into a structured analytical data warehouse using a layered architecture:

**Staging → Bronze → Silver → Gold**

The Gold layer follows a **Star Schema** design with fact and dimension tables, enabling efficient analytical queries and business KPI reporting.

---

## 🎯 Project Objectives

* Build a structured SQL Server Data Warehouse.
* Implement a layered data architecture.
* Clean and transform raw sales data.
* Design a Star Schema for analytical workloads.
* Create reusable KPI views and stored procedures.
* Perform advanced SQL analysis.
* Apply indexing and query optimization techniques.
* Generate business-oriented insights from sales data.

---

## 🏗️ Data Warehouse Architecture

```text
                    Raw CSV Data
                         │
                         ▼
                  ┌─────────────┐
                  │   Staging   │
                  └──────┬──────┘
                         │
                         ▼
                  ┌─────────────┐
                  │    Bronze   │
                  └──────┬──────┘
                         │
                         ▼
                  ┌─────────────┐
                  │    Silver   │
                  └──────┬──────┘
                         │
                         ▼
                  ┌─────────────┐
                  │     Gold    │
                  └──────┬──────┘
                         │
             ┌───────────┴───────────┐
             ▼                       ▼
       Star Schema              Analytics
                              & KPI Reporting
```

---

## 🥉 Bronze Layer

The Bronze layer stores the raw data with minimal transformation.

An additional `bronze_id` identity column is used as a technical identifier for the loaded records.

Main responsibilities:

* Raw data storage
* Initial ingestion
* Preserving source-level values
* Incremental full-row loading using `EXCEPT`

---

## 🥈 Silver Layer

The Silver layer contains cleaned and typed data.

Transformations include:

* `TRIM()` for text standardization
* Date conversion using `TRY_CONVERT()`
* Numeric conversion using `TRY_CONVERT()`
* Proper data types for sales, quantity, discount, and profit
* Standardized column sizes

### Main Silver Table

`silver.central_superstore`

---

## 🥇 Gold Layer

The Gold layer contains the analytical Star Schema.

### Dimension Tables

* `gold.dim_customer`
* `gold.dim_product`
* `gold.dim_location`
* `gold.dim_ship_mode`
* `gold.dim_date`

### Fact Table

* `gold.fact_sales`

The fact table stores sales measures and foreign keys connecting the transaction data to the dimensions.

---

## ⭐ Star Schema

```text
                    dim_customer
                         │
                         │
dim_product ─────── fact_sales ─────── dim_location
                         │
                         │
                   dim_ship_mode
                         │
                         │
                      dim_date
```

`dim_date` is used twice in the fact table:

* `order_date_key`
* `ship_date_key`

This allows the same date dimension to represent different business roles.

---

## 📊 KPIs & Analytical Views

The project includes reusable SQL views for:

### Monthly KPI Summary

`gold.vw_monthly_kpi_summary`

Includes:

* Total Orders
* Total Revenue
* Total Profit
* Profit Margin %
* Average Order Value

### Customer Segment KPI

`gold.vw_customer_segment_kpi`

Includes:

* Unique Customers
* Total Orders
* Total Revenue
* Total Profit
* Revenue per Customer

### Product Category KPI

`gold.vw_product_category_kpi`

Includes:

* Total Revenue
* Total Profit
* Profit Margin %
* Units Sold

---

## ⚙️ Stored Procedures

The project includes reusable stored procedures for parameterized analysis.

### `gold.sp_kpi_by_year_range`

Returns monthly KPIs for a specified year range.

### `gold.sp_top_products_by_profit`

Returns the top N products by total profit, with optional category filtering.

### `gold.sp_customer_kpi_lookup`

Returns a customer's sales profile and assigns a CASE-based customer tier.

---

## 🔎 Advanced SQL Analysis

The project contains **20 analytical SQL queries** covering:

* Multi-table JOINs
* GROUP BY aggregations
* CASE expressions
* CTEs
* Subqueries
* Correlated subqueries
* Window functions
* Customer Lifetime Value
* Customer segmentation
* Monthly sales trends
* Month-over-month growth
* Product profitability
* Discount impact
* Shipping performance
* State-level performance
* Category contribution
* Multi-item order analysis

---

## 🚀 Query Optimization

The project also includes a performance optimization section.

### Indexing

Indexes were created on frequently used fact-table foreign keys:

* `customer_key`
* `product_key`
* `location_key`
* `order_date_key`
* `ship_date_key`
* `ship_mode_key`
* `order_id`

Additional composite indexes were created for common filtering and grouping patterns.

A covering index was also created for the monthly KPI workload.

### Performance Analysis

SQL Server execution plans and:

```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
```

were used to examine query performance before and after indexing.

---

## 🛠️ Technologies

* **SQL Server**
* **T-SQL**
* **SQL Server Management Studio (SSMS)**
* **GitHub**
* CSV

---

## 📁 Repository Structure

```text
Central-Superstore-Data-Warehouse/
│
├── README.md
│
├── sql/
│   ├── 01_database_and_schemas.sql
│   ├── 02_staging.sql
│   ├── 03_bronze.sql
│   ├── 04_silver.sql
│   ├── 05_gold_dimensions.sql
│   ├── 06_gold_fact.sql
│   ├── 07_views.sql
│   ├── 08_stored_procedures.sql
│   ├── 09_analytics_queries.sql
│   └── 10_optimization.sql
│
├── data/
├── documentation/
└── screenshots/
```

---

## ▶️ How to Run

1. Open **SQL Server Management Studio**.
2. Execute `01_database_and_schemas.sql`.
3. Update the CSV file path in the staging script.
4. Run the scripts in order:

   * Staging
   * Bronze
   * Silver
   * Gold Dimensions
   * Gold Fact
   * Views
   * Stored Procedures
   * Analytics Queries
   * Optimization
5. Explore the Gold layer and execute the analytical queries.

---

## 📌 Project Outcome

The final solution provides a structured analytical data warehouse that transforms raw Superstore transaction data into a reusable Star Schema.

The project demonstrates practical skills in:

**Data Warehousing • SQL • Data Cleaning • Dimensional Modeling • Business Analytics • Query Optimization**
