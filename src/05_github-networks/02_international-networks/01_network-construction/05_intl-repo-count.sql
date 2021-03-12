

-- provides the total repos when filtered by country_code

WITH ctry_commits AS (
	SELECT a.*, b.country_name
	FROM gh.commits_dd_nmrc_jbsc A
	INNER JOIN gh_sna.sna_ctr_ctry_codes B
	ON A.login = B.login
	--LIMIT 100
)

SELECT COUNT(DISTINCT(login))
FROM ctry_commits;
-- 739,039 users

SELECT COUNT(DISTINCT(slug))
FROM ctry_commits;
-- 3,491,800 slugs

SELECT COUNT(DISTINCT(login))
FROM gh.commits_dd_nmrc_jbsc;
-- 3,260,612 users
-- 739039 / 3260612 = 0.2266565

SELECT COUNT(DISTINCT(slug))
FROM gh.commits_dd_nmrc_jbsc;
-- 7,628,101 slugs
