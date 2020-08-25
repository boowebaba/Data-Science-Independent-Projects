<?xml version="1.0" encoding="UTF-8"?><sqlb_project><db path="D:/SQLite/project home value trends/Home value trends.db" readonly="0" foreign_keys="1" case_sensitive_like="0" temp_store="0" wal_autocheckpoint="1000" synchronous="2"/><attached/><window><main_tabs open="structure browser pragmas query" current="3"/></window><tab_structure><column_width id="0" width="300"/><column_width id="1" width="0"/><column_width id="2" width="125"/><column_width id="3" width="953"/><column_width id="4" width="0"/><expanded_item id="0" parent="1"/><expanded_item id="1" parent="1"/><expanded_item id="2" parent="1"/><expanded_item id="3" parent="1"/></tab_structure><tab_browse><current_table name="4,15:mainhome_value_data"/><default_encoding codec=""/><browse_table_settings><table schema="main" name="home_value_data" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="87"/><column index="2" value="65"/><column index="3" value="53"/><column index="4" value="276"/><column index="5" value="117"/><column index="6" value="67"/><column index="7" value="70"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table></browse_table_settings></tab_browse><tab_sql><sql name="SQL 1">--1. How many distinct zip codes are in this dataset?

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
GROUP by substr(date,1,4),state;</sql><current_tab id="0"/></tab_sql></sqlb_project>
