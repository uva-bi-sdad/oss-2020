

-- 01_oss_full_dataset --------------------------------------------------------------- done
\copy (SELECT * FROM gh.ctrs_extra) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/01_oss_full_dataset/01_ghtorrent_user_data.csv' with csv;
\copy (SELECT * FROM gh.ctrs_raw_0821) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/01_oss_full_dataset/02_uvancses_user_data.csv' with csv;
\copy (SELECT * FROM gh.ctrs_clean_0821) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/01_oss_full_dataset/03_combined_user_data.csv' with csv;
\copy (SELECT * FROM gh.repos) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/01_oss_full_dataset/04_repos.csv' with csv;
\copy (SELECT * FROM gh.commits_dd) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/01_oss_full_dataset/05_dd_commits_data.csv' with csv;

-- 02_oss_ncses_indicator ---------------------------------------------------------------
\copy (SELECT * FROM gh.ctrs_extra) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/02_oss_ncses_indicator/01_ctrs_extra.csv' with csv;
\copy (SELECT * FROM gh.sna_ctr_academic) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/02_oss_ncses_indicator/02_sna_ctr_academic.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_ctry_codes) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/02_oss_ncses_indicator/03_sna_ctr_ctry_codes.csv' with csv;
\copy (SELECT * FROM gh.commits_dd) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/02_oss_ncses_indicator/04_dd_commits_data.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_yxy_refined) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/02_oss_ncses_indicator/05_sna_ctr_edgelist_yxy_refined.csv' with csv;

-- 03_oss_cost_iariw_aea ---------------------------------------------------------------
\copy (SELECT * FROM gh.ctrs_clean_0821) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/03_oss_cost_iariw_aea/01_ctrs_clean_0821.csv' with csv;
\copy (SELECT * FROM gh.commits_dd_nmrc_jbsc.csv) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/03_oss_cost_iariw_aea/05_commits_dd_nmrc_jbsc.csv.csv' with csv;
-- must run this bit in R
raw_ctr_data <- readRDS("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/iariw-aea/github_sectored_101321.rds")
readr::write_csv(raw_ctr_data, '/project/biocomplexity/sdad/projects_data/ncses/oss/data/03_oss_cost_iariw_aea/02_github_sectored_101321.csv')
raw_ctr_data <- readRDS("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/iariw-aea/github_sectored_110521.rds")
readr::write_csv(raw_ctr_data, '/project/biocomplexity/sdad/projects_data/ncses/oss/data/03_oss_cost_iariw_aea/03_github_sectored_110521.csv')
raw_ctr_data <- readRDS("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/iariw-aea/github_iariw_final_1121.rds")
readr::write_csv(raw_ctr_data, '/project/biocomplexity/sdad/projects_data/ncses/oss/data/03_oss_cost_iariw_aea/04_github_iariw_final_1121.csv')


-- 04_oss_networks_intl ---------------------------------------------------------------
-- nodelists
\copy (SELECT * FROM gh.ctrs_extra) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/ghtorrent_user_data.csv' with csv;
-- edgelists
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_08) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_dd_lchn_nbots_08.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0809) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_dd_lchn_nbots_0809.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0810) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_dd_lchn_nbots_0810.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0811) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_dd_lchn_nbots_0811.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0812) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_dd_lchn_nbots_0812.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0813) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_dd_lchn_nbots_0813.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0814) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_dd_lchn_nbots_0814.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0815) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_dd_lchn_nbots_0815.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0816) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_dd_lchn_nbots_0816.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0817) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_dd_lchn_nbots_0817.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0818) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_dd_lchn_nbots_0818.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0819) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_dd_lchn_nbots_0819.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_yxy_lchn) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctry_edgelist_yxy_lchn.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_08) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctr_edgelist_dd_lchn_08.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0809) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctr_edgelist_dd_lchn_0809.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0810) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctr_edgelist_dd_lchn_0810.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0811) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctr_edgelist_dd_lchn_0811.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0812) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctr_edgelist_dd_lchn_0812.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0813) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctr_edgelist_dd_lchn_0813.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0814) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctr_edgelist_dd_lchn_0814.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0815) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctr_edgelist_dd_lchn_0815.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0816) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctr_edgelist_dd_lchn_0816.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0817) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctr_edgelist_dd_lchn_0817.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0818) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctr_edgelist_dd_lchn_0818.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0819) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/04_oss_networks_intl/sna_intl_ctr_edgelist_dd_lchn_0819.csv' with csv;

-- 05_oss_networks_comm ---------------------------------------------------------------
-- nodelists
\copy (SELECT * FROM gh.ctrs_extra) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/05_oss_networks_comm/ghtorrent_user_data.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_ctry_codes) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/05_oss_networks_comm/02_sna_ctr_ctry_codes.csv' with csv;
-- edgelists
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_0819) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/05_oss_networks_comm/03_sna_ctr_edgelist_dd_lchn_0819.csv' with csv;
-- not sure where this is
-- repo_slugs table?
-- \copy (SELECT * FROM gh_sna.repo_slugs) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/05_oss_networks_comm/repo_slugs.csv' with csv;

-- 06_oss_networks_sds ---------------------------------------------------------------
\copy (SELECT * FROM gh.temp_meta_1) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/06_oss_networks_sds/temp_meta_1.csv' with csv;
\copy (SELECT * FROM gh.commits_dd_nmrc_jbsc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/06_oss_networks_sds/commits_dd_nmrc_jbsc.csv' with csv;
\copy (SELECT * FROM gh.commits_pypi_112021) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/06_oss_networks_sds/commits_pypi_112021.csv' with csv;
\copy (SELECT * FROM gh_cost.sectored_fractioned_103121) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/06_oss_networks_sds/sectored_fractioned_103121.csv' with csv;
\copy (SELECT * FROM gh.commits_per_user_pypi_112021) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/06_oss_networks_sds/commits_per_user_pypi_112021.csv' with csv;
\copy (SELECT * FROM gh.sna_pypi_edgelist_wisos_0819) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/06_oss_networks_sds/sna_pypi_edgelist_wisos_0819.csv' with csv;












