-- Using Null

/*
Sometimes NULL values are given in tables, this might be because the data is unknown or is inappropriate. 
In the Parliament database a NULL value for party in the MSP table indicates that the MSP concerned
is not a member of any of the parties. In the party table a NULL value is used where the party does
not have an official leader - or I couldn't find one. I rather like it that the Greens and the
Scottish Socialist Party don't seem to have leaders - and it suits my purposes.

We can use the phrase IS NULL to pick out fields. We can use IS NOT NULL similarly.


teacher
id	|dept	|	name		phone	mobile
101	|1		| Shrivell 	|	2753	07986 555 1234
102	|1		| Throd		|	2754	07122 555 1920
103	|1		| Splint	|	2293	
104	|		| Spiregrain|	3287	
105	|2		| Cutflower	|	3212	07996 555 6574
106	|		| Deadyawn	|	3345	


dept
id	| name
1	| Computing
2	| Design
3	| Engineering
*/

----------- Q1 -----------
/*List the teachers who have NULL for their department.*/
select name from teacher where dept is Null



----------- Q2 -----------
/*Note the INNER JOIN misses the teachers with no department 
and the departments with no teacher.*/
SELECT teacher.name, dept.name
 FROM teacher INNER JOIN dept
           ON (teacher.dept=dept.id)



----------- Q3 -----------
/*Use a different JOIN so that all teachers are listed.*/
SELECT teacher.name, dept.name
 FROM teacher left JOIN dept
           ON (teacher.dept=dept.id)



----------- Q4 -----------
/*Use a different JOIN so that all departments are listed.*/
SELECT teacher.name, dept.name
 FROM teacher right JOIN dept
           ON (teacher.dept=dept.id)



----------- Q5 -----------
 /*Use COALESCE to print the mobile number. Use the number '07986 444 2266' 
 if there is no number given. Show teacher name and mobile number or '07986 444 2266'*/
select name, COALESCE(mobile,'07986 444 2266')
from teacher



----------- Q6 -----------
/*Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. 
Use the string 'None' where there is no department.*/
select t.name, COALESCE(d.name,'None')
from teacher t
left join dept d on t.dept = d.id



----------- Q7 -----------
/*Use COUNT to show the number of teachers and the number of mobile phones.*/
select count(name), count(mobile)
from teacher



----------- Q8 -----------
/*Use COUNT and GROUP BY dept.name to show each department and the number of staff. 
Use a RIGHT JOIN to ensure that the Engineering department is listed.*/

select d.name, count(t.name)
from teacher t
right join dept d on t.dept = d.id
group by d.name



----------- Q9 -----------
/*Use CASE to show the name of each teacher followed by 'Sci' if the teacher is
 in dept 1 or 2 and 'Art' otherwise.*/

select t.name, case when d.id in (1,2) then "Sci" else "Art" end
from teacher t
left join dept d on t.dept = d.id



----------- Q10 -----------
/*Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, 
show 'Art' if the teacher's dept is 3 and 'None' otherwise.*/
select t.name, case when d.id in (1,2) then "Sci" 
					when d.id = 3 then "Art" 
					else 'None' end
from teacher t
left join dept d on t.dept = d.id



