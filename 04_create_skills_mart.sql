
-- SKILLS MART

CREATE SCHEMA IF NOT EXISTS skills_mart;

-- indepotent
DROP TABLE IF EXISTS skills_mart.fact_skill_demand_monthly;
DROP TABLE IF EXISTS skills_mart.dim_skill;
DROP TABLE IF EXISTS skills_mart.dim_date_month;



-- 1 DIMENSÃO HABILIDADES


CREATE TABLE skills_mart.dim_skill (
    skill_id INTEGER PRIMARY KEY,
    skill VARCHAR,
    type_job VARCHAR
);

INSERT INTO skills_mart.dim_skill (
    skill_id,
    skill,
    type_job
)
SELECT
    skill_id,
    skill,
    type_job
FROM skills_dim;



-- 2 DIMENSÃO MESES

CREATE TABLE skills_mart.dim_date_month (
    month_start_date DATE PRIMARY KEY,
    year INTEGER,
    month INTEGER,
    quarter INTEGER,
    quarter_name VARCHAR,
    year_quarter VARCHAR
);

INSERT INTO skills_mart.dim_date_month (
    month_start_date,
    year,
    month,
    quarter,
    quarter_name,
    year_quarter
)
SELECT DISTINCT
    CAST(DATE_TRUNC('month', job_posted_date) AS DATE),
    CAST(EXTRACT(YEAR FROM job_posted_date) AS INTEGER),
    CAST(EXTRACT(MONTH FROM job_posted_date) AS INTEGER),
    CAST(EXTRACT(QUARTER FROM job_posted_date) AS INTEGER),

    'Q' || CAST(EXTRACT(QUARTER FROM job_posted_date) AS VARCHAR),

    CAST(EXTRACT(YEAR FROM job_posted_date) AS VARCHAR)
        || '-Q'
        || CAST(EXTRACT(QUARTER FROM job_posted_date) AS VARCHAR)

FROM job_postings_fact
WHERE job_posted_date IS NOT NULL;


-- FACT DEMANDA/HABILIDADES


CREATE TABLE skills_mart.fact_skill_demand_monthly (
    skill_id INTEGER,
    month_start_date DATE,
    job_title_short VARCHAR,

    postings_count INTEGER,
    remote_postings_count INTEGER,
    health_insurance_postings_count INTEGER,
    no_degree_postings_count INTEGER,

    PRIMARY KEY (
        skill_id,
        month_start_date,
        job_title_short
    ),

    FOREIGN KEY (skill_id)
        REFERENCES skills_mart.dim_skill(skill_id),

    FOREIGN KEY (month_start_date)
        REFERENCES skills_mart.dim_date_month(month_start_date)
);

INSERT INTO skills_mart.fact_skill_demand_monthly (
    skill_id,
    month_start_date,
    job_title_short,
    postings_count,
    remote_postings_count,
    health_insurance_postings_count,
    no_degree_postings_count
)
SELECT
    sj.skill_id,
    CAST(DATE_TRUNC('month', j.job_posted_date) AS DATE),
    j.job_title_short,

    COUNT(*),

    COUNT(*) FILTER (
        WHERE j.job_work_from_home = TRUE
    ),

    COUNT(*) FILTER (
        WHERE j.job_health_insurance = TRUE
    ),

    COUNT(*) FILTER (
        WHERE j.job_no_degree_mention = TRUE
    )

FROM job_postings_fact AS j

INNER JOIN skill_job_dim AS sj
    ON j.job_id = sj.job_id

WHERE j.job_posted_date IS NOT NULL
  AND j.job_title_short IS NOT NULL

GROUP BY
    sj.skill_id,
    CAST(DATE_TRUNC('month', j.job_posted_date) AS DATE),
    j.job_title_short;