
-- this is a summary table of the users that have country codes in the commits_dd_nmrc_jbsc_nbots table

CREATE MATERIALIZED VIEW gh_sna.desc_intl_ctrs_summary AS (
	WITH sum_table AS (
	select A.login, slug, additions, deletions, country_name AS country, committed_date
	from gh.commits_dd_nmrc_jbsc_nbots A
	inner join gh_sna.sna_ctr_ctry_codes B
	on A.login = B.login
	--limit 1000
)
SELECT login AS user, country, COUNT(DISTINCT slug) AS repos,
		COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM sum_table
GROUP BY login, country
ORDER BY repos DESC
--limit 1000
);
