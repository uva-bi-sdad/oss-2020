--First, we have to write a desc_ctrs_summary table to the database...

--- original data
CREATE MATERIALIZED VIEW gh.desc_ctrs_summary AS (
SELECT login, COUNT(DISTINCT slug) AS repos, COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM gh.commits_raw
GROUP BY login
);

--- dedeuped data
CREATE MATERIALIZED VIEW gh.desc_ctrs_summary_dd AS (
SELECT login, COUNT(DISTINCT slug) AS repos,
    COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM gh.commits_dd
GROUP BY login
);
