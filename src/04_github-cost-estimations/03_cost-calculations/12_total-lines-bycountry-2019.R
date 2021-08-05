rm(list = ls())
library(RPostgreSQL)
library(tidyverse)
library(tidytable)
library(data.table)
library(countrycode)

conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

#counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_annual_0919_dd WHERE YEAR = 2019;")
counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc WHERE YEAR = 2019;")

# disconnect from postgresql database
dbDisconnect(conn)

lines_per_country <- counts_by_country %>%
  as.data.table() %>%
  mutate(new_country = ifelse(country == "missing", "Missing",
                       ifelse(country == "us", "United States", "Other Countries"))) %>%
  group_by(new_country) %>%
  summarise(commits = sum(commits),
            additions = sum(additions),
            deletions = sum(deletions))

lines_summary <- lines_per_country %>%
  add_row(new_country = "Totals",
          commits = sum(lines_per_country$commits),
          additions = sum(lines_per_country$additions),
          deletions = sum(lines_per_country$deletions)) %>%
  rename(country = new_country)
lines_summary


