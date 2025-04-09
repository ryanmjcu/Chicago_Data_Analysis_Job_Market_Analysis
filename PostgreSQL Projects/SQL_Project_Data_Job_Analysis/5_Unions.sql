-- Get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION

--Get jobs from february

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION

--Get jobs from March

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs;



-- vs. UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION ALL

--Get jobs from february

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION ALL

--Get jobs from March

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs;


-- PROBLEM 8

/* Find job postings from the first quarter that have a salary greater than $70K
- Combine job posting tables from the frist quarter of 2023
- Gets job postings with an everage yearly salary > $70,000
*/
SELECT 
    q1_job_postings.job_title_short,
    q1_job_postings.job_location,
    q1_job_postings.job_via,
    q1_job_postings.job_posted_date::DATE,
    q1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT * 
    FROM february_jobs
    UNION ALL 
    SELECT * 
    FROM march_jobs
) as q1_job_postings
WHERE q1_job_postings.salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC