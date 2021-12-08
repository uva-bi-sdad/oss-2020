
-- we need commits_per_user tables to run some of the cost estimations

-- gh.commits_per_user
CREATE MATERIALIZED VIEW gh_cost.commits_per_user AS (

WITH A AS (
	SELECT login, slug, EXTRACT(YEAR FROM committed_date)::int AS year
	FROM gh.commits_raw
	WHERE login IS NOT NULL AND login != 'null'
), B AS (
	SELECT slug, year, login, COUNT(*) AS commits
	FROM A
	GROUP BY slug, year, login
)

SELECT login, slug, commits, year
FROM B
ORDER BY commits DESC

);

CREATE INDEX login_cpu_idx ON gh_cost.commits_per_user (login);
GRANT ALL PRIVILEGES ON gh_cost.commits_per_user TO ncses_oss;


