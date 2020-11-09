--NEXT WE WANT TO CREATE A NODELIST WITH ATTRIBUTES (sna_ctr_nodelist)
--This code selects the login, commit count, number of repos each login commmitted to, and total additions and deletions.
--It also pulls country_code data from "ctr_ctry_codes" which is a table created in the 02_intl-network-construction.Rmd file.

CREATE MATERIALIZED VIEW gh.sna_ctr_nodelist_full AS (
SELECT A.login, repos, commits, additions, deletions, country_code, country_code_di, country_code_vis
FROM (SELECT login, COUNT(*) AS commits, COUNT(DISTINCT slug) AS repos, SUM(additions) AS additions, SUM(deletions) AS deletions
	  FROM gh.commits_pre
	  GROUP BY login) A
LEFT JOIN gh.sna_ctr_ctry_codes AS B
ON A.login = B.login
);
