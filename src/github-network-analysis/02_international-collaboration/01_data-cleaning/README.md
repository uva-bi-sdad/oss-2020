**GitHub International Collaboration Folder/File Structure**

**01_data-cleaning Folder**

**01_country-code-cleaning.Rmd:** Provides the code to ingest raw GH Torrent data from PostgreSQL, recode location, state and city data into valid country codes, find the counts of users from each country, and the amount of users that list multiple countries.

**02_intl-network-construction.Rmd:** Building on the country-code-cleaning.Rmd code, this file recodes the country data and writes a nodelist with country_code (comma separated when multiple countries found), country_code_di (single, multiple), and country_code_viz (all countries listed except when multiple and then converted to "multiple").

**03_antiquated-network-notes.Rmd:** This file is the original amalgamation of notes used to create the bipartite networks. The 02_intl-network-construction.Rmd file provides a steamlined version of these notes, so this is not useful.
