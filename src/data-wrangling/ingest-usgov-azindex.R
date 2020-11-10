
rm(list = ls())

library(tidyverse)
setwd("/sfs/qumulo/qhome/kb7hp/oss-data")
us_gov_azindex <- read_csv("a-z_fedgov_agencies_blk.csv")

us_gov_azindex <- us_gov_azindex %>%
  rename(agency = Agency, gov_branch = `Government Branch`, gov_agency = `Department Agency`,
         child_agency = `Child Agency`, website = Website, other_website = `Other Websites`) %>%
  select(-X7)

library("RPostgreSQL")
# reconnecting to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# writing the new users_gh_cc table to postgis_2
dbWriteTable(conn, name = c(schema = "us_gov_depts" , name = "us_gov_azindex_clean"),
             value = us_gov_azindex, row.names = FALSE)

# disconnect from postgresql database
dbDisconnect(conn)


## GRANT SELECT ON TABLE us_gov_depts.us_gov_azindex_clean TO ncses_oss;
