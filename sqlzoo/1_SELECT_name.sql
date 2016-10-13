/*
world table

name			continent
Afghanistan		Asia
Albania			Europe
Algeria			Africa
Andorra			Europe
Angola			Africa
*/

----------  Q1  -----------
/*Find the country that start with Y*/
select name
from world
where name like 'Y%'


----------  Q2  -----------
/*Find the countries that end with y*/
select name
from world
where name like '%y'


----------  Q3  -----------
/*Find the countries that contain the letter x*/
select name
from world
where name like '%x%'


----------  Q4  -----------
/*Find the countries that end with "land"*/
select name
from world
where name like '%land'


----------  Q5  -----------
/*Find the countries that start with "C" and end with "ia"*/
select name
from world
where name like 'C%ia'


----------  Q6  -----------
/*Find the country that has oo in the name*/
select name
from world
where name like '%oo%'


----------  Q7  -----------
/*Find the countries that have three or more "a" in the name*/
select name
from world
where name like '%a%a%a%'


----------  Q8  -----------
/*Find the countries that have "t" as the second character.*/
select name
from world
where name like '_t%'


----------  Q9  -----------
/*Find the countries that have two "o" characters separated by two others.*/
select name
from world
where name like '%o__o%'


----------  Q10  -----------
/*Find the countries that have exactly four characters.*/
select name
from world
where name like '____' -- 4 '_'


----------  Q11  -----------
/*Find the country where the name is the capital city*/
SELECT name
FROM world
WHERE name = capital


----------  Q12  -----------
/*Find the country where the capital is the country plus "City".*/
SELECT name
FROM world
WHERE capital = concat(name, ' City') -- use concat() function


----------  Q13  -----------
/*Find the capital and the name where the capital includes the name of the country.*/
SELECT capital, name
FROM world
WHERE capital like concat('%',name,'%')


----------  Q14  -----------
/*Find the capital and the name where the capital is an extension of name of the country.
You should include Mexico City as it is longer than Mexico. 
You should not include Luxembourg as the capital is the same as the country.*/
SELECT name,capital
FROM world
WHERE capital like concat(name,'%')
and capital != name


----------  Q15  -----------
/*For Monaco-Ville the name is Monaco and the extension is -Ville.

Show the name and the extension where the capital is an extension of name of the country.*/
SELECT name, REPLACE(capital, name, '') AS ext
FROM world
WHERE capital like concat(name,'_%')





















