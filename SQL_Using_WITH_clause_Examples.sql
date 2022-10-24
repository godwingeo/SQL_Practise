--- CTE- WITH clause - Subquery factoring  all means the same i.e using WITH clause
select * from employee;

--- The one problem with aggregration functions is except the COUNT() function
--- ALl the remaining functions like AVG, MIN,MAX requires two ways to calculate it is either WITH clause
-- Or By using the SUB query 
-- The following QUERY will error out
select AVG(salary) as avg_sal from employee where employee."salary" > avg_sal;

-- ERROR:  column "avg_sal" does not exist (AS mentioned above aggregarte function count can only be used
--To get employees greater than average salary you need to use - sub query or WITH clause  )
---  Using WITH:
--- What follows with is alias name of temp table here it is average_salary (avg_sal) is the 
--- columns to be returened from the with clause here name is given as avg_sal in the brackets ()
--- This WITH clause scope will be till the query it has been invoked is used 

With average_salary (avg_sal) AS
	(select cast(avg(salary) as int) from employee)
select * from employee e, average_salary av
where e.salary > av.avg_sal;

--- Find stores who's sales where better than the average sales across all the stores

--- 1. Total sales per each store --- Total sales
select s.store_id, SUM(cost) as total_sales_per_store from sales s 
group by s.store_id ORDER BY store_id;

--- 2. Find average sales with respect to all stores --- Avg_sales
--- We need to find the avergae on the 4 records returned from the top query
select cast(avg(total_sales_per_store) as int) as avg_sales_for_all_stores
from (select s.store_id, SUM(cost) as total_sales_per_store from sales s 
group by s.store_id ORDER BY store_id) x;

--- 3. Find the stores where total_sales is greater than avg_sales
--- We need to use the above two sub query to get the total_sales greater than avg_sales

select * from (
	select s.store_id, SUM(cost) as total_sales_per_store from sales s 
	group by s.store_id) total_sales
join (select cast(avg(total_sales_per_store) as int) as avg_sales_for_all_stores
	 from (select s.store_id, SUM(cost) as total_sales_per_store from sales s 
	 group by s.store_id ORDER BY store_id) x) avg_sales

on total_sales.total_sales_per_store > avg_sales.avg_sales_for_all_stores;

--- The probelms with the above subquery is that readability of code is not good
--- Reusability of code is also not good since same code has been used multiple times
--- Reusability will cause peromance issues
--- Using With clause yu need to combine both the above queries

with Total_sales(store_id,total_sales_per_store) AS
	(select s.store_id, SUM(cost) as total_sales_per_store from sales s 
	 group by s.store_id),
	 
	 avg_sales(avg_sales_for_all_stores) AS
	 (select cast(avg(total_sales_per_store) as int) as avg_sales_for_all_stores
	 from Total_sales)
	 --- Main query of with clause
select * from Total_sales ts
join avg_sales av
on ts.total_sales_per_store > av.avg_sales_for_all_stores;


