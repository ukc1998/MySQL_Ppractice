create table hospital ( emp_id int
, action varchar(10)
, time datetime);

insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');

SELECT * FROM hospital

### Write a SQL to find number of people present inside the hospital
/*
CASE WHEN Syntax:

SELECT column1,
             column2,
               CASE WHEN condition THEN 'Value1'
               ELSE 'Value2' END AS columnX
  FROM Cars
*/
-- Method 1


SELECT *
, case when action = 'in' then time end as intime
, case when action = 'out' then time end as outtime
FROM hospital



SELECT emp_id
, max(case when action = 'in' then time end) as intime
, max(case when action = 'out' then time end) as outtime
FROM hospital
GROUP BY emp_id


with cte as (
SELECT emp_id
, max(case when action = 'in' then time end) as intime
, max(case when action = 'out' then time end) as outtime
FROM hospital
GROUP BY emp_id
)
SELECT * FROM cte WHERE INTIME > OUTTIME OR OUTTIME IS NULL


-- MethoD 2


SELECT emp_id
, max(case when action = 'in' then time end) as intime
, max(case when action = 'out' then time end) as outtime
FROM hospital
GROUP BY emp_id
HAVING max(case when action = 'in' then time end) > 
max(case when action = 'out' then time end)
OR max(case when action = 'out' then time end) IS NULL


-- method 3

With
cte1 as (
select emp_id, max(time) as latest_in_time
from hospital
where action = 'in'
group by emp_id), 
cte2 as (
select emp_id, max(time) as latest_out_time
from hospital
where action = 'out'
group by emp_id)
SELECT * FROM cte1 LEFT JOIN cte2 on cte1.emp_id = cte2.emp_id
WHERE latest_in_time > latest_out_time or latest_out_time IS NULL

-- Method 4

with latest_time as 
(select emp_id, max(time) as max_latest_time from hospital group by emp_id)
, latest_in_time as (select emp_id, max(time) as max_latest_in_time from hospital where action = 'in' group by emp_id)
SELECT * FROM latest_time lt INNER JOIN latest_in_time lit ON lt.emp_id = lit.emp_id AND max_latest_time = max_latest_in_time


WITH CTE AS (
SELECT *,
  RANK() OVER (PARTITION BY emp_id ORDER BY time DESC) rnk
FROM hospital 
)

SELECT *
FROM CTE
WHERE rnk=1
AND action='in'
