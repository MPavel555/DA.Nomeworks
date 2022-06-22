--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/


select d.Name as Department, a. Name as Employee, a. Salary 
from 
(
select e.*, dense_rank() over (partition by DepartmentId order by Salary desc) as drn 
from Employee e 
) a 
join Department d
on a.DepartmentId = d.Id 
where drn <=3;


--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

select member_name, status, 
SUM(amount*unit_price) as costs 
from Payments 
join FamilyMembers
on Familymembers.member_id = payments.family_member
where Year (date)='2005'
GROUP BY member_name, status


--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select name 
from (
select name, count(*) as c
from passenger 
group by name
) a 
where c > 1


--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as count
from Student
left join Student_in_class
on Student.id = Student_in_class.student 
left join Class
on Student_in_class.class = Class.id 
where first_name = 'Anna'



--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select COUNT(classroom ) as count
from Schedule
where date = '2019-09-02%'


--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as count
from Student
left join Student_in_class
on Student.id = Student_in_class.student 
left join Class
on Student_in_class.class = Class.id 
where first_name = 'Anna'


--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

SELECT *,
FLOOR(age) as age
FROM 
(
select AVG(age) as age
FROM 
(
select*,
2022-Year(birthday ) as age
FROM FamilyMembers
) a
) b


--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select good_type_name, 
SUM(amount*unit_price) as costs 
from Payments 
join Goods
on Payments.good = Goods.good_id 
join GoodTypes
on Goods.type = GoodTypes.good_type_id 
where Year (date)='2005'
GROUP BY good_type_name



--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

WITH b as 
(
SELECT *,
row_number() over (order by year) as rn
from
(
select birthday,
(select curdate ()) - birthday as year
from Student
) as a
)
select * from b where rn = 1


--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

with 10class AS 
(select name, last_name, birthday  
from Class
join Student_in_class
on class.id = Student_in_class.class
join Student
on Student_in_class.student = student.id 
where name= 10
)
select MAX(age) as max_year
from
(
select *,
2022-db as age
from
(
select *,
YEAR(birthday) as db
from 10class
) as a
) as b



--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select status, member_name, 
SUM(amount*unit_price) as costs 
from Payments 
join Goods
on Payments.good = Goods.good_id 
join GoodTypes
on Goods.type = GoodTypes.good_type_id 
join FamilyMembers
on Payments.family_member= FamilyMembers.member_id  
where good_type_name = 'entertainment'
GROUP BY status, member_name



--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

select id, company, plane, town_from,town_to, time_out,time_in      
from
(
select *,
COUNT(*) over (partition by company ) as cnt
from Trip
) as a
where cnt = 10


--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select classroom
FROM 
(
with classroom as 
(
select classroom, COUNT(*) as qt  
from Schedule
join Subject
on Schedule.subject = Subject.id 
group by classroom 
)
select *,
dense_rank () over (order by qt desc) as rn
from classroom
) as a
where rn = 1



--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

select last_name
FROM 
(
select last_name,
rank() over (order by last_name) 
from Subject
join Schedule
on Subject.id= Schedule.subject 
join Teacher
on Schedule.teacher= Teacher.id 
where name = 'Physical Culture' 
) as a

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

select name
from
(select *,
concat(last_name, '.', left(first_name, 1), '.', left(middle_name, 1), '.') as name
from Student) a
order by name 
