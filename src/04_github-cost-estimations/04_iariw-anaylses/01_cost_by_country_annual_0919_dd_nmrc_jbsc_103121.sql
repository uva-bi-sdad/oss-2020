CREATE MATERIALIZED VIEW gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc_103121 AS (
WITH sector_join AS (
SELECT slug, A.login, COALESCE(B.country, 'Missing') AS country, A.additions, A.deletions,
	EXTRACT(YEAR FROM A.committed_date)::int AS year, COALESCE(B.fraction, 1) AS fraction
FROM gh.commits_dd_nmrc_jbsc A
LEFT JOIN gh_cost.users_geo_102021 AS B -- this is the fraction
ON A.login = B.login
--limit 10000
), fraction_join AS (
SELECT slug, country, year, fraction,
  -- calculates the fraction by country
	(fraction*additions) AS additions, (fraction*deletions) AS deletions
FROM sector_join
WHERE year > 2008 AND year < 2020)

SELECT slug, country, year, SUM(additions) AS fr_additions, SUM(deletions) AS fr_deletions
FROM fraction_join
WHERE year > 2008 AND year < 2020
GROUP BY slug, country, year
ORDER BY slug, country, year
);
