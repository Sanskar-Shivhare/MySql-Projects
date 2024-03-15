-- view the data
SELECT * FROM pizza_sales;

-- Total Revenue: the sum of total price of all pizza orders.
SELECT SUM(total_price) AS Total_Revenue FROM pizza_sales;

-- Average order value: The average amount spent per order, calculated by divided the total revenue by the number of cost
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Average_Order_Value FROM pizza_sales;

-- Total Pizza Sold: The sum of the quantities of all pizzas sold
SELECT SUM(quantity) AS Total_Pizza_Sold FROM pizza_sales;

-- Total Ords: The total number of orders placed.
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales;

-- Average Pizza Per Order: The average number of pizzas sold per order,calcualated by dividing the total number of pizzas sold by the total number of orders
SELECT ROUND(SUM(quantity)/
COUNT(DISTINCT order_id),2) AS Avg_Pizzas_Per_Order FROM pizza_sales;

-- Daily Trends for Total Orders
SELECT DAYNAME(STR_TO_DATE(order_date,"%d-%m-%Y")) AS order_day, COUNT(DISTINCT order_id) AS Total_orders 
FROM pizza_sales
GROUP BY order_day;


-- Monthly Trends for Total order
SELECT MONTHNAME(STR_TO_DATE(order_date,"%d-%m-%Y")) AS Month_Name , COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY Month_Name
ORDER BY Total_Orders DESC;

-- Percentage  of sales by Pizza Category
SELECT pizza_category,ROUND(SUM(total_price),2) AS total_revenue,
ROUND(SUM(total_price)* 100 /(SELECT SUM(total_price) from pizza_sales),2) AS PERCENTAGE FROM pizza_sales
group by pizza_category;

-- Percentage of Sales of Pizza Size
SELECT pizza_size,ROUND(SUM(total_price),2) AS total_revenue,
ROUND(SUM(total_price)*100/(SELECT SUM(total_price) FROM pizza_sales),2) AS percentage
FROM pizza_sales
GROUP BY pizza_size;

-- Total Pizzas Sold by Pizza Category
SELECT pizza_category,sum(quantity) AS total_quantity_sold FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_quantity_sold DESC;

-- Top 5 Pizzas by Revenue
SELECT pizza_name_id,ROUND(SUM(total_price),2) total_revenue FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY total_revenue DESC
LIMIT 5;

-- Bottom 5 Pizza by Revenue
SELECT pizza_name_id,ROUND(SUM(total_price),2) total_revenue FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY total_revenue ASC
LIMIT 5;

-- Top 5 Pizzas by Quantity
SELECT pizza_name_id, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;

-- Bottom 5 Pizzas by Quantity
SELECT pizza_name_id, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY Total_Pizza_Sold ASC
LIMIT 5;

-- Top 5 Pizzas by Total Orders
SELECT pizza_name_id, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY Total_Orders DESC
LIMIT 5;

-- Bottom 5 Pizza  by Total Orders
SELECT pizza_name_id, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY Total_Orders ASC
LIMIT 5;
