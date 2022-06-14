

LESSON 5

--task1  (lesson5)
-- Компьютерная фирма: Вывести список самых дешевых принтеров по каждому типу (type)
select *
from (
  select *, 
  row_number() over (partition by type order by price) as rn
  from printer
      ) as foo
where rn = 1

--task2  (lesson5)
-- Компьютерная фирма: Вывести список самых дешевых PC по каждому типу скорости
select * from pc

select *
from (
  select *, 
  row_number() over (partition by speed order by price asc ) as rn
  from pc
      ) as foo
where rn = 1


--task3  (lesson5)
-- Компьютерная фирма: Найти производителей, которые производят более 2-х моделей PC (через RANK, не having).
select * from product

select distinct maker 
from (
  select *,
  rank () over (partition by maker order by model) 
  from product 
  where type = 'PC'
) as а
where rank > 2

--task4 (lesson5)
-- Компьютерная фирма: Вывести список самых дешевых PC по каждому производителю. Вывод: maker, code, price

select maker, code, price 
from ( 
 select *, 
 rank () over (partition by maker order by price)  
 from  product  
 join pc  
 on product.model = pc.model 
 where type = 'PC' 
 ) a 
 where rank = 1

--task5 (lesson5)
-- Компьютерная фирма: Создать view (all_products_050521), в рамках которого будет только 2 самых дорогих товаров по каждому производителю
create view all_products_050521 as  
 
select * 
from 
 ( 
 select *, 
 row_number() over (partition by maker order by price DESC) as rn 
 from 
  ( 
  select product.model, maker, price, product.type 
   from product 
   join laptop 
   on product.model = laptop.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join pc 
    on product.model = pc.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join printer 
    on product.model = printer.model 
    ) as foo 
 ) as foo1 
where rn >=1 and rn <=2; 
 
 
--task6 (lesson5)
-- Компьютерная фирма: Сделать график со средней ценой по всем товарам по каждому производителю (X: maker, Y: avg_price) 
на базе view all_products_050521
ссылка на colab график:

https://colab.research.google.com/drive/1MFDge7pxCIZSiofsm8q0EczZ58QT13bJ?usp=sharing

select  maker, avg(price)
from all_products_050521
group by maker


--task7 (lesson5)
-- Компьютерная фирма: Для каждого принтера из таблицы printer найти разность между его ценой и минимальной ценой на модели с 
таким же значением типа (type, в долях)

select *, 
 price / min(price)  over (partition by type order by price asc ) as delta_doly
from printer


--task8 (lesson5)
-- Компьютерная фирма: Для каждого принтера из таблицы printer найти разность между его ценой и минимальной ценой на модели с таким же 
значением color (type, в долях-не надо доли)

select *, 
price - min(price) over (partition by color) as delta
from printer


--task9 (lesson5)
-- Компьютерная фирма: Для каждого laptop  из таблицы laptop вывести три самых дорогих устройства (через оконные функции).
select *
from 
(
select *,
row_number() over (order by price desc) as rn
from laptop
) as a
where rn <=3


---task10 (lesson5)
Компьютерная фирма: Для каждого производителя вывести по три самых дешевых устройства в отдельное view (products_with_lowest_price).

create view products_with_lowest_price as 
select * 
from 
 ( 
 select *, 
 row_number() over (partition by maker order by price asc) as rn 
 from 
  ( 
  select product.model, maker, price, product.type 
   from product 
   join laptop 
   on product.model = laptop.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join pc 
    on product.model = pc.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join printer 
    on product.model = printer.model 
    ) as foo 
 ) as foo1 
where rn <=3 
 
   
--task11 (lesson5)
-- Компьютерная фирма: Построить график с со средней и максимальной ценами на базе products_with_lowest_price (X: maker, Y1: max_price,
 Y2: avg)price

 select maker, avg(price)as avg, max(price) as max
 from products_with_lowest_price
 group by maker
 
 

Homework_lesson5

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов 
на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

sample:
1 1
2 1
1 2
2 2
1 3
2 3

create view pages_all_products as
select *, 
 case when num %2=0 then num/2 
 else num/2 + 1 
 end as page_num,
 case when total %6 = 0 then total/3
 else total/3 
 end as num_of_pages
     from (select *,
     row_number(*) over(order by model desc) as num, 
     count(*) over() as total 
     from Laptop) as a;

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства.
 Вывод: производитель, тип, процент (%)

 create view distribution_by_type as
 
 with A as
 (
 select type, maker,
 rank () over (partition by maker) as rn_type 
 from 
 (
 select maker, model, product.type  from printer join product using (model)
 union all
 select maker, model, product.type from pc join product using (model)
 union all
 select maker, model, product.type from laptop join product using (model)
 ) as a
)
select type, count (*) * 100.0 / (SELECT count(*) FROM A) as percent
from A
group by type


select * 
from distribution_by_type


--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/
ссылка на pie chart
https://colab.research.google.com/drive/1MFDge7pxCIZSiofsm8q0EczZ58QT13bJ#scrollTo=T92g0TCnGd0d&line=1&uniqifier=1


--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов
create table ships_two_words as
select *
from ships
where name like '% %'

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select * 
from ships 
where class is null 
and name like'S%'

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 
три самых дорогих (через оконные функции). Вывести model 
(текст задания поправил иначе некорректно: вместо производителя = 'C' изменил на 'D'т.к производителя принтеров = 'C' несуществует 
в таблице Printer )
with aa as  
(
select model, maker, price,
row_number () over (order by price desc) as rn,
avg(price) over (partition by maker) as SRED,
price - (select avg (price) from printer join product using (model) where maker = 'D') as delta
from
(select * 
from printer 
join product
using (model) 
)a
)
select * 
from aa 
where maker = 'A' 
and delta > 0 
and rn <= 3 


LESSON 6

--task1  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index как объединение всех данных по ключу code (union all). 
Сделать индекс по полю type

create table all_products_with_index as 
select product.model, maker, price, product.type  
from ( 
select code, model, price 
   from pc 
   union all  
    select code, model, price 
    from printer  
   union all  
    select code, model, price 
    from laptop   
    ) as foo 
    join product   
    on product.model = foo.model ;
 
create index type_idx1 on all_products_with_index (type);



--task2  (lesson6)
--Компьютерная фирма: Вывести список всех уникальных PC и производителя с ценой выше хотя бы одного принтера. Вывод: model, maker

select distinct pc.model, product.maker 
from pc 
join product 
on product.model = pc.model  
where pc.price > (select min(price) from printer ) 
order by product.maker


--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

with table1 as 
(
select product.model, maker, price, product.type  
from ( 
select code, model, price 
   from pc 
   union all  
    select code, model, price 
    from printer  
   union all  
    select code, model, price 
    from laptop   
    ) as foo 
    join product   
    on product.model = foo.model
)
select model
from (
  select *, 
  row_number() over (partition by type order by price desc) as rn
  from table1
      ) as foo1
where rn = 1


--task4  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task4 как объединение всех данных по ключу code (union all) и 
сделать флаг (flag) по цене > максимальной по принтеру. Сделать индекс по flag

create table all_products_with_index_task4 as 
 select product.model, maker, price, type, 
 case  
 when price > (select max(price) from printer) then 1 
 else 0 
 end flag
 from 
 (select code, model, price 
 from pc  
 union all 
 select code, model, price 
 from laptop l  
 union all 
 select code, model, price 
 from printer) all_products 
 join product  
 on all_products.model = product.model; 
 

select * from all_products_with_index_task4 

 create index flag_idx2 on all_products_with_index_task4 (flag);

 
--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) и
 сделать флаг (flag) по цене > максимальной по принтеру. Также добавить нумерацию (через оконные функции) по каждой категории 
 продукта в порядке возрастания цены (price_index). По этому price_index сделать индекс

 create table all_products_with_index_task5 as
 select *,
 case when price > (select max(price) from printer) 
 then 1
 else 0
 end flag,
 row_number() over (partition by type order by price asc) as price_index
 from
 (select code, model, price 
 from pc  
 union all 
 select code, model, price 
 from laptop l  
 union all 
 select code, model, price 
 from printer) as union_all_products
 join product
 using (model) 
 
 select * from all_products_with_index_task5
 
 create index price_index on all_products_with_index_task5(price_index);
 