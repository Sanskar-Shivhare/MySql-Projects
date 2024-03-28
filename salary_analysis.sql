USE salary;
-- Q1.Show all columns and rows in the table.
SELECT 
    *
FROM
    salaries;
    
-- Q2. Show only the EmployeeName and JobTitle columns.
SELECT 
    employeename, jobtitle
FROM
    salaries;
    
-- Q3.Show the number of employees in the table.
SELECT 
    COUNT(id) AS `number of employees`
FROM
    salaries;

-- Q4. Show the unique job titles in the table.
SELECT DISTINCT
    jobtitle
FROM
    salaries;
    
-- Q5. Show the job title and overtime pay for all employees with overtime pay greater than 50000.
SELECT 
    employeename, jobtitle
FROM
    salaries
WHERE
    overtimepay > 50000;
    
-- Q6.Show the average base pay for all employees.
SELECT 
    round(AVG(BasePay),2) as `average base pay` 
FROM
    salaries;
    
-- Q7. Show the top 10 highest paid employees.
select employeename,jobtitle from salaries
order by totalpay desc limit 10;

-- Q8. Show the average of BasePay, OvertimePay, and OtherPay for each employee.
SELECT 
    employeename,
    AVG(basepay) AS `average base pay`,
    AVG(overtimepay) AS `average overtimepay`,
    AVG(otherpay) AS `average otherpay`
FROM
    salaries
GROUP BY employeename;

-- Q9. Show all employees who have the word "Manager" in their job title.
SELECT 
    *
FROM
    salaries
WHERE
    jobtitle LIKE '%Manager%';

-- Q10. Show all employees with a total pay between 50,000 and 75,000.
SELECT 
    employeename
FROM
    salaries
WHERE
    totalpay BETWEEN 50000 AND 75000;

-- Q11. Show all employees with a base pay less than 50,000 or a total pay greater than 100,000.
SELECT 
    *
FROM
    salaries
WHERE
    basepay < 50000 OR totalpay > 100000;

-- Q12. Show all employees with a total pay benefits value between 125,000 and 150,000 and a job title containing the word "Director".
select employeename from salaries
where TotalPayBenefits between 125000 and 150000 and jobtitle like '%Director%'; 

-- Q13. show all employees ordered by their total pay benefits in descending order.
SELECT 
    employeename
FROM
    salaries
ORDER BY total_pay DESC;

-- Q14. Show all job titles with an average base pay of at least 100,000 and order them by the average base pay in descending order.
SELECT 
    jobtitle
FROM
    salaries
GROUP BY jobtitle
HAVING AVG(basepay) >= 100000
ORDER BY AVG(basepay) DESC;

-- Q15. Delete the column
SELECT 
    *
FROM
    salaries;
ALTER TABLE salaries DROP COLUMN `status`;
SELECT 
    *
FROM
    salaries;
    
-- Q16. Update the base pay of all employees with the job title containing "Manager" by increasing it by 10%.
UPDATE salaries 
SET 
    basepay = basepay * 1.1
WHERE
    jobtitle LIKE '%Manager%';
SELECT 
    *
FROM
    salaries;

-- Q17. Delete all employees who have no OvertimePay.
SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    OvertimePay = 0;
    
DELETE FROM salaries 
WHERE
    OvertimePay = 0;

SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    OvertimePay = 0;