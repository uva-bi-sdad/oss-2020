
### README - GitHub Network Data

The GitHub network data was constructed from the raw GitHub commits data (`gh.commits_raw`). The commits table contains all commit activity from GitHub data spanning 2008 (GitHub's start date) to the end of 2019. The `gh.commits_raw` data contains all users that commit to OSI-approved licenses and the files in this folder take that commit data and projects the data into a format where all users (ctr1, ct2) that contribute to common repositories are connected by ties (i.e. listed next to each other in adjacent columns) that are both weighted and time-specific. The first step in this process is creating a year-by-year collaboration edgelist and then created 11 different tables for cumulative collaboration activity. 

### GitHub file structure: 

    01_full-github-network
    ├── 01_github-network-data-construction
        ├── 01_full-ctr-network-construction-dev.Rmd
            ├── This details the network construction development process (redundant with the SQL files).
        ├── GitHub year-by-year networks 
            ├── sna_ctr_edgelist_xyx.sql 
                ├── This creates the edgelist for collaboration in a year-by-year fashion. 
            ├── sna_ctr_nodelist_xyx.sql 
                ├── This pulls out all of the distinct nodes from the edgelist and creates a nodelist. 
        ├── GitHub cumulative networks 
            ├── sna_ctr_edgelist_08.sql : sna_ctr_edgelist_0819.sql
                ├── These files write edgelists for cumulative activity from 2008-2019.
            ├── sna_ctr_nodelist_full.sql
                ├── This pulls out all of the distinct nodes from the 2008-2019 edgelist and creates a nodelist.
    ├── 02_full-ctr-analysis
    ├── 03_full-repo-analysis
    
    02_international-collaboration
    ├── 01_intl-network-data-construction 
    ├── 02_contributor-networks
    ├── 03_country-networks
    ├── 04_repository-networks
    
    03_github-academic-networks
    ├── still in development
    
    04_github-company-networks
    ├── still in development
    
### PostgreSQL database structure: 

    Relevant schemas in sdad database (look under tables and views)
    ├── gh schema
        ├── Commits data 
            ├── commits_raw
        ├── Contributor network data 
            ├── sna_ctr_edgelist_08 
            ├── sna_ctr_edgelist_0809
            ├── sna_ctr_edgelist_0810
            ├── sna_ctr_edgelist_0811
            ├── sna_ctr_edgelist_0812
            ├── sna_ctr_edgelist_0813
            ├── sna_ctr_edgelist_0814
            ├── sna_ctr_edgelist_0815
            ├── sna_ctr_edgelist_0816
            ├── sna_ctr_edgelist_0817
            ├── sna_ctr_edgelist_0818
            ├── sna_ctr_edgelist_0819
            ├── sna_ctr_edgelist_yxy
            ├── sna_ctr_nodelist_yxy
            ├── sna_ctr_nodelist_full
        ├── International contributor network data         
            ├── sna_intl_ctr_edgelist_08 
            ├── sna_intl_ctr_edgelist_0809
            ├── sna_intl_ctr_edgelist_0810
            ├── sna_intl_ctr_edgelist_0811
            ├── sna_intl_ctr_edgelist_0812
            ├── sna_intl_ctr_edgelist_0813
            ├── sna_intl_ctr_edgelist_0814
            ├── sna_intl_ctr_edgelist_0815
            ├── sna_intl_ctr_edgelist_0816
            ├── sna_intl_ctr_edgelist_0817
            ├── sna_intl_ctr_edgelist_0818
            ├── sna_intl_ctr_edgelist_0819
            ├── sna_intl_ctr_edgelist_yxy
            ├── sna_intl_ctr_nodelist_yxy
            ├── sna_intl_ctr_nodelist_full 
        ├── International contributor network data         
            ├── sna_intl_ctry_edgelist_08 
            ├── sna_intl_ctry_edgelist_0809
            ├── sna_intl_ctry_edgelist_0810
            ├── sna_intl_ctry_edgelist_0811
            ├── sna_intl_ctry_edgelist_0812
            ├── sna_intl_ctry_edgelist_0813
            ├── sna_intl_ctry_edgelist_0814
            ├── sna_intl_ctry_edgelist_0815
            ├── sna_intl_ctry_edgelist_0816
            ├── sna_intl_ctry_edgelist_0817
            ├── sna_intl_ctry_edgelist_0818
            ├── sna_intl_ctry_edgelist_0819
            ├── sna_intl_ctry_edgelist_yxy
            ├── sna_intl_ctry_nodelist_yxy
            ├── sna_intl_ctry_nodelist_full 
        
        
        
