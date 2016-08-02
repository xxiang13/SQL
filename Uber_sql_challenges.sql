# SQL questions from Uber Challenges by dustin@inferentialist.com
# https://blog.inferentialist.com/2015/10/03/uber-challenge.html

/*
The trips table

id	integer
client_id	integer (fk: users.usersid)
driver_id	integer (fk: users.usersid)
city_id	integer
client_rating	integer
driver_rating	integer
status	enum(‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’)
actual_eta	integer
request_at	date (I changed the variable: instead of timestamp, use date )
 
The users table

usersid	integer
email	character varying
signup_city_id	integer
banned	Boolean
role	Enum(‘client’, ‘driver’, ‘partner’)
created_at	timestamp with timezone
*/


/* Q1
(changed the question)
Between October 1, 2013 and Oct 22, 2013 , 
what percentage of requests made by unbanned clients each day were cancelled in each city?
*/


# numerator: #requests(unbanned clinets) -> cancelled/city
# denominator: #requets(unbanned clients)/city

# time zone? go with city itself? or one PDT? here assume not need timezone correction

# final table:
# day | city | rate



#get trips for unbanned clients and time bewteen provided date by using inner join

from
trips T
inner join users U on T.clinet_id = U.userid and U.banned = FALSE and
		   T.request_at between 10-01-2013 and 10-22-2013

# get num of requests by unbanned clinets -> cancelled

sum(case when status in ('cancelled_by_drive','cancelled_by_client') then 1 else 0 end)

# get total num of requets by unbanned clinets

/* NOTE: count(*) will consider the records with NULL status as not cancelled,
if not desired, then use count(status) to only coinsder records that have a status */

count(*) 

# use group by date, city to get the final table


######### final query ##########

select request_at, city_id, sum(case when 
								status in ('cancelled_by_drive','cancelled_by_client') 
								then 1 else 0 end)/count(*) as canellation_rate
from
trips T
inner join users U on T.clinet_id = U.userid and U.banned = FALSE and
		   T.request_at between 10-01-2013 and 10-22-2013
group by request_at, city_id


/* Q2
For city_ids 1,6, and 12, list the top three drivers by number of completed trips 
for each week between June 3, 2013 and June 24, 2013.
*/

/* final table
week | city_id | driver_id
1    | 1       | 11
1    | 1       | 12
1    | 1       | 13
2    | 6       | 14
2    | 6       | 23
2    | 6       | 33
*/

# clarify question: what there is a tie?  Here assume no tie exits

# first to seize down the table by using WHERE clause to constrain time 
# and status of trips = "completed" and cities

where request_at bewteen 06-03-2013 and 06-24-2013 and status = 'completed' and city_id in (1,6,12)

# to get driver id, inner join trips and users table and limit to role = 'driver'

from trips T
inner join users U on T.driver_id = u.userid and role='driver'

# create a temporary table, trips_driver_week, using WITH clause:
/*
week| driver_id| num_trips
1   | 11       | 1000
1   | 12       | 900
*/


# to get top 3 driver

# Method 1: 
# use correlated subquery on week to count(trips) group by driver_id and limie to top 3 
(select driver_id
from trips_driver_week
where week= T.week
order by num_trips desc limit 3)

-- Method 2: 
-- meet a condition: count number of drivers, which their num_trips > current num_trips,
-- should be less than 3
(select count(driver_id)
from trips_driver_week
where week = T.week and num_trips > A.num_trips) < 3

-- Method 3: rank() over 
-- use windows parition function and then filter by rank <=3
RANK() OVER (PARTITION BY city_id, week
			 ORDER BY num_trips
			 DESC) AS driver_rank


######### final query  ##########

with trips_driver_week AS (select extract(week from T.request_at) as week, driver_id, 
								  city_id, count(*) as num_trips
							from trips T
							inner join users U on T.driver_id = u.userid and role='driver'
							where request_at bewteen 06-03-2013 and 06-24-2013 
		  					and status = 'completed' 
		  					and city_id in (1,6,12)
							group by 1,2)
-- Method 1
select week, city_id, driver_id
from trips_driver_week T
where driver_id in (select driver_id
							from trips_driver_week
							where week = T.week and city_id = T.city_id
							order by num_trips desc limit 3)
order by week asc, num_trips desc

-- Method 2
select week, city_id, driver_id
from trips_driver_week T
where (select count(driver_id)
		from trips_driver_week
		where week = T.week and city_id = T.city_id
		and num_trips > A.num_trips) < 3
order by week asc, num_trips desc

-- Method 3: created 2nd temp. table: ranks, using 1st temp. table: trips_driver_week
ranks as (select week, city_id, driver_id,
						RANK() OVER (PARTITION BY city_id, week
									 ORDER BY num_trips
									 DESC) AS driver_rank
 				from trips_driver_week)

select week, city_id, driver_id
from ranks
where driver_rank <= 3
order by week asc, num_trips desc


