USE hr_project;
/* QUESTIONS */

/* 1. What is the gender breakdown of employee in the company?*/
SELECT gender, count(*) AS Count
FROM hr
WHERE age >= 18 AND termdate = 0000
GROUP BY gender;

/* 2. What is the race/ethnicity breakdown of employees in the company?*/
SELECT race, count(*) AS Count
FROM hr
WHERE age >= 18 AND termdate = 0000
GROUP BY race
ORDER BY count(*) DESC;

/* What is the age distribution of employees in the company?*/
SELECT
	min(age) AS Youngest,
    max(age) AS Oldest
FROM hr
WHERE age >= 18 AND termdate = 0000;

SELECT 
	CASE
		WHEN age >=18 AND age <=24 THEN '18-24'
        WHEN age >=25 AND age <=34 THEN '25-34'
        WHEN age >=35 AND age <=44 THEN '35-44'
        WHEN age >=45 AND age <=54 THEN '45-54'
        WHEN age >=55 AND age <=64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    count(*) AS Count
FROM hr
WHERE age >= 18 AND termdate = 0000
GROUP BY age_group
ORDER BY age_group;

SELECT 
	CASE
		WHEN age >=18 AND age <=24 THEN '18-24'
        WHEN age >=25 AND age <=34 THEN '25-34'
        WHEN age >=35 AND age <=44 THEN '35-44'
        WHEN age >=45 AND age <=54 THEN '45-54'
        WHEN age >=55 AND age <=64 THEN '55-64'
        ELSE '65+'
	END AS age_group, gender,
    count(*) AS Count
FROM hr
WHERE age >= 18 AND termdate = 0000
GROUP BY age_group, gender
ORDER BY age_group, gender;

/* 4. How many employees work at headquater versus remote location?*/
SELECT location, count(*) AS Count
FROM hr
WHERE age >= 18 AND termdate = 0000
GROUP BY location;

/* 5. What is the average length of employment for employees who have been terminated?*/
SELECT
	round(avg(datediff(termdate, hire_date))/365,0) AS Avg_length_employment
FROM hr
WHERE termdate <= curdate() AND termdate <> 0000 AND age >= 18;

/* 6. How does the gender distribution vary across departments and job titles?*/
SELECT department, gender, count(*) AS Count
FROM hr 
WHERE age >= 18 AND termdate = 0000
GROUP BY department,gender
ORDER BY department;
/* 7. What is the distribution of job titke across the company?*/
SELECT jobtitle, count(*) AS Count
FROM hr
WHERE age >= 18 AND termdate = 0000
GROUP BY jobtitle
ORDER BY jobtitle DESC;
/* 8. Which department has a high turnover rate?*/
SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM(
	SELECT department,
    count(*) AS total_count,
    SUM(CASE WHEN termdate <> 0000 AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr 
    WHERE age >= 18
    GROUP BY department
    ) AS subquery
ORDER BY termination_rate DESC;
/* 9. What is the distribution of employees acrosslocation by city and state?*/
SELECT location_state, count(*) AS Count
FROM hr
WHERE age >= 18 AND termdate = 0000
GROUP BY location_state
ORDER BY count DESC;

/* 10. How has the company's employee count changed over time based on hire and term dates?*/
SELECT
	year,
    hires,
    terminations,
    hires-terminations AS net_change,
    round((hires-terminations)/hires*100,2) AS net_change_percent
FROM(
	SELECT
    YEAR(hire_date) AS year,
    count(*) AS hires,
    SUM(CASE WHEN termdate <> 0000 AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
    FROM hr
    WHERE age >= 18
    GROUP BY YEAR(hire_date)
    ) AS subquery
ORDER BY year ASC;
/* 11. What is the tenure distribution for each department?*/
SELECT department, round(avg(datediff(termdate, hire_date)/365),0) AS Avg_tenure
FROM hr 
WHERE termdate <= curdate() AND termdate <> 0000 AND age >= 18
GROUP BY department;