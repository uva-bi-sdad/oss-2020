

--- just glancing through this shows me that we need to use the company column to max out the geo column
SELECT A.login, COALESCE(A.sector, 'null/missing') AS sector, COALESCE(A.cc_viz, 'missing') AS country,
	   COALESCE(B.institution, 'missing') AS institution, COALESCE(B.country, 'Missing') AS inst_country,
	   A.repos, A.commits, A.additions, A.deletions
FROM gh.cost_logins_w_sector_info AS A
LEFT JOIN gh.sna_ctr_academic AS B
ON A.login = B.login
WHERE A.sector = 'academic'
LIMIT 100;



--------- not used

CREATE MATERIALIZED VIEW gh.cost_by_country_0819 AS (
WITH country_join AS (
SELECT slug, A.login, COALESCE(B.cc_viz, 'missing') AS country, A.additions, A.deletions,
                      EXTRACT(YEAR FROM A.committed_date)::int AS year
FROM gh.commits_raw A
LEFT JOIN gh.cost_logins_w_sector_info AS B
ON A.login = B.login
)

SELECT A.slug, A.country, A.commits AS geo_commits, A.additions AS geo_additions, A.deletions AS geo_deletions,
A.sum_adds_dels AS geo_sum, A.net_adds_dels AS geo_net, B.additions AS repo_additions
FROM (SELECT slug, country, COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions,
					SUM(additions + deletions) AS sum_adds_dels, SUM(additions - deletions) AS net_adds_dels
FROM country_join
WHERE year > 2008 AND year < 2020
GROUP BY slug, country) AS A
LEFT JOIN gh.cost_by_repo_0819 B
ON A.slug = B.slug
);

----- not used

CREATE MATERIALIZED VIEW gh.cost_by_sector_0819 AS (
WITH sector_join AS (
SELECT slug, A.login, COALESCE(B.sector, 'missing') AS sector, A.additions, A.deletions,
                      EXTRACT(YEAR FROM A.committed_date)::int AS year
FROM gh.commits_raw A
LEFT JOIN gh.cost_logins_w_sector_info AS B
ON A.login = B.login
)

SELECT A.slug, A.sector, A.commits AS sector_commits, A.additions AS sector_additions, A.deletions AS sector_deletions,
A.sum_adds_dels AS sector_sum, A.net_adds_dels AS sector_net, B.additions AS repo_additions
FROM (SELECT slug, sector, COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions,
					SUM(additions + deletions) AS sum_adds_dels, SUM(additions - deletions) AS net_adds_dels
FROM sector_join
WHERE year > 2008 AND year < 2020
GROUP BY slug, sector) AS A
LEFT JOIN gh.cost_by_repo_0819 B
ON A.slug = B.slug
);
















