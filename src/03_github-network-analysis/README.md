
### README - GitHub Network Data

The GitHub network data was constructed from the raw GitHub commits data (`gh.commits_raw`). The commits table contains all commit activity from GitHub data spanning 2008 (GitHub's start date) to the end of 2019. The `gh.commits_raw` data contains all users that commit to OSI-approved licenses and the files in this folder take that commit data and projects the data into a format where all users (ctr1, ct2) that contribute to common repositories are connected by ties (i.e. listed next to each other in adjacent columns) that are both weighted and time-specific. The first step in this process is creating a year-by-year collaboration edgelist and then created 11 different tables for cumulative collaboration activity. 

### TO-DO: 

1. Finish running full network analyses over time 
    a. Convert code to function in `R` and run `slurm` 
2. Re-run international network analyses 
    a. Match users to country code through academic institutions  
    b. Match users to countries based on email 
    c. Match users to countries based on cities 
    d. Re-run international networks based on these updates
    e. Convert code to function in `R` and run `slurm` 
3. Run repo networks using the `slurm` procedure
4. Run academic academic networks using the `slurm` procedure 
5. Run company networks using the `slurm` procedure

### GitHub file structure: 

    01_full-github-network
        ├── 01_github-network-data-construction
            ├── 01_full-ctr-network-construction-dev.Rmd
                - This details the network construction development process (redundant with the SQL files).
            ├── GitHub year-by-year networks 
                ├── sna_ctr_edgelist_xyx.sql 
                    - This creates the edgelist for collaboration in a year-by-year fashion. 
                ├── sna_ctr_nodelist_xyx.sql 
                    - This pulls out all of the distinct nodes from the edgelist and creates a nodelist. 
            ├── GitHub cumulative networks 
                ├── sna_ctr_edgelist_08.sql : sna_ctr_edgelist_0819.sql
                    - These files write edgelists for cumulative activity from 2008-2019.
                ├── sna_ctr_nodelist_full.sql
                    - This pulls out all of the distinct nodes from the 2008-2019 edgelist and creates a nodelist.
        ├── 02_full-ctr-analysis
        ├── 03_full-repo-analysis
    02_international-collaboration
        ├── 01_intl-network-data-construction 
        ├── 02_contributor-networks
        ├── 03_country-networks
        ├── 04_repository-networks
    03_github-academic-networks
        ├── 
    04_github-company-networks
        ├── 
    
### PostgreSQL database structure: 

    Relevant schemas in sdad database (look under tables and views)
    
    GitHub Commits data 
        ├── gh.commits_raw
    GitHub Contributor network data 
        ├── gh.sna_ctr_edgelist_08 
        ├── gh.sna_ctr_edgelist_0809
        ├── gh.sna_ctr_edgelist_0810
        ├── gh.sna_ctr_edgelist_0811
        ├── gh.sna_ctr_edgelist_0812
        ├── gh.sna_ctr_edgelist_0813
        ├── gh.sna_ctr_edgelist_0814
        ├── gh.sna_ctr_edgelist_0815
        ├── gh.sna_ctr_edgelist_0816
        ├── gh.sna_ctr_edgelist_0817
        ├── gh.sna_ctr_edgelist_0818
        ├── gh.sna_ctr_edgelist_0819
        ├── gh.sna_ctr_edgelist_yxy
        ├── gh.sna_ctr_nodelist_yxy
        ├── gh.sna_ctr_nodelist_full
    GitHub International contributor network data         
        ├── gh.sna_intl_ctr_edgelist_08 
        ├── gh.sna_intl_ctr_edgelist_0809
        ├── gh.sna_intl_ctr_edgelist_0810
        ├── gh.sna_intl_ctr_edgelist_0811
        ├── gh.sna_intl_ctr_edgelist_0812
        ├── gh.sna_intl_ctr_edgelist_0813
        ├── gh.sna_intl_ctr_edgelist_0814
        ├── gh.sna_intl_ctr_edgelist_0815
        ├── gh.sna_intl_ctr_edgelist_0816
        ├── gh.sna_intl_ctr_edgelist_0817
        ├── gh.sna_intl_ctr_edgelist_0818
        ├── gh.sna_intl_ctr_edgelist_0819
        ├── gh.sna_intl_ctr_edgelist_yxy
        ├── gh.sna_intl_ctr_nodelist_yxy
        ├── gh.sna_intl_ctr_nodelist_full 
    GitHub International contributor network data         
        ├── gh.sna_intl_ctry_edgelist_08 
        ├── gh.sna_intl_ctry_edgelist_0809
        ├── gh.sna_intl_ctry_edgelist_0810
        ├── gh.sna_intl_ctry_edgelist_0811
        ├── gh.sna_intl_ctry_edgelist_0812
        ├── gh.sna_intl_ctry_edgelist_0813
        ├── gh.sna_intl_ctry_edgelist_0814
        ├── gh.sna_intl_ctry_edgelist_0815
        ├── gh.sna_intl_ctry_edgelist_0816
        ├── gh.sna_intl_ctry_edgelist_0817
        ├── gh.sna_intl_ctry_edgelist_0818
        ├── gh.sna_intl_ctry_edgelist_0819
        ├── gh.sna_intl_ctry_edgelist_yxy
        ├── gh.sna_intl_ctry_nodelist_yxy
        ├── gh.sna_intl_ctry_nodelist_full 
    GitHub contributor data 
        ├── github_mirror.users_osi_gh
            - This is the original 2.1m contributors from GHTorrent 
        ├── gh.ctrs_raw
            - This is the original 2.1m contributors from GHTorrent (but in gh schema)
        ├── gh.ctrs_extra
            - This is the 2.1m contributors GHTorrent data with more ctr attributes
    Geographic matching data 
        ├── gh.ctrs_raw
            - Matched contributors to country based on 
        ├── datahub.domain_names
            - We match contributors with country codes from emails
        ├── hipolabs.universities  
            - We match users based on university and then match users to country code 
        ├── maxmind.world_cities
            - We matched users based on cities & lat/lon to country code 
          
          
          
          
          
          
