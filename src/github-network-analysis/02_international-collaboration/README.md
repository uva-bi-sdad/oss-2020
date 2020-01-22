# OSS 2019-2020

## Network Analysis

This folder contains a series of files of .Rmd files that wrangle, recode, and compute networks statistics for the GH Torrent GitHub data that is included on the PostgreSQL (postgis_2) database. In operational order, these files include:

**GitHub International Collaboration Folder/File Structure**

**01_data-cleaning Folder:** Contains .Rmd files for (1) cleaning the raw data, (2) allocating country_code information to those data, and (3) converting that data to nodelists and edgelists. 

**02_contributor-networks Folder:** Contains .Rmd files for conducting year-by-year and cumulative network analysis at the contributor level. 

**03_repository-networks Folder:** Contains .Rmd files for conducting year-by-year and cumulative network analysis at the repository level. 

**04_country-to-country-networks Folder:** Contains .Rmd files for conducting year-by-year and cumulative network analysis at the country level. 


**PostgreSQL Data**

**users_gh_cc:** All users with country_code data. 

**intl_dyn_bp_edgelist:** Full dynamic bipartite edgelist for users with valid country_codes. 
