-- this cuts out all of the commits that were in more than

CREATE MATERIALIZED VIEW gh.commits_per_repo AS (
WITH filtered_table AS (
	SELECT DISTINCT login, committed_date, additions, deletions, slug
	FROM gh.commits_raw
)
SELECT login, committed_date, additions, deletions, COUNT(*) AS slugs
FROM filtered_table
GROUP BY login, committed_date, additions, deletions
);

-- then let's see how many commits go to more than one repo

SELECT COUNT(*)
FROM gh.commits_per_repo
WHERE slugs > 1 AND login IS NOT NULL AND login != 'null'
LIMIT 100;

-- wow! looks like more than 39.5 million commits went to more than one repo

SELECT COUNT(*)
FROM gh.commits_per_repo
WHERE slugs = 1 AND login IS NOT NULL AND login != 'null'
LIMIT 100;

-- that leaves us with about 220 million commits left in the data

-- so lets join that information together with the slug info from commits_raw (producing commits_filtered)

create materialized view gh.commits_nmrc as (
	select B.slug, A.login, A.committed_date, A.additions, A.deletions, A.slugs AS commits_to_repo
	from gh.commits_per_repo A
	left join gh.commits_raw B
	on  A.login = B.login and A.committed_date = B.committed_date
	and A.additions = B.additions and A.deletions = B.deletions
	where A.slugs = 1 and A.login is not NULL and A.login != 'null'
);

-- and then created our commits_per_user_filtered

CREATE MATERIALIZED VIEW gh.commits_per_user_nmrc AS (

WITH A AS (
	SELECT login, slug, EXTRACT(YEAR FROM committed_date)::int AS year
	FROM gh.commits_nmrc
	WHERE login IS NOT NULL AND login != 'null'
	LIMIT 100
), B AS (
	SELECT slug, year, login, COUNT(*) AS commits
	FROM A
	GROUP BY slug, year, login
	LIMIT 100
)

SELECT login, slug, commits, year
FROM B
ORDER BY commits DESC
LIMIT 100;

);

CREATE INDEX login_nmrc_idx ON gh.commits_per_user_nmrc (login);
GRANT ALL PRIVILEGES ON gh.commits_per_user_nmrc TO ncses_oss;
