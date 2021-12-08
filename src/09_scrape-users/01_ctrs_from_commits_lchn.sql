create materialized view gh.ctrs_from_commits_lchn as (
	select distinct(login)
	from gh.commits_dd_nmrc_jbsc
	where login is not null
);
