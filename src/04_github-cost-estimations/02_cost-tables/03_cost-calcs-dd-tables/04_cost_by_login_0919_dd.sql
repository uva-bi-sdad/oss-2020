
-- second, we want all the commits, additions, deletions, sum and net by login within repo for each year (2008-2019)

CREATE MATERIALIZED VIEW gh_cost.cost_by_login_0919_dd AS (
WITH commits_annual AS (
SELECT slug, login, additions, deletions, EXTRACT(YEAR FROM committed_date)::int AS year
FROM gh.commits_dd
)

SELECT slug, login, year, COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions,
					SUM(additions + deletions) AS sum_adds_dels, SUM(additions - deletions) AS net_adds_dels
FROM commits_annual
WHERE year > 2008 AND year < 2020
GROUP BY slug, login, year );

GRANT ALL PRIVILEGES ON TABLE gh_cost.cost_by_year_0919_dd TO ncses_oss;
