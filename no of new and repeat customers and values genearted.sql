create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);
select * from customer_orders

insert into customer_orders values
(1,100,cast('2022-01-01' as date),2000),
(2,200,cast('2022-01-01' as date),2500),
(3,300,cast('2022-01-01' as date),2100),
(4,100,cast('2022-01-02' as date),2000),
(5,400,cast('2022-01-02' as date),2200),
(6,500,cast('2022-01-02' as date),2700),
(7,100,cast('2022-01-03' as date),3000),
(8,400,cast('2022-01-03' as date),1000),
(9,600,cast('2022-01-03' as date),3000)
;

select * from customer_orders

##Q1 Find new customers and repeat customers for each and every dates

-- Method1:


Select customer_id, min(order_date) as first_order_date
from customer_orders
group by customer_id



with cte as
(Select customer_id, min(order_date) as first_order_date
from customer_orders
group by customer_id)
select co.*, cte.first_order_date from customer_orders co
inner join cte 
on co.customer_id = cte.customer_id



with cte as
(Select customer_id, min(order_date) as first_order_date
from customer_orders
group by customer_id)
select co.*, 
cte.first_order_date,
case when co.order_date = cte.first_order_date then 1 else 0 end as first_visit_flag, 
case when co.order_date != cte.first_order_date then 1 else 0 end as repeat_visit_flag 
from customer_orders co inner join cte on co.customer_id = cte.customer_id




with cte as
(Select customer_id, min(order_date) as first_order_date
from customer_orders
group by customer_id),
visit_flag as (select co.*, 
cte.first_order_date,
case when co.order_date = cte.first_order_date then 1 else 0 end as first_visit_flag, 
case when co.order_date != cte.first_order_date then 1 else 0 end as repeat_visit_flag 
from customer_orders co inner join cte on co.customer_id = cte.customer_id)
select order_date, 
sum(first_visit_flag) as no_of_first_orderers,
sum(repeat_visit_flag) as no_of_repeat_orderers 
from visit_flag
group by order_date


-- Method2: (We have just reduced the number of queries)

with cte as
(Select customer_id, min(order_date) as first_order_date
from customer_orders
group by customer_id)
select co.order_date,
sum(case when co.order_date = cte.first_order_date then 1 else 0 end) as no_of_first_orderers, 
sum(case when co.order_date != cte.first_order_date then 1 else 0 end) as no_of_repeat_orderers 
from customer_orders co inner join cte on co.customer_id = cte.customer_id
group by order_date



##Q1 Find the values genearted from new customers and repeated customers for each and evey date

with cte as
(Select customer_id, min(order_date) as first_order_date
from customer_orders
group by customer_id)
select co.order_date,
sum(case when co.order_date = cte.first_order_date then order_amount else null end) as values_from_first_comers, 
sum(case when co.order_date != cte.first_order_date then order_amount else null end) as values_from_repeaters 
from customer_orders co inner join cte on co.customer_id = cte.customer_id
group by order_date