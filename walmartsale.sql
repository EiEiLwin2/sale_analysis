Use walmart_sale;
Show tables;
Rename Table `walmartsalesdata.csv` To sales;
select `time` From sales;
Alter Table sales Add Column time_of_day varchar(20);
select * from sales;
select time,
(CASE
     WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
     WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
     ELSE "Evening"
     END) As time_of_date
From sales;
UPDATE sales
SET time_of_day=(
CASE
     WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
     WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
     ELSE "Evening"
END);
select date,
dayname(date) As day_name from sales;
ALTER Table sales Add column day_name varchar(20);
Update sales 
Set day_name=dayname(date);
select date,
monthname(date) AS month_date from sales;
ALTER Table sales Add column month_name varchar(20);
Update sales 
Set month_name=monthname(date);
-- ---------------------------------------------------------------------------------------------
-- -----------------------------------------Business Question-----------------------------------
#how many city
select distinct city from sales;
#how many branch in each city
select distinct city,branch from sales;
#how many product line
select distinct `product line` from sales;
select product_line,count(product_line) from sales  group by product_line order by count(product_line) DESC;
select month_name,sum(total) As revenue from sales group by month_name order by revenue DESC;
select month_name,sum(cogs) from sales group by month_name order by sum(cogs) DESC;
select product_line,sum(total)As revenue from sales group by product_line order by revenue DESC;
select city,sum(total) As revenue from sales group by city order by revenue DESC;
select product_line,sum(VAT) as VAT from sales group by product_line order by VAT DESC;
-- question 9 fetch product line and add a column to sales table
create temporary table temp_sales select product_line,AVG(total) As average_sales from sales group by product_line;
update sales s JOIN temp_sales t ON s.product_line=t.product_line 
SET 
s.sale_quality =
CASE 
WHEN s.total > t.average_sales THEN 'Good' Else 'Bad' END;
-- which banch is more than average product sold/
select branch,sum(quantity) from sales
group by branch 
having sum(total) > (select AVG(total) from sales);
select product_line,gender,
count(gender) as g from sales group by gender,product_line order by g ASC;
select product_line,round(avg(rating,2)) as rate from sales group by product_line order by rate ASC;
-- ------------------------------------------------------------------------------------------------
-- -----------------------------------------Customer Service --------------------------------------
-- how many unique customer type in data?
select distinct customer_type from sales;
-- which payment type using the most.
select distinct payment_method from sales;
-- how many customer type is there
select customer_type,count(customer_type) as cc from sales group by customer_type;
-- which customer type is buying the most
select sum(quantity),customer_type from sales group by customer_type;
-- customer type and their gender
select customer_type,gender,
count(gender) as g from sales group by gender,customer_type order by g ASC; 
-- which gender is mostly buying in each branch
select branch,gender,count(gender) as g from sales group by branch,gender order by g DESC;
-- most buying time 
select time_of_day,round(avg(rating),2) as avg from sales group by time_of_day order by avg DESC;
-- which time customer giving rate the most
select branch,time_of_day,round(avg(rating),2) as avg from sales group by branch,time_of_day order by avg DESC limit 5;
-- which day customer giving rate the most
select day_name,branch,round(avg(rating),2) as avg from sales group by day_name,branch order by avg DESC Limit 3;
-- --------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------Sale-------------------------------------------------------------------------
-- which time of weekday is most buying
select day_name,time_of_day,
count(time_of_day) as total_sale from sales
where day_name Not IN('Saturday','Sunday')
group by day_name,time_of_day
order by total_sale DESC Limit 5;
-- which type of customer make more revenue
select customer_type,round(sum(total),2)as revenue
from sales group by customer_type
order by revenue DESC;
-- which city is largest tax percent
select city,avg(vat) as vat
From sales
group by city,vat
order by VAT DESC
LIMIT 3;
select customer_type,sum(vat)
from sales 
group by customer_type
order by sum(vat) DESC;
