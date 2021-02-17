
-- we need commits_per_user tables to run some of the cost estimations

-- gh.commits_per_user_dd
CREATE MATERIALIZED VIEW gh.commits_per_user_dd AS (

WITH A AS (
	SELECT login, slug, EXTRACT(YEAR FROM committed_date)::int AS year
	FROM gh.commits_dd
), B AS (
	SELECT slug, year, login, COUNT(*) AS commits
	FROM A
	GROUP BY slug, year, login
)

SELECT login, slug, commits, year
FROM B
ORDER BY commits DESC

);

CREATE INDEX login_dd_idx ON gh.commits_per_user_dd (login);
GRANT ALL PRIVILEGES ON gh.commits_per_user_dd TO ncses_oss;

-- gh.commits_per_user_nmrc

CREATE MATERIALIZED VIEW gh.commits_per_user_dd_nmrc AS (

WITH A AS (
	SELECT login, slug, EXTRACT(YEAR FROM committed_date)::int AS year
	FROM gh.commits_dd_nmrc
), B AS (
	SELECT slug, year, login, COUNT(*) AS commits
	FROM A
	GROUP BY slug, year, login
)

SELECT login, slug, commits, year
FROM B
ORDER BY commits DESC

);

CREATE INDEX login_dd_nmrc_idx ON gh.commits_per_user_dd_nmrc (login);
GRANT ALL PRIVILEGES ON gh.commits_per_user_dd_nmrc TO ncses_oss;
