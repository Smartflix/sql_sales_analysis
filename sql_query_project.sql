-- sql retail sales analysis
DROP TABLE IF EXISTS retail_sales;
/*create table retail_sales
		(
			transactions_id INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(50),
			age INT,
			category VARCHAR (15),
			quantiy INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT

		);
        
*/



select * from retail_sales;

create table retail_sales_staging
like retail_sales;




insert retail_sales_staging
select * from retail_sales
;

select * from retail_sales_staging;

select count(*) 
from retail_sales_staging;


select * from retail_sales_staging
where sale_date is null;

select * from retail_sales_staging
where 
sale_time is null
or
 ï»¿transactions_id is null
or
sale_date is null
or
customer_id is null
or 
gender is null
or
age is null
or 
category is null
or 
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null ;

-- data exploration

-- how many sales do we have

select count(*) as total_sales from retail_sales_staging ;

-- total unique number of customers
select  count(distinct customer_id) as unique_customers from retail_sales_staging ;

select  count(distinct category) as unique_category from retail_sales_staging ;

select  distinct (category) as unique_category from retail_sales_staging ;

-- business key problems and answers

-- write a query to retrive all sales made on 2022-11-05

select * 
from retail_sales_staging
where sale_date = '2022-11-05';

-- write a query to retrive all transactions where category is clothing and quantity sold is more than 10 in the month of nov 2022
select *
from retail_sales_staging
where category = 'Clothing'
and
DATE_FORMAT(sale_date ,'%Y-%m') = '2022-11'
and
quantiy >=4 ;

-- write an sql query to calculate the total sales for each category
select category,count(*) as total_orders,sum(total_sale) as total_sales
from retail_sales_staging
group by category;

-- write an sql query to find the average age of customers who purchase items from the beauty category
select round(avg(age),2) as avg_age  from retail_sales_staging
where category = 'Beauty'
;
-- write an sql query to find all transaction where total sales is greater than 1000

select * from retail_sales_staging 
where total_sale >1000
;

-- write a sql query to find the total number of transaction (transaction_id) by each gender in each category
select category,gender, count(ï»¿transactions_id) 
from retail_sales_staging
group by category, gender
order by category

;

-- write a sql query to calculate the average sales for each month. find the best selling month in each year.

select 
		year(sale_date) as Year,
		month(sale_date) as Month,
		avg(total_sale) as Average_Sales,
		rank()over(partition by year(sale_date) order by avg(total_sale) desc) as ranking
	 from retail_sales_staging
	 group by 1,2 
     order by 3 desc;
-- in order to knon the month with best sals in each year we make use of cte or subquery.
select 
	Year,Month,Average_Sales from

(
	select 
		year(sale_date) as Year,
		month(sale_date) as Month,
		avg(total_sale) as Average_Sales,
		rank()over(partition by year(sale_date) order by avg(total_sale) desc) as ranking
	 from retail_sales_staging
	 group by 1,2
  ) as t1
where ranking =1
 order by YEAR
 ;


-- query to find the top 5 customers based on total sales 
select 
	customer_id,
	sum(total_sale) as total_sale
from retail_sales_staging
group by customer_id
order by 2 desc
limit 5;

-- sql query to find the number of unique customers who purchase from each category

select
	category,
    count(distinct(customer_id)) as count
from retail_sales_staging
group by 1;

select
	category,
    count(customer_id) as count
from retail_sales_staging
group by 1;

-- write an sql query to create each shift and number of orders (eg morning <=12 ,afternoon between 12 and 17:00,evening >17)



with hourly_sales as 

(

select * ,
	CASE
    WHEN hour(sale_time)  <= 12 THEN 'Morning'
    WHEN hour(sale_time) between 12 and 17 THEN 'Afternoon'
    ELSE 'Evening'
	END as shift
from retail_sales_staging

)
select 
	shift,
    count(customer_id) as total_order
from hourly_sales
group by shift;





