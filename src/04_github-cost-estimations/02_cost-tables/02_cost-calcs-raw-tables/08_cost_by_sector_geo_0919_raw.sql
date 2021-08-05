
-----fifth, we want to count academic institutions within the us

CREATE MATERIALIZED VIEW gh_cost.cost_by_sector_geo_0919_raw AS (
WITH table_join AS (
SELECT slug, C.login, COALESCE(sector, 'null/missing') AS sector,
		COALESCE(country, 'Missing') AS inst_country,
		additions, deletions, EXTRACT(YEAR FROM committed_date)::int AS year
FROM gh.commits_raw AS C
LEFT JOIN (SELECT A.login, A.sector, B.country
FROM gh_cost.cost_logins_w_sector_info AS A
LEFT JOIN gh.sna_ctr_academic AS B
ON A.login = B.login ) AS D
ON C.login = D.login
)

SELECT slug, sector, inst_country, COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions,
					SUM(additions + deletions) AS sum_adds_dels, SUM(additions - deletions) AS net_adds_dels
FROM table_join
WHERE year > 2008 AND year < 2020
GROUP BY slug, sector, inst_country
ORDER BY slug, sector, inst_country
);

GRANT ALL PRIVILEGES ON TABLE gh.cost_by_sector_geo_0919_raw TO ncses_oss;
