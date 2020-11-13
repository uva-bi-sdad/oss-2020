CREATE MATERIALIZED VIEW gh.commits_by_cc_repo AS (
SELECT slug, country_code, COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM (SELECT slug,
	  commits_pre.login,
	  EXTRACT(YEAR FROM committed_date)::int AS YEAR,
	  users_gh_cc.country_code AS country_code,
	  additions, deletions
	  FROM gh.commits_pre
	  FULL JOIN github.users_gh_cc
	  ON commits_pre.login = users_gh_cc.login) A
GROUP BY slug, A.country_code
);
