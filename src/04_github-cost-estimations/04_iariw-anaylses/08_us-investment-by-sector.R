

rm(list = ls())
library(tidyverse)
library(tidyorgs)
library(diverstidy)
library(RPostgreSQL)


# analyzed on 10/15/21 and then updated with fractions on 10/20/21
setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data")
ctrs_by_ctry <- readRDS("../data/github_sectored_101321.rds")

with_country_data <- ctrs_by_ctry %>%
  filter(!is.na(country) | !is.na(ac_country)) %>%
  mutate(country = if_else(is.na(country), ac_country, country)) %>%
  mutate(country = str_replace(country, "Jersey\\|", ""),
         country = str_replace(country, "Jersey", "United States"),
         fraction = (1 / (str_count(country, "\\|") + 1))) %>%
  select(login, country, fraction) %>%
  mutate(country = strsplit(as.character(country), "\\|")) %>%
  unnest(country) %>%
  drop_na(country) %>%
  arrange(fraction)

country_counts <- with_country_data %>%
  unnest_legacy(country = base::strsplit(country, "\\|")) %>%
  filter(country != "NA") %>%
  group_by(country) %>%
  summarise(users = sum(fraction)) %>%
  arrange(-users)

conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
dbWriteTable(conn, c("gh_cost", "users_geo_102021"), with_country_data, row.names = FALSE)
dbDisconnect(conn)

# then run 02_cost_by_country_annual_0919_dd_nmrc_jbsc_1021.sql

#rm(list = ls())
#library(tidyverse)
#library(RPostgreSQL)
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
counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc_102021;")
dbDisconnect(conn)

table(counts_by_country$country)

# joints sector info and the cost estimates at repo level
repos_geo_joined <- counts_by_country %>%
  #select(-year) %>%
  rename.(geo_commits = commits,
            geo_additions = additions,
            geo_deletions = deletions,
            geo_sum = sum_adds_dels,
            geo_net = net_adds_dels) %>%
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
  mutate(country = "All Countries") %>%
  select(country, everything()) %>%
  bind_rows(costs_by_country_wide)

setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations")
write_csv(costs_by_country_wide, "person_months_by_country_102121.csv")


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
write_csv(costs_by_country_simp_wide, "person_months_by_country_simp_102121.csv")



