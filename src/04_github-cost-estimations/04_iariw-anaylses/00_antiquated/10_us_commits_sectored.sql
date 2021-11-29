
CREATE MATERIALIZED VIEW gh_cost.us_commits_sectored_110221 AS (

WITH sector_join AS (
SELECT A.slug, EXTRACT(YEAR FROM A.committed_date)::int AS year, A.additions, A.deletions, B.*
FROM gh.commits_dd_nmrc_jbsc A
LEFT JOIN gh_cost.sectored_fractioned_103121 AS B
ON A.login = B.login
WHERE is_us = TRUE )

SELECT * FROM sector_join );
