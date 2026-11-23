CREATE SCHEMA IF NOT EXISTS flat_mart;

CREATE OR REPLACE TABLE flat_mart.job_postings AS
SELECT
    -- info vaga
    j.job_id,
    j.company_id,
    j.job_title_short,
    j.job_title,
    j.job_location,
    j.job_via,
    j.job_schedule_type,
    j.job_work_from_home,
    j.search_location,
    j.job_posted_date,
    j.job_no_degree_mention,
    j.job_health_insurance,
    j.job_country,
    j.salary_rate,
    j.salary_year_avg,
    j.salary_hour_avg,

    -- info empresa
    c.company_name,

    -- habilidades vaga
    ARRAY_AGG(
        STRUCT_PACK(
            name := s.skill,
            type := s.type_job
        )
        ORDER BY s.skill
    ) FILTER (
        WHERE s.skill_id IS NOT NULL
    ) AS skills_and_types

FROM job_postings_fact AS j

LEFT JOIN company_dim AS c
    ON j.company_id = c.company_id

LEFT JOIN skill_job_dim AS sj
    ON j.job_id = sj.job_id

LEFT JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id

GROUP BY ALL;