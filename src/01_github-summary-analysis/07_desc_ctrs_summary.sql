--First, we have to write a desc_ctrs_summary table to the database...

CREATE MATERIALIZED VIEW gh.desc_ctrs_summary AS (
SELECT login, COUNT(DISTINCT slug) AS repos, COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM gh.commits_raw
GROUP BY login
);
