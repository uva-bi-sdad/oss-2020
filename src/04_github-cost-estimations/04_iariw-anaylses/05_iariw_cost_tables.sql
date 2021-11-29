
-- first sequence

-- run
with commits_alt as (
select slug, EXTRACT(YEAR FROM A.committed_date)::int AS year, login, additions
from gh.commits_dd_nmrc_jbsc A )
select sum(additions)
from commits_alt
where year > 2008 AND year < 2020
-- to get 654786581008 total additions
--        654786581007.919
-- this is what we need to sum to after each table is made

CREATE MATERIALIZED VIEW gh_cost.cost_by_country_yr_0919_lchn_frac_110621 AS (
WITH sector_join AS (
SELECT slug, A.login, COALESCE(B.country, 'Missing') AS country, A.additions, A.deletions,
	EXTRACT(YEAR FROM A.committed_date)::int AS year, COALESCE(B.fraction, 1) AS fraction
FROM gh.commits_dd_nmrc_jbsc A
LEFT JOIN gh_cost.users_geo_102021 AS B
ON A.login = B.login
--limit 10000
), fraction_join AS (
SELECT slug, country, year, fraction, additions, (fraction*additions) AS frac_additions
FROM sector_join
WHERE year > 2008 AND year < 2020)

SELECT slug, country, year, SUM(frac_additions) AS frac_additions
FROM fraction_join
WHERE year > 2008 AND year < 2020
GROUP BY slug, country, year
ORDER BY slug, country, year );
select sum(frac_additions) from gh_cost.cost_by_country_yr_0919_lchn_frac_110621
-- 654786581007.995


CREATE MATERIALIZED VIEW gh_cost.cost_us_frac_by_sector_0919_lchn_110621 AS (
WITH sector_join AS (
SELECT slug, A.login, organization, EXTRACT(YEAR FROM A.committed_date)::int AS year,
	COALESCE(B.country, 'Missing') AS country, us_fraction, A.additions,
	COALESCE(B.us_business, 0) as us_business, COALESCE(B.us_academic, 0) as us_academic,
	COALESCE(B.us_gov, 0) as us_gov, COALESCE(B.us_nonprofit, 0) as us_nonprofit,
	COALESCE(B.us_household, 0) as us_household
FROM gh_cost.us_sectored_fractioned_110521 AS B -- only us users
LEFT JOIN gh.commits_dd_nmrc_jbsc A
ON A.login = B.login
--limit 100000
), fraction_join AS (
SELECT slug, login, organization, country, year, us_fraction, additions,
  (us_fraction*additions) AS us_additions,
	(us_business*additions) AS us_bus_frac,
	(us_academic*additions) AS us_acad_frac,
	(us_gov*additions) AS us_gov_frac,
	(us_nonprofit*additions) AS us_np_frac,
	(us_household*additions) AS us_hh_frac
FROM sector_join
WHERE year > 2008 AND year < 2020
)
select slug, country, year,
  sum(additions) as additions,
  sum(us_additions) as us_additions,
  sum(us_acad_frac) as us_acad_frac,
  sum(us_bus_frac) as us_bus_frac,
  sum(us_gov_frac) as us_gov_frac,
  sum(us_np_frac) as us_np_frac,
  sum(us_hh_frac) as us_hh_frac
from fraction_join
group by slug, year, country
order by slug, year, country );

-- to check if this is right i ran
select sum(frac_additions)
from gh_cost.cost_by_country_yr_0919_lchn_frac_110621
where country = 'United States'
-- and got 82834369166.

select sum(us_additions)
from gh_cost.cost_us_frac_by_sector_0919_lchn_110621
---------- 82752013364.9167
82834369166-82752013364.9167





