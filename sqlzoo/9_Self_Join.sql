-- Self Join

/*
stops(id, name)
route(num,company,pos, stop)

Table: stops
This is a list of areas served by buses. 
The detail does not really include each actual bus stop - 
just areas within Edinburgh and whole towns near Edinburgh.

Field	Type		|Notes
id		|INTEGER	|Arbitrary value
name	|CHAR(30)	|The name of an area served by at least one bus


Table: route
A route is the path through town taken by a bus.

Field	   |Type		|Notes
num		   |CHAR(5)	|The number of the bus - as it appears on the front of the vehicle. 
						        Oddly these numbers often include letters
company  |CHAR(3)	|Several bus companies operate in Edinburgh. 
						       The main one is Lothian Region Transport - LRT
pos		   |INTEGER	|This indicates the order of the stop within the route. 
						        Some routes may revisit a stop. Most buses go in both directions.
stop	   |INTEGER	|This references the stops table (id)

As different companies use numbers arbitrarily the num and the company 
are both required to identify a route.
*/


----------- Q1 -----------
/*How many stops are in the database.*/
select count(*) from stops 



----------- Q2 -----------
/*Find the id value for the stop 'Craiglockhart'*/
select id from stops 
where name='Craiglockhart'



----------- Q3 -----------
/*Give the id and the name for the stops on the '4' 'LRT' service.*/

-- locate the '4' 'LRT' service in route table
from route
where num='4' and company='LRT'

-- Join stops table to get id and name
select S.id, S.name
from stops S
inner join route R on S.id = R.stop
where R.num='4' and R.company='LRT'



----------- Q4 -----------
/*The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). 
Run the query and notice the two services that link these stops have a count of 2. 
Add a HAVING clause to restrict the output to these two routes.*/
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
having count(*) >= 2




----------- Q5 -----------
/*shows the services from 
Craiglockhart to London Road without changing routes.*/
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 and b.stop=149




----------- Q6 -----------
/*The query shown is similar to the previous one, however by joining two copies of the stops table 
we can refer to stops by name rather than by number. Change the query so that the services between 
'Craiglockhart' and 'London Road' are shown. */
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' and stopb.name = 'London Road'



----------- Q7 -----------
/*Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')*/
SELECT distinct a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop = 115 and b.stop =137



----------- Q8 -----------
/*Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'*/
SELECT distinct a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' and stopb.name = 'Tollcross'



----------- Q9 -----------
/*Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, 
including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. 
of the relevant services.*/
SELECT distinct stopb.name, a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' and b.company = "LRT"



---------- Q10 -----------
/*Find the routes involving two buses that can go from Craiglockhart to Sighthill.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus.

Hint
Self-join twice to find buses that visit Craiglockhart and Sighthill, then join those 
on matching stops.*/

-- buses visiting Craiglockhart
select r2.num, r2.company, r2.stop
from route r
join stops s on r.stop = s.id and s.name = 'Craiglockhart'
join route r2 on (r.company=r2.company AND r.num=r2.num)

-- buses visiting Sighthill
select r2.num, r2.company, r2.stop
from route r
join stops s on r.stop = s.id and s.name = 'Sighthill'
join route r2 on (r.company=r2.company AND r.num=r2.num)

-- join and find common stops
select distinct a.num, a.company, stops.name, b.num, b.company
from (select r2.num, r2.company, r2.stop
		from route r
		join route r2 on r.company=r2.company AND r.num=r2.num
		WHERE r.stop=(SELECT id FROM stops WHERE name= 'Craiglockhart')) a
inner join (select r2.num, r2.company, r2.stop
		from route r
		join route r2 on r.company=r2.company AND r.num=r2.num
		WHERE r.stop=(SELECT id FROM stops WHERE name= 'Sighthill')) b 
on a.stop = b.stop
inner join stops on a.stop = stops.id



