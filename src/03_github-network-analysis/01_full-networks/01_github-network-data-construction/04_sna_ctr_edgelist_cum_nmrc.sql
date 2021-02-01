
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
FROM gh.commits_reduced
WHERE slugs > 1 AND login IS NOT NULL AND login != 'null'
LIMIT 100;

-- wow! looks like more than 39.5 million commits went to more than one repo

SELECT COUNT(*)
FROM gh.commits_reduced
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


-- to delete tables if needed

drop materialized view gh.sna_ctr_edgelist_nmrc_08;
drop materialized view gh.sna_ctr_edgelist_nmrc_0809;
drop materialized view gh.sna_ctr_edgelist_nmrc_0810;
drop materialized view gh.sna_ctr_edgelist_nmrc_0811;
drop materialized view gh.sna_ctr_edgelist_nmrc_0812;
drop materialized view gh.sna_ctr_edgelist_nmrc_0813;
drop materialized view gh.sna_ctr_edgelist_nmrc_0814;
drop materialized view gh.sna_ctr_edgelist_nmrc_0815;
drop materialized view gh.sna_ctr_edgelist_nmrc_0816;
drop materialized view gh.sna_ctr_edgelist_nmrc_0817;
drop materialized view gh.sna_ctr_edgelist_nmrc_0818;
drop materialized view gh.sna_ctr_edgelist_nmrc_0819;



-- then we can create the networks from that view (left off here 4:46 pm)

-- 2008

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_nmrc_08 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_nmrc B
	INNER JOIN gh.commits_per_user_nmrc AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A
	WHERE B.login <= C.login
	-- cuts down table joins to certain yars
	AND B.YEAR = 2008 AND C.YEAR = 2008
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_nmrc_08_ctr1_idx ON gh.sna_ctr_edgelist_nmrc_08 (ctr1);
CREATE INDEX sna_ctr_edgelist_nmrc_08_ctr2_idx ON gh.sna_ctr_edgelist_nmrc_08 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_nmrc_08 TO ncses_oss;

-- 2008-09

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_nmrc_0809 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_nmrc B
	INNER JOIN gh.commits_per_user_nmrc AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A
	WHERE B.login <= C.login
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2009 AND C.YEAR BETWEEN 2008 AND 2009
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_nmrc_0809_ctr1_idx ON gh.sna_ctr_edgelist_nmrc_0809 (ctr1);
CREATE INDEX sna_ctr_edgelist_nmrc_0809_ctr2_idx ON gh.sna_ctr_edgelist_nmrc_0809 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_nmrc_0809 TO ncses_oss;

-- 2008-10

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_nmrc_0810 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_nmrc B
	INNER JOIN gh.commits_per_user_nmrc AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A
	WHERE B.login <= C.login
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2010 AND C.YEAR BETWEEN 2008 AND 2010
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_nmrc_0810_ctr1_idx ON gh.sna_ctr_edgelist_nmrc_0810 (ctr1);
CREATE INDEX sna_ctr_edgelist_nmrc_0810_ctr2_idx ON gh.sna_ctr_edgelist_nmrc_0810 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_nmrc_0810 TO ncses_oss;

-- 2008-11

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_nmrc_0811 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_nmrc B
	INNER JOIN gh.commits_per_user_nmrc AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A
	WHERE B.login <= C.login
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2011 AND C.YEAR BETWEEN 2008 AND 2011
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_nmrc_0811_ctr1_idx ON gh.sna_ctr_edgelist_nmrc_0811 (ctr1);
CREATE INDEX sna_ctr_edgelist_nmrc_0811_ctr2_idx ON gh.sna_ctr_edgelist_nmrc_0811 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_nmrc_0811 TO ncses_oss;

-- 2008-12

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_nmrc_0812 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_nmrc B
	INNER JOIN gh.commits_per_user_nmrc AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A
	WHERE B.login <= C.login
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2012 AND C.YEAR BETWEEN 2008 AND 2012
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_nmrc_0812_ctr1_idx ON gh.sna_ctr_edgelist_nmrc_0812 (ctr1);
CREATE INDEX sna_ctr_edgelist_nmrc_0812_ctr2_idx ON gh.sna_ctr_edgelist_nmrc_0812 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_nmrc_0812 TO ncses_oss;

-- 2008-13

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_nmrc_0813 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_nmrc B
	INNER JOIN gh.commits_per_user_nmrc AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A
	WHERE B.login <= C.login
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2013 AND C.YEAR BETWEEN 2008 AND 2013
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_nmrc_0813_ctr1_idx ON gh.sna_ctr_edgelist_nmrc_0813 (ctr1);
CREATE INDEX sna_ctr_edgelist_nmrc_0813_ctr2_idx ON gh.sna_ctr_edgelist_nmrc_0813 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_nmrc_0813 TO ncses_oss;

-- 2008-14

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_nmrc_0814 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_nmrc B
	INNER JOIN gh.commits_per_user_nmrc AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A
	WHERE B.login <= C.login
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2014 AND C.YEAR BETWEEN 2008 AND 2014
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_nmrc_0814_ctr1_idx ON gh.sna_ctr_edgelist_nmrc_0814 (ctr1);
CREATE INDEX sna_ctr_edgelist_nmrc_0814_ctr2_idx ON gh.sna_ctr_edgelist_nmrc_0814 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_nmrc_0814 TO ncses_oss;

-- 2008-15

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_nmrc_0815 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_nmrc B
	INNER JOIN gh.commits_per_user_nmrc AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A
	WHERE B.login <= C.login
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2015 AND C.YEAR BETWEEN 2008 AND 2015
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_nmrc_0815_ctr1_idx ON gh.sna_ctr_edgelist_nmrc_0815 (ctr1);
CREATE INDEX sna_ctr_edgelist_nmrc_0815_ctr2_idx ON gh.sna_ctr_edgelist_nmrc_0815 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_nmrc_0815 TO ncses_oss;

-- 2008-16

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_nmrc_0816 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_nmrc B
	INNER JOIN gh.commits_per_user_nmrc AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A
	WHERE B.login <= C.login
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2016 AND C.YEAR BETWEEN 2008 AND 2016
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_nmrc_0816_ctr1_idx ON gh.sna_ctr_edgelist_nmrc_0816 (ctr1);
CREATE INDEX sna_ctr_edgelist_nmrc_0816_ctr2_idx ON gh.sna_ctr_edgelist_nmrc_0816 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_nmrc_0816 TO ncses_oss;

-- 2008-17

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_nmrc_0817 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_nmrc B
	INNER JOIN gh.commits_per_user_nmrc AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A
	WHERE B.login <= C.login
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2017 AND C.YEAR BETWEEN 2008 AND 2017
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_nmrc_0817_ctr1_idx ON gh.sna_ctr_edgelist_nmrc_0817 (ctr1);
CREATE INDEX sna_ctr_edgelist_nmrc_0817_ctr2_idx ON gh.sna_ctr_edgelist_nmrc_0817 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_nmrc_0817 TO ncses_oss;

-- 2008-18

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_nmrc_0818 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_nmrc B
	INNER JOIN gh.commits_per_user_nmrc AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A
	WHERE B.login <= C.login
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2018 AND C.YEAR BETWEEN 2008 AND 2018
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_nmrc_0818_ctr1_idx ON gh.sna_ctr_edgelist_nmrc_0818 (ctr1);
CREATE INDEX sna_ctr_edgelist_nmrc_0818_ctr2_idx ON gh.sna_ctr_edgelist_nmrc_0818 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_nmrc_0818 TO ncses_oss;

-- 2008-19

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_nmrc_0819 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_nmrc B
	INNER JOIN gh.commits_per_user_nmrc AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A
	WHERE B.login <= C.login
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2019 AND C.YEAR BETWEEN 2008 AND 2019
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_nmrc_0819_ctr1_idx ON gh.sna_ctr_edgelist_nmrc_0819 (ctr1);
CREATE INDEX sna_ctr_edgelist_nmrc_0819_ctr2_idx ON gh.sna_ctr_edgelist_nmrc_0819 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_nmrc_0819 TO ncses_oss;









