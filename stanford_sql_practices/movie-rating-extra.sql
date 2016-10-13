/*
a new movie-rating website, and collect data on reviewers' ratings of various movies.


Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain
ratingDate. 
*/

--------   Q1   --------
/*Find the names of all reviewers who rated Gone with the Wind.*/

select distinct Rev.name
from Rating R
left join Movie M on R.mID = M.mID
left join Reviewer Rev on R.rID = Rev.rID
where M.title = 'Gone with the Wind'


--------   Q2   --------
/*For any rating where the reviewer is the same as the director of the movie, 
return the reviewer name, movie title, and number of stars. */

select Rev.name, M.title, R.stars
from Rating R
inner join Movie M on R.mID = M.mID
inner join Reviewer Rev on R.rID = Rev.rID 
			and M.director = Rev.name -- join based on reviewer is the same as the director



--------   Q3   --------
/*Return all reviewer names and movie names together in a single list, alphabetized. 
(Sorting by the first name of the reviewer and first word in the title is fine; 
no need for special processing on last names or removing "The".)  */

-- soluton: UNION two results
select distinct title
from Movie
UNION
select distinct name
from Reviewer
order by name, title



--------   Q4   --------
/*Find the titles of all movies not reviewed by Chris Jackson.*/

-- subquery to find all movie reviewed by Chris Jackson
(select mID 
	from Rating R
	inner join Reviewer Rev on R.rID = Rev.rID
	where Rev.name = 'Chris Jackson')

-- use Where clause to filter these movies

select distinct M.title
from Movie M 
-- all movie not reviewed by 'Chris Jackson' also contains movie with no reviews!
-- shouldn't join Rating table to limit to all movie with reviews
where M.mID not in (select mID 
					from Rating R
					inner join Reviewer Rev on R.rID = Rev.rID
					where Rev.name = 'Chris Jackson')



--------   Q5   --------
/*For all pairs of reviewers such that both reviewers gave a rating to the same movie,
return the names of both reviewers. Eliminate duplicates, don't pair reviewers with 
themselves, and include each pair only once. For each pair, return the names in the 
pair in alphabetical order. */

-- use self join on same movie and give join condition that their rID different
select distinct Rev1.name, Rev2.name
from Rating R1
inner join Rating R2 on R1.mId = R2.mID and R1.rID != R2.rID
inner join Reviewer Rev1 on R1.rID = Rev1.rID
inner join Reviewer Rev2 on R2.rID = Rev2.rID
where Rev1.name < Rev2.name -- give condition only keep a pair names in alphabetical order



--------   Q6   --------
/*For each rating that is the lowest (fewest stars) currently in the database, 
return the reviewer name, movie title, and number of stars. */

-- use subquery the lowest star in the database

select Rev.name, M.title, R.stars
from Rating R
inner join Reviewer Rev on R.rID = Rev.rID
inner join Movie M on R.mID = M.mID
where stars = (select min(stars) from Rating)



--------   Q7   --------
/*List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order. */

select M.title, avg(R.stars) as avg_rating
from Rating R
inner join Movie M on R.mID = M.mID
group by R.mID, M.title
order by avg_rating desc, M.title -- order M.title with in each group of same average rating



--------   Q8   --------
/*Find the names of all reviewers who have contributed three or more ratings. 
(As an extra challenge, try writing the query without HAVING or without COUNT.) */

-- use correlative subquery to count how many reviews of the reviewer made, set the count > 3
from Rating R
where (select count(*) from Rating where rID = R.rID) >= 3

-- Final code
select distinct Rev.name
from Rating R
inner join Reviewer Rev on R.rID = Rev.rID 
where (select count(*) from Rating where rID = R.rID) >= 3




--------   Q9   --------
/*Some directors directed more than one movie. For all such directors, return the titles of
all movies directed by them, along with the director name. Sort by director name, 
then movie title. (As an extra challenge, try writing the query both with and without COUNT.)*/

-- Method 1: with count and having
-- use subquery get director who directed more than 1 movies -> Where clause to select them
select title,director
from Movie
where director in (select director from Movie group by director having count(*) > 1)
order by director, title

-- Method 2: without count, use self join
-- self inner join on same director but different movie (mID)
-- all movies left directed by a director who directed more than 1 movie

select M1.title, M1.director
from Movie M1
inner join Movie M2 on M1.director = M2.director and M1.mId != M2.mID
order by M1.director, M1.title

--Method3: use Exist + correlated subquery
select title,director
from Movie M
where Exist (select 1 from Movie where director = M.director and mID != M.mID)
order by director, title



--------   Q10   --------
/*Find the movie(s) with the highest average rating. Return the movie title(s) and average 
rating. (Hint: This query is more difficult to write in SQLite than other systems; 
you might think of it as finding the highest average rating and then choosing the movie(s)
with that average rating.) */

-- use subquery get avg rating for each movie first
(select avg(stars) from Rating group by mID)

-- Final code
select M.title, avg(stars)
from Rating R
inner join Movie M on R.mID = M.mID
group by M.mID, M.title
having avg(stars) >= all (select avg(stars) as avg_rating from Rating group by mID)
-- use Having clause to select avg rating is highest



--------   Q11   --------
/*Find the movie(s) with the lowest average rating. Return the movie title(s) and average
rating. (Hint: This query may be more difficult to write in SQLite than other systems;
you might think of it as finding the lowest average rating and then choosing the movie(s)
with that average rating.)*/

-- same as Q10
select M.title, avg(stars)
from Rating R
inner join Movie M on R.mID = M.mID
group by M.mID, M.title
having avg(stars) <= all (select avg(stars) as avg_rating from Rating group by mID)



--------   Q12   --------
/*For each director, return the director's name together with the title(s) of the movie(s) 
they directed that received the highest rating among all of their movies, and the value of
that rating. Ignore movies whose director is NULL. */

-- use correlated subquery to get highest rate for all movie of each director
from Movie M
(select max(A.stars) from Rating A, Movie B
						where A.mID = B.mID and B.director = M.director)


-- Final code
select distinct M.director, M.title, R.stars
from Rating R
inner join Movie M on R.mId = M.mID
where R.stars = (select max(A.stars) from Rating A, Movie B -- inner join two table and also correalted query
						where A.mID = B.mID and B.director = M.director)






