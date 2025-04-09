/*
Question: What skills are the most optimal to learn?
- Most optimal = highest paying and highest demanded
- Filter for Chicago, IL jobs with salary given in the job posting
*/

SELECT 
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS skill_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim   
    ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND job_location = 'Chicago, IL'
    AND salary_year_avg IS NOT NULL
GROUP BY skills
HAVING COUNT(skills_job_dim.job_id) > 15
ORDER BY avg_salary DESC, skill_count DESC
LIMIT 10;

