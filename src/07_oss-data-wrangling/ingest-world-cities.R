
rm(list = ls())

library(tidyverse)
setwd("/sfs/qumulo/qhome/kb7hp/oss-data")
city_dataset <- read_csv("worldcitiespop.csv")


city_dataset %>%
  drop_na(Population)

library("RPostgreSQL")
# reconnecting to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# writing the new users_gh_cc table to postgis_2
dbWriteTable(conn, name = c(schema = "maxmind" , name = "world_cities"),
             value = city_dataset, row.names = FALSE)

# disconnect from postgresql database
dbDisconnect(conn)
