
-- quantos registros
SELECT
    'priority_roles' AS table_name,
    COUNT(*) AS total
FROM priority_mart.priority_roles

UNION ALL

SELECT
    'priority_jobs_snapshot',
    COUNT(*)
FROM priority_mart.priority_jobs_snapshot;

-- vagas/prioridade
SELECT
    job_title_short,
    priority_lvl,
    COUNT(*) AS total_jobs
FROM priority_mart.priority_jobs_snapshot
GROUP BY job_title_short, priority_lvl
ORDER BY priority_lvl, total_jobs DESC;

-- Vagas fora da regra (esperado: 0)
SELECT COUNT(*) AS invalid_jobs
FROM priority_mart.priority_jobs_snapshot AS pjs
WHERE NOT EXISTS (
    SELECT 1
    FROM priority_mart.priority_roles AS pr
    WHERE pr.role_name = pjs.job_title_short
      AND pr.priority_lvl = pjs.priority_lvl
);

-- Registros nulos (esperado 0)
SELECT COUNT(*) AS null_errors
FROM priority_mart.priority_jobs_snapshot
WHERE job_id IS NULL
   OR job_title_short IS NULL
   OR priority_lvl IS NULL
   OR updated_at IS NULL;
