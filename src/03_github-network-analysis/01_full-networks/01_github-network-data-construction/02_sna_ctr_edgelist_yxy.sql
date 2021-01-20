-- creating the year by year edgelist is a two-part process
-- doing it all in one crack took so long that pgadmin timed out

-- step 1: create a large table of users committing to slugs each year (~25 mins)

-- step 2: this creates the edgelist (previously missing the distinct on slug)

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_yxy AS (
	WITH D AS (
	SELECT commits_per_user.slug, commits_per_user.year,
           commits_per_user.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user
	INNER JOIN gh.commits_per_user AS C ON commits_per_user.year = C.year AND commits_per_user.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A and loops
	WHERE commits_per_user.login < C.login AND commits_per_user.login != C.login )

SELECT ctr1, ctr2, COUNT(*) AS repo_wts, year
FROM D
GROUP BY ctr1, ctr2, year
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_yxy_ctr1_idx ON gh.sna_ctr_edgelist_yxy (ctr1);
CREATE INDEX sna_ctr_edgelist_yxy_ctr2_idx ON gh.sna_ctr_edgelist_yxy (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_yxy TO ncses_oss;
