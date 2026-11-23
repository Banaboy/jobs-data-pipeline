
-- Update prioridade Data Engineer
UPDATE priority_mart.priority_roles
SET priority_lvl = 1
WHERE role_name = 'Data Engineer'
  AND priority_lvl IS DISTINCT FROM 1;

-- sem duplicar
MERGE INTO priority_mart.priority_roles AS tgt
USING (
    SELECT
        4 AS role_id,
        'Data Scientist' AS role_name,
        2 AS priority_lvl
) AS src
ON tgt.role_id = src.role_id
WHEN NOT MATCHED THEN
    INSERT (role_id, role_name, priority_lvl)
    VALUES (src.role_id, src.role_name, src.priority_lvl);

-- snapshot
MERGE INTO priority_mart.priority_jobs_snapshot AS tgt
USING (
    SELECT
        jpf.job_id,
        jpf.job_title_short,
        cd.company_name AS company_name,
        jpf.job_posted_date,
        jpf.salary_year_avg,
        pr.priority_lvl
    FROM job_postings_fact AS jpf
    LEFT JOIN company_dim AS cd
        ON jpf.company_id = cd.company_id
    INNER JOIN priority_mart.priority_roles AS pr
        ON jpf.job_title_short = pr.role_name
) AS src
ON tgt.job_id = src.job_id

-- update 
WHEN MATCHED AND (
    tgt.job_title_short IS DISTINCT FROM src.job_title_short
    OR tgt.company_name IS DISTINCT FROM src.company_name
    OR tgt.job_posted_date IS DISTINCT FROM src.job_posted_date
    OR tgt.salary_year_avg IS DISTINCT FROM src.salary_year_avg
    OR tgt.priority_lvl IS DISTINCT FROM src.priority_lvl
)
THEN UPDATE SET
    job_title_short = src.job_title_short,
    company_name = src.company_name,
    job_posted_date = src.job_posted_date,
    salary_year_avg = src.salary_year_avg,
    priority_lvl = src.priority_lvl,
    updated_at = CURRENT_TIMESTAMP

-- inserir novas vagas
WHEN NOT MATCHED THEN
    INSERT (
        job_id,
        job_title_short,
        company_name,
        job_posted_date,
        salary_year_avg,
        priority_lvl,
        updated_at
    )
    VALUES (
        src.job_id,
        src.job_title_short,
        src.company_name,
        src.job_posted_date,
        src.salary_year_avg,
        src.priority_lvl,
        CURRENT_TIMESTAMP
    )


WHEN NOT MATCHED BY SOURCE THEN DELETE;
