create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;


## Question - Make an output table with the help of input table. 
-- output table should have Team name, matches palyed, No of wins and losses.alter

select team_1 as team_name, case when team_1 = winner then 1 else 0 end as win_flag from icc_world_cup
union all
select team_2 as team_name, case when team_2 = winner then 1 else 0 end as win_flag from icc_world_cup


select team_name,
count(*) as no_of_matches_played,
sum(win_flag) as no_of_matches_won,
count(*) - sum(win_flag) as no_of_matches_lost
from
(select team_1 as team_name, case when team_1 = winner then 1 else 0 end as win_flag from icc_world_cup
union all
select team_2 as team_name, case when team_2 = winner then 1 else 0 end as win_flag from icc_world_cup) subquery
group by team_name
order by no_of_matches_won desc, no_of_matches_lost asc, team_name;