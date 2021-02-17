--NEXT WE WANT TO CREATE A NODELIST WITH ATTRIBUTES FOR EACH YEAR (sna_ctr_nodelist_yxy)
--THIS TAKES THE EXACT SAME CODE AS THE LAST SNIPPET AND ADDS A YEAR TO THE GROUP_BY

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_yxy AS (

WITH C AS (
	SELECT B.slug, B.year,
           B.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user B
	INNER JOIN gh.commits_per_user AS C ON B.year = C.year AND B.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A and loops
	WHERE B.login < C.login AND B.login != C.login )

SELECT ctr1, ctr2, COUNT(*) AS repo_wts, year
FROM C
GROUP BY ctr1, ctr2, year
ORDER BY repo_wts DESC

);

CREATE INDEX sna_ctr_edgelist_yxy_ctr1_idx ON gh.sna_ctr_edgelist_yxy (ctr1);
CREATE INDEX sna_ctr_edgelist_yxy_ctr2_idx ON gh.sna_ctr_edgelist_yxy (ctr2);
GRANT ALL PRIVILEGES ON gh.sna_ctr_edgelist_yxy TO ncses_oss;
