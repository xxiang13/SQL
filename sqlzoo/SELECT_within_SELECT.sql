-- SELECT within SELECT

/*
This tutorial looks at how we can use SELECT statements within SELECT statements to perform more complex queries.

name	    | continent	| area	   | population	| gdp
Afghanistan	| Asia	    | 652230   | 25500100	| 20343000000
Albania	    | Europe	| 28748	   | 2831741	| 12960000000
Algeria	    | Africa	| 2381741  | 37100000	| 188681000000
Andorra	    | Europe	| 468	   | 78115	    | 3712000000
Angola	    | Africa	| 1246700  | 20609294	| 100990000000

*/

-------- Q1 ----------
/*
list each country name where the population is larger than that of 'Russia'
*/

-- first,get population of Russia
select population from world where name=Russia

-- second, restrict to population larger than Russia's
population > (select population from world where name='Russia')

--- Final Code ---
select name from world
where population > (select population 
					from world 
					where name='Russia')


-------- Q2 -----------
/*
Show the countries in Europe with a per capita GDP greater 
than 'United Kingdom'.
*/
-- first, a per capita GDP of UK
select gdp/population from world
where names = 'United Kingdom'

-- greater than UK's
gdp/population > (select population from world where name='United Kingdom')

--- Final Code ---
select name from world
where continent = 'Europe'
and gdp/population > (select gdp/population 
						from world 
						where name='United Kingdom')


-------- Q3 -----------
/*
List the name and continent of countries in the continents containing 
either Argentina or Australia. Order by name of the country.
*/

-- continent contain 'Argentina' or 'Australia'
select continent from world
where name='Argentina' or name='Australia'

--- Final Code ---
select name,continent
from world
where continent in (select continent from world
					where name='Argentina' or name='Australia')
order by name


-------- Q4 -----------
/*Which country has a population that is more than Canada but less than 
Poland? Show the name and the population.*/

--subquery to get population of Canada and Poland
select population from world
where name='Canada' or name = 'Poland'

--- Final Code ---
select name,population
from world
where population > (select population from world where name = 'Canada')
and population < (select population from world where name = 'Poland')


-------- Q5 -----------
/*Germany (population 80 million) has the largest population of the 
countries in Europe. Austria (population 8.5 million) has 11% of the 
population of Germany.

Show the name and the population of each country in Europe. Show the 
population as a percentage of the population of Germany.

Decimal places
Percent symbol %
*/

--- Final Code ---
select name,concat(round(population*100/(select population 
													from world where
													name='Germany'),0),'%')
from world
where continent = "Europe"


-------- Q6 -----------
/*
Which countries have a GDP greater than every country in Europe? 
[Give the name only.] (Some countries may have NULL gdp values)
*/

-- get all gdp in Europe
select gdp from world
where continent = "Europe"

--- Final Code ---
select name
from world
where gdp > all (select gdp from world 
				 where continent="Europe" and gdp is not NULL)
-- NOTE: if there is null, use > all(subquery) will be false



-------- Q7 -----------
/*Find the largest country (by area) in each continent, 
show the continent, the name and the area:*/

-- get largest area of each continent
select max(area) from world
group by continent


-- get countries having largest area of each continent

select continent,name,area
from world
where area in (select max(area) from world
			   group by continent)



-------- Q8 -----------
/*List each continent and the name of the country
 that comes first alphabetically.*/

-- use correalted subquery find first alphabetically country
from world W 
where name = (select name from world
			  where world.continent = W.continent
			  order by name asc limit 1 )

--- Final Code ---
select continent,name
from world W 
where name = (select name from world
			  where world.continent = W.continent
			  order by name asc limit 1 )

--- Solution 2 ---
SELECT continent, name FROM world x
	WHERE name <= ALL
		(SELECT name FROM world y
			WHERE y.continent=x.continent);


-------- Q9 -----------
/*Find the continents where all countries have a population <= 25000000. 
Then find the names of the countries associated with these continents. 
Show name, continent and population*/

-- use subquery to get continents where at least one country have a population > 25000000
-- these continents don't meet the criteria
select distinct continent from world
					 where population > 25000000

--- Final Code ---
select name, continent, population
from world
where continent not in (select distinct continent from world
					 where population > 25000000)

--- Solution 3 ---
SELECT name, continent, population FROM world x
	WHERE 25000000 >= ALL
		(SELECT population FROM world y
			WHERE y.continent=x.continent);

--- Solution 3 ---
SELECT name, continent, population
FROM world
WHERE continent IN (SELECT continent
FROM world
GROUP BY continent
HAVING count(*) = SUM(CASE WHEN population <= 25000000 THEN 1 ELSE 0 END))



-------- Q10 -----------
/*Some countries have populations more than three times that of any of their neighbours
(in the same continent). Give the countries and continents.*/

-- use correlated subquery to get all neighbers population
(select population from world where continent=W.continent and name != W.name)

-- use WHERE clause to filter out population of the country /3 
-- smaller than any population of neighbers

where population/3 > all (select population 
						  from world 
						  where continent=W.continent and name != W.name)

--- Final Code ---
select name,continent
from world W
where population/3 > all (select population 
						  from world 
						  where continent=W.continent and name != W.name)






















































