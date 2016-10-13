-- JOIN
/*

Table: game
id		|mdate			|stadium					|team1	|team2
1001 	|8 June 2012	|National Stadium, Warsaw	|POL	|GRE
1002	|8 June 2012	|Stadion Miejski (Wroclaw)	|RUS	|CZE
1003	|12 June 2012	|Stadion Miejski (Wroclaw)	|GRE	|CZE
1004	|12 June 2012	|National Stadium, Warsaw	|POL	|RUS

Table: goal
matchid	|teamid	|player					|gtime
1001	|POL	|Robert Lewandowski		|17
1001	|GRE	|Dimitris Salpingidis	|51
1002	|RUS	|Alan Dzagoev			|15
1002	|RUS	|Roman Pavlyuchenko		|82

Table: eteam
id | teamname       | coach
POL| Poland     	| Franciszek Smuda
RUS| Russia     	| Dick Advocaat
CZE| Czech Republic | Michal Bilek
GRE| Greece     	| Fernando Santos
*/

---------- Q1 ----------
/*
Show the matchid and player name for all goals scored by Germany. 
To identify German players, check for: teamid = 'GER'
*/

select matchid, player
from goal
where teamid="GER"


---------- Q2 ----------
/*Show id, stadium, team1, team2 for just game 1012*/
select id, stadium, team1, team2
from game
where id=1012



---------- Q3 ----------
/*show the player, teamid, stadium and mdate and for every German goal*/
SELECT player,teamid,stadium,mdate
FROM game 
JOIN goal ON id=matchid and teamid="GER"



---------- Q4 ----------
/*Show the team1, team2 and player for every goal scored by a player 
called Mario player LIKE 'Mario%'*/

-- every goal scored by a player called Mario player LIKE 'Mario%'
from goal
where player like 'Mario%'

-- final code
SELECT team1,team2,player
FROM game 
JOIN goal ON id=matchid and player like 'Mario%'



---------- Q5 ----------
/*Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10*/
SELECT G.player, G.teamid, E.coach, G.gtime
FROM goal G
JOIN eteam E ON E.id = G.teamid and G.gtime <= 10



---------- Q6 ----------
/*List the the dates of the matches and the name of the team1 in which 'Fernando Santos'
was the coach.*/

-- get team with coach 'Fernando Santos'
select id
from eteam
where coach = 'Fernando Santos'

-- final code
SELECT distinct GA.mdate, E.teamname
FROM game GA
JOIN eteam E ON E.id = GA.team1
where GA.team1 = (select id
					from eteam
					where coach = 'Fernando Santos')



---------- Q7 ----------
/*List the player for every goal scored in a game where the stadium 
was 'National Stadium, Warsaw'*/

-- the stadium was 'National Stadium, Warsaw'
where GA.stadium = 'National Stadium, Warsaw'


-- Final code
select G.player
from game GA
JOIN goal G on GA.id = G.matchid
where GA.stadium = 'National Stadium, Warsaw'



---------- Q8 ----------
/*Show the name of all players who scored a goal against Germany.*/

-- scored a goal against Germany -> Germany in team1 or team2 but goal is not by German

-- Germany in team1 or team2: 
from game
where 'GER' in (team1, team2)

-- goal is not by Germany:
from goal G
where G.teamid != 'GER'

-- Final code
select distinct G.player
from game GA
JOIN goal G on GA.id = G.matchid
where 'GER' in (GA.team1, GA.team2)
and G.teamid != 'GER'



---------- Q9 ----------
/*Show teamname and the total number of goals scored.*/
select E.teamname,count(*)
from goal G
JOIN eteam E ON E.id = G.teamid
group by E.teamname




---------- Q10 ----------
/*Show the stadium and the number of goals scored in each stadium.*/
select GA.stadium,count(*)
from game GA
JOIN goal G ON GA.id = G.matchid
group by GA.stadium



---------- Q11 ----------
/*For every match involving 'POL', show the matchid, date and the number of goals scored.*/

-- every match involving 'POL'
from game GA
where 'POL' in (GA.team1, GA.team2)

-- Final code
select G.matchid, GA.mdate, count(G.matchid)
from game GA
JOIN goal G on GA.id = G.matchid
where 'POL' in (GA.team1, GA.team2)
group by G.matchid, GA.mdate



---------- Q12 ----------
/*For every match where 'GER' scored, show matchid, match date and 
the number of goals scored by 'GER'*/

--'GER' scored
from goal G
where G.teamid = 'GER'

--For every match where 'GER' scored
select G.matchid,GA.mdate, count(G.matchid)
from game GA
JOIN goal G on GA.id = G.matchid
where G.teamid = 'GER'
group by G.matchid, GA.mdate




---------- Q13 ----------
/*Write query to get following table

mdate			team1	score1	team2	score2
1 July 2012		ESP		4		ITA		0
10 June 2012	ESP		1		ITA		1
10 June 2012	IRL		1		CRO		3
*/

SELECT mdate,
team1,
sum(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1, 
-- goal level, each goal would have either score1 = 1 and score2 = 0 or other way flipped
team2,
sum(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
FROM game 
LEFT OUTER JOIN goal ON matchid = id -- left join since not every game has score(s)
group by matchid,mdate,team1,team2
order by mdate, matchid, team1,team2
