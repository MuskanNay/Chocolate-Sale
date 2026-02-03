create database sales 
 ;
use sales;
select * from  `chocolate sales (2)`;

-- 🔹 STEP 2: Data Cleaning in SQL
--  Amount column (remove $ and ,)

update `chocolate sales (2)`
set `Amount` = replace(replace(`Amount`,'$',''),',', '');

SET SQL_SAFE_UPDATES = 0; -- code error remove ke liye safe mode off karna 

-- 1️⃣ Total Sales

select sum(amount) as total_sales  from `chocolate sales (2)`;

-- 2️⃣ Total Boxes Shipped
select sum(`Boxes Shipped`) as total_box_shipped  from  `chocolate sales (2)`;

-- 3️⃣ Average Sale Value

select round(avg(amount),2) as avg_sales  from `chocolate sales (2)`;

-- 🔹 STEP 4: Group By Analysis (MOST IMPORTANT)
-- 4️⃣ Country Wise Sales
SELECT 
    country, ROUND(SUM(amount), 2) sales
FROM
    `chocolate sales (2)`
GROUP BY country
ORDER BY sales DESC;

-- 5️⃣ Product Wise Sales
select product,round(sum(amount),2) as sales  from     `chocolate sales (2)` group by product order by sales desc  ;


-- 6️⃣ Sales Person Performance

select `Sales Person`, round(sum(amount),2) as total_sales from  `chocolate sales (2)` group by `Sales Person` order by total_sales desc ;

select * from `chocolate sales (2)`;

-- 🔹 STEP 5: Date Analysis (Intermediate)
-- 7️⃣ Year Wise Sales
select year(date),round(sum(amount),2) as sales  from `chocolate sales (2)` group by date order by sales  desc ;

desc `chocolate sales (2)`;

UPDATE `chocolate sales (2)`
SET date = STR_TO_DATE(date, '%d/%m/%Y');

-- ✅ STEP 4: Column Datatype Change Karo amount 

alter table `chocolate sales (2)` modify amount int;

-- 8️⃣ Month Wise Sales
select monthname(date), sum(amount) as sales  from `chocolate sales (2)` group by date  order by sales desc ; 


-- 🔹 STEP 6: Advanced SQL (Interview Level 🔥)
-- 9️⃣ Top 5 Products by Sales

select product , sum(amount) as sales  from `chocolate sales (2)` group by product order by sales desc limit 5 ;


-- 🔟 Window Function – Rank Sales Person

select `Sales Person` ,sum(amount)  as sales ,rank() over (order by sum(amount) desc) as sales_rank 
 from `chocolate sales (2)` group by `Sales Person`;
 
 -- 1️⃣1️⃣ Contribution % by Country
 select country, sum(amount) as sales, round(sum(amount) * 100.0/ sum(sum(amount)) over () , 2 ) as contribution_percentage
 from `chocolate sales (2)` group by country ;
 
 -- 💡 Q1: Which country contributes highest revenue?

SELECT 
    country,
    SUM(amount) AS total_revenue
FROM `chocolate sales (2)`
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 1;


--  Q2: Top performing product?
select product , sum(amount) as total_sales  from `chocolate sales (2)` group by product order by total_sales limit 1 ;

--  Q3: Monthly sales trend?

select year(date) as year , monthname(date) as month  , sum(amount) as total_sales  from `chocolate sales (2)` group by 
month,year order by year,month   ;


-- Q4: Who are top 3 salespersons?

select `sales person`, sum(amount) as total_sales  from `chocolate sales (2)` group by `sales person` order by total_sales  limit 3 ;


-- Q5: Which product has highest average sale?

select product, avg(amount) avg_amt  from `chocolate sales (2)`group by product order by avg_amt desc limit 1 ;


-- Q5 – Top 3 premium products

SELECT 
    product, SUM(amount) AS total_sales
FROM
    `chocolate sales (2)`
GROUP BY product
ORDER BY total_sales DESC
LIMIT 3;



-- 1️⃣ Country × Product Performance Matrix
-- Kaunsa product kaunsa country me best perform karta hai


select country , product, sum(amount) as total_sales  from  `chocolate sales (2)` group by country , product order by country, total_sales desc  ;

-- 2️⃣ Best Product per Country (Window Function 🔥)




SELECT country, product, total_sales
FROM (
    SELECT 
        country,
        product,
        SUM(amount) AS total_sales,
        RANK() OVER (PARTITION BY country ORDER BY SUM(amount) DESC) AS rnk
    FROM `chocolate sales (2)`
    GROUP BY country, product
) t
WHERE rnk = 1;
 
 
 
 -- 3️⃣ Sales Person Contribution % (Performance Review)
 
 SELECT 
    `sales person`,
    SUM(amount) AS total_sales,
    ROUND(
        SUM(amount) * 100.0 / SUM(SUM(amount)) OVER (), 2
    ) AS contribution_percentage
FROM `chocolate sales (2)`
GROUP BY `sales person`
ORDER BY total_sales DESC;

 
-- 4️⃣ Running Total (Trend Analysis)

SELECT `date`, sum(amount) as total_sales, sum(sum(amount)) over (order by date) as running_total
from `chocolate sales (2)` group by `date`order by date ; 


-- 5️⃣ Month-on-Month Growth % 🔥🔥

SELECT 
    year,
    month,
    total_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY year, month)) * 100.0
        / LAG(total_sales) OVER (ORDER BY year, month), 2
    ) AS mom_growth_percentage
FROM (
    SELECT 
        YEAR(date) AS year,
        MONTH(date) AS month,
        SUM(amount) AS total_sales
    FROM `chocolate sales (2)`
    GROUP BY YEAR(date), MONTH(date)
) t;

 
 -- 6️⃣ Low Performing Products (Action Items)
 
 select product, sum(amount) as total_sales  from `chocolate sales (2)` group by product having total_sales < (select avg(total) from 
 ( select sum(amount) as total from `chocolate sales (2)` group by product ) x);
 
 
 
 -- 7️⃣ Consistent Top Sales Persons (Stability Analysis)
 
 
SELECT 
    `sales person`, COUNT(DISTINCT YEAR(date)) AS active_yr
FROM
    `chocolate sales (2)`
GROUP BY `sales person`
HAVING active_yr >= 2;

select * from `chocolate sales (2)`;

-- 8️⃣ Boxes vs Revenue Efficiency 🔥

SELECT 
    product,
    ROUND(SUM(amount) / SUM(`boxes shipped`), 2) AS revenue_per_box
FROM
    `chocolate sales (2)`
GROUP BY product;
