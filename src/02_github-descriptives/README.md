
### README - GitHub Summary Data




The GitHub network data was constructed from the raw GitHub commits data (`gh.commits_raw`). The commits table contains all commit activity from GitHub data spanning 2008 (GitHub's start date) to the end of 2019. The `gh.commits_raw` data contains all users that commit to OSI-approved licenses and the files in this folder take that commit data and projects the data into a format where all users (ctr1, ct2) that contribute to common repositories are connected by ties (i.e. listed next to each other in adjacent columns) that are both weighted and time-specific. The first step in this process is creating a year-by-year collaboration edgelist and then created 11 different tables for cumulative collaboration activity. 

### GitHub file structure: 



### PostgreSQL database structure: 

    Relevant schemas in sdad database (look under tables and views)
    ├── gh 
        ├── Commits data 
            ├── commits_raw
        ├── Summary Tables
            ├── desc_ctrs_summary
            ├── desc_ctrs_summary_yxy
            ├── desc_owners_summary
            ├── desc_repos_summary
            ├── desc_licenses_osi
