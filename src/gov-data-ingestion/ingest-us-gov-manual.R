

library("XML")
setwd("/sfs/qumulo/qhome/kb7hp/oss-data")
us_gov_manual <- xmlToDataFrame("GOVMAN-2019-11-21.xml")
us_gov_manual


library("RPostgreSQL")
# reconnecting to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# writing the new users_gh_cc table to postgis_2
dbWriteTable(conn, name = c(schema = "us_gov_manual" , name = "us_govman_2019"),
             value = us_gov_manual, row.names = FALSE)

# disconnect from postgresql database
dbDisconnect(conn)
