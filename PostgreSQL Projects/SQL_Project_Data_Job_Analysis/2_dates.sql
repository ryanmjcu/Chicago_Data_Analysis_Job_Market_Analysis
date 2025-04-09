-- :: is used for casting, or converting a value from one data type to another

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM
    job_postings_fact
LIMIT 5;


SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM
    job_postings_fact
LIMIT 5;


SELECT
    COUNT(job_id) as job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY date_month
ORDER BY job_posted_count DESC;

-- Problem 1: FIND avg yearly and hourly salary for jobs posted after June 1, 2023

SELECT 
    job_title_short,
    AVG(salary_year_avg) as avg_salary_year,
    AVG(salary_hour_avg) AS avg_salary_hour
FROM job_postings_fact
WHERE job_posted_date::DATE > '2023-06-01'
GROUP BY job_title_short;

-- Create three tables for Jan, Feb, March 2023 jobs

