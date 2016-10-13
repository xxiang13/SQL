-- Numeric example
/*
National Student Survey 2012

Table: nss
Field					Type
ukprn					varchar(8)
institution				varchar(100)
subject					varchar(60)
level					varchar(50)
question				varchar(10)
A_STRONGLY_DISAGREE		int(11)
A_DISAGREE				int(11)
A_NEUTRAL				int(11)
A_AGREE					int(11)
A_STRONGLY_AGREE		int(11)
A_NA					int(11)
CI_MIN					int(11)
score					int(11)
CI_MAX					int(11)
response				int(11)
sample					int(11)
aggregate				char(1)

The table nss has one row per institution, subject and question.
*/

--------- Q1 ----------
/*
The example shows the number who responded for:
question 1
at 'Edinburgh Napier University'
studying '(8) Computer Science'

Show the the percentage who STRONGLY AGREE
*/
SELECT A_STRONGLY_AGREE
  FROM nss
 WHERE question='Q01'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'



--------- Q2 ----------
/*Show the institution and subject where the score is at least 100 for question 15.*/
select institution,subject
from nss
where score >= 100 and question='Q15'



--------- Q3 ----------
/*Show the institution and score where the score for '(8) Computer Science' is 
less than 50 for question 'Q15'*/
select institution, score
from nss
where score < 50 and question = 'Q15' and subject = '(8) Computer Science'



--------- Q4 ----------
/*Show the subject and total number of students who responded to question 22 for
 each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.*/
select subject, sum(response)
from nss
where question = 'Q22' 
and subject in ('(8) Computer Science','(H) Creative Arts and Design' )
group by subject



--------- Q5 ----------
/*Show the subject and total number of students who A_STRONGLY_AGREE to question 22 
for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.*/

select subject, sum(A_STRONGLY_AGREE*response/100)
from nss
where question = 'Q22' 
and subject in ('(8) Computer Science','(H) Creative Arts and Design' )
group by subject



--------- Q6 ----------
/*Show the percentage of students who A_STRONGLY_AGREE to question 22 for the subject 
'(8) Computer Science' show the same figure for the subject '(H) Creative Arts and Design'.
Use the ROUND function to show the percentage without decimal places.*/
select subject, 
round(sum(A_STRONGLY_AGREE*response)/sum(response)) -- A_STRONGLY_AGREE*response process before group by
from nss
where question = 'Q22' 
and subject in ('(8) Computer Science','(H) Creative Arts and Design' )
group by subject



--------- Q7 ----------
/*Show the average scores for question 'Q22' for each institution that 
include 'Manchester' in the name.

The column score is a percentage - you must use the method outlined above to 
multiply the percentage by the response and divide by the total response. Give
your answer rounded to the nearest whole number.*/

select institution, round(sum(score*response)/sum(response))
from nss
where question='Q22' and institution like '%Manchester%'
group by institution



--------- Q8 ----------
/*Show the institution, the total sample size and the number of 
computing students for institutions in Manchester for 'Q01'.*/
select institution, sum(sample)
,sum(case when subject = '(8) Computer Science' then sample else 0 end)
from nss
where question='Q01' and institution like '%Manchester%'
group by institution



