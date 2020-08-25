--The dataset used for this project :- 
https://drive.google.com/file/d/1rydAepWim_Pi0Krh1-RoJjJjDKwc4Gpv/view 


--1. How many distinct zip codes are in this dataset?

select count(distinct zip_code) from home_value_data;

--2. How many zip codes are from each state?

select state,
count(DISTINCT zip_code) AS 'No of Zip Codes' from home_value_data
GROUP by state;

-- OR

select state,count(zip_code)from home_value_data GROUP by 1;

--3. What range of years are represented in the data?

    --Hint: The date column is in the format yyyy-mm. Try taking a look at using the substr() function to help extract just the year.

select min(substr(date,1,4)) as 'starting year',
max(substr(date,1,4)) as 'ending year'
from home_value_data;


-- 4.Using the most recent month of data available, what is the range of estimated home values across the nation?

select date , value from home_value_data where date = (select max(date) from home_value_data);


-- ** Analysis: Explore how home value differ by region as well as change over time.


-- 5.Using the most recent month of data available, which states have the highest average home values? How about the lowest?

select state,
round(avg(value),0) as 'Average Value' from home_value_data
where date = (SELECT max(date) from home_value_data) group by 1 ORDER by 2 ASC;

-- 6. Using the most recent month of data available, what is the range of estimated home values across the nation?

select distinct state, min(value) ||'-'|| max(value) as 'Value Range'
from home_value_data WHERE date = (select max(date) from home_value_data) GROUP by 1;

-- 7 .Which states have the highest/lowest average home values for the year of 2017? What about for the year of 2007? 1997?

select substr(date,1,4) as 'DATE',state, round(avg(value),2) as 'Avg_Value' from home_value_data
WHERE substr(date,1,4)='2017' GROUP by state order by round(avg(value),2) desc;

select substr(date,1,4) as 'DATE',state, round(avg(value),2) as 'Avg_Value' from home_value_data 
WHERE substr(date,1,4)='2007' GROUP by state order by round(avg(value),2) Desc;

select substr(date,1,4) as 'DATE',state, round(avg(value),2) as 'AVG_VALUE' from home_value_data 
WHERE substr(date,1,4)='1997' GROUP by state order by round(avg(value),2) DESC;


-- ** Intermediate Problems:--

-- 8. What is the percent change 59 in average home values from 2007 to 2017 by state?


with baseyear as (Select home_value_data.state,substr(date,1,4),round(avg(value),2) 'average'
from home_value_data
where substr(date,1,4)='2007'
GROUP by home_value_data.state),endyear as (SELECT home_value_data.state,substr(date,1,4),round(Avg(value),2)'average'
from home_value_data
where substr(date,1,4)='2017'
GROUP by home_value_data.state)

SELECT baseyear.state,baseyear.average 'Base_avg',endyear.average 'End_avg',(endyear.average- baseyear.average)/baseyear.average * 100 'Percent_change'
from baseyear
join endyear on baseyear.state = endyear.state;


-- 9. How would you describe the trend in home values for each state from 2007 to 2017?

select substr(date,1,4) 'Year',state, round(Avg(value),2) as 'avg_value'
from home_value_data
where substr(date,1,4) between '2007' and '2017'
GROUP by substr(date,1,4),state;
