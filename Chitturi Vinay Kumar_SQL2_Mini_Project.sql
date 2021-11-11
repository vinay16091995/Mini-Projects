CREATE SCHEMA IF NOT EXISTS ICC_Test_Cricket;

use icc_test_cricket;

-- 1.Import the csv file to a table in the database.

select * from `ICC Test Batting Figures`;


-- 2.Remove the column 'Player Profile' from the table.

alter table `ICC Test Batting Figures` drop column `Player Profile`;

select * from `ICC Test Batting Figures`;


-- 3.Extract the country name and player names from the given data and store it in seperate columns for further usage.

create or replace view ICC_Test_Batting_Figures1 as
select *,substring_index(player,'(',1) as Player_Name,
if(replace(substring_index(player,'(',-1),')','') like '%/%', substring_index(replace(substring_index(player,'(',-1),')',''),'/',-1),replace(substring_index(player,'(',-1),')','') ) as Country_Name 
from `ICC Test Batting Figures`;

select * from ICC_Test_Batting_Figures1;


-- 4.From the column 'Span' extract the start_year and end_year and store them in seperate columns for further usage.

create or replace view ICC_Test_Batting_Figures2 as
select *,substring_index(span,'-',1) as start_year,substring_index(span,'-',-1) as end_year
from ICC_Test_Batting_Figures1;


select * from ICC_Test_Batting_Figures2;


-- 5.The column 'HS' has the highest score scored by the player so far in any given match. 
-- The column also has details if the player had completed the match in a NOT OUT status. 
-- Extract the data and store the highest runs and the NOT OUT status in different columns.

create or replace view ICC_Test_Batting_Figures3 as
select *,substring_index(HS,'*',1) as Highest_Runs, if(HS like '%*','not out','out') as Not_Out_Status
from ICC_Test_Batting_Figures2;


select * from ICC_Test_Batting_Figures3;


-- 6.Using the data given, considering the players who were active in the year of 2019, 
-- create a set of batting order of best 6 players using the selection criteria of those 
-- who have a good average score across all matches for India.

select row_number() over() Batting_order, Player_Name,Country_Name,Avg,start_year,end_year from ICC_Test_Batting_Figures3
where (start_year<=2019) and (end_year>=2019) and (Country_Name='INDIA')
order by Avg desc
limit 6;



-- 7.Using the data given, considering the players who were active in the year of 2019, 
-- create a set of batting order of best 6 players using the selection criteria of those 
-- who have highest number of 100s across all matches for India.

select row_number() over() Batting_order, Player_Name,Country_Name,`100`,start_year,end_year from ICC_Test_Batting_Figures3
where (start_year<=2019) and (end_year>=2019) and (Country_Name='INDIA')
order by `100` desc
limit 6;


-- 8.Using the data given, considering the players who were active in the year of 2019, 
-- create a set of batting order of best 6 players using 2 selection criterias of your own for India.

select row_number() over() Batting_order, Player_Name,Country_Name,Avg,`0`,start_year,end_year from ICC_Test_Batting_Figures3
where (start_year<=2019) and (end_year>=2019) and (Country_Name='INDIA') and (`0`<5)
order by Avg desc
limit 6;


-- 9.Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, 
-- considering the players who were active in the year of 2019, create a set of batting order 
-- of best 6 players using the selection criteria of those who have a good average score across all matches for South Africa.

create or replace view ‘Batting_Order_GoodAvgScorers_SA’ as
select row_number() over() Batting_order, Player_Name,Country_Name,Avg,start_year,end_year from ICC_Test_Batting_Figures3
where (start_year<=2019) and (end_year>=2019) and (Country_Name='SA')
order by Avg desc
limit 6;


select * from ‘Batting_Order_GoodAvgScorers_SA’;


-- 10.Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, 
-- considering the players who were active in the year of 2019, create a set of batting order 
-- of best 6 players using the selection criteria of those who have highest number of 100s across all matches for South Africa.

create or replace view ‘Batting_Order_HighestCenturyScorers_SA’ as
select row_number() over() Batting_order, Player_Name,Country_Name,`100`,start_year,end_year from ICC_Test_Batting_Figures3
where (start_year<=2019) and (end_year>=2019) and (Country_Name='SA')
order by `100` desc
limit 6;


select * from ‘Batting_Order_HighestCenturyScorers_SA’;


