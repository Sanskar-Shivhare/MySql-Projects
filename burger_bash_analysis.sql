-- WE HAVR FOUR TABLES

-- BURGER NAME
SELECT * FROM burger_names;

-- BURGER RUNNER 
SELECT * FROM burger_runner;

-- CUSTOMER ORDERS
SELECT * FROM customer_orders;

-- RUNNER ORDERS
SELECT * FROM 	runner_orders;

-- -----------------------------------------------

-- Q1. How many burgers were ordered?
SELECT 
    COUNT(*) AS `number of burgers ordered`
FROM
    customer_orders;
    
-- Q2. How many unique customer orders were made?
SELECT 
    COUNT(DISTINCT order_id) AS `unique number of orders`
FROM
    customer_orders;
    
-- Q3. How many successful orders were delivered by each runner?
SELECT 
    runner_id, COUNT(DISTINCT order_id) AS successful_orders
FROM
    runner_orders
WHERE
    cancellation IS NULL
GROUP BY runner_id;

-- Q4. How many of each type of burger was delivered?
SELECT 
    b.burger_name, COUNT(c.burger_id) AS deliver_burger_count
FROM
    customer_orders c
        JOIN
    runner_orders r ON c.order_id = r.order_id
        JOIN
    burger_names b ON c.burger_id = b.burger_id
WHERE
    r.distance IS NOT NULL
GROUP BY b.burger_name;

-- Q5.  How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
    customer_id, burger_name, COUNT(*) AS count_of_orders
FROM
    customer_orders c
        JOIN
    burger_names b ON c.burger_id = b.burger_id
GROUP BY customer_id , burger_name;

-- Q6. What was the maximum number of burgers delivered in a single order?
WITH burger_count_cte AS
(
 SELECT c.order_id, COUNT(c.burger_id) AS burger_per_order
 FROM customer_orders AS c
 JOIN runner_orders AS r
  ON c.order_id = r.order_id
 WHERE r.distance is not null
 GROUP BY c.order_id
)
SELECT MAX(burger_per_order) AS burger_count
FROM burger_count_cte;

-- Q7. For each customer, how many delivered burgers had at least 1 change and how many had no changes?
SELECT 
    c.customer_id,
    SUM(CASE
        WHEN c.exclusions <> ' ' OR c.extras <> ' ' THEN 1
        ELSE 0
    END) AS at_least_1_change,
    SUM(CASE
        WHEN c.exclusions = ' ' AND c.extras = ' ' THEN 1
        ELSE 0
    END) AS no_change
FROM
    customer_orders AS c
        JOIN
    runner_orders AS r ON c.order_id = r.order_id
WHERE
    r.distance != 0
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- Q8. What was the total volume of burgers ordered for each hour of the day?
SELECT 
    EXTRACT(HOUR FROM order_time) AS hour_of_day,
    COUNT(order_id) AS burger_count
FROM
    customer_orders
GROUP BY EXTRACT(HOUR FROM order_time);

-- Q9. How many runners signed up for each 1 week period?
SELECT 
    EXTRACT(WEEK FROM registration_date) AS registration_week,
    COUNT(runner_id) AS runner_signup
FROM
    burger_runner
GROUP BY EXTRACT(WEEK FROM registration_date);

-- Q10. What was the average distance travelled for each customer?
SELECT 
    c.customer_id, ROUND(AVG(r.distance), 2) AS avg_distance
FROM
    customer_orders AS c
        JOIN
    runner_orders AS r ON c.order_id = r.order_id
WHERE
    r.duration IS NOT NULL
GROUP BY c.customer_id;
