-- Employee table
select * from employee;
-- Get the Maximum salary from the employee table
select MAX(salary) as Maximum_salary From employee;

--- Get the Maximum salary in each department
select dept_name, MAX(salary) as Maximum_salary From employee 
Group BY dept_name;

--- Now assume that we need to get the max slary along with all the columns 
--- We need to use the window function.It is done using OVER clause
--- max(salary) is a aggregate function which gets converted to a window function using OVER() clause
select e.*, max(salary) over() as max_salary
from employee e;

-- Now assume we need to find the max salary for each department then to achieve that we need to use a 
-- partition by  keyword inside the OVER() clause
select e.*, max(salary) over(partition by dept_name) as max_salary
from employee e;

---Row Number() this is used to assign unique number to each of the records
select e.*,
row_number() over() as rn_number from employee e;

-- To seggregate the records with unique number to particular rows 
-- Use partition 
select e.*,
row_number() over(partition by dept_name) as rn_number from employee e;

-- To get the first two employees from each department assume that the 
-- employee id for employees joined earlier is less than recently joined
-- Note to access the row number you have to chnage it to subquery

select * from(select e.*,
row_number() over(partition by dept_name order by emp_id) as rn_number 
from employee e) x where x.rn_number < 3;

--Select employee with top 3 salary in a department 
select e.*, 
rank() over(partition by dept_name order by salary) as rank_num
from employee e ;

--Select employee with top 3 salary in a department 
select * from (select e.*, 
rank() over(partition by dept_name order by salary) as rank_num
from employee e) x where x.rank_num <4;

---  Rank will skip values for each duplicate - only difference between rank and dense_rank

select * from (select e.*, 
dense_rank() over(partition by dept_name order by salary) as dense_rank_num
from employee e) x where x.dense_rank_num <4;
--- Diff between row_number, rank,dense_rank
select e.*,
rank() over(partition by dept_name order by salary) as rank_num,			   
dense_rank() over(partition by dept_name order by salary) as dense_rank_num,
row_number() over() as rn_number			   
from employee e;
-- Fetch a query to check or compare the salary with previous employee salary
select e.*,
lag(salary) over(partition by dept_name order by emp_id) 
as previous_salary from employee e;
-- Fetch a query to check or compare the salary for every 2nd previous employee salary
--- Here 0 is the default value mainly when no values is available 
select e.*,
lag(salary, 2, 0) over(partition by dept_name order by emp_id) 
as previous_salary from employee e;

--- Lead function is  vice versa of lag
select e.*,
lead(salary) over(partition by dept_name order by emp_id) 
as previous_salary from employee e;

--- Uses case where lead and lag can be useful eg- If we need to find if the salary of the previous
--- Employee is largfer or smaller print - High or Low 

select e.*,
lag(salary) over(partition by dept_name order by emp_id) as previous_salary,
case when e.salary > lag(salary) over(partition by dept_name order by emp_id) THEN 'High'
	 when e.salary > lag(salary) over(partition by dept_name order by emp_id) THEN 'Low'
	 when e.salary = lag(salary) over(partition by dept_name order by emp_id) THEN 'same salary'
	 end as Salary_status
from employee e;
	 

	
