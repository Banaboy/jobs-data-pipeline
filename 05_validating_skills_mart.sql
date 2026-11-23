
-- quantos registros/tabela
SELECT
    'dim_skill' AS nome_tabela,
    COUNT(*) AS total
FROM skills_mart.dim_skill

UNION ALL

SELECT
    'dim_date_month',
    COUNT(*)
FROM skills_mart.dim_date_month

UNION ALL

SELECT
    'fact_skill_demand_monthly',
    COUNT(*)
FROM skills_mart.fact_skill_demand_monthly;


-- duplicação
SELECT
    skill_id,
    month_start_date,
    job_title_short,
    COUNT(*) AS total

FROM skills_mart.fact_skill_demand_monthly

GROUP BY
    skill_id,
    month_start_date,
    job_title_short

HAVING COUNT(*) > 1;


