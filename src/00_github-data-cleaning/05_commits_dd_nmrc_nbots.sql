
-- first, run all the code in the 03_commits_dd_nmrc.sql file

-- next, run this to get the gh.commits_dd_nmrc_nbots view

CREATE MATERIALIZED VIEW gh.commits_dd_nmrc_nbots AS (
SELECT DISTINCT slug, committed_date, login, additions, deletions
FROM gh.commits_dd_nmrc
WHERE login NOT IN (SELECT * FROM gh.bots_table)
);
