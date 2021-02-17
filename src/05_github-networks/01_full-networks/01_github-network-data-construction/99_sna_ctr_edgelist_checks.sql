
--- checks

SELECT *
FROM gh.sna_ctr_edgelist_0812
--WHERE ctr1 = 'ffainelli' OR ctr2 = 'ffainelli'
LIMIT 100;

---


SELECT *
FROM gh.desc_ctrs_summary_yxy
WHERE login = 'IgorMinar' AND year BETWEEN 2008 AND 2011
ORDER BY repos DESC
LIMIT 100;
