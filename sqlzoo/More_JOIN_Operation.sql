-- More JOIN operations

/*
Movie Database
This database features two entities (movies and actors) in a many-to-many relation. 
Each entity has its own table. A third table, casting , is used to link them. 
The relationship is many-to-many because each film features many actors and each actor 
has appeared in many films.


Table: movie
Field name	|Type		|Notes
id			|INTEGER	|An arbitrary unique identifier
title		|CHAR(70)	|The name of the film - usually in the language of the first release.
yr			|DECIMAL(4)	|Year of first release.
director	|INT		|A reference to the actor table.
budget		|INTEGER	|How much the movie cost to make (in a variety of currencies unfortunately).
gross		|INTEGER	|How much the movie made at the box office.

Example: movie
id		|title					|yr	    |director	|budget		|gross
10003	|"Crocodile" Dundee II	|1988	|38			|15800000	239606210
10004	|'Til There Was You		|1997	|49			|10000000	


Table: actor
Field name	|Type		|Notes
id			|INTEGER	|An arbitrary unique identifier
name		|CHAR(36)	|The name of the actor (the term actor is used to refer to both male and female thesps.)

Example: actor
id	|name
20	|Paul Hogan
50	|Jeanne Tripplehorn


Table: casting
Field name  | Type 		| Notes
movieid		| INTEGER	| A reference to the movie table.
actorid 	| INTEGER	| A reference to the actor table.
ord 		| INTEGER	| The ordinal position of the actor in the cast list. The star of the movie will have ord value 1 the co-star will have

Example: casting
movieid |actorid| ord
10003 	|20		| 4
10004 	|50		| 1
*/

--------------- Q1 ---------------
/*List the films where the yr is 1962 [Show id, title]*/
select id,title
from movie
where Year = 1962



--------------- Q2 ---------------
/*Give year of 'Citizen Kane'.*/
select yr
from movie
where title = 'Citizen Kane'



--------------- Q3 ---------------
/*List all of the Star Trek movies, include the id, title and yr 
(all of these movies include the words Star Trek in the title). Order results by year.*/

select id,title,yr
from movie
where title like '%Star Trek%' --all of these movies include the words Star Trek in the title
order by yr



--------------- Q4 ---------------
/*What are the titles of the films with id 11768, 11955, 21191*/
select title
from movie
where id in (11768, 11955, 21191)



--------------- Q5 ---------------
/*What id number does the actress 'Glenn Close' have?*/
select id
from actor
where name = 'Glenn Close'



--------------- Q6 ---------------
/*What is the id of the film 'Casablanca'*/
select id
from movie
where title='Casablanca'



--------------- Q7 ---------------
/*Obtain the cast list for 'Casablanca'.
what is a cast list? The cast list is the names of the actors who were in the movie.
Use movieid=11768, this is the value that you obtained in the previous question.*/
select A.name
from movie M
inner join casting C on M.id=C.movieid
inner join actor A on C.actorid=A.id 
where M.id=11768



--------------- Q8 ---------------
/*Obtain the cast list for the film 'Alien'*/
select A.name
from movie M
inner join casting C on M.id=C.movieid
inner join actor A on C.actorid=A.id
where M.title='Alien'



--------------- Q9 ---------------
/*List the films in which 'Harrison Ford' has appeared*/
select M.title
from movie M
inner join casting C on M.id=C.movieid 
inner join actor A on C.actorid=A.id
where A.name = 'Harrison Ford'



--------------- Q10 ---------------
/*List the films where 'Harrison Ford' has appeared - but not in the starring role. 
[Note: the ord field of casting gives the position of the actor. 
If ord=1 then this actor is in the starring role]*/
select M.title
from movie M
inner join casting C on M.id=C.movieid 
inner join actor A on C.actorid=A.id
where A.name = 'Harrison Ford' and C.ord != 1



--------------- Q11 ---------------
/*List the films together with the leading star for all 1962 films.*/
select M.title, A.name
from movie M
inner join casting C on M.id=C.movieid 
inner join actor A on C.actorid=A.id
where C.ord = 1 and M.yr=1962



--------------- Q12 ---------------
/*Which were the busiest years for 'John Travolta', show the year and the number of 
movies he made each year for any year in which he made more than 2 movies.*/
select M.yr, count(M.id)
from movie M
inner join casting C on M.id=C.movieid 
inner join actor A on C.actorid=A.id
where A.name = 'John Travolta'
group by M.yr
having count(M.id) > 2



--------------- Q13 ---------------
/*List the film title and the leading actor for all 
of the films 'Julie Andrews' played in.*/
select m.title, a.name
from movie m
inner join casting c on m.id=c.movieid and c.ord = 1
inner join actor a on c.actorid=a.id
where m.id in (select M.id
					from movie M
					inner join casting C on M.id=C.movieid 
					inner join actor A on C.actorid=A.id
					where A.name = 'Julie Andrews')



--------------- Q14 ---------------
/*Obtain a list, in alphabetical order, of actors who've had 
at least 30 starring roles.*/
select a.name
from casting c
inner join actor a on c.actorid=a.id
where c.ord = 1
group by a.id, a.name
having count(c.movieid) >= 30
order by a.name



--------------- Q15 ---------------
/*List the films released in the year 1978 ordered by the number 
of actors in the cast.*/
select M.title, count(C.actorid)
from movie M
inner join casting C on M.id=C.movieid 
where M.yr = 1978
group by M.id,M.title -- order by two, select only need to include one
order by count(C.actorid) desc



--------------- Q16 ---------------
/*List all the people who have worked with 'Art Garfunkel'.*/
select distinct a.name
from casting c
inner join actor a on c.actorid=a.id
where c.movieid in (select distinct C.movieid
					from casting C
					inner join actor A on C.actorid=A.id
					where A.name = 'Art Garfunkel')
and a.name != 'Art Garfunkel'










