
-- in this file, we examine the impact of duplicates in the commits_raw data
-- bayoan scraped all of the commits_raw data, but used the nodeID and the sha1/oid
-- while he started off with the sha1, he eventually realized that the nodeID was
-- a more effective strategy and transitioned to that for the majority of scraping

-- step 1: create commits_dd as the deduplicated commits_raw table

CREATE MATERIALIZED VIEW gh.commits_dd AS (
SELECT DISTINCT slug, committed_date, login, additions, deletions
FROM gh.commits_raw );
-- took just over an hour to write

-- step 2: compare the counts of commits_raw and commits_dd

SELECT COUNT(*) FROM gh.commits_raw
-- yields a total of 889,977,032  "distinct" commits and

SELECT COUNT(*) FROM gh.commits_dd
-- yields a total of 778,804,586 distinct commits
-- this means that there were 111,172,446 (12.5%) scraping errors before 2021-02-15





