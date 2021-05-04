-- step 1: create a large table of users committing to slugs each year (~12 mins)

CREATE MATERIALIZED VIEW gh.commits_per_user AS (

WITH A AS (
	SELECT login, slug, EXTRACT(YEAR FROM committed_date)::int AS year
	FROM gh.commits_raw
	WHERE login IS NOT NULL AND login != 'null'
), B AS (
	SELECT slug, year, login, COUNT(*) AS commits
	FROM A
	GROUP BY slug, year, login
)

SELECT login, commits, slug, year
FROM B
ORDER BY commits DESC

);

CREATE INDEX login_idx ON gh.commits_per_user (login);
GRANT ALL PRIVILEGES ON gh.commits_per_user TO ncses_oss;



