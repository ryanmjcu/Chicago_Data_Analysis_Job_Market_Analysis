# Chicago Data Analyst Job Market Analysis in SQL

# Introduction
In this guided project, I focused on Data Analyst roles in Chicago, exploring top-paying jobs and skills, most in-demand skills, and more!
# Background
I sought out this project as part of my journey in data analytics. This was project is based on a dataset put togehter by youtuber/data analytics teacher [Luke Barousse](https://www.youtube.com/@LukeBarousse), wherein information was pulled from thousands of LinkedIn job postings to compile into one dataset. 

As a young professional just dipping his toes into data analytics, and considering job-searching in this field, this easily piqued my interest. 

### The questions I want to answer with my queries are:
1. What are the highest-paying jobs, specifically Data Analyst roles?
2. What skills do we see required for those top-paying jobs?
3. All around, what skills are most in-demand, or appear the most in these job postings?
4. What salary can be expected on average for each data skill?
5. What skills are both high in demand and high in average pay? i.e., What are the most 'optimal' skills to learn for someone seeking a Data Analyst job? 
# Tools I Used
For this data analysis, I utilized just a few key tools and technologies:
- **SQL**
- **PostgreSQL**
- **Visual Studio Code**
- **Git + GitHub**
# The Analysis
Each of the 5 queries in this project aimed to investigate separate, but related aspects of the data analytics job market:

### 1. Top Paying Data Analyst Jobs
To find the roles with the highest pay, I filtered the data to show only Data Analyst positions located in Chicago, IL, and then further filtered these positions by their average yearly salary. Additionally, I excluded job postings which did not include a yearly salary upfront. 
```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location = 'Chicago, IL'
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```
From this results set we see that getting paid over $100K is doable as a Data Analyst in this city, with the top position even paying over $200K!
### 2. Skills Required For Highest-Paying Data Analyst Jobs
In this query, I utilized a common table expression (CTE) to first identify those top-paying jobs with that fit the criteria from question #1. Then, I joined the skills tables to connect those jobs to the skills given in the job posting.

```sql
WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_location = 'Chicago, IL' AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills 
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id 
ORDER BY salary_year_avg DESC;
```
Here we see some commonalities among the top-paying jobs: some method of analysis, whether that be Python, SQL, or R, as well as visuzalization tools are seen across many of the top paying jobs, with some more specialized technologies mixed in.

### 3. Most In-Demand Skills for Data Analysts
In answering this question, I wanted to shft focus away from salary and instead on demand. I aggregated the count of job postings per skills, again joining tables to connect skills to their respective jobs.
```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id 
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Chicago, IL'
GROUP BY 
    skills
ORDER BY 
    demand_count DESC
LIMIT 5
```
To no surprise, this list of most in-demand skills is topped by SQL, Excel, and Python, with Tableau and SAS following closely. This hints at future findings of what may be the most optimal skills to learn

### 4. Top Skills Based On Salary
In this query, instead of identifying the top skills by the number of times they appear in job postings, I found the top skills based on the average salary associated with them. 
```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND
    job_location = 'Chicago, IL' AND
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;
```
From these results we see that baseline skills like just SQL and Excel don't cut it when it comes to getting top-dollar salaries. Data Analysts should look to learn higher level technologies in order to further their career.

### 5. Most 'Optimal' Skills to Learn
For this query, I combined much of what was garnered in my prior queries to determine what skills are at that intersection of both well-paying, and well-demanded.
```sql
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
```

| Skill       | Job Count | Average Salary ($) |
|-------------|-----------|---------------------|
| Python      | 50        | 103,176             |
| SQL Server  | 17        | 101,415             |
| SQL         | 84        | 100,434             |
| R           | 32        | 100,134             |
| Tableau     | 50        | 98,762              |
| Power BI    | 30        | 90,955              |
| Excel       | 58        | 90,149              |
| SAS         | 30        | 85,979              |
| PowerPoint  | 19        | 83,973              |
| Word        | 19        | 82,780              |

By looking at both demand and average salary at once, we see a culmination of the insights we've gained previously: Python/R, SQL, Tableau/Power BI, and Excel top the list. Specifically, SQL and Python both see demand >= 50 jobs as well as average salary > $100K. This points to these two skills in particular being most optimal for prospective Data Analysts to learn.
# What I Learned
- **Data Aggregation:** I utilized aggregating fuctions like COUNT() and AVG() to correctly and quickly create insights into this data.
- **Intricate Queries:** I used techniques from across the spectrum of SQL progression, ranging from simple aggregations as above, to advanced CTEs and JOINs.
- **Problem-Solving:** I won't pretend that each of these queries ran the first time around, I learned to identify problems on my own, as well as be able to tell when I need extra help from other resources.
# Conclusions
### Insights
A few key insights popped out to me when answering these questions:
1. A Data Analyst in Chicago can easily make six figures: The top 10 best paying jobs in Chicago all paid above that $100,000 threshold, so with the right experience and skills, a high salary should be readily attainable.
2. Importnace of SQL: queries 2 & 3 showed me that SQL is almost required to acquire a top-paying job, but is also generally in high demand.
3. Specialization: highly specialized skills can garner high salary, indicating that as one progresses through their career, so will their salary.
4. Skill optimization: Based on the data from query 5, it seems that the most optimal skills to learn are an analysis tool such as Python or R, SQL, and a visualization tool such as Power BI or Tableau.
