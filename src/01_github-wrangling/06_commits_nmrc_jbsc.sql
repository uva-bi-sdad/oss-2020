create materialized view gh.commits_freq as (
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
    )
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
 SELECT a.slug,
    a.committed_date,
    a.login,
    a.additions,
    a.deletions
   FROM gh.commits_dd a
   JOIN gh.commits_freq b
   ON a.committed_date = b.committed_date
   AND a.login = b.login
   AND a.additions = b.additions
   AND a.deletions = b.deletions
);
create materialized view gh.commits_freq_1 as (
    with a as (
        SELECT slug,
            max(committed_date),
            min(committed_date)
        FROM gh.commits_freq_0
        group by slug
    ),
    b as (
        select distinct on (slug) slug,
            max - min as duration
        from a
        order by slug,
            duration desc
    )
    select distinct a.*
    from gh.commits_freq_0 a
    join b
    on a.slug = b.slug
);
create materialized view gh.commits_dd_nmrc_jbsc as (
    with a as (
        select *,
            false to_keep
        from gh.commits_dd
        union all
        select *,
            true to_keep
        from gh.commits_freq_1
    ),
    b as (
        select distinct on (committed_date, login, additions, deletions) *
        from a
        order by committed_date,
            login,
            additions,
            deletions,
            to_keep desc
    )
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