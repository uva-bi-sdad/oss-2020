
#### National Center for Science Engineering Statistics 
#### Open Source Software 2020 Indicator Sidebars
#### International Collaborations Indicators 

#### Scripts: 

    ├── 01_schema_mapping.Rmd
        ├── Provides figures for the data integration process 
    ├── 02_intl_collaborations
        ├── 01_raw-commits-to-yxy-edgelist.sql 
            ├── Converts commits data to edgelist 
        ├── 02_github-users-to-ctry.Rmd 
            ├── Classifies GitHub users to countries
        ├── 03_create-ctry-yxy-edgelist.Rmd 
            ├── Converts country edgelist to country collaboration edgelist 
        ├── 04_collaboration-matrices.R
            ├── Converts edgelist to collaboration matrix 
        ├── 05_tables-and-visualizations.Rmd
            ├── Creates visualizations and tables included in sidebar
        ├── 06_variation-over-time.Rmd
            ├── Visualizes variations in collaborations over time 
        ├── 07_total_activity_allvsintl.sql
            ├── Compares international GitHub activity vs. all GitHub activity
        ├── README.md 
            ├── Provides structure of materials for indicator creation

