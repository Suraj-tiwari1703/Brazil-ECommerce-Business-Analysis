--Sales performance M1
select sum(payment_value)  as  Total_Revenue from payments;--1

select sum(p.payment_value) as Monthlyrev ,DATE_TRUNC('month', o.order_purchase_timestamp)::date as Monthly from payments p
join orders o
on p.order_id = o.order_id
group by Monthly
order by Monthly asc;--2

with Sale_cte as (
select sum(p.payment_value) as Monthlyrev ,DATE_TRUNC('month', o.order_purchase_timestamp)::date as Monthly from payments p
join orders o
on p.order_id = o.order_id
group by Monthly
order by Monthly asc) 
(SELECT 'Highest' AS Type, Monthly, Monthlyrev 
 FROM Sale_cte 
 ORDER BY Monthlyrev DESC 
 LIMIT 1)
UNION ALL
(SELECT 'Lowest' AS Type, Monthly, Monthlyrev 
 FROM Sale_cte 
 ORDER BY Monthlyrev ASC 
 LIMIT 1);--3

--4 Revenue is declining over the time

select avg(payment_value) as AvgOrderValue from payments;--5

select max(payment_value) as HighestOrderValue ,order_id 
from payments 
group by order_id 
order by HighestOrderValue DESC limit 1;--6

------------------------------------
--Customer Analysis M2

select distinct count(customer_id)
from orders;--1

select count(customer_id) as MAXstateCustomer,customer_state
from customers 
group by customer_state
order by MAXstateCustomer desc limit 1;--2

select count(customer_id) as MAXCityCustomer,customer_city
from customers 
group by customer_city
order by MAXCityCustomer desc limit 1;--3

select sum(p.payment_value) as HighestRevstate , c.customer_state 
from payments p
join orders o
on p.order_id = o.order_id
join customers c
on c.customer_id = o.customer_id
group by c.customer_state
order by HighestRevstate desc limit 1; --4

select count(order_id) as  CustOrdermul ,customer_id 
from orders group by customer_id 
having count(order_id)>1;  --5

select (count(case when order_count > 1 then 1 end)*100)/count(*) as repeat_customer_percentage
from (select customer_id,count(order_id) as order_count from orders
group by customer_id) as customer_orders; --6
------------------------------------
--Product Analysis M3

select sum(p.payment_value) as Highetrevcat , py.product_category_english
from payments p
join order_items o
on p.order_id=o.order_id
join products py
on o.product_id = py.product_id
group by py.product_category_english
order by Highetrevcat desc limit 1;

select count(o.order_id) as highsell , p.product_category_english 
from order_items o 
join products p 
on o.product_id = p.product_id
group by p.product_category_english
order by highsell desc limit 1; --2


select avg(o.price) as highsell , p.product_category_english 
from order_items o 
join products p 
on o.product_id = p.product_id
group by p.product_category_english
order by highsell desc limit 1; --3

select count(o.order_id) as lowsell , p.product_category_english 
from order_items o 
join products p 
on o.product_id = p.product_id
group by p.product_category_english
order by lowsell asc limit 1; --4


select count(o.order_id) as frequentsell , p.product_id 
from order_items o 
join products p 
on o.product_id = p.product_id
group by p.product_id
order by frequentsell desc limit 1; --5




------------------------------------
--seller Analysis M4
select seller_id ,sum(p.payment_value) as highrev from order_items o
join payments p
on o.order_id = p.order_id
group by seller_id
order by 2 desc limit 1;--1


select seller_id ,count(order_item_id) as mostitem from order_items 
group by seller_id
order by 2 desc limit 1;--2

select count(seller_id) ,seller_state from sellers 
group by 2 order by 1 desc  limit 1 ;--3

(select round(avg(review_score),2) as acgre , seller_id from reviews r
join order_items o
on r.order_id = o.order_id
group by 2
order by 1 desc limit 1)
union all
(select round(avg(review_score),2) as acgre , seller_id from reviews r
join order_items o
on r.order_id = o.order_id
group by 2
order by 1 asc limit 1);--4&5

-----------------------------------
--order Analysis M5
select count(order_id) from orders where order_status ='delivered';--1
select count(order_id) from orders where order_status ='canceled';--2
select count(order_id) from orders where order_status ='unavailable';--3

select  order_status,
count(order_status)*100.0/ (select count(*) from orders )as asdsd
from orders 
group by order_status;--4

select count(order_id) as highordermon,date_trunc('month',order_purchase_timestamp)::date as months
from orders
group by months 
order by highordermon desc limit 1;--5
------------------------------------
--delivery Analysis M6

SELECT AVG(DATE_PART('day',order_delivered_customer_date-order_purchase_timestamp))
FROM orders;--1

SELECT COUNT(*)FROM orders
WHERE order_delivered_customer_date >
order_estimated_delivery_date;--2

SELECT AVG(DATE_PART('day',o.order_delivered_customer_date-o.order_purchase_timestamp)) as highdel,c.customer_state
FROM orders o
join customers c
on o.customer_id = c.customer_id 
group by 2 
order by 1 desc limit 1;--3

SELECT avg(DATE_PART('day',o.order_delivered_customer_date-o.order_purchase_timestamp)) as lowdelday,oo.seller_id
FROM sellers s
join order_items oo
on s.seller_id = oo.seller_id
join orders o 
on o.order_id = oo.order_id
group by 2 
order by 1 asc limit 1;--4

SELECT r.review_score,ROUND(AVG(DATE_PART('day',o.order_delivered_customer_date - o.order_purchase_timestamp))::numeric,2) AS avg_delivery_days
FROM orders o
JOIN reviews r
ON o.order_id = r.order_id
GROUP BY r.review_score
ORDER BY r.review_score;--5




------------------------------------
--payment Analysis M7

select count(payment_type) as mostusedpayment , payment_type 
from payments group by payment_type 
order by 1 desc limit 1;--1

select avg(payment_value) as Avgpayment from payments;
--2
select sum(payment_value) as HighestRev ,payment_type 
from payments group by payment_type order by 1 desc limit 1;
--3
select avg(payment_installments) as AvgChooseInstalls from payments;
--4
select count(order_id) as ordervalue ,payment_type from payments
group by  2 order by 1 ;
--5




------------------------------------
--CUSTOMER SATISFACTION Analysis M8

select avg(review_score) as avgreviewscore from reviews ;
select * from reviews;--1

select count(case when review_score = 5 then 1 end)*100/count(*) as fivestarper
from reviews;--2

select count(case when review_score = 1 then 1 end)*100/count(*) as fivestarper
from reviews;--3

select count(r.review_score) as lowratingcat , p.product_category_english 
from reviews r 
join order_items o
on r.order_id=o.order_id
join products p 
on p.product_id = o.product_id
group by 2
order by 1 asc limit 1;--4

select count(r.review_score) as lowratingselll , s.seller_id 
from reviews r 
join order_items o
on r.order_id=o.order_id
join sellers s
on s.seller_id = o.product_id
group by 2
order by 1 desc limit 10;--5
------------------------------------
--geographic Analysis M8
SELECT 
    c.customer_state,
    AVG(o.order_delivered_customer_date - o.order_delivered_carrier_date) AS avg_delivery_time 
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id 
GROUP BY 
    c.customer_state 
ORDER BY 
    avg_delivery_time DESC 
LIMIT 1;--5


select sum(p.payment_value) as HighestRevstate , c.customer_city
from payments p
join orders o
on p.order_id = o.order_id
join customers c
on c.customer_id = o.customer_id
group by c.customer_state
order by HighestRevstate desc limit 1; --1


select sum(p.payment_value) as HighestRevcity , c.customer_city
from payments p
join orders o
on p.order_id = o.order_id
join customers c
on c.customer_id = o.customer_id
group by 2
order by 1 desc limit 1; --2


select count(customer_id) as Highestcuststate , customer_state
from customers
group by 2
order by 1 desc limit 1; --3


select count(seller_id) ,seller_state from sellers 
group by 2 order by 1 desc  limit 1 ;--4
