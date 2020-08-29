 --1.Select all columns from the first 10 rows. What columns does the table have?

 select * from survey limit 10;

 --2.What is the number of responses for each question?

 select question,
 count(distinct user_id) as 'users'
 from survey
 group by question;

 --3. calculating the conversion rate
 with jtable as
 ( select distinct q.user_id,
  h.user_id is not null as 'is_home_try_on',
  h.number_of_pairs, 
  p.user_id is not null as 'is_purchase'
  from quiz 'q' 
  left join home_try_on 'h' on h.user_id= q.user_id
  left join purchase 'p' on p.user_id= q.user_id)

  select round(1.0 * sum(is_purchase)/count(user_id),2) as overall_cr from jtable;

------------------ HOME TRY - ON FUNNEL:

----------- 4.
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

with conversion_table as 
(
  select distinct q.user_id,
  h.user_id is not null as 'is_home_try_on',
  h.number_of_pairs,
  p.user_id is not null as 'is_purchase'
  from quiz as 'q'
  left join home_try_on as 'h'
    on h.user_id = q.user_id
  left join purchase as 'p'
    on p.user_id = q.user_id
)
select number_of_pairs,
round(100.0*sum(is_purchase)/count(user_id),2)as 'overall_cr'
from conversion_table
where number_of_pairs is not null
group by number_of_pairs;

-- purchase rate by 'style'

with purchased_styles as(
  select distinct q.style,
  count(q.user_id) as 'users'
  from quiz as 'q'
  left join purchase as 'p'
    on p.user_id = q.user_id
  where p.user_id IS NOT NULL
  group by 1
),
all_styles as(
  select distinct q.style,
  count(q.user_id)as 'users'
  from quiz as 'q'
  left join purchase as 'p'
    on p.user_id = q.user_id
  group by 1
)

select all_styles.style,
all_styles.users,
purchased_styles.users as 'purchased_users',
round(100.0*purchased_styles.users/all_styles.users,2)as'conversional_rate'
from purchased_styles
left join all_styles
  on all_styles.style = purchased_styles.style;

-------5.

select q.user_id,
case 
  when h.user_id is not null then 'True'
  else 'False'
  End as 'is_home_try_on',
  h.number_of_pairs,
case
  when p.user_id is not null then 'True'
  else 'False'
  end as 'is_purchase'
from quiz as 'q'
left join home_try_on as 'h'
  on h.user_id = q.user_id
left join purchase as 'p'
  on p.user_id = h.user_id
limit 10;

--------6. Overall conversion Rates:-

--- purchase funnel :-
WITH funnel AS (SELECT q.user_id AS 'quiz',
       h.address IS NOT NULL AS 'is_home_try_on',
       h.number_of_pairs,
       p.product_id IS NOT NULL AS 'is_purchase'
FROM quiz AS q
LEFT JOIN home_try_on AS h 
ON q.user_id = h.user_id
LEFT JOIN purchase AS p 
ON h.user_id = p.user_id
)
SELECT COUNT(quiz) AS 'quiz_num',
       SUM(is_home_try_on) AS 'home_try_num',
       SUM(is_purchase) AS 'purchase_num'
FROM funnel;

-- We can compare conversion from 
--quiz to home_try_on and home_try_on to purchase :-

with funnel as (
  select q.user_id as 'quiz',
  h.address is not null as 'is_home_try_on',
  h.number_of_pairs,
  p.product_id is not null as'is_purchase'
  from quiz as 'q'
  left join home_try_on as 'h'
    on h.user_id = q.user_id
  left join purchase as 'p'
    on p.user_id = h.user_id
)
select 1.0 * sum(is_home_try_on)/count(quiz) as 'try_on_conv',
1.0 *sum(is_purchase)/sum(is_home_try_on) as 'purchase_conv'
from funnel;

---We can calculate the difference in purchase rates between customers who had 3 number_of_pairs with ones who had 5.

with funnel as (
  select q.user_id as 'quiz',
  h.address is not null as 'is_home_try_on',
  h.number_of_pairs as 'number_of_pairs',
  p.product_id is not null as 'is_purchase'
from quiz as 'q'
left join home_try_on as 'h'
  on h.user_id = q.user_id
left join purchase as 'p'
  on p.user_id = h.user_id
)
select number_of_pairs,
round(1.0 * sum(is_purchase)/sum(is_home_try_on),2) as'purchase_conv'
from funnel
where number_of_pairs is not null
group by number_of_pairs;


----- TRENDS :- MORE COMMON STYLES:--

--THE most common results of the style quiz

select style, count(user_id) 'style_browsed'
from quiz
group by style
order by 2 desc;

-- The most common types of purchase made 
select style,
count(user_id) as 'purchases_made'
from purchase
group by style
order by 2 desc;

