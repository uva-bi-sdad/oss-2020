
-- second, we want all the commits, additions, deletions, sum and net by year (2019)
-- this is not by login/year - just by year

CREATE MATERIALIZED VIEW gh_cost.cost_by_year_0919_dd_nmrc_nbots AS (
WITH commits_annual AS (
SELECT slug, login, additions, deletions, EXTRACT(YEAR FROM committed_date)::int AS year
FROM gh.commits_dd_nmrc_nbots
)

SELECT slug, year, COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions,
					SUM(additions + deletions) AS sum_adds_dels, SUM(additions - deletions) AS net_adds_dels
FROM commits_annual
WHERE year > 2008 AND year < 2020
GROUP BY slug, year );

GRANT ALL PRIVILEGES ON TABLE gh_cost.cost_by_year_0919_dd_nmrc_nbots TO ncses_oss;
