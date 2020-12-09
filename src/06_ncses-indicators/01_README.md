
### National Center for Science Engineering Statistics 
### Open Source Software 2020 Economic Indicators 
### International Collaborations Indicator 

### Scripts: 

    ├── 05_ncses_intl_indicators
        ├── 01_README.md 
            ├── Provides structure of materials for indicator creation
        ├── 02_commits-to-edgelist.sql 
            ├── Converts commits data to edgelist 
        ├── 03_github-to-ctry-code.Rmd 
            ├── Classifies GitHub users to countries  
        ├── 04_create-ctry-edgelist.Rmd 
            ├── Converts country edgelist to country collaboration edgelist 
        ├── 05_collaboration-matrix.R
            ├── Converts edgelist to collaboration matrix 

### Relevant Data: 

    ├── GHOSST.jl_Data 
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
          
            

