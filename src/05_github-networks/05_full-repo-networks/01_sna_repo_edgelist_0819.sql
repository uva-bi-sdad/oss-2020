
-- using the commits_per_user_raw table
-- takes 2-3 hours to finish

CREATE MATERIALIZED VIEW gh_sna.sna_repo_edgelist_0819 AS (

WITH C AS (
	SELECT B.login, B.year, B.slug AS repo1, C.slug AS repo2
	FROM gh.commits_per_user_raw B
	INNER JOIN gh.commits_per_user_raw AS C ON B.year = C.year AND B.login = C.login
	-- line below removes duplicate rows of A-B, B-A and loops
	WHERE B.slug < C.slug AND B.slug != C.slug
	-- cuts down table joins to certain yars
	AND B.YEAR BETWEEN 2008 AND 2019 AND C.YEAR BETWEEN 2008 AND 2019
	LIMIT 1000
)

SELECT repo1, repo2, COUNT(*) AS weight
FROM C
GROUP BY repo1, repo2
ORDER BY weight DESC
LIMIT 1000;

);

CREATE INDEX sna_repo_edgelist_08_repo1_idx ON gh_sna.sna_repo_edgelist_0819 (repo1);
CREATE INDEX sna_repo_edgelist_08_repo2_idx ON gh_sna.sna_repo_edgelist_0819 (repo2);
GRANT ALL PRIVILEGES ON gh_sna.sna_repo_edgelist_0819 TO ncses_oss;

