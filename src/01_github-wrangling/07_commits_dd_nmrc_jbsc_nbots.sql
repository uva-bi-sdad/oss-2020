-- create commits_dd_nmrc_jbsc_nbots as the deduped, debotted commits table
-- after bayoan's approach to removing the multi-repo commits
CREATE MATERIALIZED VIEW gh.commits_dd_nmrc_jbsc_nbots AS (
SELECT DISTINCT slug, committed_date, login, additions, deletions
FROM gh.commits_dd_nmrc_jbsc
WHERE login NOT IN (SELECT * FROM gh.bots_table));
