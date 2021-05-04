
-- In this overall pipeline, we are measuring the number of pairwise international
-- collaborations that occur on the Open Source Software platform - GitHub.
-- Please see the README to understand how the full pipeline fits together.

-- In this file, let's start by noting that we have a table in PostgreSQL database that
-- has all of the raw commits collected from OSI-approved licenses from 2008-2019 inclusive.
-- Through continued testing, we know that this table (gh.commits_raw) needs a number of
-- refinements applied to make the data meaningful, including de-duplication, removal of bots,
-- and the removal of commits that are "mirrored" from older versions of repositories.
-- This refinement is needed because, in some instances, code is contributed to a repo and then
-- mirrored into new repos, which means that "contributions" compile in new, but distinct, repos.
-- While these may be considered integral to the new repos, we did not consider them "collaborations"
-- and thus we removed them. Note that the impact of this refinement is substantial in that it would
-- inflate the number of collaborations 15x in the latter years of the analysis. Once these refinements
-- were applied, we create a summary table of the number of commits per user (gh.commits_per_user_ind)
-- and then an edgelist with all of the unique combinations of pairwise collabortions for 2008-2019.

-- Step 1: Run refinements (de-deduplication, longest chain, and removal of bots)

-- De-Duplication of Commits Data
create materialized view gh.commits_dd as (
    select distinct slug, committed_date, login, additions, deletions
    from gh.commits_raw
);

-- Filter to Only Include the Longest Chains
create materialized view gh.commits_freq as (
    -- Find how many times a commit show up
    with a as (
        select committed_date,
            login,
            additions,
            deletions,
            count(*)
        FROM gh.commits_dd
        group by committed_date,
            login,
            additions,
            deletions
    ) -- Find all commits which appear in multiple repos
    select *
    from a
    where count > 1
    order by count desc,
        committed_date,
        login,
        additions,
        deletions
);
create materialized view gh.commits_freq_0 as (
    -- Find the slugs of each commit that appears in multiple repos
    SELECT a.slug,
        a.committed_date,
        a.login,
        a.additions,
        a.deletions
    FROM gh.commits_dd a
        JOIN gh.commits_freq b ON a.committed_date = b.committed_date
        AND a.login = b.login
        AND a.additions = b.additions
        AND a.deletions = b.deletions
);
create materialized view gh.commits_freq_1 as (
    -- Compute the earliest and most recent "shared" commit for each repo
    with a as (
        SELECT slug,
            max(committed_date),
            min(committed_date)
        FROM gh.commits_freq_0
        group by slug
    ),
    -- Compute the duration from earliest to most recent "shared" commit
    -- in each repo and keep only the slug of the repo with the longest chain
    b as (
        select distinct on (slug) slug,
            max - min as duration
        from a
        order by slug,
            duration desc
    )
    -- For each commit, assign the repo in which it shows up having the longest chain
    select distinct a.*
    from gh.commits_freq_0 a
        join b on a.slug = b.slug
);
-- creates the "longest chain" refinement table
create materialized view gh.commits_dd_nmrc_jbsc as (
    -- Have original records and the "refined" records
    -- give preference to refined ones over the orginal ones
    with a as (
        select *,
            false to_keep
        from gh.commits_dd
        union all
        select *,
            true to_keep
        from gh.commits_freq_1
    ),
    -- Remove original records for which there is a refined one
    b as (
        select distinct on (committed_date, login, additions, deletions) *
        from a
        order by committed_date,
            login,
            additions,
            deletions,
            to_keep desc
    )
    -- Final clean up which has every commit just ones based on the refinement
    select distinct slug,
        committed_date,
        login,
        additions,
        deletions
    from b
    order by slug,
        committed_date,
        login
);

-- Removal of known bots

CREATE MATERIALIZED VIEW gh.commits_refined AS (
    SELECT DISTINCT slug, committed_date, login, additions, deletions
    FROM gh.commits_dd_nmrc_jbsc
    WHERE login NOT IN (SELECT * FROM gh.bots_table)
);

-- Step 2: Create a table of users committing to slugs each year (takes about ~25 mins)

CREATE MATERIALIZED VIEW gh.commits_per_user_refined AS (

WITH A AS (
	SELECT login, slug, EXTRACT(YEAR FROM committed_date)::int AS year
	FROM gh.commits_refined
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

GRANT ALL PRIVILEGES ON gh.commits_per_user_refined TO ncses_oss;

-- Step 3: This creates the edgelist for all year-by-year (yxy)
-- pairwise collaborations based on user logins

CREATE MATERIALIZED VIEW gh_sna.sna_ctr_edgelist_yxy_refined AS (
	WITH D AS (
	SELECT Z.slug, Z.year, Z.login AS ctr1, C.login AS ctr2
	FROM gh.commits_per_user_refined Z
	INNER JOIN gh.commits_per_user_refined AS C
	ON Z.year = C.year AND Z.slug = C.slug
	-- line below removes duplicate rows of A-B, B-A and loops
	WHERE Z.login < C.login AND Z.login != C.login )

SELECT ctr1, ctr2, COUNT(*) AS repo_wts, year
FROM D
GROUP BY ctr1, ctr2, year
ORDER BY repo_wts DESC

);

GRANT ALL PRIVILEGES ON gh_sna.sna_ctr_edgelist_yxy_refined TO ncses_oss;
