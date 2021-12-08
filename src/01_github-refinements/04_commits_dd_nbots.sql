
-- we want to control for the effect of bots in our studies
-- this is because it can severely bias the number of shared repos
-- (i.e. the edges in our collaboration networks) or the total
-- number of commits in our cost estimations


-- step 1: create a table with all the known bots
-- this info is taken from acctype in bayoan's scrape
-- and all of the logins with a "bot" at the end
CREATE MATERIALIZED VIEW gh.bots_table AS (
SELECT A.login
FROM gh.desc_ctrs_summary A -- update to commits_dd
LEFT JOIN gh_2007_2020.test_usr B
ON A.login = B.login
WHERE A.login SIMILAR TO '(%bot|%-bot)' OR A.login LIKE '%[bot]%' OR B.acctype = 'Bot');
-- this gives us a table of 3,337 total bots


-- step 2: create commits_dd_nbots as the deduped, debotted commits table
CREATE MATERIALIZED VIEW gh.commits_dd_nbots AS (
SELECT DISTINCT slug, committed_date, login, additions, deletions
FROM gh.commits_dd
WHERE login NOT IN (SELECT * FROM gh.bots_table));


-- bonus code in case filtering bots out is needed
-- creates a table with all the bots removed
SELECT *
FROM gh.____
WHERE login NOT IN (SELECT * FROM gh.bots_table);

-- filtering bots from edgelist
SELECT * FROM gh.____
WHERE ctr1 NOT IN (SELECT * FROM gh.bots_table)
  AND ctr2 NOT IN (SELECT * FROM gh.bots_table);
