-- Write a query to identifyn highest total sale value across all categories
SELECT category, MAX(total_sale) AS highest_total_sale
FROM retail_sales
GROUP BY category
ORDER BY highest_total_sale DESC, category


-- Retrieve transaction_id of all orders with highest total sale value

SELECT transactions_id
FROM retail_sales
WHERE total_sale IN (SELECT MAX(total_sale) FROM retail_sales)
ORDER BY transactions_id

-- What is the total number of orders that amounted to highest total sale value

SELECT COUNT(transactions_id)
FROM retail_sales
WHERE total_sale IN (SELECT MAX(total_sale) FROM retail_sales)

-- Write a query to show category-wise of total orders that had registered highest total sale value
SELECT category, COUNT(transactions_id) AS orders
FROM retail_sales
WHERE total_sale IN (SELECT MAX(total_sale) FROM retail_sales)
GROUP BY category
ORDER BY orders DESC, category

--Write a query to show gender-wise of total orders that had registered highest total sale value 

SELECT gender, COUNT(transactions_id) AS orders
FROM retail_sales
WHERE total_sale IN (SELECT MAX(total_sale) FROM retail_sales)
GROUP BY gender
ORDER BY orders DESC

-- Among all the orders with highest total sale value, what % of them to total orders had female buyers?

WITH female_orders AS (SELECT gender, COUNT(transactions_id) AS fem_orders
FROM retail_sales
WHERE total_sale IN (SELECT MAX(total_sale) FROM retail_sales) AND gender ILIKE 'female'
GROUP BY gender
), 

total_orders AS (SELECT COUNT(transactions_id) AS orders
FROM retail_sales
WHERE total_sale IN (SELECT MAX(total_sale) FROM retail_sales))

SELECT  gender, ROUND((fem_orders/ CAST(orders AS NUMERIC))*100,2) AS "% of total orders"
FROM female_orders, total_orders

-- Calculate total sale for each category
SELECT category, SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY category
ORDER BY total_sale DESC, category

-- Get all the transactions pertaining to clothing category where the quantity sold is more than 10 in the month of NOV-2022

SELECT transactions_id, category, quantity
FROM retail_sales
WHERE category ILIKE 'clothing' AND quantity > 2 
AND EXTRACT(YEAR FROM sale_date) = 2022 AND EXTRACT(MONTH FROM sale_date)= 11
ORDER BY quantity DESC, transactions_id

-- Average age of shoppers who bought beauty items

SELECT FLOOR(AVG(age)) AS "average age of customers"
FROM retail_sales
WHERE category ILIKE 'beauty'

-- Retrieve total number of transactions made by each gender in each category

SELECT gender, category, COUNT(transactions_id) AS total_orders
FROM retail_sales
GROUP BY gender, category
ORDER BY gender, total_orders DESC, category

-- Calculate average sale for each month. Also, best-selling months for each year
SELECT Year, Month, avg_sales
FROM(
	SELECT EXTRACT(YEAR FROM sale_date) AS Year, 
	       EXTRACT (MONTH FROM sale_date) AS Month, 
		   ROUND(CAST(AVG(total_sale) AS NUMERIC),2) AS avg_sales,
		   RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY  ROUND(CAST(AVG(total_sale) AS NUMERIC),2) DESC ) AS rank
	FROM retail_sales
	GROUP BY Year, Month) AS T2
WHERE rank= 1

-- Find top 5 customers based on their highest total sales

SELECT customer_id, SUM(total_sale) AS lifetime_order_value
FROM retail_sales
GROUP BY customer_id
ORDER BY lifetime_order_value DESC
LIMIT 5


-- Find a list of unique customers in each category
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category

-- create multiple time-shifts and identify the number of purchases done in those respective shifts for everyday
SELECT 
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift, COUNT(transactions_id)
FROM retail_sales
GROUP BY shift
ORDER BY shift DESC

-- END OF PROJECT




