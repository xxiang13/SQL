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
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily 
mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also
present.

*/

----------- Q1 ----------- 
/*Find the names of all students who are friends with someone named Gabriel.*/

-- get the ID for who named Gabriel
select ID as G_ID
from Highschooler where name = 'Gabriel'

-- since friend relationship is mutual, so if there is ID1 = G_ID -> there is a ID2 = G_ID,
-- two pairs will be same but in different order

Select H.name
from Friend F
inner join Highschooler H on F.ID2 = H.ID
where F.ID1 in (select ID
			from Highschooler where name = 'Gabriel')


----------- Q2 ----------- 
/*For every student who likes someone 2 or more grades younger than themselves, 
return that student's name and grade, and the name and grade of the student they like*/

-- likes someone 2 or more grades younger -> grade for ID1 - grade for ID2 >= 2
-- join Highschooler and Likes to get ID1, ID2 grade first 
-- and use WHERE clause to select IDs meet the condition

select H1.name, H1.grade, H2.name, H2.grade
from Likes L
inner join Highschooler H1 on L.ID1 = H1.ID
inner join Highschooler H2 on L.ID2 = H2.ID
where H1.grade - H2.grade >= 2


----------- Q3 ----------- 
/*For every pair of students who both like each other, return the name and grade of both
students. Include each pair only once, with the two names in alphabetical order.*/

-- do self join two pair L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1 -> both like each other
-- return both 2 pairs
from Likes L1
inner join Likes L2 on L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1

-- use wWhere clause to limit name in a pair is alphabetically ordered -> dedupelicate pairs
where H1.name < H2.name 


-- Final code
select H1.name, H1.grade, H2.name, H2.grade
from Likes L1
inner join Likes L2 on L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1
inner join Highschooler H1 on L1.ID1 = H1.ID
inner join Highschooler H2 on L1.ID2 = H2.ID
where H1.name < H2.name 



----------- Q4 -----------
/*Find all students who do not appear in the Likes table (as a student who likes or is liked)
and return their names and grades. Sort by grade, then by name within each grade.*/

-- first find students who likes(showing as ID1 in Likes table)
select ID1 from Likes

-- then find students who are liked (showing as ID2 in Likes table)
select ID2 from Likes

-- Union the two result -> students who appear in the Likes table 
-- use results in subquery and Where clause to filter out these IDs
(select ID1 as ID from Likes
union
select ID2 as ID from Likes)

-- Final code
select name, grade
from Highschooler
where ID not in (select ID1 as ID from Likes
					union
					select ID2 as ID from Likes)
order by grade, name



----------- Q5 -----------
/*For every situation where student A likes student B, but we have no information about whom
B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names
and grades.*/

-- Clarify: ID1 = A, ID2 = B, but no ID1 = B in Likes table -> who are B?
-- first correalted subquery find how many ID1 in table is current pair ID2
-- limit the count = 0 -> B not appear as an ID1 in the Likes table
from Likes L
where (select count(*) from Likes where ID1 = L.ID2) = 0

-- Final code

select H1.name, H1.grade, H2.name, H2.grade
from Likes L
inner join Highschooler H1 on L.ID1 = H1.ID
inner join Highschooler H2 on L.ID2 = H2.ID
where (select count(*) from Likes where ID1 = L.ID2) = 0



----------- Q6 -----------
/*Find names and grades of students who only have friends in the same grade.
Return the result sorted by grade, then by name within each grade*/

-- first join Highschooler to get ID1 grade
from Friend F
inner join Highschooler H on F.ID1 = H.ID

-- then use correalted subquery to get all friends of current ID1 (ID2s)
-- and inner join Highschooler to get the grade of ID2
-- give condition grade of ID2 != ID1's, use NOT EXISTS to filter all these cases
from Friend F
inner join Highschooler H on F.ID1 = H.ID
where NOT EXISTS (select * from Friend F1
				  inner join Highschooler H1 on F1.ID1 = F.ID1 and 
				  F1.ID2 = H1.ID and H1.grade != H.grade)

-- Final code
select distinct H.name, H.grade
from Friend F
inner join Highschooler H on F.ID1 = H.ID
where NOT EXISTS (select * from Friend F1
				  inner join Highschooler H1 on F1.ID1 = F.ID1 and 
				  F1.ID2 = H1.ID and H1.grade != H.grade)
order by H.grade, H.name



----------- Q7 -----------
/*For each student A who likes a student B where the two are not friends, find if
they have a friend C in common (who can introduce them!). For all such trios, return 
the name and grade of A, B, and C*/

-- first find student A who likes a student B where the two are not friends
-- pair (A,B) in Likes table, but not in Friend table
from Likes 
where (ID1, ID2) not in (select ID1, ID2 from Friend)

-- join Friends tables to find connecting friend C bewteen A, B
from Likes L
inner join Friend F1 on L.ID1 = F1.ID1
inner join Friend F2 on L.ID2 = F2.ID1 and F1.ID2 = F2.ID2 -- connecting A, B

-- Final code
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Likes L
inner join Friend F1 on L.ID1 = F1.ID1
inner join Friend F2 on L.ID2 = F2.ID1 and F1.ID2 = F2.ID2
inner join Highschooler H1 on H1.ID = L.ID1
inner join Highschooler H2 on H2.ID = L.ID2
inner join Highschooler H3 on H3.ID = F2.ID2 -- connecting friend
where (ID1, ID2) not in (select ID1, ID2 from Friend) -- tuple In operator not work in SQLite
/* change to: where NOT EXISTS (select * from Friend where ID1 = L.ID1 and ID2 = L.ID2)
for SQLite*/



----------- Q8 -----------
/*Find the difference between the number of students in the school and 
the number of different first names.*/

select count(ID) - count(distinct name)
from Highschooler 



----------- Q9 -----------
/*Find the name and grade of all students who are liked by more than one other student.*/

-- use correlated subquery to link ID2 = current student -> be liked by someone
-- count how many cases, limit to larger than 1 -> liked by more than one other student
from Highschooler H
where (select count(*) from Likes where ID2 = H.ID) > 1

-- Final code
select H.name, H.grade
from Highschooler H
where (select count(*) from Likes where ID2 = H.ID) > 1





















