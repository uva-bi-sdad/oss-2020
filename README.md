### Open Source Software 2020 

Update: 11/10/2020

This repository contains the 2020 analyses of GitHub data conducted by researchers at the University of Virginia's Biocomplexity Institute. The structure of the repo is posted below. Here are links to our OSS sibling repos: [GHOSS.jl](https://github.com/uva-bi-sdad/GHOSS.jl), [CRAN](https://github.com/uva-bi-sdad/CRAN), [standardizeR](https://github.com/brandonleekramer/standardizeR), and [DSPG/oss-2020](https://github.com/DSPG-Young-Scholars-Program/dspg20oss)

    ├── data 
        ├── GHTorrent
        ├── GitHub commit data [see GHOSS.jl](https://github.com/uva-bi-sdad/GHOSS.jl)
        ├── Cost estimations data 
        ├── Sectoring data 
            ├── Academic datasets
            ├── Government datasets
            ├── Non-Profit datasets
        ├── CRAN Maintainers data
    ├── functions
        ├── [standardizeR](https://github.com/brandonleekramer/standardizeR)
    ├── src
        ├── 01_github-summary-analysis
        ├── 02_github-cost-estimations
        ├── 03_github-network-analysis 
        ├── 04_sectoring-analysis
        ├── 05_cran-maintainer-survey
        ├── 06_data-wrangling 

Overall, the `src` file contains analyses that pertain to: 

**Summary Tables for GitHub activity:**

    ├── GitHub activity for all repos 
    ├── GitHub activity for all contributors
    ├── GitHub activity for all owners
    ├── Top licenses on GitHub 

**Cost Estimates for GitHub activity:**

    ├── Cost estimates for all GitHub activity 
    ├── Cost estimates for GitHub activity by year
    ├── Cost estimates for GitHub activity by country
    ├── Cost estimates for GitHub activity by sector

**Network analysis of GitHub collaboration**

    ├── Network analysis of full GitHub network 
    ├── Network analysis of international collaboration on GitHub
    ├── Network analysis of academic collaboration on GitHub
    ├── Network analysis of business collaboration on GitHub

**Sectoring analysis of GitHub users**

    ├── Academic 
    ├── Business
    ├── Government
    ├── Household
    ├── Non-Profit
    ├── Full sectoring approach
    ├── [dspg20oss](https://github.com/DSPG-Young-Scholars-Program/dspg20oss) 

**CRAN Maintainer Survey:** 

    ├── [CRAN Maintainer data](https://github.com/uva-bi-sdad/CRAN) 
    ├── CRAN wrangling and descriptives 
    
**GitHub data sources and wrangling files:** 

    ├── Data wrangling files
    ├── Code for posting data to PostgreSQL 
