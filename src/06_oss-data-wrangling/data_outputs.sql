
psql -U username -d sdad -h postgis1
\dn
\dt forbes.*

-- american soldier
\copy (SELECT * FROM american_soldier.survey_32_clean) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/american_soldier/survey_32_clean.csv' with csv;
\copy (SELECT * FROM american_soldier.survey_32_combined) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/american_soldier/survey_32_combined.csv' with csv;
\copy (SELECT * FROM american_soldier.survey_32n_raw) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/american_soldier/survey_32n_raw.csv' with csv;
\copy (SELECT * FROM american_soldier.survey_32w_raw) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/american_soldier/survey_32w_raw.csv' with csv;

-- bloomberg
\copy (SELECT * FROM bloomberg.gov_contractors) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/bloomberg/gov_contractors.csv' with csv;

-- codegov
\copy (SELECT * FROM codegov.agencies) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/codegov/agencies.csv' with csv;
\copy (SELECT * FROM codegov.agencies_requirements) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/codegov/agencies_requirements.csv' with csv;
\copy (SELECT * FROM codegov.agencies_status) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/codegov/agencies_status.csv' with csv;

-- cran
\copy (SELECT * FROM cran.cran_maintainers) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/cran/cran_maintainers.csv' with csv;

-- datahub
\copy (SELECT * FROM datahub.country_codes) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/datahub/country_codes.csv' with csv;
\copy (SELECT * FROM datahub.domain_names) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/datahub/domain_names.csv' with csv;

-- forbes
\copy (SELECT * FROM forbes.charities2019_top100) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/forbes/charities2019_top100.csv' with csv;
\copy (SELECT * FROM forbes.fortune2018_us1000) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/forbes/fortune2018_us1000.csv' with csv;
\copy (SELECT * FROM forbes.fortune2019_us1000) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/forbes/fortune2019_us1000.csv' with csv;
\copy (SELECT * FROM forbes.fortune2020_global2000) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/forbes/fortune2020_global2000.csv' with csv;

--us_sam
\copy (SELECT * FROM us_sam.fh_public_api) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/us_sam/fh_public_api.csv' with csv;
\copy (SELECT * FROM us_sam.fh_public_clean) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/us_sam/fh_public_clean.csv' with csv;

-- us_gov_depts
\copy (SELECT * FROM us_gov_depts.gov_acronyms) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/us_gov_depts/gov_acronyms.csv' with csv;
\copy (SELECT * FROM us_gov_depts.nonprofit_govadmins) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/us_gov_depts/nonprofit_govadmins.csv' with csv;
\copy (SELECT * FROM us_gov_depts.us_gov_azindex) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/us_gov_depts/us_gov_azindex.csv' with csv;
\copy (SELECT * FROM us_gov_depts.us_gov_azindex_clean) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/us_gov_depts/us_gov_azindex_clean.csv' with csv;
\copy (SELECT * FROM us_gov_depts.us_gov_azindex_dspg) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/us_gov_depts/us_gov_azindex_dspg.csv' with csv;
\copy (SELECT * FROM us_gov_depts.us_gov_ffrdcs) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/us_gov_depts/us_gov_ffrdcs.csv' with csv;
\copy (SELECT * FROM us_gov_depts.us_gov_manual) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/us_gov_depts/us_gov_manual.csv' with csv;

-- pubmed_2021
\copy (SELECT * FROM pubmed_2021.all_diversity_ids) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/all_diversity_ids.csv' with csv;
\copy (SELECT * FROM pubmed_2021.all_diversity_ids_0721) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/all_diversity_ids_0721.csv' with csv;
\copy (SELECT * FROM pubmed_2021.bio_diversity_ids) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/bio_diversity_ids.csv' with csv;
\copy (SELECT * FROM pubmed_2021.bio_diversity_ids_0721) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/bio_diversity_ids_0721.csv' with csv;
\copy (SELECT * FROM pubmed_2021.filtered_publications) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/filtered_publications.csv' with csv;
\copy (SELECT * FROM pubmed_2021.human_research_ids) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/human_research_ids.csv' with csv;
\copy (SELECT * FROM pubmed_2021.soc_diversity_ids) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/soc_diversity_ids.csv' with csv;
\copy (SELECT * FROM pubmed_2021.soc_diversity_ids_0721) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/soc_diversity_ids_0721.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_abstract) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_abstract.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_accession_number) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_accession_number.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_author) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_author.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_chemical) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_chemical.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_citation_subset) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_citation_subset.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_comments_correction) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_comments_correction.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_data_bank) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_data_bank.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_gene_symbol) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_gene_symbol.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_general_note) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_general_note.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_grant) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_grant.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_investigator) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_investigator.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_journal) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_journal.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_keyword) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_keyword.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_language) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_language.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_medline_citation) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_medline_citation.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_medline_journal_info) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_medline_journal_info.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_mesh_heading) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_mesh_heading.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_other_abstract) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_other_abstract.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_other_id) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_other_id.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_personal_name_subject) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_personal_name_subject.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_pmids_in_file) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_pmids_in_file.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_publication_type) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_publication_type.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_qualifier_name) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_qualifier_name.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_space_flight_mission) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_space_flight_mission.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_suppl_mesh_name) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_suppl_mesh_name.csv' with csv;
\copy (SELECT * FROM pubmed_2021.tbl_xml_file) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/tbl_xml_file.csv' with csv;
--- m_views
\copy (SELECT * FROM pubmed_2021.abstract_data) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/abstract_data.csv' with csv;
\copy (SELECT * FROM pubmed_2021.all_div_abstracts_0721) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/all_div_abstracts_0721.csv' with csv;
\copy (SELECT * FROM pubmed_2021.all_diversity_abstracts_0321) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/all_diversity_abstracts_0321.csv' with csv;
\copy (SELECT * FROM pubmed_2021.articles_per_journal) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/articles_per_journal.csv' with csv;
\copy (SELECT * FROM pubmed_2021.articles_per_year) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/articles_per_year.csv' with csv;
\copy (SELECT * FROM pubmed_2021.biomedical_abstracts) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/biomedical_abstracts.csv' with csv;
\copy (SELECT * FROM pubmed_2021.biomedical_articles_per_journal) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/biomedical_articles_per_journal.csv' with csv;
\copy (SELECT * FROM pubmed_2021.biomedical_articles_per_year) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/biomedical_articles_per_year.csv' with csv;
\copy (SELECT * FROM pubmed_2021.biomedical_human_abstracts) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/biomedical_human_abstracts.csv' with csv;
\copy (SELECT * FROM pubmed_2021.biomedical_human_per_journal) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/biomedical_human_per_journal.csv' with csv;
\copy (SELECT * FROM pubmed_2021.biomedical_human_per_year) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/biomedical_human_per_year.csv' with csv;
\copy (SELECT * FROM pubmed_2021.human_abstracts_0721) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/human_abstracts_0721.csv' with csv;
\copy (SELECT * FROM pubmed_2021.soc_diversity_abstracts) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/soc_diversity_abstracts.csv' with csv;
\copy (SELECT * FROM pubmed_2021.soc_diversity_abstracts_0721) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/pubmed_2021/soc_diversity_abstracts_0721.csv' with csv;

-- gh
-- materialized views
\copy (SELECT * FROM gh.bots_table) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/bots_table.csv' with csv;
\copy (SELECT * FROM gh.commits_dd) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/commits_dd.csv' with csv;
\copy (SELECT * FROM gh.commits_dd_nmrc_jbsc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/commits_dd_nmrc_jbsc.csv' with csv;
\copy (SELECT * FROM gh.orgs_data) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/orgs_data.csv' with csv;
\copy (SELECT * FROM gh.commits_per_repo_dd) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/commits_per_repo_dd.csv' with csv;
\copy (SELECT * FROM gh.commits_per_user_dd) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/commits_per_user_dd.csv' with csv;
\copy (SELECT * FROM gh.commits_per_user_dd_lchn) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/commits_per_user_dd_lchn.csv' with csv;
\copy (SELECT * FROM gh.desc_repos_summary_dd) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/desc_repos_summary_dd.csv' with csv;
\copy (SELECT * FROM gh.desc_repos_summary_dd_lchn) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/desc_repos_summary_dd_lchn.csv' with csv;
\copy (SELECT * FROM gh.ctrs_for_cost_0919) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/ctrs_for_cost_0919.csv' with csv;
\copy (SELECT * FROM gh.ctrs_for_cost_0919_0821) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/ctrs_for_cost_0919_0821.csv' with csv;
\copy (SELECT * FROM gh.desc_licenses_osi) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/desc_licenses_osi.csv' with csv;
\copy (SELECT * FROM gh.desc_ctrs_intl_sum_dd_lchn) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/desc_ctrs_intl_sum_dd_lchn.csv' with csv;
\copy (SELECT * FROM gh.desc_ctrs_summary_dd_lchn) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/desc_ctrs_summary_dd_lchn.csv' with csv;
\copy (SELECT * FROM gh.desc_owners_intl_sum_dd_lchn) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/desc_owners_intl_sum_dd_lchn.csv' with csv;
\copy (SELECT * FROM gh.desc_owners_summary_dd_lchn) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/desc_owners_summary_dd_lchn.csv' with csv;
\copy (SELECT * FROM gh.desc_repos_intl_sum_dd_lchn) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/desc_repos_intl_sum_dd_lchn.csv' with csv;
\copy (SELECT * FROM gh.desc_repos_sum_lchn_0919) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/desc_repos_sum_lchn_0919.csv' with csv;
-- tables
\copy (SELECT * FROM gh.ctrs_clean_0821) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/ctrs_clean_0821.csv' with csv;
\copy (SELECT * FROM gh.ctrs_raw_0821) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/ctrs_raw_0821.csv' with csv;
\copy (SELECT * FROM gh.licenses) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/licenses.csv' with csv;
\copy (SELECT * FROM gh.repos) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/repos.csv' with csv;
\copy (SELECT * FROM gh.sna_ctr_academic) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/sna_ctr_academic.csv' with csv;
\copy (SELECT * FROM gh.sna_ctr_academic_0821) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/sna_ctr_academic_0821.csv' with csv;
\copy (SELECT * FROM gh.sna_ctr_academic_dspg_old) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/sna_ctr_academic_dspg_old.csv' with csv;
\copy (SELECT * FROM gh.sna_ctr_academic_dspg_final) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/sna_ctr_academic_dspg_final.csv' with csv;
\copy (SELECT * FROM gh.sna_ctr_city_codes) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/sna_ctr_city_codes.csv' with csv;
\copy (SELECT * FROM gh.sna_ctr_gov) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/sna_ctr_gov.csv' with csv;
\copy (SELECT * FROM gh.sna_ctr_nonprofits) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/sna_ctr_nonprofits.csv' with csv;
\copy (SELECT * FROM gh.sna_ctr_sectors) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/sna_ctr_sectors.csv' with csv;
\copy (SELECT * FROM gh.sna_ctr_sectors_hbs) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/sna_ctr_sectors_hbs.csv' with csv;
\copy (SELECT * FROM gh.users) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/users.csv' with csv;
\copy (SELECT * FROM gh.usr_email) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/usr_email.csv' with csv;
-- not done yet
\copy (SELECT * FROM gh.ctrs_classified_0821) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/ctrs_classified_0821.csv' with csv;
\copy (SELECT * FROM gh.ctrs_clean_0821) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/ctrs_clean_0821.csv' with csv;
\copy (SELECT * FROM gh.ctrs_extra) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/ctrs_extra.csv' with csv;
\copy (SELECT * FROM gh.ctrs_extra_dspg) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/ctrs_extra_dspg.csv' with csv;
\copy (SELECT * FROM gh.ctrs_raw) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/ctrs_raw.csv' with csv;
\copy (SELECT * FROM gh.ctrs_raw_0821) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh/ctrs_raw_0821.csv' with csv;








-- gh_cost
-- materialized views
\copy (SELECT * FROM gh_cost.cost_academic_geo_0919_jbsc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_academic_geo_0919_jbsc.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_academic_geo_0919_raw) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_academic_geo_0919_raw.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_0919_dd) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_0919_dd.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_0919_dd_nmrc_jbsc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_0919_dd_nmrc_jbsc.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_0919_hbs) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_0919_hbs.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_0919_nmrc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_0919_nmrc.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_0919_raw) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_0919_raw.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_19_raw) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_19_raw.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_annual_0919_dd) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_annual_0919_dd.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_annual_0919_dd_nmrc_jbsc.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc_0821) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_annual_0919_dd_nmrc_jbsc_0821.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc_101521) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_annual_0919_dd_nmrc_jbsc_101521.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc_102021) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_annual_0919_dd_nmrc_jbsc_102021.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc_103121) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_annual_0919_dd_nmrc_jbsc_103121.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_country_yr_0919_lchn_frac_110621) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_country_yr_0919_lchn_frac_110621.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_login_0919_dd) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_login_0919_dd.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_login_0919_raw) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_login_0919_raw.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_repo_0919_dd) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_repo_0919_dd.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_repo_0919_dd_nbots) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_repo_0919_dd_nbots.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_repo_0919_dd_nmrc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_repo_0919_dd_nmrc.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_repo_0919_dd_nmrc_jbsc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_repo_0919_dd_nmrc_jbsc.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_repo_0919_dd_nmrc_jbsc_nbots) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_repo_0919_dd_nmrc_jbsc_nbots.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_repo_0919_dd_nmrc_nbots) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_repo_0919_dd_nmrc_nbots.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_repo_0919_hbs) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_repo_0919_hbs.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_repo_0919_nmrc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_repo_0919_nmrc.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_repo_0919_raw) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_repo_0919_raw.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_sector_0919_dd_nmrc_nbots) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_sector_0919_dd_nmrc_nbots.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_sector_0919_nmrc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_sector_0919_nmrc.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_sector_0919_raw) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_sector_0919_raw.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_year_0919_dd) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_year_0919_dd.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_year_0919_dd_nbots) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_year_0919_dd_nbots.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_year_0919_dd_nmrc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_year_0919_dd_nmrc.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_year_0919_dd_nmrc_jbsc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_year_0919_dd_nmrc_jbsc.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_year_0919_dd_nmrc_jbsc_nbots) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_year_0919_dd_nmrc_jbsc_nbots.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_year_0919_dd_nmrc_nbots) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_year_0919_dd_nmrc_nbots.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_year_0919_nmrc) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_year_0919_nmrc.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_by_year_0919_raw) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_by_year_0919_raw.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_commits_by_year_0919) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_commits_by_year_0919.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_commits_by_year_0919) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_commits_by_year_0919.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_commits_sum_raw) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_commits_sum_raw.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_logins_w_sector_info) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_logins_w_sector_info.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_logins_w_sector_info_hbs) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_logins_w_sector_info_hbs.csv' with csv;
\copy (SELECT * FROM gh_cost.cost_us_frac_by_sector_0919_lchn_110621) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/cost_us_frac_by_sector_0919_lchn_110621.csv' with csv;
\copy (SELECT * FROM gh_cost.ctry_desc_2019) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/ctry_desc_2019.csv' with csv;
\copy (SELECT * FROM gh_cost.desc_academic_counts_102021) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/desc_academic_counts_102021.csv' with csv;
\copy (SELECT * FROM gh_cost.desc_country_counts_102021) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/desc_country_counts_102021.csv' with csv;
\copy (SELECT * FROM gh_cost.us_commits_sectored_110221) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/us_commits_sectored_110221.csv' with csv;
-- tables
\copy (SELECT * FROM gh_cost.sectored_fractioned_103121) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/sectored_fractioned_103121.csv' with csv;
\copy (SELECT * FROM gh_cost.sectored_fractioned_110521) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/sectored_fractioned_110521.csv' with csv;
\copy (SELECT * FROM gh_cost.us_sectored_fractioned_110521) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/us_sectored_fractioned_110521.csv' with csv;
\copy (SELECT * FROM gh_cost.user_academic_fractions) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/user_academic_fractions.csv' with csv;
\copy (SELECT * FROM gh_cost.user_country_fractions) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/user_country_fractions.csv' with csv;
\copy (SELECT * FROM gh_cost.users_geo_101521) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/users_geo_101521.csv' with csv;
\copy (SELECT * FROM gh_cost.users_geo_102021) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_cost/users_geo_102021.csv' with csv;

-- gh_sna
-- tables
\copy (SELECT * FROM gh_sna.sna_intl_ctry_summary) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_summary.csv' with csv;
\copy (SELECT * FROM gh.sna_academic_ctr_edgelist_0819) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_academic_ctr_edgelist_0819.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_yxy_lchn) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_yxy_lchn.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_08) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctr_edgelist_dd_lchn_08.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0809) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctr_edgelist_dd_lchn_0809.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0810) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctr_edgelist_dd_lchn_0810.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0811) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctr_edgelist_dd_lchn_0811.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0812) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctr_edgelist_dd_lchn_0812.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0813) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctr_edgelist_dd_lchn_0813.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0814) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctr_edgelist_dd_lchn_0814.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0815) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctr_edgelist_dd_lchn_0815.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0816) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctr_edgelist_dd_lchn_0816.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0817) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctr_edgelist_dd_lchn_0817.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0818) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctr_edgelist_dd_lchn_0818.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_0819) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctr_edgelist_dd_lchn_0819.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_08) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_dd_lchn_nbots_08.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0809) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_dd_lchn_nbots_0809.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0810) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_dd_lchn_nbots_0810.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0811) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_dd_lchn_nbots_0811.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0812) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_dd_lchn_nbots_0812.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0813) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_dd_lchn_nbots_0813.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0814) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_dd_lchn_nbots_0814.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0815) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_dd_lchn_nbots_0815.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0816) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_dd_lchn_nbots_0816.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0817) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_dd_lchn_nbots_0817.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0818) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_dd_lchn_nbots_0818.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0819) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_intl_ctry_edgelist_dd_lchn_nbots_0819.csv' with csv;
-- materialized views
\copy (SELECT * FROM gh_sna.desc_ctrs_intl_dd_lchn_summary) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/desc_ctrs_intl_dd_lchn_summary.csv' with csv;
\copy (SELECT * FROM gh_sna.desc_intl_ctrs_summary) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_snadesc_intl_ctrs_summary/.csv' with csv;
\copy (SELECT * FROM gh_sna.desc_intl_ctry_annual_sum) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/desc_intl_ctry_annual_sum.csv' with csv;
\copy (SELECT * FROM gh_sna.desc_intl_ctry_summary) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/desc_intl_ctry_summary.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_08) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_08.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_0809) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_0809.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_0810) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_0810.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_0811) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_0811.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_0812) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_0812.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_0813) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_0813.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_0814) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_0814.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_0815) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_0815.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_0816) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_0816.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_0817) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_0817.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_0818) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_0818.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_0819) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_0819.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_08) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_dd_lchn_08.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_0809) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_dd_lchn_0809.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_0810) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_dd_lchn_0810.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_0811) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_dd_lchn_0811.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_0812) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_dd_lchn_0812.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_0813) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_dd_lchn_0813.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_0814) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_dd_lchn_0814.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_0815) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_dd_lchn_0815.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_0816) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_dd_lchn_0816.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_0817) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_dd_lchn_0817.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_0818) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_dd_lchn_0818.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_dd_lchn_0819) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_dd_lchn_0819.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_yxy) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_yxy.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_edgelist_yxy_lchn) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_edgelist_yxy_lchn.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_ctr_nodelist_temp) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_ctr_nodelist_temp.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_language_summary) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_language_summary.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_language_summary_old) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_language_summary_old.csv' with csv;
\copy (SELECT * FROM gh_sna.sna_topic_summary) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_sna/sna_topic_summary.csv' with csv;

-- github_mirror
\copy (SELECT * FROM github_mirror.organization_members) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/github_mirror/organization_members.csv' with csv;
\copy (SELECT * FROM github_mirror.orgs) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/github_mirror/orgs.csv' with csv;



-- gh_2007_2020
\copy (SELECT * FROM gh_2007_2020.commits_by_user_157k) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/commits_by_user_157k.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.commits_per_user_157k) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/commits_per_user_157k.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.commits_per_user_subnet) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/commits_per_user_subnet.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.gov_edu_contr_2019) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/gov_edu_contr_2019.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.owners) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/owners.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.sna_157k_edges) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/sna_157k_edges.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.sna_repos_subnet_edges) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/sna_repos_subnet_edges.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.us_fed_public_decade) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/us_fed_public_decade.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.us_fed_public_hed) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/us_fed_public_hed.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.usr_to_get_login) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/usr_to_get_login.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.usr_to_get_login_full) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/usr_to_get_login_full.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.commits_unnested) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/commits_unnested.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.licenses) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/licenses.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.pats) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/pats.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.pats_update) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/pats_update.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.queries) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/queries.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.queries_2019) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/queries_2019.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.repos) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/repos.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.repos_2019) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/repos_2019.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.repos_chk) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/repos_chk.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.repos_noreadmes) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/repos_noreadmes.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.repos_ranked) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/repos_ranked.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.repos_subset_157k) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/repos_subset_157k.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.repos_subset_final) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/repos_subset_final.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.us_fed) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/us_fed.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.us_ipeds_public_hed) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/us_ipeds_public_hed.csv' with csv;

-- permission denied
ALTER TABLE gh_2007_2020.baseline_msft_rht OWNER TO ncses_oss;
ALTER TABLE gh_2007_2020.baseline_msft_rht_decade OWNER TO ncses_oss;
ALTER TABLE gh_2007_2020.gov_edu_contr_2019 OWNER TO ncses_oss;
ALTER TABLE gh_2007_2020.owners OWNER TO ncses_oss;
ALTER TABLE gh_2007_2020.repo_domains OWNER TO ncses_oss;
ALTER TABLE gh_2007_2020.repo_domains_decade OWNER TO ncses_oss;
ALTER TABLE gh_2007_2020.us_fed_public_decade OWNER TO ncses_oss;
ALTER TABLE gh_2007_2020.us_fed_public_hed OWNER TO ncses_oss;
ALTER TABLE gh_2007_2020.usr_to_get_login OWNER TO ncses_oss;
ALTER TABLE gh_2007_2020.usr_to_get_login_full OWNER TO ncses_oss;
ALTER TABLE codegov.repos OWNER TO ncses_oss;
ALTER TABLE codegov.gh_agencies OWNER TO ncses_oss;
ALTER TABLE codegov.gh_torrent_orgs OWNER TO ncses_oss;

\copy (SELECT * FROM codegov.repos) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/codegov/repos.csv' with csv;
\copy (SELECT * FROM codegov.gh_agencies) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/codegov/gh_agencies.csv' with csv;
\copy (SELECT * FROM codegov.gh_torrent_orgs) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/codegov/gh_torrent_orgs.csv' with csv;
\copy (SELECT * FROM spinellis_gh_enterprise.cohort_project_details) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/spinellis_gh_enterprise/cohort_project_details.csv' with csv;
\copy (SELECT * FROM spinellis_gh_enterprise.enterprise_projects) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/spinellis_gh_enterprise/enterprise_projects.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.baseline_msft_rht) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/baseline_msft_rht.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.baseline_msft_rht_decade) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/baseline_msft_rht_decade.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.gov_edu_contr_2019) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/gov_edu_contr_2019.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.owners) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/owners.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.repo_domains) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/repo_domains.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.repo_domains_decade) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/repo_domains_decade.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.us_fed_public_decade) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/us_fed_public_decade.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.us_fed_public_hed) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/us_fed_public_hed.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.usr_to_get_login) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/usr_to_get_login.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.usr_to_get_login_full) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/usr_to_get_login_full.csv' with csv;
\copy (SELECT * FROM gh_2007_2020.commits) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/gh_2007_2020/commits.csv' with csv;

-- oss and oss_universe on the database

\copy (SELECT * FROM oss.CDN_authors_info) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/CDN_authors_info.csv' with csv;
\copy (SELECT * FROM oss.CDN_dependencies_info) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/CDN_dependencies_info.csv' with csv;
\copy (SELECT * FROM oss.cdn_author_info_deduped) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_author_info_deduped.csv' with csv;
\copy (SELECT * FROM oss.cdn_contributions) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_contributions.csv' with csv;
\copy (SELECT * FROM oss.cdn_contributions_deduped) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_contributions_deduped.csv' with csv;
\copy (SELECT * FROM oss.cdn_dependencies_deduped) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_dependencies_deduped.csv' with csv;
\copy (SELECT * FROM oss.cdn_dependencies_info) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_dependencies_info.csv' with csv;
\copy (SELECT * FROM oss.cdn_final) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_final.csv' with csv;
\copy (SELECT * FROM oss.cdn_general_info) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_general_info.csv' with csv;
\copy (SELECT * FROM oss.cdn_general_info_deduped) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_general_info_deduped.csv' with csv;
\copy (SELECT * FROM oss.cdn_keywords_deduped) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_keywords_deduped.csv' with csv;
\copy (SELECT * FROM oss.cdn_license_info) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_license_info.csv' with csv;
\copy (SELECT * FROM oss.cdn_package_lines) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_package_lines.csv' with csv;
\copy (SELECT * FROM oss.cdn_package_lines_deduped) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_package_lines_deduped.csv' with csv;
\copy (SELECT * FROM oss.cdn_value_info) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cdn_value_info.csv' with csv;
\copy (SELECT * FROM oss.codgov_contributors) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/codgov_contributors.csv' with csv;
\copy (SELECT * FROM oss.codgov_licenses) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/codgov_licenses.csv' with csv;
\copy (SELECT * FROM oss.cran_dependencies) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cran_dependencies.csv' with csv;
\copy (SELECT * FROM oss.cran_export) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/cran_export.csv' with csv;
\copy (SELECT * FROM oss.extremes) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/extremes.csv' with csv;
\copy (SELECT * FROM oss.geocoded) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/geocoded.csv' with csv;
\copy (SELECT * FROM oss.julia_contributions) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/julia_contributions.csv' with csv;
\copy (SELECT * FROM oss.julia_contributors_commits) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/julia_contributors_commits.csv' with csv;
\copy (SELECT * FROM oss.julia_cost_estimates) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/julia_cost_estimates.csv' with csv;
\copy (SELECT * FROM oss.julia_licenses) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/julia_licenses.csv' with csv;
\copy (SELECT * FROM oss.julia_licenses_github) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/julia_licenses_github.csv' with csv;
\copy (SELECT * FROM oss.julia_pkg_status) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/julia_pkg_status.csv' with csv;
\copy (SELECT * FROM oss.licenses) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/licenses.csv' with csv;
\copy (SELECT * FROM oss.python_contributors) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/python_contributors.csv' with csv;
\copy (SELECT * FROM oss.python_cost_estimates) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/python_cost_estimates.csv' with csv;
\copy (SELECT * FROM oss.python_final) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/python_final.csv' with csv;
\copy (SELECT * FROM oss.python_general_pkg_info) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/python_general_pkg_info.csv' with csv;
\copy (SELECT * FROM oss.python_loc_contributors) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/python_loc_contributors.csv' with csv;
\copy (SELECT * FROM oss.python_pkg_dependencies) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/python_pkg_dependencies.csv' with csv;


-- issues
\copy (SELECT * FROM oss.CDN_licenses_info) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/CDN_licenses_info.csv' with csv;
\copy (SELECT * FROM oss.CRAN_OSI_CI_passing) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/CRAN_OSI_CI_passing.csv' with csv;
\copy (SELECT * FROM oss.CRAN_analysis) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/CRAN_analysis.csv' with csv;
\copy (SELECT * FROM oss.CRAN_direct_download_costs) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/CRAN_direct_download_costs.csv' with csv;
\copy (SELECT * FROM oss.CRAN_name_slugs_keys) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/CRAN_name_slugs_keys.csv' with csv;
\copy (SELECT * FROM oss.code_gov_contributions) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_db/code_gov_contributions.csv' with csv;





\copy (SELECT * FROM oss_universe.all_repos_commits_2012) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/all_repos_commits_2012.csv' with csv;
\copy (SELECT * FROM oss_universe.all_repos_commits_2013) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/all_repos_commits_2013.csv' with csv;
\copy (SELECT * FROM oss_universe.all_repos_commits_2014) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/all_repos_commits_2014.csv' with csv;
\copy (SELECT * FROM oss_universe.all_repos_commits_2015) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/all_repos_commits_2015.csv' with csv;
\copy (SELECT * FROM oss_universe.all_repos_commits_2016) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/all_repos_commits_2016.csv' with csv;
\copy (SELECT * FROM oss_universe.all_repos_commits_2017) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/all_repos_commits_2017.csv' with csv;
\copy (SELECT * FROM oss_universe.all_repos_commits_2018) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/all_repos_commits_2018.csv' with csv;
\copy (SELECT * FROM oss_universe.bad_repos) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/bad_repos.csv' with csv;
\copy (SELECT * FROM oss_universe.contributions) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/contributions.csv' with csv;
\copy (SELECT * FROM oss_universe.copyright) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/copyright.csv' with csv;
\copy (SELECT * FROM oss_universe.errors) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/errors.csv' with csv;
\copy (SELECT * FROM oss_universe.github_commits) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/github_commits.csv' with csv;
\copy (SELECT * FROM oss_universe.github_repos) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/github_repos.csv' with csv;
\copy (SELECT * FROM oss_universe.github_repos_tracker) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/github_repos_tracker.csv' with csv;
\copy (SELECT * FROM oss_universe.licenses) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/licenses.csv' with csv;
\copy (SELECT * FROM oss_universe.reponames_2008) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/reponames_2008.csv' with csv;
\copy (SELECT * FROM oss_universe.reponames_2012) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/reponames_2012.csv' with csv;
\copy (SELECT * FROM oss_universe.reponames_2013) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/reponames_2013.csv' with csv;
\copy (SELECT * FROM oss_universe.reponames_2014) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/reponames_2014.csv' with csv;
\copy (SELECT * FROM oss_universe.reponames_2015) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/reponames_2015.csv' with csv;
\copy (SELECT * FROM oss_universe.reponames_2016) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/reponames_2016.csv' with csv;
\copy (SELECT * FROM oss_universe.reponames_2017) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/reponames_2017.csv' with csv;
\copy (SELECT * FROM oss_universe.reponames_2018) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/reponames_2018.csv' with csv;
\copy (SELECT * FROM oss_universe.slug_cnt) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/slug_cnt.csv' with csv;
\copy (SELECT * FROM oss_universe.slugcreatedon) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/slugcreatedon.csv' with csv;
\copy (SELECT * FROM oss_universe.tooMany) TO '/project/biocomplexity/sdad/projects_data/ncses/oss/data/oss_universe/tooMany.csv' with csv;






\dn
\dt gh_2007_2020.*
SELECT pg_size_pretty( pg_total_relation_size('oss_universe.all_repos_commits_2012') );
SELECT pg_size_pretty( pg_total_relation_size('gh.commits') );




-- https://docs.google.com/spreadsheets/d/1LLoN2JpW4wrdw5NsN3UfVunjrXh5sKzBB8zUoj0ANDY/edit#gid=0






