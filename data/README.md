# Dataset

This folder contains the dataset used in the Central Superstore Data Warehouse project.

## File

- `Central_Superstore.csv`

## Description

The dataset contains sales transaction data, including:

- Orders
- Customers
- Products
- Categories
- Locations
- Shipping modes
- Sales
- Quantity
- Discounts
- Profit
- Order and shipping dates

The dataset is used as the source for the Staging layer and is transformed through the Bronze, Silver, and Gold layers.

## Usage

The CSV file should be loaded into the `staging.central_superstore` table using the `BULK INSERT` command in:

`sql/02_staging.sql`

The file path in the SQL script should be updated according to the local location of the downloaded repository.
