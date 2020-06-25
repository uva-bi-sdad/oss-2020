
rm(list = ls())

library(tidyverse)
setwd("/sfs/qumulo/qhome/kb7hp/oss-data")
domain_names <- read_csv("top-level-domain-names.csv")

domain_names <- domain_names %>%
  rename(domain = Domain, type = Type, organization = `Sponsoring Organisation`)

library("RPostgreSQL")
# reconnecting to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# writing the new users_gh_cc table to postgis_2
dbWriteTable(conn, name = c(schema = "datahub" , name = "domain_names"),
             value = domain_names, row.names = FALSE)

# disconnect from postgresql database
dbDisconnect(conn)
