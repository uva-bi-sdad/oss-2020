
rm(list = ls())

library(tidyverse)
setwd("/sfs/qumulo/qhome/kb7hp/oss-data")
herd_data <- read_csv("herd_2018.csv")
fss_data <- read_csv("fss_2018.csv")

herd_data <- herd_data %>%
  mutate(
    all_rnd_expenditures = all_rnd_expenditures * 1000,
    federal_government = federal_government * 1000,
    state_local_government = state_local_government * 1000,
    institution_funds = institution_funds * 1000,
    business = business * 1000,
    nonprofit_organizations = nonprofit_organizations * 1000,
    all_other_sources = all_other_sources * 1000
  )

fss_data <- fss_data %>%
  mutate(
    all_federal_obligations = all_federal_obligations * 1000,
    rnd = rnd * 1000,
    rnd_plant = rnd_plant * 1000,
    sne_instruction_facilties = sne_instruction_facilties * 1000,
    fellowship_training_grants = fellowship_training_grants * 1000,
    sne_general_support = sne_general_support * 1000,
    sne_other_activities = sne_other_activities * 1000
  )


library("RPostgreSQL")
# reconnecting to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# writing the new users_gh_cc table to postgis_2
dbWriteTable(conn, name = c(schema = "ncses" , name = "herd_2018"),
             value = herd_data, row.names = FALSE)

dbWriteTable(conn, name = c(schema = "ncses" , name = "fss_2018"),
             value = fss_data, row.names = FALSE)

# disconnect from postgresql database
dbDisconnect(conn)
