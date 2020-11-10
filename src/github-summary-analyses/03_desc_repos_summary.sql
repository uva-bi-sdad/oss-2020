--CREATES A SUMMARY TABLE OF INFO ON ALL REPOS

CREATE MATERIALIZED VIEW gh.desc_repos_summary AS (
SELECT slug, COUNT(*) AS commits, COUNT(DISTINCT login) AS logins, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM gh.commits_pre
GROUP BY slug
);
