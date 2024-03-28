CREATE DATABASE cars;
USE cars;

-- -------------------------------------------------------------------------------

-- Q1. READ THE DATA
SELECT 
    *
FROM
    car_dekho;

-- Q2. COUNT OF TOTAL CARS
SELECT 
    COUNT(*) AS `number of total cars`
FROM
    car_dekho;

-- Q3. THE MANAGER ASK THE EMPLOYEE HOW MANY CARS IS AVAILABLE IN 2023
 SELECT 
    COUNT(*) AS `number of cars in 2023`
FROM
    car_dekho
WHERE
    year = 2023;
    
-- Q4. THE MANAGER ASK THE EMPLOYEE HOW MANY CARS IS AVAILABLE IN 2000,2021,2022
SELECT 
    COUNT(*)
FROM
    car_dekho
WHERE
    year IN (2020 , 2021, 2022);
    
-- Q5. CLIENT ASKED TO PRINT THE TOTAL OF ALL CARS BY YEAR. I DON'T SEE ALL THE DETAILS.
SELECT 
    year, COUNT(*) AS `number of cars per year`
FROM
    car_dekho
GROUP BY year;

-- Q6. CLIENT ASKED TO CAR DEALER AGENT HOW MANY DIESEL CARS WILL THERE BE IN 2020?
SELECT 
    COUNT(*) AS `number of diesel cars in 2020`
FROM
    car_dekho
WHERE
    fuel = 'Diesel' AND year = 2020;

-- Q7. CLIENT REQUESTED A CAR DEALER AGENT HOW MANY PETROL CARS WILL THERE BE IN 2020?
SELECT 
    COUNT(*) AS `number of petrol cars in 2020`
FROM
    car_dekho
WHERE
    fuel = 'petrol' AND year = 2020;

-- Q8. THE MANAGER TOLD THE EMPLOYEE TO GIVE A PRINT ALL THE FUEL CARS (PETROL,DIESEL AND CNG) COME BY ALL YEAR.
SELECT 
    year, fuel, COUNT(*) `Number of Cars`
FROM
    car_dekho
GROUP BY year , fuel;

-- Q9. MANAGER SAID THERE WERE MORE THAN 100 CARS IN A GIVEN YEAR,WHICH YEAR HAD MORE THAN 100 CARS?
SELECT 
    year, COUNT(*) AS `number of cars`
FROM
    car_dekho
GROUP BY year
HAVING COUNT(*) > 100
ORDER BY year DESC;

-- Q10. THE MANAGER SAID TO THE EMPLOYEE ALL CARS COUNT DETAILS BETWEEN 2015 AND 2023 
SELECT 
    *
FROM
    car_dekho
WHERE
    year BETWEEN 2015 AND 2023;
