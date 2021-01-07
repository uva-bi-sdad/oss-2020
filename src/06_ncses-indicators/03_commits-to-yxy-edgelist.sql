CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_yxy AS (

WITH A AS (
	SELECT login, slug, EXTRACT(YEAR FROM committed_date)::int AS year
	FROM gh.commits_raw
	WHERE login IS NOT NULL AND login != 'null' AND login NOT SIMILAR TO '(%bot|%-bot)' AND login NOT LIKE '%[bot]%'
	--LIMIT 100000
), B AS (
	SELECT slug, year, login, COUNT(*) AS commits
	FROM A
	GROUP BY slug, year, login
	--LIMIT 100000
), D AS (
	SELECT B.slug, B.year, B.login AS ctr1, C.login AS ctr2, B.commits
	FROM B
	INNER JOIN B AS C ON B.year = C.year
	WHERE B.login != C.login -- removes self-loops
), edgelist AS (
	SELECT ctr1, ctr2, year, COUNT(*) AS repo_wts
	FROM D
	GROUP BY ctr1, ctr2, year
)
SELECT * FROM edgelist
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_yxy_ctr1_idx ON gh.sna_ctr_edgelist_yxy (ctr1);
CREATE INDEX sna_ctr_edgelist_yxy_ctr2_idx ON gh.sna_ctr_edgelist_yxy (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_yxy TO ncses_oss;
