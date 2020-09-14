
rm(list = ls())

library(tidyverse)
setwd("/sfs/qumulo/qhome/kb7hp/oss-data")
bloomberg_gov_contractors <- read_csv("bloomberg_gov_contractors.csv")


library("RPostgreSQL")
# reconnecting to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# writing the new users_gh_cc table to postgis_2
dbWriteTable(conn, name = c(schema = "bloomberg" , name = "gov_contractors"),
             value = bloomberg_gov_contractors, row.names = FALSE)

# disconnect from postgresql database
dbDisconnect(conn)
