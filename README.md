# Retail Sales Analysis SQL Project

## Project Overview

This project is designed to demonstrate my thorough understanding of SQL skills and various techniques used to explore, clean, and analyze data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. 

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Sales_data`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Sales_data;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a query to identify the highest total sale value across all categories**:
```sql
SELECT category, MAX(total_sale) AS highest_total_sale
FROM retail_sales
GROUP BY category
ORDER BY highest_total_sale DESC, category;
```

2. **Retrieve transaction_id of all orders with highest total sale value**:
```sql
SELECT transactions_id
FROM retail_sales
WHERE total_sale IN (SELECT MAX(total_sale) FROM retail_sales)
ORDER BY transactions_id;
```

3. **What is the total number of orders that amounted to highest total sale value**:
```sql
SELECT COUNT(transactions_id)
FROM retail_sales
WHERE total_sale IN (SELECT MAX(total_sale) FROM retail_sales);
```

4. **Write a query to show category-wise split of total orders that had registered highest total sale value**:
```sql
SELECT category, COUNT(transactions_id) AS orders
FROM retail_sales
WHERE total_sale IN (SELECT MAX(total_sale) FROM retail_sales)
GROUP BY category
ORDER BY orders DESC, category;
```

5. **Write a query to show gender-wise of total orders that had registered highest total sale value**:
```sql
SELECT gender, COUNT(transactions_id) AS orders
FROM retail_sales
WHERE total_sale IN (SELECT MAX(total_sale) FROM retail_sales)
GROUP BY gender
ORDER BY orders DESC;
```

6. **Among all the orders with highest total sale value, what % of them to total orders had female buyers?**:
```sql
WITH female_orders AS (SELECT gender, COUNT(transactions_id) AS fem_orders
FROM retail_sales
WHERE total_sale IN (SELECT MAX(total_sale) FROM retail_sales) AND gender ILIKE 'female'
GROUP BY gender
), 

total_orders AS (SELECT COUNT(transactions_id) AS orders
FROM retail_sales
WHERE total_sale IN (SELECT MAX(total_sale) FROM retail_sales))

SELECT  gender, ROUND((fem_orders/ CAST(orders AS NUMERIC))*100,2) AS "% of total orders"
FROM female_orders, total_orders;
```

7. **Calculate total sale for each category**:
```sql
SELECT category, SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY category
ORDER BY total_sale DESC, category;
```

8. **Get all transaction ids pertaining to clothing category where the quantity sold is more than 2 in the month of NOV-2022 **:
```sql
SELECT transactions_id, category, quantity
FROM retail_sales
WHERE category ILIKE 'clothing' AND quantity > 2 
AND EXTRACT(YEAR FROM sale_date) = 2022 AND EXTRACT(MONTH FROM sale_date)= 11
ORDER BY quantity DESC, transactions_id;
```

9. **Average age of shoppers who bought beauty items**:
```sql
SELECT FLOOR(AVG(age)) AS "average age of customers"
FROM retail_sales
WHERE category ILIKE 'beauty';
```

9. **Retrieve total number of transactions made by each gender in each category**:
```sql
SELECT gender, category, COUNT(transactions_id) AS total_orders
FROM retail_sales
GROUP BY gender, category
ORDER BY gender, total_orders DESC, category;
```

10. **Calculate average sale for each month. Also, find best-selling months for each year**:
```sql
SELECT Year, Month, avg_sales
FROM(
	SELECT EXTRACT(YEAR FROM sale_date) AS Year, 
	       EXTRACT (MONTH FROM sale_date) AS Month, 
		   ROUND(CAST(AVG(total_sale) AS NUMERIC),2) AS avg_sales,
		   RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY  ROUND(CAST(AVG(total_sale) AS NUMERIC),2) DESC ) AS rank
	FROM retail_sales
	GROUP BY Year, Month) AS T2
WHERE rank= 1;
```

11. **Find top 5 customers based on their total sales**:
```sql
SELECT customer_id, SUM(total_sale) AS lifetime_order_value
FROM retail_sales
GROUP BY customer_id
ORDER BY lifetime_order_value DESC
LIMIT 5;
```
12. **Find a list of unique customers in each category**:
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

13. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
SELECT 
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift, COUNT(transactions_id)
FROM retail_sales
GROUP BY shift
ORDER BY shift DESC;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves covers basic as well as complex SQL concepts such as database setup, data cleaning, exploratory data analysis, and attempst to answer several business-critcial queries.

## To Verify The Queries: 

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts mentioned in the database setup section above to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `SQL_queries_project1` file to perform the analysis.



