--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

SET @r1=0,@r2=0,@r3=0,@r4=0;
SELECT MIN(Doctor),MIN(Professor),MIN(Singer),MIN(Actor)
FROM (
SELECT CASE
    WHEN OCCUPATION = 'Doctor' THEN (@r1:=@r1+1)
    WHEN OCCUPATION = 'Professor' THEN (@r2:=@r2+1)
    WHEN OCCUPATION = 'Singer' THEN (@r3:=@r3+1)
    WHEN OCCUPATION = 'Actor' THEN (@r4:=@r4+1) END AS RowNumber,
    CASE WHEN OCCUPATION = 'Doctor' THEN Name END AS Doctor,
    CASE WHEN OCCUPATION = 'Professor' THEN Name END AS Professor,
    CASE WHEN OCCUPATION = 'Singer' THEN Name END AS Singer,
    CASE WHEN OCCUPATION = 'Actor' THEN Name END AS Actor
FROM OCCUPATIONS
ORDER BY Name) as temp


--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

select *,
case when Occupation = 'Doctor' then 1
when Occupation = 'Professor' then 2
when Occupation = 'Singer' then 3
else 4
end flag
from Occupations




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