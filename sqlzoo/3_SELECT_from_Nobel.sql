/*
nobel table
yr		subject		winner
1960	Chemistry	Willard F. Libby
1960	Literature	Saint-John Perse
1960	Medicine	Sir Frank Macfarlane Burnet
1960	Medicine	Peter Madawar
*/


---------  Q1  ----------
/*displays Nobel prizes for 1950.*/
select yr, subject, winner
from nobel
where yr = 1950



---------  Q2  ----------
/*Show who won the 1962 prize for Literature.*/
select winner
from nobel
where subject = 'Literature'
and yr = 1962



---------  Q3  ----------
/*Show the year and subject that won 'Albert Einstein' his prize.*/
select yr, subject
from nobel
where winner = 'Albert Einstein'



---------  Q4  ----------
/*Give the name of the 'Peace' winners since the year 2000, including 2000.*/
select winner
from nobel
where subject = 'Peace'
and yr >= 2000



---------  Q5  ----------
/*Show all details (yr, subject, winner) of the Literature prize 
winners for 1980 to 1989 inclusive*/
select yr, subject, winner
from nobel
where subject = 'Literature'
and yr >= 1980 and yr <= 1989


---------  Q6  ----------
/*
Show all details of the presidential winners:
Theodore Roosevelt
Woodrow Wilson
Jimmy Carter
*/
select yr, subject, winner
from nobel
where winner in ('Theodore Roosevelt','Woodrow Wilson','Jimmy Carter')



---------  Q7  ----------
/*Show the winners with first name John*/
select winner
from nobel
where winner like 'John%'



---------  Q8  ----------
/*Show the Physics winners for 1980 together with the Chemistry winners for 1984*/
select yr, subject, winner
from nobel
where (subject ='Physics' and yr = 1980) OR
(subject ='Chemistry' and yr = 1984)



---------  Q9  ----------
/*Show the winners for 1980 excluding the Chemistry and Medicine*/
select yr, subject, winner
from nobel
where yr = 1980
and subject not in ('Chemistry','Medicine')



---------  Q10  ----------
/*Show who won a 'Medicine' prize in an early year (before 1910, not including 1910) 
together with winners of a 'Literature' prize in a later year (after 2004, including 2004)*/
select yr, subject, winner
from nobel
where (subject ='Medicine' and yr < 1910) OR
(subject ='Literature' and yr >= 2004)



---------  Q12  ----------
/*Find all details of the prize won by EUGENE O'NEILL*/
select yr, subject, winner
from nobel
where winner = 'EUGENE O\'NEILL' --Escaping single quotes



---------  Q13  ----------
/*List the winners, year and subject where the winner starts with Sir. 
Show the the most recent first, then by name order.*/
select winner,yr, subject
from nobel
where winner like 'Sir%'
order by yr desc, winner



---------  Q14  ----------
/*The expression subject IN ('Chemistry','Physics') can be used as 
a value - it will be 0 or 1.

Show the 1984 winners and subject ordered by subject and winner name; 
but list Chemistry and Physics last.*/
select winner,subject
from nobel
where yr = 1984 
ORDER BY subject IN ('Chemistry', 'Physics'), subject, winner

















