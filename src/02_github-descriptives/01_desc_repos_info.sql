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
