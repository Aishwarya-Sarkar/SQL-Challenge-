-- 1. What is the total amount each customer spent at the restaurant?
SELECT
      s.customer_id,
      sum(m.price) as total_amount
FROM sales s
inner join menu m on s.product_id=m.product_id
group by s.customer_id;

-- 2. How many days has each customer visited the restaurant?
select customer_id, count(*) as DaysofVisits
from
(
  select distinct customer_id, order_date 
	from sales
)a
group by customer_id

-- 3. What was the first item from the menu purchased by each customer?
select customer_id, product_name from
(
	select customer_id, product_name,
  DENSE_RANK() OVER (PARTITION BY customer_id order by order_date asc) rn
	 from sales s
  	inner join menu m
  	on s.product_id=m.product_id
)a
where a.rn=1

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
	select s.product_id, product_name,count(*) as NoOfTimesPurchased
	 from sales s
  	inner join menu m
  	on s.product_id=m.product_id
    group by s.product_id, product_name;
	
-- 5. Which item was the most popular for each customer?
with A as
(
  SELECT
  "customer_id",  "product_id", count(product_id) as cnt
  FROM dannys_diner.sales
  group by "customer_id",  "product_id"
)
select customer_id, product_id from
--(
select customer_id, product_id,CNT,
DENse_RANK() OVER (partition by customer_id order by cnt desc) RN
from A
)c
where c.rn=1;