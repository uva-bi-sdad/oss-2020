**GitHub International Collaboration Folder/File Structure**

**02_contributor-networks Folder**

**01_intl-dyn-ctr-nets-cumulative.Rmd:** This file ingests the nodelist and edgelists, creates a bipartite network, transposes the network into only a contributor network, and finally runs network global and node-level statistics for each year of GitHub's history (2008-2018) in a *cumulative* fashion.

**02_intl-dyn-ctr-nets-cumulative-report.Rmd:** This files ingests the global and node-level statistics computed in the previous files and then graphs the variation in  cumulative networks over time.

**03_intl-dyn-ctr-nets-yearbyyear.Rmd:** This file ingests the nodelist and edgelists, creates a bipartite network, transposes the network into only a contributor network, and finally runs network global and node-level statistics for each year of GitHub's history (2008-2018) in a *year-by-year* fashion.

**04_intl-dyn-ctr-nets-yearbyyear-report.Rmd:** This files ingests the global and node-level statistics computed in the previous files and then graphs the variation in year-by-year networks over time.

**05_intl-dyn-ctr-nets-pub-figures.Rmd:** This files ingests the global and node-level statistics computed in the previous files and then graphs the variation in year-by-year AND cumulative networks over time.

**06_intl-dyn-ctr-powerlaw-analysis.Rmd:** This file looks at the node-level (weighted and unweighted) degree distribution to determine the magnitude of the power laws on a year-by-year and cumulative basis.


**PostgreSQL Data**

**users_gh_cc:** All users with country_code data. 

**intl_dyn_bp_edgelist:** Full dynamic bipartite edgelist for users with valid country_codes. 
