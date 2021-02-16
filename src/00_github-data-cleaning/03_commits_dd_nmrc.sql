

-- this does a group_by all that tells us how many commits go to each repo

CREATE MATERIALIZED VIEW gh.commits_per_repo AS (
WITH filtered_table AS (
	SELECT DISTINCT login, committed_date, additions, deletions, slug
	FROM gh.commits_dd
)
SELECT login, committed_date, additions, deletions, COUNT(*) AS slugs
FROM filtered_table
GROUP BY login, committed_date, additions, deletions
);

CREATE INDEX login_cpr_idx ON gh.commits_per_repo (login);

-- then let's see how many commits go to more than one repo
SELECT COUNT(*)
FROM gh.commits_per_repo
WHERE slugs > 1;
-- looks like 51,546,708 commits went to more than one repo

-- now lets check how many repos only commit to one repo
SELECT COUNT(*)
FROM gh.commits_per_repo
WHERE slugs = 1
LIMIT 100;
-- that leaves us with about 261,408,910 commits left in the data

-- so lets join that information together with the slug
-- info from commits_dd (producing gh.commits_dd_nmrc)
create materialized view gh.commits_dd_nmrc as (
	select B.slug, A.login, A.committed_date, A.additions,
	       A.deletions, A.slugs AS number_of_repos
	from gh.commits_per_repo A
	left join gh.commits_dd B
	on  A.login = B.login and A.committed_date = B.committed_date
	and A.additions = B.additions and A.deletions = B.deletions
	where A.slugs = 1 -- include nulls bc their commits count towards cost estimtes
);
-- this table has 261,408,910 commits


