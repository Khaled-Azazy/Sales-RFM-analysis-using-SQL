-- total sales in each country
select distinct country,
sum(price*QUANTITY) over (partition by country)
from tableretail


select * from tableretail

-- what are the years in the data and the sales in each year extract year then using the year see the sales 
select distinct  extract( year from to_Date(INVOICEDATE, 'MM/DD/YYYY HH24:MI:SS')) as  "Year",
sum(price*QUANTITY) over (partition by extract( year from to_Date(INVOICEDATE, 'MM/DD/YYYY HH24:MI:SS'))) as "total"
from tableretail


-- what is the min and max total sales for all the years for each customer 
select  distinct customer_id, extract(year from to_Date(INVOICEDATE, 'MM/DD/YYYY HH24:MI:SS')) as  "Year",
min (price*QUANTITY) over(partition by customer_id, extract(year from to_Date(INVOICEDATE, 'MM/DD/YYYY HH24:MI:SS')) ) as "min treansaction",
max (price*QUANTITY) over(partition by customer_id, extract(year from to_Date(INVOICEDATE, 'MM/DD/YYYY HH24:MI:SS')) ) as "max treansaction"
from tableretail

-- top 10 customers with number of  trenasactions

select *
from (select customer_id,  "number of transactions",
rank() over(order by "number of transactions" desc) as "Rank"
from 
(select distinct  customer_id,
count (*) over(partition by customer_id) as "number of transactions"
from tableretail
order by 2 desc))
where "Rank" <= 10



-- produects of the total payments and count using the stockcode of the produect
select distinct stockcode,
sum(price*QUANTITY) over (partition by stockcode) as "produect sales",
count(*) over (partition by stockcode) as "produect count"
from tableretail
order by 2 desc