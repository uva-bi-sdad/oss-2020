

CREATE MATERIALIZED VIEW gh.commits_per_user_dd_lchn_nn AS (

WITH A AS (
	SELECT login, slug, EXTRACT(YEAR FROM committed_date)::int AS year
	FROM gh.commits_dd_nmrc_jbsc_nbots
	WHERE login IS NOT NULL AND login != 'null'
), B AS (
	SELECT slug, year, login, COUNT(*) AS commits
	FROM A
	GROUP BY slug, year, login
)

SELECT login, commits, slug, year
FROM B
ORDER BY commits DESC

);

create materialized view gh.shared_intl_repos AS (

with C AS (
	select A.login, A.country_name, B.slug, B.year
	from gh_sna.sna_ctr_ctry_codes A
	inner join gh.commits_per_user_dd_lchn_nn B
	on A.login = B.login
	where A.country_code_di != 'multiple' AND A.country_name IS NOT NULL
	--limit 1000
), D AS (
	SELECT slug, year, COUNT(DISTINCT(login)) AS users
	FROM gh.commits_per_user_dd_lchn_nn
	GROUP BY slug, year
	--limit 1000
), E AS (
  SELECT C.login, C.country_name, C.slug, C.year, D.users
  from C
  inner join D
  on C.slug = D.slug AND C.year = D.year AND users > 1
  ORDER BY users DESC
  --limit 1000
)

select country_name AS country, slug, year, COUNT(login) AS users_in_ctry
from E
group by country, slug, year, users
ORDER BY users_in_ctry DESC
--LIMIT 1000
);

CREATE INDEX shared_repos_idx ON gh.shared_intl_repos (slug);
-GRANT ALL PRIVILEGES ON gh.shared_intl_repos TO ncses_oss;



































