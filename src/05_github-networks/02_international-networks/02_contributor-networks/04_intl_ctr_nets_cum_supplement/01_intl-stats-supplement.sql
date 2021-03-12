
-- ctrs_per_repo
CREATE MATERIALIZED VIEW gh.desc_repos_intl_sum_dd_lchn AS (
SELECT slug, COUNT(*) AS commits, COUNT(DISTINCT login) AS logins,
       SUM(additions) AS additions, SUM(deletions) AS deletions
FROM (SELECT slug, B.login, B.country_code_vis AS country_code,
      EXTRACT(YEAR FROM committed_date)::int AS YEAR, additions, deletions
      FROM gh.commits_dd_nmrc_jbsc A
      LEFT JOIN gh_sna.sna_ctr_ctry_codes B
      ON A.login = B.login
      WHERE B.country_code_vis IS NOT NULL) C
GROUP BY slug
);

-- repos_per_owner
CREATE MATERIALIZED VIEW gh.desc_owners_intl_sum_dd_lchn AS (
SELECT split_part(slug, '/', 1) AS owner, COUNT(DISTINCT slug) AS repos,
      COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM (SELECT slug, B.login, EXTRACT(YEAR FROM committed_date)::int AS YEAR,
      B.country_code_vis AS country_code, additions, deletions
      FROM gh.commits_dd_nmrc_jbsc A
      LEFT JOIN gh_sna.sna_ctr_ctry_codes B
      ON A.login = B.login
      WHERE B.country_code IS NOT NULL) C
GROUP BY owner
);

-- repos_per_ctr
CREATE MATERIALIZED VIEW gh.desc_ctrs_intl_sum_dd_lchn AS (
SELECT login, country_code, COUNT(DISTINCT slug) AS repos,
      COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM (SELECT slug, B.login, B.country_code_vis AS country_code,
      EXTRACT(YEAR FROM committed_date)::int AS YEAR, additions, deletions
      FROM gh.commits_dd_nmrc_jbsc A
      LEFT JOIN gh_sna.sna_ctr_ctry_codes B
      ON A.login = B.login
      WHERE B.country_code_vis IS NOT NULL) C
GROUP BY login, country_code
);

