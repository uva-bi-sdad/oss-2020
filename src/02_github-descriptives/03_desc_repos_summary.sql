
--CREATES A SUMMARY TABLE OF INFO ON ALL REPOS

-- original data
CREATE MATERIALIZED VIEW gh.desc_repos_summary AS (
SELECT slug, COUNT(*) AS commits, COUNT(DISTINCT login) AS logins,
  SUM(additions) AS additions, SUM(deletions) AS deletions
FROM gh.commits
GROUP BY slug
ORDER BY commits
);

-- longest_chain refinement / repo summary
CREATE MATERIALIZED VIEW gh.desc_repos_summary_dd_lchn AS (
SELECT slug, COUNT(*) AS commits, COUNT(DISTINCT login) AS logins,
	SUM(additions) AS additions, SUM(deletions) AS deletions
FROM gh.commits_dd_nmrc_jbsc
GROUP BY slug
ORDER BY commits
);
