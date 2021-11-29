CREATE MATERIALIZED VIEW gh_cost.cost_by_sector_annual_0919_103121_nonus AS (
WITH sector_join AS (
SELECT slug, A.login, A.additions, A.deletions,
EXTRACT(YEAR FROM A.committed_date)::int AS year, B.company,
	COALESCE(B.organization, 'Missing') AS organization,
	COALESCE(B.sector_count, 0) AS sector_count,
	COALESCE(B.in_us, 0) AS in_us,
	COALESCE(B.country, 'Missing') AS country,
	COALESCE(B.nonus_academic, 0) AS nonus_academic,
	COALESCE(B.nonus_business, 0) AS nonus_business,
	COALESCE(B.nonus_gov, 0) AS nonus_gov,
	COALESCE(B.nonus_nonprofit, 0) AS nonus_nonprofit,
	COALESCE(B.nonus_household, 0) AS nonus_household
  FROM gh.commits_dd_nmrc_jbsc A
  LEFT JOIN gh_cost.sectored_fractioned_103121 AS B
  ON A.login = B.login
  --LIMIT 1000
), sectored_additions AS (
  SELECT slug, login, year, additions,
  (additions * nonus_academic) as academic_adds,
  (additions * nonus_business) as business_adds,
  (additions * nonus_gov) as gov_adds,
  (additions * nonus_nonprofit) as nonprofit_adds,
  (additions * nonus_household) as household_adds
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

