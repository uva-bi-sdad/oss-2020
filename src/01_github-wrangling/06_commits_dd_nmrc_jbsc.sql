create materialized view gh.commits_freq as (
    -- Find how many times a commit show up
    with a as (
        SELECT committed_date,
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
    -- in each repo and keep only the slug of the repo with the longest
    -- chain
    b as (
        select distinct on (slug) slug,
            max - min as duration
        from a
        order by slug,
            duration desc
    )
    -- For each commit, assign the repo in which it shows up having the
    -- longest chain
    select distinct a.*
    from gh.commits_freq_0 a
        join b on a.slug = b.slug
);
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