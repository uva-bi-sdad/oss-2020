
rm(list = ls())

library(tidyverse)
setwd("/sfs/qumulo/qhome/kb7hp/oss-data")
country_list <- read_csv("country-and-continent-codes-list.csv")


library("RPostgreSQL")
# reconnecting to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# writing the new users_gh_cc table to postgis_2
dbWriteTable(conn, name = c(schema = "datahub" , name = "country_codes"),
             value = country_list, row.names = FALSE)

# disconnect from postgresql database
dbDisconnect(conn)

# https://datahub.io/JohnSnowLabs/country-and-continent-codes-list
