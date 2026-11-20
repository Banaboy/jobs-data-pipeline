-- amostragem por tabela
SELECT '>>> Amostragem da company_dim <<<' AS info;
SELECT * FROM company_dim LIMIT 5;

SELECT '>>> Amostragem da skills_dim <<<' AS info;
SELECT * FROM skills_dim LIMIT 5;

SELECT '>>> Amostragem de job_postings_fact <<<' AS info;
SELECT * FROM job_postings_fact LIMIT 5;

SELECT '>>> Amostragem da skill_job_dim <<<' AS info;
SELECT * FROM skill_job_dim LIMIT 5;