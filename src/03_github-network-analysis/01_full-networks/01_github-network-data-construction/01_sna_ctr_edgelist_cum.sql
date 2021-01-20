
-- create a large table of users committing to slugs each year (~12 mins)

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

-- then delete all the previous tables

DROP MATERIALIZED VIEW gh.sna_ctr_edgelist_08;
DROP MATERIALIZED VIEW gh.sna_ctr_edgelist_0809;
DROP MATERIALIZED VIEW gh.sna_ctr_edgelist_0810;
DROP MATERIALIZED VIEW gh.sna_ctr_edgelist_0811;
DROP MATERIALIZED VIEW gh.sna_ctr_edgelist_0812;
DROP MATERIALIZED VIEW gh.sna_ctr_edgelist_0813;
DROP MATERIALIZED VIEW gh.sna_ctr_edgelist_0814;
DROP MATERIALIZED VIEW gh.sna_ctr_edgelist_0815;
DROP MATERIALIZED VIEW gh.sna_ctr_edgelist_0816;
DROP MATERIALIZED VIEW gh.sna_ctr_edgelist_0817;
DROP MATERIALIZED VIEW gh.sna_ctr_edgelist_0818;
DROP MATERIALIZED VIEW gh.sna_ctr_edgelist_0819;

-- then write all the new tables

-- 2008

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_08 AS (

WITH C AS (
	SELECT B.slug, B.year,
           B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A and loops
	WHERE B.login < C.login AND B.login != C.login
	-- cuts down table joins to certain yars
	AND B.YEAR = 2008 AND C.YEAR = 2008
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_08_ctr1_idx ON gh.sna_ctr_edgelist_08 (ctr1);
CREATE INDEX sna_ctr_edgelist_08_ctr2_idx ON gh.sna_ctr_edgelist_08 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_08 TO ncses_oss;

-- 2008-09

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_0809 AS (

WITH C AS (
	SELECT B.slug, B.year,
           B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A and loops
	WHERE B.login < C.login AND B.login != C.login
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2009 AND C.YEAR BETWEEN 2008 AND 2009
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_0809_ctr1_idx ON gh.sna_ctr_edgelist_0809 (ctr1);
CREATE INDEX sna_ctr_edgelist_0809_ctr2_idx ON gh.sna_ctr_edgelist_0809 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_0809 TO ncses_oss;

-- 2008-10

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_0810 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	WHERE B.login < C.login AND B.login != C.login
	AND B.YEAR BETWEEN 2008 AND 2010 AND C.YEAR BETWEEN 2008 AND 2010
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_0810_ctr1_idx ON gh.sna_ctr_edgelist_0810 (ctr1);
CREATE INDEX sna_ctr_edgelist_0810_ctr2_idx ON gh.sna_ctr_edgelist_0810 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_0810 TO ncses_oss;

-- 2008-11

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_0811 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	WHERE B.login < C.login AND B.login != C.login
	AND B.YEAR BETWEEN 2008 AND 2011 AND C.YEAR BETWEEN 2008 AND 2011
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_0811_ctr1_idx ON gh.sna_ctr_edgelist_0811 (ctr1);
CREATE INDEX sna_ctr_edgelist_0811_ctr2_idx ON gh.sna_ctr_edgelist_0811 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_0811 TO ncses_oss;

-- 2008-12

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_0812 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	WHERE B.login < C.login AND B.login != C.login
	AND B.YEAR BETWEEN 2008 AND 2012 AND C.YEAR BETWEEN 2008 AND 2012
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_0812_ctr1_idx ON gh.sna_ctr_edgelist_0812 (ctr1);
CREATE INDEX sna_ctr_edgelist_0812_ctr2_idx ON gh.sna_ctr_edgelist_0812 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_0812 TO ncses_oss;

-- 2008-13

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_0813 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	WHERE B.login < C.login AND B.login != C.login
	AND B.YEAR BETWEEN 2008 AND 2013 AND C.YEAR BETWEEN 2008 AND 2013
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_0813_ctr1_idx ON gh.sna_ctr_edgelist_0813 (ctr1);
CREATE INDEX sna_ctr_edgelist_0813_ctr2_idx ON gh.sna_ctr_edgelist_0813 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_0813 TO ncses_oss;

-- 2008-14

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_0814 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	WHERE B.login < C.login AND B.login != C.login
	AND B.YEAR BETWEEN 2008 AND 2014 AND C.YEAR BETWEEN 2008 AND 2014
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_0814_ctr1_idx ON gh.sna_ctr_edgelist_0814 (ctr1);
CREATE INDEX sna_ctr_edgelist_0814_ctr2_idx ON gh.sna_ctr_edgelist_0814 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_0814 TO ncses_oss;

-- 2008-15

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_0815 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	WHERE B.login < C.login AND B.login != C.login
	AND B.YEAR BETWEEN 2008 AND 2015 AND C.YEAR BETWEEN 2008 AND 2015
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_0815_ctr1_idx ON gh.sna_ctr_edgelist_0815 (ctr1);
CREATE INDEX sna_ctr_edgelist_0815_ctr2_idx ON gh.sna_ctr_edgelist_0815 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_0815 TO ncses_oss;

-- 2008-16

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_0816 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	WHERE B.login < C.login AND B.login != C.login
	AND B.YEAR BETWEEN 2008 AND 2016 AND C.YEAR BETWEEN 2008 AND 2016
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_0816_ctr1_idx ON gh.sna_ctr_edgelist_0816 (ctr1);
CREATE INDEX sna_ctr_edgelist_0816_ctr2_idx ON gh.sna_ctr_edgelist_0816 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_0816 TO ncses_oss;

-- 2008-17

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_0817 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	WHERE B.login < C.login AND B.login != C.login
	AND B.YEAR BETWEEN 2008 AND 2017 AND C.YEAR BETWEEN 2008 AND 2017
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_0817_ctr1_idx ON gh.sna_ctr_edgelist_0817 (ctr1);
CREATE INDEX sna_ctr_edgelist_0817_ctr2_idx ON gh.sna_ctr_edgelist_0817 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_0817 TO ncses_oss;

-- 2008-18

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_0818 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	WHERE B.login < C.login AND B.login != C.login
	AND B.YEAR BETWEEN 2008 AND 2018 AND C.YEAR BETWEEN 2008 AND 2018
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_0818_ctr1_idx ON gh.sna_ctr_edgelist_0818 (ctr1);
CREATE INDEX sna_ctr_edgelist_0818_ctr2_idx ON gh.sna_ctr_edgelist_0818 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_0818 TO ncses_oss;

-- 2008-19

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_0819 AS (

WITH C AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	WHERE B.login < C.login AND B.login != C.login
	AND B.YEAR BETWEEN 2008 AND 2019 AND C.YEAR BETWEEN 2008 AND 2019
)

SELECT ctr1, ctr2, COUNT(*) AS repo_wts
FROM C
GROUP BY ctr1, ctr2
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_0819_ctr1_idx ON gh.sna_ctr_edgelist_0819 (ctr1);
CREATE INDEX sna_ctr_edgelist_0819_ctr2_idx ON gh.sna_ctr_edgelist_0819 (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_0819 TO ncses_oss;




















