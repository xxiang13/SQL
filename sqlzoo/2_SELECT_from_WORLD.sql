/*
world table:
name		|continent	|area		|population	|gdp
Afghanistan	|Asia		|652230		|25500100	|20343000000
Albania		|Europe		|28748		|2831741	|12960000000
Algeria		|Africa		|2381741	|37100000	|188681000000
Andorra		|Europe		|468		|78115		|3712000000
Angola		|Africa		|1246700	|20609294	|100990000000
*/


---------- Q2 -----------
/*Show the name for the countries that have a population of 
at least 200 million. 200 million is 200000000, there are eight zeros.*/

select name
from world
where population >= 200000000



---------- Q3 -----------
/*Give the name and the per capita GDP for those countries with 
a population of at least 200 million.*/

select name, gdp/population
from world
where population >= 200000000



---------- Q4 -----------
/*Show the name and population in millions for the countries of the 
continent 'South America'. Divide the population by 1000000 to get population in millions.*/

select name, population/1000000
from world
where continent = 'South America'



---------- Q5 -----------
/*Show the name and population for France, Germany, Italy*/
select name, population
from world
where name in ('France','Germany','Italy')



---------- Q6 -----------
/*Show the countries which have a name that includes the word 'United'*/
select name
from world
where name like '%United%'



---------- Q7 -----------
/*Two ways to be big: A country is big if it has an area of more than 3 million 
sq km or it has a population of more than 250 million.
Show the countries that are big by area or big by population. Show name, 
population and area.*/
select name, population, area
from world
where area >= 3000000 or population >= 250000000
order by area, population




---------- Q8 -----------
/*Exclusive OR (XOR). Show the countries that are big by area or big by population 
but not both. Show name, population and area.*/

-- first get country big in both first
(select name
from world
where area >= 3000000 and population >= 250000000)

-- use WHERE clause to filter out these countries
select name, population,area
from world
where (area >= 3000000 or population >= 250000000) -- use pathesis separate conditions!
and name not in (select name
					from world
					where area >= 3000000 and population >= 250000000)




---------- Q9 -----------
/*Show the name and population in millions and the GDP in billions for the countries 
of the continent 'South America'. Use the ROUND function to show the values to two decimal 
places. 
For South America show population in millions and GDP in billions both to 2 decimal places.*/

select name, round(population/1000000,2), round(gdp/1000000000,2)
from world
where continent = 'South America'



---------- Q10 -----------
/*Show the name and per-capita GDP for those countries with a GDP of 
at least one trillion (1000000000000; that is 12 zeros). 
Round this value to the nearest 1000.
Show per-capita GDP for the trillion dollar countries to the nearest $1000.*/

select name, round(gdp/(population*1000))*1000 --Round this value to the nearest 1000
from world
where gdp >= 1000000000000



---------- Q11 -----------
/*Show the name - but substitute Australasia for Oceania - for countries beginning with N.*/

select name, case when continent = 'Oceania' then 'Australasia' else continent end
from world
where name like 'N%'



---------- Q12 -----------
/*Show the name and the continent - but substitute Eurasia for Europe and Asia; 
substitute America for each country in North America or South America or Caribbean. 
Show countries beginning with A or B*/

select name, case when continent in ('Europe','Asia') then 'Eurasia'
				  when continent in ('North America','South America','Caribbean') 
				  then 'America' 
				  else continent end

from world
where (name like 'A%' or name like 'B%')
order by name



---------- Q13 -----------
/*Put the continents right...

Oceania becomes Australasia
Countries in Eurasia and Turkey go to Europe/Asia
Caribbean islands starting with 'B' go to North America, 
other Caribbean islands go to South America

Order by country name in ascending order
Show the name, the original continent and the new continent of all countries.*/

select name, continent
,case when continent='Oceania' then 'Australasia'
 when continent in ('Eurasia','Turkey') then 'Europe/Asia'
 when continent='Caribbean' then
 	case when name like 'B%' then 'North America' -- nested if condition
 	else 'South America' end 
 else continent end
from world
order by name





