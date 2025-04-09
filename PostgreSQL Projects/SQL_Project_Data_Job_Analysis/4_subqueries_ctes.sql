SELECT *
FROM (
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;

-- versus CTEs

WITH january_jobs AS
(
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)
SELECT * FROM january_jobs;


-- subquery example

SELECT 
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE company_id IN (
SELECT company_id
FROM 
    job_postings_fact
WHERE 
    job_no_degree_mention = true
ORDER BY 
    company_id
);


-- CTE example
/* Find the companies that have the most job openings.
- get the total number of job postings per company id
- returnthe total number of jobs with the company name
*/
WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) As total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)
SELECT 
    company_dim.name as company_name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY 
    total_jobs DESC
;


/* 
Find the count of the number of remote job postings per skill
- display the top 5 skills by their demand in remote jobs
- include skill ID, name, and count of postings requiring the skill
*/
WITH remote_job_skills AS (
    SELECT 
        skill_id,
        COUNT(*) AS skill_count
    FROM    
        skills_job_dim AS skills_to_job
    JOIN job_postings_fact AS job_postings 
        ON job_postings.job_id = skills_to_job.job_id
    WHERE job_work_from_home = True AND job_postings.job_title_short = 'Data Analyst'
    GROUP BY 
        skill_id
)

SELECT skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY skill_count DESC
LIMIT 5;