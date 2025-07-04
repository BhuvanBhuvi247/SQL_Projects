# Retail Sales Analysis
## Overview 
**Project Title:** Retail Sales Analysis
**Field:** Data Analytics

This is a project which is perfomed to explore, clean and analyze the retail sales data. The project involves creating a database, importing, performing exploratory data analysis (EDA) and answering specific business questions through SQL queries. This Provides basic insight on how queries help in solving the business problems.

## Objectives
1) Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
2) Data Cleaning: Identify and remove any records with missing or null values.
3) Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
4) Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.

## Details

### 1. Creating Database 

- Database Creation: A database named `retailsales` is created.
- Table Creation: A table named `retailsales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retailsales;

CREATE TABLE retailsales
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
```sql
SELECT COUNT(*) FROM retailsales;
```
- **Customer Count**: Find out how many unique customers are in the dataset.
```sql
SELECT COUNT(DISTINCT customer_id) AS Customer_Count FROM retailsales;
```
- **Category Count**: Identify all unique product categories in the dataset.
```sql
SELECT DISTINCT category AS Categories FROM retailsales;
```
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
```sql
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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on 2022-11-05**

```sql
SELECT * FROM retailsales
WHERE sale_date = '2022-11-05';
```
2. **Write a SQL query to retrieve all transactions where category is 'clothing' and the quantity sold is more than 3 in month of nov 2022**

```sql
SELECT * FROM retailsales
WHERE category = 'Clothing' 
AND quantiy > 3
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
ORDER BY sale_date;
```
3. **Write a SQL query to calculate the total sales (total_sales) for each category.**

```sql
SELECT 
	category,
	SUM(total_sale) AS sales,
    COUNT(*) AS total_orders
FROM retailsales
GROUP BY category;
```
4. **Write a SQL query to find the average age of customers who puschased items from the 'Beauty' category.**

```sql
SELECT AVG(age) FROM retailsales
WHERE category = 'Beauty'; 
```
5. **Write a SQL query to find all transactions where the total_sales is greater than 1000.**

```sql
SELECT * FROM retailsales
WHERE total_sale > 1000;
```
6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**

```sql
SELECT 
	gender,
    category,
    COUNT(*)
FROM retailsales  
GROUP BY gender,category
ORDER BY gender;
```
7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.**

```sql
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
```

8. **Write SQL query to find top 5 customers based on the highest total sales**

```sql
SELECT 
	customer_id,
	SUM(total_sale) AS total_sale
FROM retailsales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;
```
9. **Write SQL query to find the number of unique customers who purchased items from each category.**

```sql
SELECT 
	COUNT(DISTINCT customer_id) AS unique_cust,
    category
FROM retailsales
GROUP BY category
ORDER BY unique_cust DESC;
```

10. **Write a SQL query to create each shift and number of orders (Ex. Morning <=12, Afternoon Between 12 and 17, Evening >17)**

```sql
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
```
