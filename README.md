### UVA-BII Open Source Software 2020-21

As of: 02/16/2021

This repository contains the 2020 analyses of GitHub data conducted by a team at the [University of Virginia's Biocomplexity Institute](https://github.com/uva-bi-sdad/OSS-Research-Website). This team includes Gizem Korkmaz, José Bayoán Santiago Calderón, Brandon Kramer, Aaron Schroder, and Sallie Keller in UVA's Social and Decision Analytics Division and Carol Robbins and Ledia Gucci at the US National Center for Science and Engineering Statistics. 

The structure for this repo is outlined below, but this repo also links to several sibling repos:
[GHOSS.jl](https://github.com/uva-bi-sdad/GHOSS.jl), [CRAN](https://github.com/uva-bi-sdad/CRAN), [standardizeR](https://github.com/brandonleekramer/standardizeR), and [DSPG-Young-Scholars-Program/dspg20oss](https://github.com/DSPG-Young-Scholars-Program/dspg20oss).

#### GitHub structure 

    ├── data 
        ├── GHTorrent data
        ├── GitHub commit data
        ├── Cost estimations data 
        ├── Sectoring data 
            ├── Academic datasets
            ├── Government datasets
            ├── Non-Profit datasets
        ├── CRAN Maintainers data
    ├── scripts
        ├── standardizeR
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

#### Database structure 

    ├── gh 
        ├── GitHub commits data 
        ├── GitHub user data  
        ├── GitHub descriptives
    ├── gh_cost 
        ├── GitHub cost tables  
    ├── gh_networks
        ├── Contributor networks 
        ├── International contributor networks  
        ├── Country-to-country networks  
    ├── github
    ├── github_mirror 
        ├── GHTorrent data  
    
    
    
