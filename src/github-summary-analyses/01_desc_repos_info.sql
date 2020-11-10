--CREATES SUMMARY TABLE FOR NEW REPOS OVER TIME

CREATE MATERIALIZED VIEW gh.desc_repos_info AS (
SELECT slug, spdx, created
FROM gh.repos
WHERE status = 'DONE'
ORDER BY slug ASC
);
