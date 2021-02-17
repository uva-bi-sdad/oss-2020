
#### National Center for Science Engineering Statistics 
#### Open Source Software 2020 Indicator Sidebars
#### International Collaborations Indicator 

#### Scripts: 

    ├── 01_intl_collaborations
        ├── README.md 
            ├── Provides structure of materials for indicator creation
        ├── 01_github-to-ctry-code.Rmd 
            ├── Classifies GitHub users to countries
        ├── 02_commits-to-yxy-edgelist.sql 
            ├── Converts commits data to edgelist 
        ├── 03_create-ctry-yxy-edgelist.Rmd 
            ├── Converts country edgelist to country collaboration edgelist 
        ├── 04_collaboration-matrix.R
            ├── Converts edgelist to collaboration matrix 
        ├── 05_tables-and-visualizations.Rmd
            ├── Creates visualizations and tables included in sidebar
    ├── 02_gov_contributions
        ├── TBD 

#### Relevant Data: 

    ├── GHOST.jl_Data 
        ├── commits_raw
            ├── slug
            ├── login
            ├── additions
            ├── deletions
            ├── committed_date
            ├── as_of

    ├── GHTorrent_Data 
        ├── ctrs_extra
            ├── login
            ├── email
            ├── company
            ├── country_code
            ├── city
            ├── state
            ├── location
            ├── state
            ├── latitude
            ├── longitude
        ├── ctrs_academic
            ├── login 
            ├── institution
            ├── country

#### Note: `ctrs_extra` combines GHTorrent users data with scraped email data for each user. 
          
            

