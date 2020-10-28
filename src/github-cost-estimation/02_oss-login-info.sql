--this takes the desc_ctrs_summary (github summary data of distinct logins) and
--sna_ctr_sectors (the logins from gh torrent after being sectored during DSPG)
--and joins them together

CREATE MATERIALIZED VIEW gh.cost_logins_w_sector_info AS (
SELECT A.login, A.repos, A.commits, A.additions, A.deletions,
       B.sector, B.city_info, B.cc_multiple, B.cc_di, B.cc_viz,
	   B.raw_location, B.email, B.company_original, B.company_cleaned
FROM gh.desc_ctrs_summary A
LEFT JOIN gh.sna_ctr_sectors B
ON A.login = B.login );

--get the counts
WITH new_table AS (
	SELECT COALESCE(sector, 'n/a') AS sector, login, commits, additions, deletions
	FROM gh.cost_logins_w_sector_info
)
SELECT sector, SUM(commits), SUM(additions), SUM(deletions)
FROM new_table
GROUP BY sector;
