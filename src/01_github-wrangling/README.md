
#### GitHub data wrangling  

As of: 02-16-2020

In this folder, we detail the data refinement strategies we used on the GitHub data. The `commits_raw` is the original data scraped from GitHub using the `GHOST.jl` package. Refinements include deduplication, removal of bots, and removal of multi-repo commits.

#### GitHub Structure
    
    ├── oss-2020/src  
        ├──00_github-data-checks
            ├── 01_commits_raw.sql
            ├── 02_commits_dd.sql 
            ├── 03_commits_dd_nmrc.sql 
            ├── 04_commits_dd_nbots.sql
            ├── 05_commits_dd_nmrc_nbots.sql
            ├── 06_commits_per_user_*.sql

#### Database Structure
    
    ├── PostgreSQL 
        ├── gh
            ├── commits_raw
            ├── commits_dd
            ├── commits_nmrc
            ├── commits_dd_nbots
            ├── commits_dd_nmrc_nbots
            ├── commits_per_user
            ├── commits_per_user_dd
            ├── commits_per_user_dd_nbots
            ├── commits_per_user_dd_nmrc
            ├── commits_per_user_dd_nmrc_nbots
           
