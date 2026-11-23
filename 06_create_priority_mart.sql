
CREATE SCHEMA IF NOT EXISTS priority_mart;

-- prioridade
CREATE TABLE IF NOT EXISTS priority_mart.priority_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR NOT NULL UNIQUE,
    priority_lvl INTEGER NOT NULL
        CHECK (priority_lvl BETWEEN 1 AND 3)
);

-- novas regras
MERGE INTO priority_mart.priority_roles AS tgt
USING (
    SELECT 1 AS role_id, 'Data Engineer' AS role_name, 2 AS priority_lvl
    UNION ALL
    SELECT 2, 'Senior Data Engineer', 1
    UNION ALL
    SELECT 3, 'Software Engineer', 3
) AS src
ON tgt.role_id = src.role_id
WHEN NOT MATCHED THEN
    INSERT (role_id, role_name, priority_lvl)
    VALUES (src.role_id, src.role_name, src.priority_lvl);

-- Snapshot vagas dentro das regras
CREATE TABLE IF NOT EXISTS priority_mart.priority_jobs_snapshot (
    job_id INTEGER PRIMARY KEY,
    job_title_short VARCHAR NOT NULL,
    company_name VARCHAR,
    job_posted_date TIMESTAMP,
    salary_year_avg DOUBLE,
    priority_lvl INTEGER NOT NULL,
    updated_at TIMESTAMP NOT NULL
);
