
--CREATES A SUMMARY TABLE OF INFO ON ALL REPOS

-- original data
CREATE MATERIALIZED VIEW gh.desc_repos_summary AS (
SELECT slug, COUNT(*) AS commits, COUNT(DISTINCT login) AS logins, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM gh.commits
GROUP BY slug
ORDER BY commits
);

-- deduped data
CREATE MATERIALIZED VIEW gh.desc_repos_summary_dd AS (
SELECT slug, COUNT(*) AS commits, COUNT(DISTINCT login) AS logins, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM gh.commits_dd
GROUP BY slug
ORDER BY commits
);
