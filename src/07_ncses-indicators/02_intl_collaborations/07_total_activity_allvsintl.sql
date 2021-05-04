WITH all_data AS (
	select SUM(commits) AS commmits
	from gh.commits_per_user_dd_lchn
	--limit 100
)
select * from all_data;

WITH intl_data AS (
	select A.login, A.slug, A.commits, A.year, B.country_code_di, country_name
	from gh.commits_per_user_dd_lchn A
	inner join gh_sna.sna_ctr_ctry_codes B
	on A.login = B.login AND B.country_code_di != 'multiple' AND B.country_name IS NOT NULL
	--limit 100
)
select SUM(commits) AS intl_commits from intl_data;

135197866 / 260544812 = 0.5189





