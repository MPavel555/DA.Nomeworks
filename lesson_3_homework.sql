HomeWork Lesson 3

-task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
решение 1
select class, count(result) 
from ships 
join outcomes 
on ships.name = outcomes.ship
where result = 'sunk' 
group by class 

Рушение 2
with ships_sunk as
(
select *
from ships 
where name = any (select ship from outcomes where result = 'sunk')
)
select class, count(name) 
from ships_sunk
group by class

 
--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного
 корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

 select class, launched 
from ships
where name = class 



--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число 
потопленных кораблей.

with Classes_Ships as 
(
select * 
from classes
join ships
using (class)
) 
select class, count(name)  
from Classes_Ships
where name = any (select ship from outcomes where result = 'sunk')
group by class


--tasк4 Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же 
водоизмещения (учесть корабли из таблицы Outcomes).
(коммент по решению: вывел из таблицы outcomes все наименования кораблей соответсвующих в объединенной таблице ships+classes
кораблям с мах кол-вом орудий)

with table1 as 
(
select  displacement, name, numguns
from ships
join classes 
using (class)
)
select distinct ship 
from outcomes
where ship = any (select name from table1 where numguns = (select max(numguns) from table1))

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором 
среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

with Maker_PC_minRAM_maxSPEED as 
(select maker, speed, ram
from pc 
join product
using (model)
where ram = (select min(ram) from pc where speed = (select max(speed) from pc))
and speed = (select max(speed) from pc)
)
select maker, speed, ram
from Maker_PC_minRAM_maxSPEED
where maker = all (select maker from printer)