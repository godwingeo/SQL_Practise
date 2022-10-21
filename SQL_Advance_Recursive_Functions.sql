select * from emp_details ORDER BY id;
--- Find the hierarchy of employees under a given manager Asha

with RECURSIVE emp_hierarchy as 
	(select id, name, manager_id, designation, 1 as lvl from emp_details where name = 'Asha'
	 UNION
	 select E.id, E.name, E.manager_id, E.designation,H.lvl + 1 as lvl from emp_hierarchy H 
	 join emp_details E ON H.id = E.manager_id -- Here join itself is termination condition, Add level
	)
select * from emp_hierarchy;

---Assume in the above output you need to get the Manager name instead of Manager ID 
--- This can be achieved without touching the recursive query the final query has to be joined to
--- to get the Manager name
with RECURSIVE emp_hierarchy as 
	(select id, name, manager_id, designation, 1 as lvl from emp_details where name = 'Asha'
	 UNION
	 select E.id, E.name, E.manager_id, E.designation,H.lvl + 1 as lvl from emp_hierarchy H 
	 join emp_details E ON H.id = E.manager_id -- Here join itself is termination condition, Add level
	)
select H2.id as emp_id, H2.name as emp_name, E2.name as manager_name,H2.lvl as level 
from emp_hierarchy as H2 join emp_details E2 ON
H2.manager_id = E2.id ORDER BY emp_id DESC;

--- Find the hirerachy of managers for a given employee -- this is vice versa of the above query
--- We need to pick one employee and find Manager or employee above him
--- Consider that we are querying the above logic for employee - David

with RECURSIVE emp_hierarchy as 
	(select id, name, manager_id, designation, 1 as lvl from emp_details where name = 'David'
	 UNION
	 select E.id, E.name, E.manager_id, E.designation,H.lvl + 1 as lvl from emp_hierarchy H 
	 join emp_details E ON H.manager_id = E.id -- Here join itself is termination condition, Add level
	)
select H2.id as emp_id, H2.name as emp_name, E2.name as manager_name,H2.lvl as level 
from emp_hierarchy as H2 join emp_details E2 ON
H2.manager_id = E2.id;

