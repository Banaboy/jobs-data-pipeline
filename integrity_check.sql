-- checagem de integridade (retorna 0 se estiver ok)
SELECT '>>> Checagem de referencial de integridade <<<' AS info;

SELECT 
    'company_ids orfãos em job_postings_fact' AS check_type,
    COUNT(*) AS orphaned_count
FROM job_postings_fact 
WHERE company_id NOT IN (SELECT company_id FROM company_dim);

SELECT 
    'skill_ids orfãos em skills_job_dim' AS check_type,
    COUNT(*) AS orphaned_count
FROM skill_job_dim 
WHERE skill_id NOT IN (SELECT skill_id FROM skills_dim);

SELECT 
    'job_ids orfãos em skills_job_dim' AS check_type,
    COUNT(*) AS orphaned_count
FROM skill_job_dim 
WHERE job_id NOT IN (SELECT job_id FROM job_postings_fact);