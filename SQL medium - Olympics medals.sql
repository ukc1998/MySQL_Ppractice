CREATE TABLE events (
ID int,
event varchar(255),
YEAR INt,
GOLD varchar(255),
SILVER varchar(255),
BRONZE varchar(255)
);

INSERT INTO events VALUES (1,'100m',2016, 'Amthhew Mcgarray','donald','barbara');
INSERT INTO events VALUES (2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith');
INSERT INTO events VALUES (3,'500m',2016, 'Charles','Nichole','Susana');
INSERT INTO events VALUES (4,'100m',2016, 'Ronald','maria','paula');
INSERT INTO events VALUES (5,'200m',2016, 'Alfred','carol','Steven');
INSERT INTO events VALUES (6,'500m',2016, 'Nichole','Alfred','Brandon');
INSERT INTO events VALUES (7,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (8,'200m',2016, 'Thomas','Dawn','catherine');
INSERT INTO events VALUES (9,'500m',2016, 'Thomas','Dennis','paula');
INSERT INTO events VALUES (10,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (11,'200m',2016, 'jessica','Donald','Stefeney');
INSERT INTO events VALUES (12,'500m',2016,'Thomas','Steven','Catherine');

SELECT * FROM events

#Q1 write query to find no of gold medals per swimmer for swimmers who won gold medals

SELECT gold as Swimmer, COUNT(*) as Number_Of_Golds 
FROM events 
GROUP by gold;

#Q2 write query to find no of gold medals per swimmer for swimmers who won only gold medals

-- Method 1

SELECT gold as Swimmer, COUNT(*) as Number_Of_Golds 
FROM events
WHERE gold NOT IN (SELECT silver FROM events UNION ALL SELECT bronze from events)
GROUP by gold;

-- Method 2

with cte as (
SELECT gold AS Swimmer, 'gold' AS medal_type from events
UNION ALL SELECT silver AS Swimmer, 'silver' AS medal_type from events
UNION ALL SELECT bronze AS Swimmer, 'bronze' AS medal_type from events)
select Swimmer, count(1) AS No_Of_Gold
FROM cte
GROUP BY swimmer
HAVING COUNT(distinct medal_type) = 1 and MIN(medal_type) = 'gold'