-- first, we want all the commits, additions, deletions, sum and net by repo (2008-2019)

CREATE MATERIALIZED VIEW gh_cost.cost_by_repo_0919_dd_nmrc_jbsc AS (
WITH commits_annual AS (
SELECT slug, login, additions, deletions, EXTRACT(YEAR FROM committed_date)::int AS year
FROM gh.commits_dd_nmrc_jbsc
)

SELECT slug, COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions,
					SUM(additions + deletions) AS sum_adds_dels, SUM(additions - deletions) AS net_adds_dels
FROM commits_annual
WHERE year > 2008 AND year < 2020
GROUP BY slug
);

GRANT ALL PRIVILEGES ON TABLE gh_cost.cost_by_repo_0919_dd_nmrc_jbsc TO ncses_oss;
