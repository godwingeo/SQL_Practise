select * from olympics_history;
select * from olympics_history_noc_regions;

--- 1. How many olympics games have been held?
--- Remove duplicates using Distinct key word
select Count(distinct games) as No_of_olympics_held from olympics_history;
--- 2. List down all Olympics games held so far
--- Two ways
select distinct oh.year,oh.season,oh.city
from olympics_history oh
order by year;

select year, season, city from olympics_history 
Group By year,season,city
ORDER BY year;

--- 3. Mention the total no of nations who participated in each olympics game?
with all_countries as 
 (select games, nr.region
			from olympics_history oh
			join olympics_history_noc_regions nr ON nr.noc = oh.noc
			group by games, nr.region)
select games, count(1) as total_countries
from all_countries
group by games
order by games;
--- 4.Which year saw the highest and lowest no of countries participating in olympics


      with all_countries as
              (select games, nr.region
              from olympics_history oh
              join olympics_history_noc_regions nr ON nr.noc=oh.noc
              group by games, nr.region),
          tot_countries as
              (select games, count(1) as total_countries
              from all_countries
              group by games)
--- Seggregrate and see how the below queries works --- this is just selection of minimum and
-- Maximum value
      select distinct
      concat(first_value(games) over(order by total_countries)
      , ' - '
      , first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
      concat(first_value(games) over(order by total_countries desc)
      , ' - '
      , first_value(total_countries) over(order by total_countries desc)) as Highest_Countries
      from tot_countries
      order by 1;
	  
---6.Idetify the sport which was played in all summer olympics
--- a.The first step is to identify the total no of games played in olympics
--- b.Find for each sport how many games where played in 
--- c. compare 1 and 2

with t1 as
(select COUNT(DISTINCT games) as total_summer_games  from olympics_history
 where season = 'Summer'),
t2 as
 (select DISTINCT sport, games from olympics_history where season = 'Summer' ORDER BY  games),
t3 as (
  Select sport, count(*) as no_of_games from t2 group by sport)

select * from t3 join t1 on t1.total_summer_games = t3.no_of_games;

--- 11. Top 5 athletes who has won Gold medal
with t1 as
(select name, COUNT(1) as no_of_medals from olympics_history where medal = 'Gold' group by name
order by no_of_medals desc),
t2 as 
(select *, dense_rank() over(order by no_of_medals desc) as rnk  from t1 )
select * from t2 where rnk <=5;

