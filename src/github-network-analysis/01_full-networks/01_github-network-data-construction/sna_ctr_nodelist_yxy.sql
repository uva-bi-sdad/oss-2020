--NEXT WE WANT TO CREATE A NODELIST WITH ATTRIBUTES FOR EACH YEAR (sna_ctr_nodelist_yxy)
--THIS TAKES THE EXACT SAME CODE AS THE LAST SNIPPET AND ADDS A YEAR TO THE GROUP_BY

CREATE MATERIALIZED VIEW gh.sna_ctr_nodelist_yxy AS (
SELECT A.login, year, repos, commits, additions, deletions, country_code, country_code_di, country_code_vis
FROM (SELECT login, COUNT(*) AS commits, COUNT(DISTINCT slug) AS repos,
      SUM(additions) AS additions, SUM(deletions) AS deletions, EXTRACT(YEAR FROM committed_date)::int AS YEAR
	    FROM gh.commits
	    GROUP BY login, year) A
LEFT JOIN gh.login_ctry_codes AS B
ON A.login = B.login
);
