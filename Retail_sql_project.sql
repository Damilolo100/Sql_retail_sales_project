SELECT * 
FROM retail_sales;

SELECT COUNT (*)
FROM retail_sales;

--Data Exploration

--How many Sales were made
SELECT COUNT (*) AS total_sales 
				FROM retail_sales;

--How many unique customers do we have
SELECT COUNT (DISTINCT customer_id) AS total_sales
				FROM retail_sales;
				
--How many distinct categories do we have?
SELECT DISTINCT category
				FROM retail_sales;
--Data Analysis / Business Key Problem 
--Q1 Write a Query to retrieve all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05'

--Q2 Write a SQL Query to retrieve all transactions where the category is 'clothing' and the quantity 
--sold is more than 10 in Nov. 2022

SELECT 
	category,
	SUM(quantiy)
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
GROUP BY 1

SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND 
	quantiy >= 4

--Q3 Write a query to calculate each category's total sales (total_sales).
SELECT 
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category

--Q4 Write a query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND(AVG(age), 2) AS avg_age
FRO retail_sales
WHERE category = 'Beauty'

--Q5 Write a query to find all transactions where the total_sale exceeds 1000.
SELECT *
	FROM retail_sales
WHERE total_sale > 1000

--Write a query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	category,
	gender,
	COUNT(*) AS total_trans
FROM retail_sales
GROUP BY
	category,
	gender
ORDER BY category

--Q7 Write a query to calculate the average sale for each month. Find out best-selling month in each year

SELECT 
	year,
	month,
	avg_sale
	FROM
	(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS RANK
	FROM retail_sales
	GROUP BY 1,2
	) AS t1
WHERE rank = 1

--SELECT DATA set
SELECT * FROM retail_sales

--Q8 Write a query to find the top 5 customers based on the highest total sales
SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q9 Write a query to find the number of Unique customers who purchased items from each category
SELECT 
	category,
	COUNT(DISTINCT customer_id) AS count_unique_customer
FROM retail_sales
GROUP BY category

--Q10 Write a query to create each shift and number of orders(Example morning <=12, Afternon Between 12 & 17, Evening > 17)
WITH hourly_sale
AS(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift