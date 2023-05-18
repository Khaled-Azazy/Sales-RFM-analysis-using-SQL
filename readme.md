# Sales Data Analysis Project

This project aims to analyze sales data and derive insights from it using SQL queries and RFM (Recency, Frequency, Monetary) analysis. It provides various metrics and visualizations to understand sales performance, customer behavior, and product analysis.

## Dataset

The dataset used for this project is stored in the file `OnlineRetaill`. It contains sales data including customer information, transaction details, products, and payment information.

## SQL Queries

The SQL queries are written in the file `OnlineRetaill` and perform several analyses on the sales data. The queries include:

- Calculation of total sales per country.
- Determination of sales per year.
- Identification of minimum and maximum sales per customer per year.
- Identification of the top 10 customers with the highest transaction count.
- Calculation of total payment and count per product.

## RFM Analysis

RFM (Recency, Frequency, Monetary) analysis is performed to segment users based on their transaction history. The analysis involves the following steps:

1. Recency: Calculation of the number of days since the last transaction for each customer.
2. Frequency: Determination of the number of transactions per customer.
3. Monetary: Calculation of the total amount paid by each customer.
4. Calculation of average frequency and monetary values.
5. Assigning scores to recency, frequency, and monetary using the ntile function.
6. Categorization of users into approximately 10 segments using a case statement.

## Usage

To run the SQL queries and perform the analysis:

1. Ensure that you have a compatible SQL database management system installed.
2. Import the dataset file `OnlineRetaill` into the database.
3. Execute the SQL queries in the `OnlineRetaill` file using the appropriate database management system.

## Results

The results of the analysis will provide insights into various aspects of the sales data, including:

- Total sales per country.
- Sales per year.
- Minimum and maximum sales per customer per year.
- Top 10 customers with the highest transaction count.
- Total payment and count per product.
