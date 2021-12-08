### UVA-BII Open Source Software 2019-2021

As of: 12/08/2021

This repository contains the 2020 analyses of GitHub data conducted by a team at the University of Virginia's Biocomplexity Institute. This team includes Gizem Korkmaz (now at Coleridge Initiative), [José Bayoán Santiago Calderón](https://jbsc.netlify.app/) (now at the Bureau of Economic Analysis), [Brandon Kramer](https://www.brandonleekramer.com/) (now at Edge & Node), and Aaron Schroder in the UVA's Social and Decision Analytics Division as well as Carol Robbins and Ledia Gucci at the US National Center for Science and Engineering Statistics (NCSES). For in-depth questions about the project's code, please contact Brandon Kramer. While the structure of the repo is outlined below, it is important to mention that several sibling repositories can also be found at the [Team OSS GitHub Organization](https://github.com/team-oss). Project deliverables are available at the [Team OSS Website](https://opensourcesoftware.netlify.app/). Moreover, the team has developed three packages to support work related to this project, including [GHOST.jl](https://github.com/team-oss/GHOST.jl), [tidyorgs](https://github.com/brandonleekramer/tidyorgs), and [diverstidy](https://github.com/brandonleekramer/diverstidy). 

#### oss-2020 repository structure 

From 2019-2021, the OSS team conducted four main sets of analyses. The **first** sets of analyses are located in the first two folders in the `src` folder (`01_github-refinements` and `02_github-descriptives`). For the project, we used the `GHOST.jl` package (see above), which is available in its raw form in the `gh.commits` table on the PgAdmin database. We also scraped user and repo data with `PyGitHub` (see `09_scrape-users` `10_scrape-repos` folders). The first folder details various refinements we made to remove duplicates, bots, and duplicate lines of code deriving from cloned repos. The second folder contains the descriptive analyses conducted on these refined data. The **second** set of analyses relates to classify OSS users. This code was converted from the [2020 DPSG project](https://github.com/dspG-Young-Scholars-Program/dspg20oss/) and is now mostly antiquated. As of Fall 2021, this code has been formalized into two packages named [tidyorgs](https://github.com/brandonleekramer/tidyorgs) and [diverstidy](https://github.com/brandonleekramer/diverstidy). Please use these for the most robust classification techniques. The **third** set of analyses are the cost estimations made for the ongoing *Research Policy* paper that Carol, Ledia, Gizem, Bayoán and Brandon are writing. This code can be used to estimate the labor costs for all US users over time (2009-2019) and make estimates by sector. While this code was not developed, this work can also be adapted to estimate the value of repos based on lines of code. The **fourth** set of analyses align with the network analysis paper Brandon has been developing for *Scientific Reports*. This work evaluates longitudinal trends in international collaboration at both the user- and country-level. This work was used to form the basis of a published statistical indicator (see `07_ncses-indicators` folder). Finally, the is an unfinshed set of research analyses to learn more about package maintainers in the `08_cran-maintainer-survey` folder. Below is an outline of the code and database structure: 

    ├── data 
        ├── GHTorrent data
        ├── GitHub commit data
        ├── Cost estimations data 
        ├── Sectoring data 
            ├── Academic datasets
            ├── Government datasets
            ├── Non-Profit datasets
        ├── CRAN Maintainers data
        
    ├── src
        ├── 01_github-wrangling
            ├── Variations of commits data 
        ├── 02_github-descriptives
            ├── GitHub activity for all repos 
            ├── GitHub activity for all contributors
            ├── GitHub activity for all owners
            ├── Top licenses on GitHub 
        ├── 03_github-sectoring
            ├── Full sectoring approach
            ├── Academic 
            ├── Business
            ├── Government
            ├── Household
            ├── Non-Profit
        ├── 04_github-cost-estimations
            ├── Cost estimates for all GitHub activity 
            ├── Cost estimates for GitHub activity by year
            ├── Cost estimates for GitHub activity by country
            ├── Cost estimates for GitHub activity by sector
        ├── 05_github-networks 
            ├── Network analysis of full GitHub network 
            ├── Network analysis of international collaboration on GitHub
            ├── Network analysis of academic collaboration on GitHub
            ├── Network analysis of business collaboration on GitHub
        ├── 06_oss-data-wrangling 
            ├── Data wrangling files
            ├── Code for posting data to PostgreSQL
        ├── 07_ncses-sidebars 
            ├── International collaborations 
            ├── Goverment contributions 
        ├── 08_cran-maintainer-survey
            ├── CRAN Maintainer data tool
            ├── CRAN wrangling and descriptives
        ├── 09_scrape-users
        ├── 10_scrape-repos

#### Database structure 

    ├── gh 
        ├── GitHub commits data 
            ├── gh.commits, gh.commits_dd, gh.commits_dd_nmrc_jbsc
        ├── GitHub user data 
        ├── GitHub descriptives
    ├── gh_2009_2020
        ├── GitHub commits data for 2020
            Note: The scrape was not fully completed
    ├── gh_cost 
        ├── GitHub cost tables  
    ├── gh_networks
        ├── Contributor networks 
        ├── International contributor networks  
        ├── Country-to-country networks  
    ├── github
    ├── github_mirror 
        ├── GHTorrent data  
    
    
    
