
#### GitHub Cost Estimatitons

This folder contains all the materials needed to calculate the cost estimations for GitHub Open Source Software repositories. This process is done using COCOMO2 and estimates acquired from our colleagues Carol Robbins and Ledia Gucci at the National Center for Science and Engineering Statistics (NCSES). 

#### Prerequisites 

To run these calculations, the `commits` and `users` data are needed. However, before getting started, some data cleaning needs to be done to get appropriate estimates. Five different versions of the `commits` were developed in the `/src/00_github-data-cleaning` folder based on whether the data comes from the raw data, the deduplicated data, the data with bots removed, or the data having multi-repo commits removed.  

#### Creating Tables and Running Cost Estimations 

Once these general tables are present in the database, the tables for the cost estimates can be made by using the code for producing tables in the `/src/02_github-cost-estimations/0X_cost-calcs-X/01_cost-calcs-tables/` folders. After all of the tables are produced, the cost estimates can be calculated in `R` under the `/src/02_github-cost-estimations/0X_cost-calcs-X` folders. A summary of these differences has been outlined in this [Google sheet](https://docs.google.com/document/d/1L9HEeY1V-jeGwGdyBx41eKjx2oH94dWkYGqfdczZUkY/edit). 

#### Repository Overview 

    ├── oss-2020/src
        ├── 02_github-cost-estimations
            ├── 01_cost-calcs-tables
                ├── 01_cost_logins_w_sector_info.sql
                ├── 02_cost-calcs-original-tables
                    ├── 02_cost_by_repo_0919.sql
                    ├── 03_cost_by_year_0919.sql
                    ├── 04_cost_by_login_annual_0919.sql
                    ├── 05_cost_by_sector_0919.sql
                    ├── 06_cost_by_country_0919.sql
                    ├── 07_cost_by_country_19.sql
                    ├── 08_cost_by_sector_geo_0919.sql
                    ├── 09_cost_academic_geo_0919.sql
                ├── 03_cost-calcs-dd-tables.R
                    ├── 02_cost_by_repo_0919_dd.sql
                    ├── 03_cost_by_year_0919_dd.sql
                    ├── 04_cost_by_login_annual_0919_dd.sql
                    ├── 05_cost_by_sector_0919_dd.sql
                    ├── 06_cost_by_country_0919_dd.sql
                    ├── 07_cost_by_country_19_dd.sql
                    ├── 08_cost_by_sector_geo_0919_dd.sql
                    ├── 09_cost_academic_geo_0919_dd.sql
                ├── 04_cost-calcs-dd-nbots-tables.R
                    ├── 02_cost_by_repo_0919_dd_nbots.sql
                    ├── 03_cost_by_year_0919_dd_nbots.sql
                    ├── 04_cost_by_login_annual_0919_dd_nbots.sql
                    ├── 05_cost_by_sector_0919_dd_nbots.sql
                    ├── 06_cost_by_country_0919_dd_nbots.sql
                    ├── 07_cost_by_country_19_dd_nbots.sql
                    ├── 08_cost_by_sector_geo_0919_dd_nbots.sql
                    ├── 09_cost_academic_geo_0919_dd_nbots.sql
                ├── 05_cost-calcs-dd-nmrc-tables.R
                    ├── 02_cost_by_repo_0919_dd_nmrc.sql
                    ├── 03_cost_by_year_0919_dd_nmrc.sql
                    ├── 04_cost_by_login_annual_0919_dd_nmrc.sql
                    ├── 05_cost_by_sector_0919_dd_nmrc.sql
                    ├── 06_cost_by_country_0919_dd_nmrc.sql
                    ├── 07_cost_by_country_19_dd_nmrc.sql
                    ├── 08_cost_by_sector_geo_0919_dd_nmrc.sql
                    ├── 09_cost_academic_geo_0919_dd_nmrc.sql
                ├── 06_cost-calcs-dd-nmrc-nbots-tables.R
                    ├── 02_cost_by_repo_0919_dd_nmrc_nbots.sql
                    ├── 03_cost_by_year_0919_dd_nmrc_nbots.sql
                    ├── 04_cost_by_login_annual_0919_dd_nmrc_nbots.sql
                    ├── 05_cost_by_sector_0919_dd_nmrc_nbots.sql
                    ├── 06_cost_by_country_0919_dd_nmrc_nbots.sql
                    ├── 07_cost_by_country_19_dd_nmrc_nbots.sql
                    ├── 08_cost_by_sector_geo_0919_dd_nmrc_nbots.sql
                    ├── 09_cost_academic_geo_0919_dd_nmrc_nbots.sql
            ├── 02_cost-calcs-by-repo.R
            ├── 03_cost-calcs-2019.R
            ├── 04_cost-calcs-by-sector.R
            ├── 05_cost-calcs-by-country.R
            ├── 06_cost-calcs-in-academia.R
            ├── 07_cost-calcs-by-country-2019.R
            ├── 08_cost-calcs-comparisons.R
    ├── oss-2020/data
        ├── cost_estimations 
            ├── cost_original
            ├── cost_dd
            ├── cost_dd_nbots
            ├── cost_dd_nmrc
            ├── cost_dd_nmrc_nbots 
            
#### Database Overview

    ├── gh_cost
        ├── 
        ├── 
