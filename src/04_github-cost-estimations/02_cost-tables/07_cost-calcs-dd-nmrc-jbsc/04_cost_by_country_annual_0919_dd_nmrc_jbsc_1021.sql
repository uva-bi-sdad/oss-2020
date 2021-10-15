
--fourth, we want all the commits, additions, deletions, sum and net by country (2008-2019)

CREATE MATERIALIZED VIEW gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc_101521 AS (
WITH sector_join AS (
SELECT slug, A.login, COALESCE(B.country, 'Missing') AS country, A.additions, A.deletions,
	EXTRACT(YEAR FROM A.committed_date)::int AS year
FROM gh.commits_dd_nmrc_jbsc A
LEFT JOIN gh_cost.users_geo_101521 AS B
ON A.login = B.login
)

SELECT slug, country, year, COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions,
					SUM(additions + deletions) AS sum_adds_dels, SUM(additions - deletions) AS net_adds_dels
FROM sector_join
WHERE year > 2008 AND year < 2020
GROUP BY slug, country, year
ORDER BY slug, country, year
);

GRANT ALL PRIVILEGES ON TABLE gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc TO ncses_oss;
