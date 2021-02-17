--Next, let's look at descriptives per contributor.
--First, we have to write a desc_ctrs_summary table to the database...

--- original data
CREATE MATERIALIZED VIEW gh.desc_owners_summary AS (
SELECT split_part(slug, '/', 1) AS owner, COUNT(DISTINCT slug) AS repos,
      COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM gh.commits_raw
GROUP BY owner
);

--- dedeuped data
CREATE MATERIALIZED VIEW gh.desc_owners_summary AS (
SELECT split_part(slug, '/', 1) AS owner, COUNT(DISTINCT slug) AS repos,
      COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM gh.commits_dd
GROUP BY owner
);
