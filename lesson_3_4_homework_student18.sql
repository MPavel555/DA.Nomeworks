--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing


--HomeWork_Lesson 3-4


--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type
with all_models as 
( 
select model
from pc 
union all
select model
from laptop
union all
select model
from printer
)
select model, maker, type 
from all_models
join product
using (model)


--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", 
у остальных - "0"

select *
from printer 
where price > (select avg(price)  from printer )
 
select *,
 case when price > (select avg(price) from printer)
 then  1
 else  0
 end flag
 from printer 

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
 
 select *
 from ships 
 where class is null 
 

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
 комментарий: нужно разобрать пример по этой задаче гуглинг не помог не получилось сопоставить разные типы данных: battles.date и ships.launched 
 

 

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
вариант 1
select battle
from outcomes
join ships 
on outcomes.ship = ships.name 
where class = 'Kongo'

вариант 2
select battle
from outcomes 
where ship = any (select name from ships where class ='Kongo')


--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом,
 если стоимость больше > 300. Во view три колонки: model, price, flag

 create view all_products_flag_300 as
with all_product as
(
select model, price, code
 from pc 
 union
 select model, price, code
 from printer
 union
 select model, price, code
 from laptop
 )
 select model, price,
 case when price > 300  then 1
 else 0
 end flag
 from all_product
 
--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом,
 если стоимость больше cредней . Во view три колонки: model, price, flag
  
 create view all_products_flag_avg_price as
with all_product as
(
select model, price, code
 from pc 
 union
 select model, price, code
 from printer
 union
 select model, price, code
 from laptop
 )
 select model, price,
 case when price > (select avg(price) from all_product)  then 1
 else 0
 end flag
 from all_product
 
 

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. 
Вывести model
коммент к решению в таблице Product  нет производителя Printer = С только A,D,E  поэтому  среднюю будем искать по производителю принтеров D и E 

select model
from printer
join product
using (model)
where maker ='A' and price > (select avg(price)  
                             from printer
                             join product
                             using (model)
                             where maker > 'A')


--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
эта задача дублирует task3

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

select 
((
 select sum(price)
 from laptop
 join product
 using(model)
 where maker = 'A'
 )
 +
 (
 select sum(price)
 from printer
 join product
 using(model)
 where maker = 'A'
 )
 +
 (
 select sum(price)
 from pc
 join product
 using(model)
 where maker = 'A'
 ))
/
(
(
 select count(price)
 from laptop
 join product
 using(model)
 where maker = 'A'
 )
 +
 (
 select count(price)
 from printer
 join product
 using(model)
 where maker = 'A'
 )
 +
 (
 select count(price)
 from pc
 join product
 using(model)
 where maker = 'A'
)
)

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as

with products_by_makers as
(
select model, maker 
from pc
join product
using (model)
union all
select model, maker
from printer
join product
using (model)
union all
select model,maker
from laptop
join product
using (model)
)
select maker, count(*) as quantity 
from products_by_makers
group by maker
order by quantity

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)
ссылка на колаб
https://colab.research.google.com/drive/1MFDge7pxCIZSiofsm8q0EczZ58QT13bJ#scrollTo=_1ZDOBt4LnSi&line=11&uniqifier=1

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

CREATE TABLE printer_updated as

with product_renametype  as
(
select maker, model, type as typemaker  
from product
)
SELECT model, code, color, type, price 
FROM printer
join product_renametype
using (model)
where maker <> 'D'
 

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя
 (название printer_updated_with_makers)
 
CREATE view printer_updated_with_makers as
with product_renametype  as
(
select maker, model, type as typemaker  
from product
)
select model, code, color, type, price, maker 
FROM printer_updated
join product_renametype
using (model)
order by maker

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class 
(если значения класса нет/IS NULL, то заменить на 0)


create view sunk_ships_by_classes as

with table1 as
(
select class, name 
from outcomes
join ships
on outcomes.ship = ships.name
where result = 'sunk'
)
select class as clas, count(*) as quantity
from table1
group by class


--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

https://colab.research.google.com/drive/1MFDge7pxCIZSiofsm8q0EczZ58QT13bJ#scrollTo=B3o6rCPAvPMy&line=17&uniqifier=1


--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1,
 иначе 0
 
 create table classes_with_flag as
 
 select *,
 case when numguns >= 9 then 1
 else 0
 end flag
 from classes
 
 
--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)
график по ссылке
https://colab.research.google.com/drive/1MFDge7pxCIZSiofsm8q0EczZ58QT13bJ#scrollTo=hO6tO43X2Plc&line=3&uniqifier=1
 
select country, count(*) as quantity_clasess
 from classes
 group by country
 
--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
select count(name) 
from ships 
where name like 'M%' or name like 'O%'


--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select *
from ships
WHERE name  like '% %';
 
--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)
ссылка на график
https://colab.research.google.com/drive/1MFDge7pxCIZSiofsm8q0EczZ58QT13bJ#scrollTo=tckNFKSUOvW1&line=3&uniqifier=1

select launched, count(*) as quontity_ships_launched 
from ships
group by launched
