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
	  
---5.Which nation has participated in all of the olympic games


