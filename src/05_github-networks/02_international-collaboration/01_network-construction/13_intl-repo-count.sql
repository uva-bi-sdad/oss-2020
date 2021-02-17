

-- provides the total repos when filtered by country_code

WITH A AS (
SELECT commits_pre.login, slug, country_code
FROM gh.commits_pre
INNER JOIN github.users_gh_cc
ON commits_pre.login = users_gh_cc.login
WHERE users_gh_cc.login IS NOT NULL AND EXTRACT(YEAR FROM committed_date)::int > 2007
)
SELECT COUNT(DISTINCT(slug))
FROM A;

-- The node counts (for any given year) can be found by using the net-analysis files or by using the net-summary file.
