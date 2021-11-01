CREATE MATERIALIZED VIEW gh_cost.cost_by_sector_annual_0919_103121b AS (
WITH sector_join AS (
SELECT slug, A.login, A.additions, A.deletions,
EXTRACT(YEAR FROM A.committed_date)::int AS year, B.company,
	COALESCE(B.organization, 'Missing') AS organization,
	COALESCE(B.sector_count, 0) AS sector_count,
	COALESCE(B.in_us, 0) AS in_us,
	COALESCE(B.us_academic, 0) AS us_academic,
	COALESCE(B.us_business, 0) AS us_business,
	COALESCE(B.us_gov, 0) AS us_gov,
	COALESCE(B.us_nonprofit, 0) AS us_nonprofit,
	COALESCE(B.us_household, 0) AS us_household
  FROM gh.commits_dd_nmrc_jbsc A
  LEFT JOIN gh_cost.sectored_fractioned_103121 AS B
  ON A.login = B.login
  WHERE country = 'United States'
  --LIMIT 100000
), sectored_additions AS (
  SELECT slug, login, year, additions,
  (additions * us_academic) as academic_adds,
  (additions * us_business) as business_adds,
  (additions * us_gov) as gov_adds,
  (additions * us_nonprofit) as nonprofit_adds,
  (additions * us_household) as household_adds
  FROM sector_join WHERE year > 2008 AND year < 2020
), with_other_adds AS (
  SELECT slug, login, year, additions,
  academic_adds, business_adds, gov_adds, nonprofit_adds, household_adds,
  (additions - (academic_adds+business_adds+gov_adds+nonprofit_adds+household_adds)) as other_adds
  FROM sectored_additions
)

SELECT year,
SUM(academic_adds) AS academic_additions,
SUM(business_adds) AS business_additions,
SUM(gov_adds) AS gov_additions,
SUM(nonprofit_adds) AS nonprofit_additions,
SUM(household_adds) AS household_additions,
SUM(other_adds) AS nonsectored_additions,
SUM(additions) AS total_additions
FROM with_other_adds
GROUP BY year
ORDER BY year );

