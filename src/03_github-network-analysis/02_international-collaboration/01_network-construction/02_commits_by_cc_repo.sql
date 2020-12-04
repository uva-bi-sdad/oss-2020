CREATE MATERIALIZED VIEW gh.commits_by_cc_repo AS (
SELECT slug, country_code, COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM (SELECT slug,
	  commits_raw.login, EXTRACT(YEAR FROM committed_date)::int AS YEAR,
	  sna_ctr_ctry_codes.country_code_vis AS country_code, additions, deletions
	  FROM gh.commits_raw
	  FULL JOIN gh.sna_ctr_ctry_codes
	  ON commits_raw.login = sna_ctr_ctry_codes.login) A
GROUP BY slug, A.country_code
);


