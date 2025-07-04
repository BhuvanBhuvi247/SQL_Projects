CREATE TABLE retailSales (
							transactions_id INT PRIMARY KEY,
							sale_date DATE,
                            sale_time TIME,
                            customer_id INT,	
                            gender VARCHAR(15) ,
                            age INT,
                            category VARCHAR(15),
                            quantiy INT,
                            price_per_unit FLOAT,
                            cogs FLOAT,
                            total_sale FLOAT
                            );
                            
SELECT * FROM retailsales;

SELECT COUNT(*) FROM retailsales;

SELECT * FROM retailsales
WHERE transactions_id IS NULL;

SELECT * FROM retailsales
WHERE sale_date IS NULL;

SELECT * FROM retailsales
WHERE 
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR 
    gender IS NULL
    OR
    age IS NULL
    OR
    category IS NULL
    OR 
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR 
    total_sale IS NULL;
    
DELETE FROM retailsales
WHERE 
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR 
    gender IS NULL
    OR
    age IS NULL
    OR
    category IS NULL
    OR 
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR 
    total_sale IS NULL;
    
-- DATA EXPLORATION 
-- Count of sales
SELECT COUNT(*) AS total_sale FROM retailsales;
-- Count of customers
SELECT COUNT(DISTINCT customer_id) AS Customer_Count FROM retailsales;
-- CHECK CATEGORIES
SELECT DISTINCT category AS Categories FROM retailsales;
    
-- DATA ANALYSIS 

-- 1) Write a SQL query to retrieve all columns for sales made on 2022-11-05
SELECT * FROM retailsales
WHERE sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where category is 'clothing' and the quantity sold is more than 3 in month of nov 2022
SELECT * FROM retailsales
WHERE category = 'Clothing' 
AND quantiy > 3
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
ORDER BY sale_date;

-- 3) Write a SQL query to calculate the total sales (total_sales) for each category.

SELECT 
	category,
	SUM(total_sale) AS sales,
    COUNT(*) AS total_orders
FROM retailsales
GROUP BY category;

-- 4) Write a SQL query to find the average age of customers who puschased items from the 'Beauty' category.

SELECT AVG(age) FROM retailsales
WHERE category = 'Beauty'; 

-- 5) Write a SQL query to find all transactions where the total_sales is greater than 1000.

SELECT * FROM retailsales
WHERE total_sale > 1000;

-- 6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	gender,
    category,
    COUNT(*)
FROM retailsales  
GROUP BY gender,category
ORDER BY gender;

-- 7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.alter

SELECT 
	year,
    month,
    avg_sale
FROM
(
SELECT 
	YEAR(sale_date) AS year,
	MONTH(sale_date) AS month,
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale)DESC) AS pos
FROM retailsales
GROUP BY year, month
) AS T1
WHERE pos = 1;

-- 8) Write SQL query to find top 5 customers based on the highest total sales

SELECT 
	customer_id,
	SUM(total_sale) AS total_sale
FROM retailsales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- 9) Write SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	COUNT(DISTINCT customer_id) AS unique_cust,
    category
FROM retailsales
GROUP BY category
ORDER BY unique_cust DESC;

-- 10) Write a SQL query to create each shift and number of orders (Ex. Morning <=12, Afternoon Between 12 and 17, Evening >17)

WITH hourly_sales
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS shift
FROM retailsales
)
SELECT 
	shift,
    COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;

SELECT * FROM retailsales