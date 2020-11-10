
### OSS Sectoring Approach 

This folder is the more mature version of the OSS Data Science for Public Good 2020 Summer Project (see [Repo](https://github.com/DSPG-Young-Scholars-Program/dspg20oss) and [Website](https://dspg-young-scholars-program.github.io/dspg20oss/?dspg)). For an overview of the methods used for sector, see the [DSPG methods page](https://dspg-young-scholars-program.github.io/dspg20oss/methods/?dspg).

### TO-DO: 

- Consolidate documentation 
  - Go back to DSPG spreadsheet and document additional datasources
  - Go back to OSS planning sheet and merge data information 
- Supplement geo user data  
  - Match users to country code through academic institutions  
  - Match users to countries based on email 
  - Match users to countries based on cities 
  - Re-run international networks based on these updates 
- Finish within government sectoring
  - Finalize standardizeR functions 
  - Conduct user matching to government institutions 
  - Fix false positions from Crystal's initial gov sectoring 
- Match contributors to companies 
  - Match on Forbes data 
  - Match on US companies dataset 
  - Match on [Lazer et al.'s government strucuture data](http://gov-structure.kimalbrecht.com/) 
  - Match on [US Spending database](https://files.usaspending.gov/database_download/) 
- Improve nonprofit sector
  - Fix false negatives from Crystal's initial gov sectoring 
  - Match based on [IRS nonprofit dataset](https://www.irs.gov/charities-non-profits/exempt-organizations-business-master-file-extract-eo-bmf)

### GitHub file structure: 

    01_sectoring-all-users.Rmd 
    02_academic
        ├──  
    03_business
        ├── 
    04_government 
        ├── 
    05_household  
        ├── 01_household-matching.Rmd
    06_nonprofit  
        ├── 01_nonprofit-matching.Rmd
    
### PostgreSQL database structure: 

    Relevant schemas in sdad database (look under tables and views)
    
    GitHub contributor data 
        ├── gh.ctrs_raw
            - Raw contributor data from GHTorrent
        ├── gh.ctrs_extra 
            - Contributor data from GHTorrent with extra attributes (used for DSPG)
        ├── gh.sna_ctr_academic
            - All matched academic contributors 
        ├── gh.sna_ctr_gov 
            - All matched government contributors
        ├── gh.sna_ctr_nonprofits
            - All matched nonprofit contributors
        ├── gh.sna_ctr_sectors
            - All matched sectored contributors
    Academic matching 
        ├── hipolabs.universites          
        ├── ipeds.flags2018
        ├── ipeds.ic2018ay
        ├── ipeds.ic2018py
    Business matching          
        ├── forbes.fortune2018_top100
        ├── forbes.fortune2019_top100
        ├── forbes.fortune2020_global2000
    Government matching          
        ├── bloomberg.gov_contractors
        ├── gleif.legal_entities
        ├── us_gov_depts.gov_acronyms
        ├── us_gov_depts.us_gov_index_clean
        ├── us_gov_depts.us_gov_ffrdcs
        ├── us_gov_depts.us_gov_manual 
        ├── us_sam.fh_public_api
    Nonprofit matching          
        ├── forbes.charities_2019_top100 
        ├── united_nations.ngo_list
        ├── us_gov_depts.nonprofit_govadmins
    Geographic matching 
        ├── gh.ctrs_raw
            - Matched contributors to country based on 
        ├── datahub.domain_names
            - We match contributors with country codes from emails
        ├── hipolabs.universities  
            - We match users based on university and then match users to country code 
        ├── maxmind.world_cities
            - We matched users based on cities & lat/lon to country code 










