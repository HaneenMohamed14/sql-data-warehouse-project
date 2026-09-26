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
* ILoading new distinct full rows from the Staging layer using `EXCEPT`

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
* Total Sales
* Total Profit
* Total Quantity
* Profit Margin %

### Customer Segment KPI

`gold.vw_customer_segment_kpi`

Includes:

* Total Customers
* Total Orders
* Total Sales
* Total Profit
* Total Quantity
* Profit Margin %

### Product Category KPI

`gold.vw_product_category_kpi`

Includes:

* Total Products
* Total Quantity
* Total Sales
* Total Profit
* Average Discount
* Profit Margin %

---

## ⚙️ Stored Procedures

The project includes reusable stored procedures for parameterized analysis.

### `gold.sp_kpi_by_year_range`

Returns annual KPIs for a specified year range.

### `gold.sp_top_products_by_profit`

Returns the top N products ranked by total profit.

### `gold.sp_customer_kpi_lookup`

Returns customer-level KPIs including total orders, sales, quantity, profit, and profit margin.

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
* Category contribution
* Multi-item order analysis

---

## 🚀 Query Optimization

The project also includes a performance optimization section.

### Indexing

Indexes were created to improve query performance on frequently used columns:

* `gold.fact_sales(order_date_key)`
* `gold.fact_sales(customer_key)`
* `gold.fact_sales(product_key)`
* `gold.dim_customer(customer_id)`
* `gold.dim_product(product_id)`

A composite covering index was also created on:

* `order_date_key`
* `product_key`

with included columns:

* `sales`
* `quantity`
* `discount`
* `profit`
### Performance Analysis

`SET STATISTICS IO` and `SET STATISTICS TIME` were used to inspect query performance and resource usage.
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
sql-data-warehouse-project/
│
├── README.md
├── LICENSE
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
│   ├── Central_Superstore.csv
│   └── README.md
│
├── documentation/
│   └── data_warehouse_architecture.png
│
└── screenshots/
    ├── gold_star_schema.png
    └── query_results.png
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
