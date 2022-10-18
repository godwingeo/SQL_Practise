--- Count no of students  in each class
SELECT * FROM classes;

SELECT class_id, COUNT(1) AS output_count FROM student_classes 
GROUP BY class_id ORDER BY class_id;

--- FIND the class having count more than 100 

SELECT class_id, COUNT(1) AS output_count FROM student_classes 
GROUP BY class_id
HAVING COUNT(*) > 100 --Having is mainly used with GROUP BY 
ORDER BY class_id;


SELECT *  FROM student_parent SP WHERE parent_id = 'P00019';

--- Parents with more than one kid in the school -
SELECT parent_id, COUNT(1) AS "no_of_kids" FROM student_parent SP
GROUP BY parent_id
HAVING COUNT(1) > 1;

--- Get details of the parents who have more than one kid ---
--- Tables Parents,Students, Student_Address, 
SELECT * FROM students;
SELECT * FROM PARENTS P;
SELECT * FROM student_parent;
SELECT * FROM address;

SELECT P.id, (P.first_name||''||P.last_name) AS "parent_name",
(s."first_name"||''||s."last_name") AS student_name,
s.age as student_age,s.gender AS STUDENT_GENDER ,sp."student_id", 
(adrs.street||' '||adrs.city||' '||adrs.state||' '||adrs.country) AS Address
FROM PARENTS P JOIN
student_parent sp ON P."id" = sp."parent_id" 
join students s ON sp.student_id = s.id 
join address adrs ON P.address_id = adrs.address_id
WHERE P.id IN (SELECT parent_id FROM student_parent SP
GROUP BY parent_id
HAVING COUNT(1) > 1)
ORDER BY 1;

--- All joins have the duplicates(Interview question)
SELECT * FROM public."join_particse_L";
SELECT * FROM public."join_practise_R";

SELECT * FROM public."join_particse_L" L join "join_practise_R" R
ON L."Id" = R."id";

SELECT * FROM public."join_particse_L" L right join "join_practise_R" R
ON L."Id" = R."id";

SELECT * FROM public."join_particse_L" L left join "join_practise_R" R
ON L."Id" = R."id";

SELECT * FROM public."join_particse_L" L full join "join_practise_R" R
ON L."Id" = R."id";


-- SUM of salaries of both teaching-non -teaching staff

select  stf.staff_type, SUM(ss.salary) as total_sal from staff stf join staff_salary ss 
on stf.staff_id = ss.staff_id GROUP BY stf.staff_type;

--Getting Max salary of both teaching and non teaching staff

select  stf.staff_type, MAX(ss.salary) as total_sal from staff stf join staff_salary ss 
on stf.staff_id = ss.staff_id GROUP BY stf.staff_type;

--Getting Min salary of both teaching and non teaching staff

select  stf.staff_type, MIN(ss.salary) as total_sal from staff stf join staff_salary ss 
on stf.staff_id = ss.staff_id GROUP BY stf.staff_type;

--Get the name and salary info of the employees
Select * from staff;
Select * from staff_salary;

select (stf."first_name"||' '||stf."last_name") AS full_name, ss."salary" from staff stf join staff_salary ss 
on stf.staff_id = ss.staff_id;