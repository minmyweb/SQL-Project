create database coffee_shop_sales_d;
use coffee_shop_sales_d;





create table coffee_shop_sales(ï»¿transaction_id int,transaction_date date,transaction_time time,
                      transaction_qty int,store_id int,store_location text,product_id int,
                      unit_price double,product_category text,product_type text,product_detail text);
select * from coffee_shop_sales;


load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/coffee.csv' into table coffee_shop_sales
fields terminated by ',' 
enclosed by '"'
lines terminated by '\n'
ignore 1 lines;

show variables like "secure_file_priv";

select * from coffee_shop_sales;
update coffee_shop_sales set transaction_time = str_to_date(transaction_time,'%H:%i%s');

alter table coffee_shop_sales change column ï»¿transaction_id transaction_id int;

describe coffee_shop_sales;

select round(sum(unit_price*transaction_qty)) as total_sales
from coffee_shop_sales
where
month(transaction_date)= 3; #march month

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

    
    select count(transaction_id) as total_orders
    from coffee_shop_sales where month(transaction_date)=3; #march month=3
    
    
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(count(transaction_id)) AS total_sales,
    (count(transaction_id) - LAG(count(transaction_id), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(count(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    select sum(transaction_qty) as total_qty_sold
    from coffee_shop_sales where month(transaction_date)=5;
    
    
    SELECT 
    MONTH(transaction_date) AS month,
    ROUND(count(transaction_id)) AS total_sales,
    (sum(transaction_qty) - LAG(sum(transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(sum(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mon_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    
    select
    concat(round( sum(unit_price*transaction_qty)/1000,1),'K') as total_sales,
     concat(round( sum(transaction_qty)/1000,1),'K') as total_qty_sold,
     concat(round( count(transaction_id)/1000,1),'K') as total_orders
    from coffee_shop_sales
    where transaction_date='2023-05-18';
    
    #weekends -sat-sun   weekdays- mon-fri
    #sun=1  ,mon=2, sat=7
    
select 
case when dayofweek(transaction_date) in (1,7) then 'Weekends'
else 'weekdays'
end as data_type,
    concat(round( sum(unit_price*transaction_qty)/1000,1),'K') as total_sales
from coffee_shop_sales
where month(transaction_date)  =  2
group by
case when dayofweek(transaction_date) in (1,7) then 'Weekends'
else 'weekdays' end;

select 
     store_location,
     concat(round(sum(unit_price*transaction_qty)/1000,1),'K') as total_sales
     from coffee_shop_sales
     where month(transaction_date)=5
     group by store_location order by sum(unit_price*transaction_qty) desc;
     
     
     
select 
    concat(round(avg(total_sales)/1000,1),'K') as avg_sales
    from
    (
     select sum(unit_price*transaction_qty) as total_sales
	from coffee_shop_sales
     where month(transaction_date)=4
     group by transaction_date
     ) as internal_query;
     
     
     select 
     day(transaction_date) as day_of_month,
     sum(unit_price*transaction_qty) as total_sales
     from coffee_shop_sales
     where month(transaction_date)=5
     group by(transaction_date)
     order by(transaction_date);
     
     
     SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;

  SELECT 
	product_category,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_category
ORDER BY SUM(unit_price * transaction_qty) DESC
limit 10;

SELECT 
	product_type,
	ROUND(SUM(unit_price * transaction_qty)/1000,1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10;

select 
hour(transaction_time),
sum(unit_price*transaction_qty) as total_sales
from coffee_shop_sales
where month(transaction_date)=5
group by hour(transaction_time) #hour no 14
order by hour(transaction_time);

SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;
 


   


    
    
    