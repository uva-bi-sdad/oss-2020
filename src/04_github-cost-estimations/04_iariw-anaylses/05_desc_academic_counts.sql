-- academic counts
create materialized view gh_cost.desc_academic_counts_102021 as (
with C as (
select organization,
	(repos * fraction) as repos_frac,
	(commits * fraction) as commits_frac,
	(additions * fraction) as additions_frac,
	(deletions * fraction) as deletions_frac
from gh.desc_ctrs_summary_dd_lchn A
left join gh_cost.user_academic_fractions B
on A.login = B.login
where fraction is not null )

select organization, sum(repos_frac) as repos, sum(commits_frac) as commits,
					 sum(additions_frac) as additions, sum(deletions_frac) as deletions
from C
group by organization
order by additions desc );

-- country counts
create materialized view gh_cost.desc_country_counts_102021 as (
with C as (
select country,
	(repos * fraction) as repos_frac,
	(commits * fraction) as commits_frac,
	(additions * fraction) as additions_frac,
	(deletions * fraction) as deletions_frac
from gh.desc_ctrs_summary_dd_lchn A
left join gh_cost.user_country_fractions B
on A.login = B.login
where fraction is not null )

select country, sum(repos_frac) as repos, sum(commits_frac) as commits,
					 sum(additions_frac) as additions, sum(deletions_frac) as deletions
from C
group by country
order by additions desc );
