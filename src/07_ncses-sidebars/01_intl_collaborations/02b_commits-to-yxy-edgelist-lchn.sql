
-- creating the year by year edgelist is a two-part process
-- doing it all in one crack took so long that pgadmin timed out

-- step 1: create a large table of users committing to slugs each year (~25 mins)

CREATE MATERIALIZED VIEW gh.commits_per_user_dd_lchn_nn AS (

WITH A AS (
	SELECT login, slug, EXTRACT(YEAR FROM committed_date)::int AS year
	FROM gh.commits_dd_nmrc_jbsc_nbots
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

CREATE INDEX login_lchn_idx ON gh.commits_per_user_dd_lchn_nbots (login);
GRANT ALL PRIVILEGES ON gh.commits_per_user_dd_lchn_nbots TO ncses_oss;

-- step 2: this creates the edgelist (previously missing the distinct on slug)

CREATE MATERIALIZED VIEW gh_sna.sna_ctr_edgelist_yxy AS (
	WITH D AS (
	SELECT Z.slug, Z.year, Z.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_dd_lchn_nn Z
	INNER JOIN gh.commits_per_user_dd_lchn_nn AS C ON Z.year = C.year AND Z.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A and loops
	WHERE Z.login < C.login AND Z.login != C.login )

SELECT ctr1, ctr2, COUNT(*) AS repo_wts, year
FROM D
GROUP BY ctr1, ctr2, year
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_yxy_ctr1_idx ON gh_sna.sna_ctr_edgelist_yxy (ctr1);
CREATE INDEX sna_ctr_edgelist_yxy_ctr2_idx ON gh_sna.sna_ctr_edgelist_yxy (ctr2);
GRANT ALL PRIVILEGES ON gh_sna.sna_ctr_edgelist_yxy TO ncses_oss;
