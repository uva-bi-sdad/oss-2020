CREATE MATERIALIZED VIEW gh_cost.cost_by_sector_us_annual_0919_110221 AS (
WITH sector_join AS (
SELECT slug, A.login, A.additions, A.deletions,
EXTRACT(YEAR FROM A.committed_date)::int AS year, B.company,
	COALESCE(B.country, 'Missing') AS country,
	COALESCE(B.organization, 'Missing') AS organization,
	COALESCE(B.us_academic, 0) AS us_academic,
	COALESCE(B.us_business, 0) AS us_business,
	COALESCE(B.us_gov, 0) AS us_gov,
	COALESCE(B.us_nonprofit, 0) AS us_nonprofit,
	COALESCE(B.us_household, 0) AS us_household
  	FROM gh.commits_dd_nmrc_jbsc A
 	LEFT JOIN gh_cost.sectored_fractioned_103121 AS B
  	ON A.login = B.login
	WHERE country = 'United States'
	--LIMIT 10000
), sectored_additions AS (
  SELECT slug, login, year, organization, country, additions,
  (additions * us_academic) as academic_adds,
  (additions * us_business) as business_adds,
  (additions * us_gov) as gov_adds,
  (additions * us_nonprofit) as nonprofit_adds,
  (additions * us_household) as household_adds
  FROM sector_join WHERE year > 2008 AND year < 2020
), with_other_adds AS (
  SELECT slug, login, year, organization, country, additions,
  academic_adds, business_adds, gov_adds, nonprofit_adds, household_adds,
  (additions - (academic_adds+business_adds+gov_adds+nonprofit_adds+household_adds)) as other_adds
  FROM sectored_additions
)

SELECT year,
SUM(academic_adds) AS us_academic_additions,
SUM(business_adds) AS us_business_additions,
SUM(gov_adds) AS us_gov_additions,
SUM(nonprofit_adds) AS us_nonprofit_additions,
SUM(household_adds) AS us_household_additions,
SUM(other_adds) AS us_nonsectored_additions,
SUM(additions) AS us_total_additions
FROM with_other_adds
GROUP BY year
ORDER BY year );

---

CREATE MATERIALIZED VIEW gh_cost.cost_by_sector_frgn_annual_0919_110221 AS (
WITH sector_join AS (
SELECT slug, A.login, A.additions, A.deletions,
EXTRACT(YEAR FROM A.committed_date)::int AS year, B.company,
	COALESCE(B.country, 'Missing') AS country,
	COALESCE(B.organization, 'Missing') AS organization,
	COALESCE(B.us_academic, 0) AS us_academic,
	COALESCE(B.us_business, 0) AS us_business,
	COALESCE(B.us_gov, 0) AS us_gov,
	COALESCE(B.us_nonprofit, 0) AS us_nonprofit,
	COALESCE(B.us_household, 0) AS us_household
  	FROM gh.commits_dd_nmrc_jbsc A
 	LEFT JOIN gh_cost.sectored_fractioned_103121 AS B
  	ON A.login = B.login
	WHERE country != 'United States' AND country != 'Missing'
	--LIMIT 10000
), sectored_additions AS (
  SELECT slug, login, year, organization, country, additions,
  (additions * us_academic) as academic_adds,
  (additions * us_business) as business_adds,
  (additions * us_gov) as gov_adds,
  (additions * us_nonprofit) as nonprofit_adds,
  (additions * us_household) as household_adds
  FROM sector_join WHERE year > 2008 AND year < 2020
), with_other_adds AS (
  SELECT slug, login, year, organization, country, additions,
  academic_adds, business_adds, gov_adds, nonprofit_adds, household_adds,
  (additions - (academic_adds+business_adds+gov_adds+nonprofit_adds+household_adds)) as other_adds
  FROM sectored_additions
)

SELECT year,
SUM(academic_adds) AS frgn_academic_additions,
SUM(business_adds) AS frgn_business_additions,
SUM(gov_adds) AS frgn_gov_additions,
SUM(nonprofit_adds) AS frgn_nonprofit_additions,
SUM(household_adds) AS frgn_household_additions,
SUM(other_adds) AS frgn_nonsectored_additions,
SUM(additions) AS frgn_total_additions
FROM with_other_adds
GROUP BY year
ORDER BY year );


---

CREATE MATERIALIZED VIEW gh_cost.cost_by_sector_na_annual_0919_110221 AS (
WITH sector_join AS (
SELECT slug, A.login, A.additions, A.deletions,
EXTRACT(YEAR FROM A.committed_date)::int AS year, B.company,
	COALESCE(B.country, 'Missing') AS country,
	COALESCE(B.organization, 'Missing') AS organization,
	COALESCE(B.us_academic, 0) AS us_academic,
	COALESCE(B.us_business, 0) AS us_business,
	COALESCE(B.us_gov, 0) AS us_gov,
	COALESCE(B.us_nonprofit, 0) AS us_nonprofit,
	COALESCE(B.us_household, 0) AS us_household
  	FROM gh.commits_dd_nmrc_jbsc A
 	LEFT JOIN gh_cost.sectored_fractioned_103121 AS B
  	ON A.login = B.login
	WHERE country == 'Missing'
	--LIMIT 10000
), sectored_additions AS (
  SELECT slug, login, year, organization, country, additions,
  (additions * us_academic) as academic_adds,
  (additions * us_business) as business_adds,
  (additions * us_gov) as gov_adds,
  (additions * us_nonprofit) as nonprofit_adds,
  (additions * us_household) as household_adds
  FROM sector_join WHERE year > 2008 AND year < 2020
), with_other_adds AS (
  SELECT slug, login, year, organization, country, additions,
  academic_adds, business_adds, gov_adds, nonprofit_adds, household_adds,
  (additions - (academic_adds+business_adds+gov_adds+nonprofit_adds+household_adds)) as other_adds
  FROM sectored_additions
)

SELECT year,
SUM(academic_adds) AS na_academic_additions,
SUM(business_adds) AS na_business_additions,
SUM(gov_adds) AS na_gov_additions,
SUM(nonprofit_adds) AS na_nonprofit_additions,
SUM(household_adds) AS na_household_additions,
SUM(other_adds) AS na_nonsectored_additions,
SUM(additions) AS na_total_additions
FROM with_other_adds
GROUP BY year
ORDER BY year );
