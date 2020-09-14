
rm(list = ls())

library(tidyverse)
setwd("/sfs/qumulo/qhome/kb7hp/oss-data")
ipeds_hd2018 <- read_csv("ipeds_hd2018.csv")
ipeds_flags2018 <- read_csv("ipeds_flags2018.csv")
ipeds_ic2018 <- read_csv("ipeds_ic2018.csv")
ipeds_ic2018ay <- read_csv("ipeds_ic2018ay.csv")
ipeds_ic2018py <- read_csv("ipeds_ic2018py.csv")

ipeds_hd2018 <- ipeds_hd2018 %>%
  filter(UNITID != 120795 & UNITID != 161509 & UNITID != 162654 & UNITID != 177302)

ipeds_hd2018 = ipeds_hd2018[-c(2074, 2145, 2278, 3024, 2144),]


library("RPostgreSQL")
# reconnecting to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# writing the new users_gh_cc table to postgis_2
dbWriteTable(conn, name = c(schema = "ipeds" , name = "hd2018"),
             value = ipeds_hd2018, row.names = FALSE)
dbDisconnect(conn)




dbWriteTable(conn, name = c(schema = "ipeds" , name = "flags2018"),
             value = ipeds_flags2018, row.names = FALSE)
dbWriteTable(conn, name = c(schema = "ipeds" , name = "ic2018"),
             value = ipeds_ic2018, row.names = FALSE)
dbWriteTable(conn, name = c(schema = "ipeds" , name = "ic2018ay"),
             value = ipeds_ic2018ay, row.names = FALSE)
dbWriteTable(conn, name = c(schema = "ipeds" , name = "ic2018py"),
             value = ipeds_ic2018py, row.names = FALSE)

# disconnect from postgresql database
dbDisconnect(conn)
