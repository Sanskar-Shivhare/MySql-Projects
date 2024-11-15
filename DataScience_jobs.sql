use practise;

show tables ;

select * from salaries;

-- You're a Compensation analyst employed by a multinational corporation. Your Assignment is to Pinpoint Countries who give work fully remotely, for the title 'managers’ Paying salaries Exceeding $90,000 USD


SELECT DISTINCT
    company_location
FROM
    salaries
WHERE
    job_title LIKE '%Manager%'
        AND salary_in_usd > 90000
        AND remote_ratio = 100;
        
        
-- AS a remote work advocate Working for a progressive HR tech startup who place their freshers’ clients IN large tech firms. you're tasked WITH Identifying top 5 Country Having greatest count of large (company size) number of companies.

SELECT 
    company_location, COUNT(company_location) counts
FROM
    salaries
WHERE
    company_size = 'L'
        AND experience_level = 'EN'
GROUP BY 1
ORDER BY counts DESC
LIMIT 5;


-- Picture yourself AS a data scientist Working for a workforce management platform. Your objective is to calculate the percentage of employees. Who enjoy fully remote roles WITH salaries Exceeding $100,000 USD, Shedding light ON the attractiveness of high-paying remote positions IN today's job market.

SELECT 
    ROUND(COUNT(*) / (SELECT 
                    COUNT(*)
                FROM
                    salaries
                WHERE
                    salary_in_usd > 100000) * 100,
            2) percentage
FROM
    salaries
WHERE
    salary_in_usd > 100000
        AND remote_ratio = 100;

-- Imagine you're a data analyst Working for a global recruitment agency. Your Task is to identify the Locations where entry-level average salaries exceed the average salary for that job title IN market for entry level, helping your agency guide candidates towards lucrative opportunities.

SELECT DISTINCT
    company_location
FROM
    (SELECT 
        job_title, AVG(salary_in_usd) `job average salary`
    FROM
        salaries
    GROUP BY 1) t
        INNER JOIN
    (SELECT 
        *
    FROM
        (SELECT 
        company_location, job_title, AVG(salary_in_usd) AS `avg`
    FROM
        salaries
    GROUP BY 1 , 2) t1) t1 ON t.job_title = t1.job_title
WHERE
    `avg` > `job average salary`;


-- You've been hired by a big HR Consultancy to look at how much people get paid IN different Countries. Your job is to Find out for each job title which. Country pays the maximum average salary. This helps you to place your candidates IN those countries.

select company_location from 
(select company_location,job_title,avg(salary_in_usd) Average,dense_rank() over(partition by job_title order by avg(salary_in_usd) desc) ranks 
from salaries 
group by 1,2)t 
where ranks = 1;


-- AS a data-driven Business consultant, you've been hired by a multinational corporation to analyze salary trends across different company Locations. Your goal is to Pinpoint Locations WHERE the average salary Has consistently Increased over the Past few years (Countries WHERE data is available for 3 years Only(present year and past two years) providing Insights into Locations experiencing Sustained salary growth.
with temp as (
	SELECT 
		*
	FROM
		salaries
	WHERE
		company_location IN (SELECT 
				company_location
			FROM
				salaries
			WHERE
				work_year >= YEAR(NOW()) - 2
			GROUP BY 1
			HAVING COUNT(DISTINCT work_year) = 3) )

select  max(case when work_year = 2022 then average end ) as avg_salary_2022,
		max(case when work_year = 2023 then average end ) as avg_salary_2023,
		max(case when work_year = 2024 then average end ) as avg_salary_2024 
        from(
				select company_location,
				work_year,avg(salary_in_usd) as average from temp
				group by 1,2)t
                having avg_salary_2024>avg_salary_2023 and avg_salary_2023>avg_salary_2022;
                
                
                
                
--  Picture yourself AS a workforce strategist employed by a global HR tech startup. Your Mission is to Determine the percentage of fully remote work for each experience level IN 2021 and compare it WITH the corresponding figures for 2024, Highlighting any significant Increases or decreases IN remote work Adoption over the years.

select a.experience_level,cnt/100*total 2021_perentage 
from (select experience_level,count(*) total from salaries where work_year = 2021 
group by 1)a inner join

(select experience_level,count(*) cnt from salaries where work_year = 2021 and remote_ratio = 100
group by 1)b on a.experience_level = b.experience_level;



-- AS a Compensation specialist at a Fortune 500 company, you're tasked WITH analyzing salary trends over time. Your objective is to calculate the average salary increase percentage for each experience level and job title between the years 2023 and 2024, helping the company stay competitive IN the talent market.

WITH t AS
(
SELECT experience_level, job_title ,work_year, round(AVG(salary_in_usd),2) AS 'average'  FROM salaries WHERE work_year IN (2023,2024) GROUP BY experience_level, job_title, work_year
)  -- step 1



SELECT *,round((((AVG_salary_2024-AVG_salary_2023)/AVG_salary_2023)*100),2)  AS changes
FROM
(
	SELECT 
		experience_level, job_title,
		MAX(CASE WHEN work_year = 2023 THEN average END) AS AVG_salary_2023,
		MAX(CASE WHEN work_year = 2024 THEN average END) AS AVG_salary_2024
	FROM  t GROUP BY experience_level , job_title -- step 2
)a ; -- STEP 3


/* As a market researcher, your job is to Investigate the job market for a company that analyzes workforce data. Your Task is to know how many people were
 employed IN different types of companies AS per their size IN 2021.*/
-- Select company size and count of employees for each size.

SELECT company_size, COUNT(company_size) AS 'COUNT of employees' 
FROM salaries 
WHERE work_year = 2021 
GROUP BY company_size;
             -- OR
-- Alternatively, use a subquery to achieve the same result.
SELECT company_size, COUNT(company_size) 
FROM
(
    -- Subquery selects data for the year 2021.
    SELECT * FROM salaries WHERE work_year = 2021
) t 
GROUP BY company_size;





/* Imagine you are a talent Acquisition specialist Working for an International recruitment agency. Your Task is to identify the top 3 job titles that 
command the highest average salary Among part-time Positions IN the year 2023.*/
SELECT job_title, AVG(salary_in_usd) AS 'average' 
FROM salaries  
WHERE employment_type = 'PT'  
GROUP BY job_title 
ORDER BY AVG(salary_IN_usd) DESC 
LIMIT 3;   -- limiting only top 3






/* As a database analyst you have been assigned the task to Select Countries where average mid-level salary is higher than overall mid-level salary for the year 2023.*/

-- Calculate the average mid-level salary and store it in a variable
SET @average = (SELECT AVG(salary_IN_usd) AS 'average' FROM salaries WHERE experience_level='MI');

-- Select company location and average mid-level salary for countries where the salary exceeds the calculated average.
SELECT company_location, AVG(salary_IN_usd) 
FROM salaries 
WHERE experience_level = 'MI' AND salary_IN_usd > @average 
GROUP BY company_location;

/* You're a Financial analyst Working for a leading HR Consultancy, and your Task is to Assess the annual salary growth rate for various job titles. 
By Calculating the percentage Increase IN salary FROM previous year to this year, you aim to provide valuable Insights Into salary trends WITHIN different job roles.*/

WITH t AS    -- creating common table expression.
(
    -- Subquery to calculate average salary for each job title in 2023 and 2024
    SELECT a.job_title, average_2023, average_2024 FROM
    (
        -- Subquery to calculate average salary for each job title in 2023
        SELECT job_title , AVG(salary_IN_usd) AS average_2023 
        FROM salaries 
        WHERE work_year = 2023 
        GROUP BY job_title
    ) a
    -- Inner join with subquery to calculate average salary for each job title in 2024
    INNER JOIN
    (
        -- Subquery to calculate average salary for each job title in 2024
        SELECT job_title , AVG(salary_IN_usd) AS average_2024 
        FROM salaries 
        WHERE work_year = 2024 
        GROUP BY job_title
    ) b ON a.job_title = b.job_title
)
-- Final query to calculate percentage change in salary from 2023 to 2024 for each job title
SELECT *, ROUND((((average_2024-average_2023)/average_2023)*100),2) AS 'percentage_change' 
FROM t;

 
 
 
 
 /* You've been hired by a global HR Consultancy to identify Countries experiencing significant salary growth for entry-level roles. Your task is to list the top three 
 Countries with the highest salary growth rate FROM 2020 to 2023, helping multinational Corporations identify  Emerging talent markets.*/

WITH t AS   -- creating CTE
(
    -- Subquery to calculate average salary for entry-level roles in 2021 and 2023
    SELECT 
        company_location, 
        work_year, 
        AVG(salary_in_usd) as average 
    FROM 
        salaries 
    WHERE 
        experience_level = 'EN' 
        AND (work_year = 2021 OR work_year = 2023)
    GROUP BY  
        company_location, 
        work_year
)
-- Main query to calculate percentage change in salary from 2021 to 2023 for each country
SELECT 
    *, 
    (((AVG_salary_2023 - AVG_salary_2021) / AVG_salary_2021) * 100) AS changes
FROM
(
    -- Subquery to pivot the data and calculate average salary for each country in 2021 and 2023
    SELECT 
        company_location,
        MAX(CASE WHEN work_year = 2021 THEN average END) AS AVG_salary_2021,
        MAX(CASE WHEN work_year = 2023 THEN average END) AS AVG_salary_2023
    FROM 
        t 
    GROUP BY 
        company_location
) a 
-- Filter out null values and select the top three countries with the highest salary growth rate
WHERE 
    (((AVG_salary_2023 - AVG_salary_2021) / AVG_salary_2021) * 100) IS NOT NULL  
ORDER BY 
    (((AVG_salary_2023 - AVG_salary_2021) / AVG_salary_2021) * 100) DESC 
    limit 3 ;

/* You are a researcher and you have been assigned the task to Find the year with the highest average salary for each job title.*/

WITH avg_salary_per_year AS 
(
    -- Calculate the average salary for each job title in each year
    SELECT work_year, job_title, AVG(salary_in_usd) AS avg_salary 
    FROM salaries
    GROUP BY work_year, job_title
)

SELECT job_title, work_year, avg_salary FROM 
    (
       -- Rank the average salaries for each job title in each year
       SELECT job_title, work_year, avg_salary, RANK() OVER (PARTITION BY job_title ORDER BY avg_salary DESC) AS rank_by_salary
	   FROM avg_salary_per_year
    ) AS ranked_salary
WHERE 
    rank_by_salary = 1; -- Select the records where the rank of average salary is 1 (highest)
    
    
    
    
    
/* You have been hired by a market research agency where you been assigned the task to show the percentage of different employment type (full time, part time) in 
Different job roles, in the format where each row will be job title, each column will be type of employment type and  cell value  for that row and column will show 
the % value*/

SELECT 
    job_title,
    ROUND((SUM(CASE WHEN employment_type = 'PT' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS PT_percentage, -- Calculate percentage of part-time employment
    ROUND((SUM(CASE WHEN employment_type = 'FT' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS FT_percentage, -- Calculate percentage of full-time employment
    ROUND((SUM(CASE WHEN employment_type = 'CT' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS CT_percentage, -- Calculate percentage of contract employment
    ROUND((SUM(CASE WHEN employment_type = 'FL' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS FL_percentage -- Calculate percentage of freelance employment
FROM 
    salaries
GROUP BY 
    job_title; -- Group the result by job title
   




