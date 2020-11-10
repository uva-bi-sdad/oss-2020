
rm(list = ls())

library(jsonlite)
setwd("/sfs/qumulo/qhome/kb7hp/oss-data")
academic_dataset <- jsonlite::fromJSON("world_universities_and_domains.json")

library(tidyverse)
academic_dataset <- academic_dataset %>%
  rename(institution = name, state_provience = `state-province`,
         country_code = alpha_two_code, webpages = web_pages) %>%
  select(institution, country, country_code, domains, webpages, state_provience) %>%
  unnest(domains) %>%
  unnest(webpages)

library("RPostgreSQL")
# reconnecting to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# writing the new users_gh_cc table to postgis_2
dbWriteTable(conn, name = c(schema = "hipolabs" , name = "universities_new"),
             value = academic_dataset, row.names = FALSE)

# disconnect from postgresql database
dbDisconnect(conn)
