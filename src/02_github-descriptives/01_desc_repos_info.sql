--CREATES SUMMARY TABLE FOR NEW REPOS OVER TIME

CREATE MATERIALIZED VIEW gh.desc_repos_info_lchn AS (
WITH distinct_repos AS (
	SELECT a.slug, b.spdx, b.created
  	FROM gh.commits_dd_nmrc_jbsc a
  	INNER JOIN gh.repos b
  	ON a.slug = b.slug
)
SELECT *
FROM distinct_repos
ORDER BY slug ASC
);

create materialized view gh.desc_repos_annual_lchn AS (
WITH tmp_table AS (
SELECT DISTINCT(slug), spdx, EXTRACT(YEAR FROM created)::int AS year
FROM gh.desc_repos_info_lchn
--LIMIT 100
)

SELECT year, COUNT(slug) AS repo_count
FROM tmp_table
GROUP BY year
ORDER BY year ASC
--LIMIT 100
);
