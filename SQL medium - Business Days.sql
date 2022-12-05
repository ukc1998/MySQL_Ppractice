create table tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);

insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');
create table holidays
(
holiday_date date
,reason varchar(100)
);

insert into holidays values
('2022-08-11','Raksha Bandhan'),('2022-08-15','Independence day');

### Write a SQL to find out business days between create date and resolve date 
-- excluding weekends and public holidays.

SELECT * FROM tickets
SELECT * FROM holidays

/* 
2022-08-01 Monday					2022-08-03 Wednesday
2022-08-01 Monday					2022-08-12 Friday
2022-08-01 Monday					2022-08-16 Tuesday
*/

SELECT 
*,
DATEDIFF(resolved_date,create_date) + 1 as actual_days,
WEEK(create_date),
WEEK(resolved_date),
WEEK(resolved_date) - WEEK(create_date) AS week_diff
from tickets

SELECT 
*,
DATEDIFF(resolved_date,create_date) + 1 as actual_days,
WEEK(resolved_date) - WEEK(create_date) AS week_diff,
DATEDIFF(resolved_date,create_date) + 1 - 2*(WEEK(resolved_date) - WEEK(create_date)) as business_days_including_holidays
from tickets

SELECT * 
FROM tickets as t
LEFT JOIN
holidays as h
ON
holiday_date between create_date and resolved_date
ORDER BY holiday_date



SELECT * 
FROM tickets
LEFT JOIN
holidays
ON
holiday_date between create_date and resolved_date
ORDER BY holiday_date


SELECT ticket_id, 
create_date, 
resolved_date,
COUNT(holiday_date) as no_of_holidays
FROM
tickets LEFT JOIN holidays
ON
holiday_date between create_date and resolved_date
GROUP BY ticket_id, create_date, resolved_date

 
-- ab upar waale table ko subquery k form me use karenge

SELECT 
*,
DATEDIFF(resolved_date,create_date) + 1 as actual_days,
WEEK(resolved_date) - WEEK(create_date) AS week_diff,
DATEDIFF(resolved_date,create_date) + 1 - 2*(WEEK(resolved_date) - WEEK(create_date)) as business_days_including_holidays
FROM
(SELECT ticket_id, 
create_date, 
resolved_date,
COUNT(holiday_date) as no_of_holidays
FROM
tickets LEFT JOIN holidays
ON
holiday_date between create_date and resolved_date
GROUP BY ticket_id, create_date, resolved_date) subquery

SELECT 
*,
DATEDIFF(resolved_date,create_date) + 1 as actual_days,
WEEK(resolved_date) - WEEK(create_date) AS week_diff,
DATEDIFF(resolved_date,create_date) + 1 - 2*(WEEK(resolved_date) - WEEK(create_date)) as business_days_including_holidays,
DATEDIFF(resolved_date,create_date) + 1 
- 2*(WEEK(resolved_date) - WEEK(create_date)) 
- no_of_holidays as REQUIRED_BUSINESS_DAYS
FROM
(SELECT ticket_id, 
create_date, 
resolved_date,
COUNT(holiday_date) as no_of_holidays
FROM
tickets LEFT JOIN holidays
ON
holiday_date between create_date and resolved_date
GROUP BY ticket_id, create_date, resolved_date) subquery