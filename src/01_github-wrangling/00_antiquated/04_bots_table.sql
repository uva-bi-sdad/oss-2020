
-- creates a table with all the bots
CREATE MATERIALIZED VIEW gh.bots_table AS (
SELECT A.login
FROM gh.desc_ctrs_summary A -- update to commits_dd
LEFT JOIN gh_2007_2020.test_usr B
ON A.login = B.login
WHERE A.login SIMILAR TO '(%bot|%-bot)' OR A.login LIKE '%[bot]%' OR B.acctype = 'Bot');

-- creates a table with all the bots removed
SELECT *
FROM gh.____
WHERE login NOT IN (SELECT * FROM gh.bots_table);

-- filtering bots from edgelist
SELECT * FROM gh.____
WHERE ctr1 NOT IN (SELECT * FROM gh.bots_table)
  AND ctr2 NOT IN (SELECT * FROM gh.bots_table);
