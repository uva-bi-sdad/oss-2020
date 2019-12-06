# OSS 2019-2020 

## Network Analysis 

This folder contains a series of files of .Rmd files that wrangle, recode, and compute networks statistics for the GH Torrent GitHub data that is included on the PostgreSQL (postgis_2) database. In operational order, these files include:

**International Analyses**

**country-code-cleaning.Rmd:** Provides the code to ingest raw GH Torrent data from PostgreSQL, recode location, state and city data into valid country codes, find the counts of users from each country, and the amount of users that list multiple countries. 

**intl-nets-construction.Rmd:** Building on the country-code-cleaning code, this file recodes the country data in addition to writing nodelists (users_gh_cc) and edgelists (intl_st_bp_edgelist, intl_dyn_bp_edgelist) to the database.

**intl-dyn-ctr-nets-cum.Rmd:** This file ingests the nodelist and edgelists, creates a bipartite network, transposes the network into only a contributor network, and finally runs network global and node-level statistics for each year of GitHub's history (2008-2018) in a *cumulative* fashion.

**intl-dyn-ctr-nets-yxy.Rmd:** This file ingests the nodelist and edgelists, creates a bipartite network, transposes the network into only a contributor network, and finally runs network global and node-level statistics for each year of GitHub's history (2008-2018) in a *year-by-year* fashion.

**intl-dyn-ctr-nets-sum.Rmd:** This files ingests the global and node-level statistics computed in the previous files and then graphs the variation in year-by-year and cumulative networks over time.  

**intl-repo-nets.Rmd:** This file ingests the nodelist and edgelists, creates a bipartite network, transposes the network into only a repository network. This file is still incomplete.

**Organizational Analyses**

**org-code-cleaning.Rmd:** Provides the code to ingest raw GH Torrent data from PostgreSQL, recode company code data into valid organizational codes, find the counts of users from each organization, and totals from both academic and non-academic institutions. 




