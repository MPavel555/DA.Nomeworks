--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

SELECT 
    CASE
        WHEN Grades.Grade > 7 THEN Students.Name
        WHEN Grades.Grade <= 7 THEN NULL
        END, Grades.Grade, Students.Marks FROM Students INNER JOIN Grades 
        ON Students.Marks BETWEEN Grades.Min_Mark AND Max_Mark ORDER BY Grades.Grade DESC, Students.Name ASC, Students.Marks ASC;


--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem
set @r1=0, @r2=0, @r3=0, @r4=0;
select min(Doctor), min(Professor), min(Singer), min(Actor)
from(
  select case when Occupation='Doctor' then (@r1:=@r1+1)
            when Occupation='Professor' then (@r2:=@r2+1)
            when Occupation='Singer' then (@r3:=@r3+1)
            when Occupation='Actor' then (@r4:=@r4+1) end as RowNumber,
    case when Occupation='Doctor' then Name end as Doctor,
    case when Occupation='Professor' then Name end as Professor,
    case when Occupation='Singer' then Name end as Singer,
    case when Occupation='Actor' then Name end as Actor
  from OCCUPATIONS
  order by Name
) Temp
group by RowNumber


--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY NOT IN (SELECT CITY FROM STATION WHERE CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%')


--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY NOT IN (SELECT CITY FROM STATION WHERE CITY LIKE '%A' OR CITY LIKE '%E' OR CITY LIKE '%I' OR CITY LIKE '%O' OR CITY LIKE '%U')

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

SELECT DISTINCT CITY 
FROM STATION 
WHERE (CITY NOT IN (SELECT CITY FROM STATION WHERE CITY LIKE '%A' OR CITY LIKE '%E' OR CITY LIKE '%I' OR CITY LIKE '%O' OR CITY LIKE '%U'))
OR (CITY NOT IN (SELECT CITY FROM STATION WHERE CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%'))


--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY NOT IN (SELECT CITY FROM STATION WHERE CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%')
and CITY NOT IN (SELECT CITY FROM STATION WHERE CITY LIKE '%A' OR CITY LIKE '%E' OR CITY LIKE '%I' and CITY LIKE '%O' OR CITY LIKE '%U');



--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name from Employee where months < 10 and salary > 2000

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select
case
when Grades.Grade > 7 then Students.Name 
else Null
End, Grades.Grade, Students.Marks
From Students Join Grades on Students.Marks between  Grades.Min_Mark and Grades.Max_Mark
Order by Grades.Grade desc, Students.Name asc, Students.Marks asc;
