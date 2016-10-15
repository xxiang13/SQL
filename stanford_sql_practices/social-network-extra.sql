/*
Students at your hometown high school have decided to organize their social network using
databases. So far, they have collected information about sixteen students in four grades,
9-12. Here's the schema: 

Highschooler ( ID, name, grade ) 
English: There is a high school student with unique ID and a given first name in a certain
grade. 

Friend ( ID1, ID2 ) 
English: The student with ID1 is friends with the student with ID2. Friendship is mutual,
so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. 
Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, 
there is no guarantee that (456, 123) is also present.
*/

-------- Q1 --------
/*For every situation where student A likes student B, but student B likes a different 
student C, return the names and grades of A, B, and C. */

-- self join Likes table, let L1.ID2 = L2.ID1 = B and L2.ID2 != A

select H1.name as A, H1.grade, H2.name as B, H2.grade, H3.name as C, H3.grade
from Likes L1
inner join Likes L2 on L1.ID2 = L2.ID1 and L2.ID2 != L1.ID1
inner join Highschooler H1 on H1.ID = L1.ID1
inner join Highschooler H2 on H2.ID = L1.ID2
inner join Highschooler H3 on H3.ID = L2.ID2



-------- Q2 --------
/*Find those students for whom all of their friends are in different grades from themselves. 
Return the students' names and grades.*/

-- first, get grade for current ID1 in Friends table
from Likes L
inner join Highschooler H on H.ID = L.ID1

-- use correlted subquery to get all friends (ID2) of the current student
-- and limit thier grade = ID's 
-- use WHERE + NOT EXISTS to filter out these ID1 
-- since all friends in different grades -> no friend in same grade
from Likes L
inner join Highschooler H1 on H1.ID = L.ID1
where NOT EXIST (select * from Likes L1
				 inner join Highschooler H2 on L1.ID2 = H2.ID and H2.grade = H1.grade
				 where ID1 = L.ID1)

-- Final code
select distinct H1.name, H1.grade
from Friend L
inner join Highschooler H1 on H1.ID = L.ID1
where NOT EXISTS (select * from Friend L1
				 inner join Highschooler H2 on L1.ID2 = H2.ID and H2.grade = H1.grade
				 -- get ID2 grade
				 where L1.ID1 = L.ID1)



-------- Q3 --------
/*What is the average number of friends per student? (Your result should be just one number.)*/

-- clarify: how to compute the average? sum(#friends of each student)/#student

-- first, use subquery to get # friends of each student
(select ID1, count(*) as avg_friends
from Friend
group by ID1)

-- Final code
select sum(avg_friends)/count(ID1)
from (select ID1, count(*) as avg_friends
      from Friend
      group by ID1)



-------- Q4 --------
/*Find the number of students who are either friends with Cassandra or are friends of 
friends of Cassandra. Do not count Cassandra, even though technically she is 
a friend of a friend*/

-- get friends of Cassandra
(select ID2 as ID
from Friend F
inner join Highschooler H on F.ID1 = H.ID
where H.name = 'Cassandra') as DF

-- use above result to get friends of friends of Cassandra
inner join Friend F2 on F2.ID1 = DF.ID


-- Final code
select count(distinct DF.ID) + sum(case when H2.name != 'Cassandra' then 1 else 0 end)
								-- use case when get total number excluding Cassandra
from (select ID2 as ID
			from Friend F
			inner join Highschooler H on F.ID1 = H.ID
			where H.name = 'Cassandra') as DF -- Cassandra's friends
inner join Friend F2 on F2.ID1 = DF.ID -- links friends of Cassandra's friends
inner join Highschooler H2 on F2.ID2 = H2.ID



-------- Q5 --------
/*Find the name and grade of the student(s) with the greatest number of friends. */

-- find number of friends of each student
select count(ID1) as num_friend
from Friend
group by ID1

-- get students who have max number of friends
select H.name, H.grade
from Friend F
inner join Highschooler H on F.ID1 = H.ID
group by ID1
having count(*) >= all (select count(ID1) as num_friend -- >= all() to get the maximum number
				   		from Friend
    			   		group by ID1)





