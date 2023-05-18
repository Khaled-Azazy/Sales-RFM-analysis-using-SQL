select  cust_id, CALENDAR_Dt, prev_Date , (to_Date(CALENDAR_Dt,'yyyy-mm-dd')- to_Date(prev_date,'yyyy-mm-dd')) as diff, 
 row_number() over(order by (to_Date(CALENDAR_Dt,'yyyy-mm-dd')- to_Date(prev_date,'yyyy-mm-dd'))) as rn
 from (
select distinct cust_id, CALENDAR_DT,
lag(CALENDAR_DT,1) over(partition by cust_id order by CALENDAR_DT)  as prev_date
from mytable order by cust_id)

select * from mytable where cust_id=44366381 ORDER BY CALENDAR_DT



with tab as (
select cust_id,CALENDAR_Dt,
sum(amt_le) over(partition by cust_id order by amt_le rows  between unbounded preceding and current row)  as sum_till_curr,
count(*) over(partition by cust_id order by amt_le rows  between unbounded preceding and current row) as cnt
from mytable
where amt_le <> 0
order by cust_id),
t as (select cust_id, sum_till_curr,cnt from tab
where sum_till_curr >= 250
group by cust_id, sum_till_curr,cnt
order by cust_id)

select avg(cnt) as avg_needed_TO_GET_250 from (select cust_id, sum_till_curr,cnt  from t
where sum_till_curr = (select min(sum_till_curr) from t  t1 where t1.cust_id = t.cust_id)
order by cust_id)
-- so that average is about 4 days to pay 250 and more

----------------------------------------------------------------------------------------------
WITH daily_sales AS (
  SELECT
    Cust_Id,
    Calendar_Dt,
    ROW_NUMBER() OVER (PARTITION BY Cust_Id ORDER BY Calendar_Dt) AS rn,
    Amt_LE
  FROM mytable
),
filtered_sales AS (
  SELECT
    Cust_Id,
    Calendar_Dt,
    rn,
    Amt_LE,
    CASE
      WHEN Amt_LE > 0 THEN 1
      ELSE 0
    END AS purchase_flag
  FROM daily_sales
),
consecutive_sales AS (
  SELECT
    Cust_Id,
    Calendar_Dt,
    rn,
    SUM(purchase_flag) OVER (PARTITION BY Cust_Id ORDER BY Calendar_Dt ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS grp
  FROM filtered_sales
),
max_consecutive_sales AS (
  SELECT
    Cust_Id,
    MAX(cnt) AS max_consecutive_days
  FROM (
    SELECT
      Cust_Id,
      COUNT(*) AS cnt
    FROM consecutive_sales
    GROUP BY Cust_Id, grp
  )
  GROUP BY Cust_Id
)
SELECT
  mcs.Cust_Id,
  mcs.max_consecutive_days
FROM max_consecutive_sales mcs
JOIN mytable ytn
ON mcs.Cust_Id = ytn.Cust_Id
order by max_consecutive_days desc
---------------------------------------------------------------------------------------
