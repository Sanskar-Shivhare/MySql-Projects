use swiggy;
-- OUR TABLE
SELECT 
    *
FROM
    swiggy;
    
-- Q1. HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?
SELECT 
    COUNT(DISTINCT restaurant_name) AS `count of restaurant who's rating is greater than 4.5`
FROM
    swiggy
WHERE
    rating > 4.5;
    
-- Q2. WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?
SELECT 
    city,
    COUNT(DISTINCT restaurant_name) AS `number of restaurants`
FROM
    swiggy
GROUP BY city
ORDER BY `number of restaurants` DESC
LIMIT 1;

-- Q3. HOW MANY RESTAURANTS HAVE THE WORD "PIZZA" IN THEIR NAME?
SELECT 
    COUNT(DISTINCT restaurant_name) AS pizza_restaurant
FROM
    swiggy
WHERE
    restaurant_name LIKE '%pizza%';
    
-- Q4. WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?
SELECT 
    cuisine, COUNT(*) AS cuisine_count
FROM
    swiggy
GROUP BY cuisine
ORDER BY cuisine_count DESC
LIMIT 1;

-- Q5. WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?
SELECT 
    city, ROUND(AVG(rating), 2) AS average_rating
FROM
    swiggy
GROUP BY city
ORDER BY average_rating DESC;

-- Q6. WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?
SELECT DISTINCT
    restaurant_name, menu_category, MAX(price) AS highestprice
FROM
    swiggy
WHERE
    menu_category = 'Recommended'
GROUP BY restaurant_name , menu_category;

-- Q7. FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE.
SELECT 
    restaurant_name, MAX(cost_per_person) expense
FROM
    swiggy
WHERE
    cuisine != 'Indian'
GROUP BY restaurant_name
ORDER BY expense DESC
LIMIT 5;

-- Q8. FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THETOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER.

SELECT DISTINCT
    restaurant_name, cost_per_person
FROM
    swiggy
WHERE
    cost_per_person > (SELECT 
            AVG(cost_per_person)
        FROM
            swiggy);
            
-- Q9. RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.
SELECT DISTINCT
    t1.restaurant_name, t1.city, t2.city
FROM
    swiggy t1
        JOIN
    swiggy t2 ON t1.restaurant_name = t2.restaurant_name
        AND t1.city != t2.city;
        
-- Q10. WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?
SELECT 
    restaurant_name, COUNT(item) AS number_of_item
FROM
    swiggy
WHERE
    menu_category = 'main course'
GROUP BY restaurant_name
ORDER BY number_of_item DESC
LIMIT 1;

-- Q11. LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME.
SELECT DISTINCT
    restaurant_name,
    (COUNT(CASE
        WHEN veg_or_nonveg = 'Veg' THEN 1
    END) * 100 / COUNT(*)) AS vegetarian_percetage
FROM
    swiggy
GROUP BY restaurant_name
HAVING vegetarian_percetage = 100.00
ORDER BY restaurant_name;

-- Q12. WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?
SELECT DISTINCT
    restaurant_name, ROUND(AVG(price), 2) AS average_price
FROM
    swiggy
GROUP BY restaurant_name
ORDER BY average_price
LIMIT 1;

-- Q13. WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?
SELECT DISTINCT
    restaurant_name,
    COUNT(DISTINCT menu_category) AS category_count
FROM
    swiggy
GROUP BY restaurant_name
ORDER BY category_count DESC
LIMIT 5;

-- Q14. WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?
SELECT DISTINCT
    restaurant_name,
    (COUNT(CASE
        WHEN veg_or_nonveg = 'non-veg' THEN 1
    END) * 100 / COUNT(*)) AS non_vegetarian_percetage
FROM
    swiggy
GROUP BY restaurant_name
ORDER BY non_vegetarian_percetage DESC
LIMIT 1;