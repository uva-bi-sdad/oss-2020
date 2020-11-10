


setwd("/sfs/qumulo/qhome/kb7hp/oss-data")
enterprise_data <- read.delim("enterprise_projects_wheaders.txt")


library("RPostgreSQL")
# reconnecting to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# writing the new users_gh_cc table to postgis_2
dbWriteTable(conn, name = c(schema = "spinellis_gh_enterprise" , name = "enterprise_projects"),
             value = enterprise_data, row.names = FALSE)

# disconnect from postgresql database
dbDisconnect(conn)



setwd("/sfs/qumulo/qhome/kb7hp/oss-data")
cohort_data <- read.delim("cohort_project_details_wheaders.txt")
cohort_data <- cohort_data %>% rename(url = Url)

library("RPostgreSQL")
# reconnecting to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# writing the new users_gh_cc table to postgis_2
dbWriteTable(conn, name = c(schema = "spinellis_gh_enterprise" , name = "cohort_project_details"),
             value = cohort_data, row.names = FALSE)

# disconnect from postgresql database
dbDisconnect(conn)








