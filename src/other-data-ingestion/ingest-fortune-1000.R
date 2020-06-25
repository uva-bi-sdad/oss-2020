
rm(list = ls())

library(tidyverse)
setwd("/sfs/qumulo/qhome/kb7hp/oss-data")
fortune_1000_2018 <- read_csv("fortune-data-2018-kaggle.csv")
fortune_1000_2019 <- read_csv("fortune-data-2019-someka.csv")
fortune_1000_2020 <- read_csv("fortune-data-2020-forbes.csv")

library("RPostgreSQL")
# reconnecting to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# writing the new users_gh_cc table to postgis_2
dbWriteTable(conn, name = c(schema = "forbes" , name = "fortune2018_us1000"),
             value = fortune_1000_2018, row.names = FALSE)

dbWriteTable(conn, name = c(schema = "forbes" , name = "fortune2019_us1000"),
             value = fortune_1000_2019, row.names = FALSE)

dbWriteTable(conn, name = c(schema = "forbes" , name = "fortune2020_global2000"),
             value = fortune_1000_2020, row.names = FALSE)

# disconnect from postgresql database
dbDisconnect(conn)
