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

