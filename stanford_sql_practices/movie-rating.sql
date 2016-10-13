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
/*Find the titles of all movies directed by Steven Spielberg.*/

select title
from Movie
where director == 'Steven Spielberg'


--------   Q2   --------
/*Find all years that have a movie that received a rating of 4 or 5, 
and sort them in increasing order. */

-- movies that received a rating of 4 or 5
select mID
from Rating
where stars in (4,5)

-- Final code
select distinct year
from Movie
where mID in (select mID
				from Rating
				where stars in (4,5))


--------   Q3   --------
/*Find the titles of all movies that have no ratings. */

-- Method 1
-- use left join to get no rating
select M.title
from Movie M
left join Rating R on M.mID = R.mID
where R.mID is null

-- Method 2
-- use subquery
select M.title
from Movie M
where M.mID not in (select mID from Rating)


--------   Q4   --------
/*Some reviewers didn't provide a date with their rating. 
Find the names of all reviewers who have ratings with a NULL value for the date. */

-- Method1: subquery
--subquery to get rID with a NULL value for the date
(select rID from Rating where ratingDate is NULL)

-- Final code
select name
from Reviewer
where rID in (select rID from Rating where ratingDate is NULL)

-- Method2: left join

select Rev.name
from Rating R
left join Reviewer Rev on R.rID = Rev.rID
where ratingDate is NULL


--------   Q5   --------
/*Write a query to return the ratings data in a more readable format: reviewer name, 
movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, 
then by movie title, and lastly by number of stars*/

-- join all tables
select Rev.name, M.title, R.stars, R.ratingDate
from Rating R
left join Movie M on R.mID = M.mID
left join Reviewer Rev on Rev.rID = R.rID
order by Rev.name, M.title, R.stars


--------   Q6   --------
/*For all cases where the same reviewer rated the same movie twice and gave it a higher
rating the second time, return the reviewer's name and the title of the movie.*/

--Clarify: a movie would have exactly max 2 reviews by a same person? or more than 2? 
--         Here we only consider extact 2 or at least 2?  -> 
-- user correletd subquery to get # of higher rating for each rating + other criterias,
-- and limit the # to be at least 1
from Rating R
where (select count(*) from Rating where rID = R.rID and mID = R.mID and stars > R.stars) = 1

-- Final code
select Rev.name, M.title
from Rating R
left join Movie M on R.mID = M.mID
left join Reviewer Rev on Rev.rID = R.rID
where (select count(*) from Rating 
		where rID = R.rID and mID = R.mID and 
		ratingDate > R.ratingDate and stars > R.stars) = 1


--------   Q7   --------
/*For each movie that has at least one rating, find the highest number of stars that
movie received. Return the movie title and number of stars. Sort by movie title. */

select M.title, max(R.stars)
from Rating R
inner join Movie M on R.mID = M.mID -- movies with no rating will be filtered out
group by M.title
order by M.title


--------   Q8   --------
/*For each movie, return the title and the 'rating spread', that is, the difference
between highest and lowest ratings given to that movie. Sort by rating spread from 
highest to lowest, then by movie title. */


select M.title, max(R.stars)-min(R.stars) as rating_spread
from Rating R
inner join Movie M on R.mID = M.mID -- movies with no rating will be filtered out
group by M.title
order by rating_spread desc



--------   Q9   --------
/*Find the difference between the average rating of movies released before 1980 
and the average rating of movies released after 1980. (Make sure to calculate the 
average rating for each movie, then the average of those averages for movies before 
1980 and movies after. Don't just calculate the overall average rating before and 
after 1980.) */

-- use subquery get average rating for each movie
(select R.mID, M.year, avg(R.stars) as avg_star
from Rating R
inner join Movie M on R.mID = M.mID
group by R.mID, M.year)

-- Final code
select avg(case when year < 1980 
			then avg_star else NULL end) - avg(case when year > 1980 
											then avg_star else NULL end) 
-- need to give null value for movie not meet criteria in case when, so when compute the avg
-- won't consider thoese movie, if give 0 value, it emlarged base population, bring down avg
from (select R.mID as mID, M.year as year, avg(R.stars) as avg_star
				from Rating R
				inner join Movie M on R.mID = M.mID
				group by R.mID, M.year)








