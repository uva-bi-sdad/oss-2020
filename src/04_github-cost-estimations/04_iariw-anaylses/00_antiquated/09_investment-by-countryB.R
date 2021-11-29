
rm(list = ls())
library(tidyverse)
library(tidyorgs)
library(diverstidy)
library(RPostgreSQL)
library(tidytable)

conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
counts_by_year <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_year_0919_dd_nmrc_jbsc;")
dbDisconnect(conn)

counts_by_year <- data.table::as.data.table(counts_by_year)

#COST BASED ON Additions
counts_by_year[,person_months := round(2.5 * (2.4 * (additions/1000)^1.05)^0.38,2)]

conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_yr_0919_lchn_frac_110621;")
dbDisconnect(conn)

table(counts_by_country$country)

# joints sector info and the cost estimates at repo level
repos_geo_joined <- counts_by_country %>%
  rename.(geo_additions = fr_additions,
          geo_deletions = fr_deletions) %>%
  left_join(counts_by_year, by = c("slug", "year")) %>%
  select(slug, country, year, everything())

# calculates the cost for sectors additions
repos_geo_joined <- repos_geo_joined %>%
  rename.(repo_additions = additions,
          repo_deletions = deletions) %>%
  mutate.(geo_fraction = round(geo_additions / repo_additions, 3),
          geo_person_months = geo_fraction * person_months) %>%
  arrange.(slug, country, geo_fraction)
repos_geo_joined$geo_person_months[is.nan(repos_geo_joined$geo_person_months)] <- 0

# taken from ledia proposal 2 in wage_alternatives_oews_2009-2019 in carol's email from 10/28/21
wage_table <- data.frame(year = c(2009, 2010, 2011, 2012, 2013, 2014,
                                  2015, 2016, 2017, 2018, 2019),
                         wages = c(83574.08349,	84197.43403, 86098.45741, 88011.44974,
                                   91252.34, 94383.22369,	97192.85349, 99432.04656,
                                   102379.0605,	104318.9007,	106953.8709))

repos_geo_joined %>%
  slice(1:1000) %>%
  select(slug, country, year, person_months) %>%
  left_join(wage_table, by = "year") %>%
  mutate(investment = person_months * wages)


conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
sectored_fractioned <- dbGetQuery(conn, "SELECT * FROM gh_cost.sectored_fractioned_103121;")
dbDisconnect(conn)








costs_by_country <- repos_geo_joined %>%
  group_by(country, year) %>%
  summarize(person_months = sum(geo_person_months)) %>%
  arrange(country, year); costs_by_country

costs_by_country_wide <- costs_by_country %>%
  pivot_wider(names_from = year, values_from = person_months) %>%
  arrange(-`2019`)

costs_by_country_wide <- costs_by_country %>%
  group_by(year) %>%
  summarise(person_months = sum(person_months)) %>%
  pivot_wider(names_from = year, values_from = person_months) %>%
  mutate(country = "Totals") %>%
  select(country, everything()) %>%
  bind_rows(costs_by_country_wide)

setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations")
write_csv(costs_by_country_wide, "person_months_by_country_103121.csv")


costs_by_country_simplified <- costs_by_country %>%
  mutate(geo_binary = "Other Countries") %>%
  mutate(geo_binary = ifelse(country == "Missing", "Missing",
                             ifelse(country == "United States", "United States", geo_binary))) %>%
  group_by(geo_binary, year) %>%
  summarize(person_months = sum(person_months)) %>%
  rename(geography = geo_binary)

costs_by_country_simp_wide <- costs_by_country_simplified %>%
  pivot_wider(names_from = year, values_from = person_months)

setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations")
write_csv(costs_by_country_simp_wide, "person_months_by_country_simp_103121.csv")



