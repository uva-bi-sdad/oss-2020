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

#counts_by_year <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_year_0919_dd WHERE YEAR = 2019;")
counts_by_year <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_year_0919_dd_nmrc_jbsc WHERE YEAR = 2019;")

# disconnect from postgresql database
dbDisconnect(conn)

counts_by_year <- as.data.table(counts_by_year)

#COST BASED ON Additions
counts_by_year[,adds_wo_gross := round(22094.19 * 2.5 * (2.4 * (additions/1000)^1.05)^0.38,2)]
counts_by_year[,adds_w_gross := round(27797.24 * 2.5 * (2.4 * (additions/1000)^1.05)^0.38,2)]

#COST BASED ON Additions + Deletions
counts_by_year[,sum_wo_gross := round(22094.19 * 2.5 * (2.4 * (sum_adds_dels/1000)^1.05)^0.38,2)]
counts_by_year[,sum_w_gross := round(27797.24 * 2.5 * (2.4 * (sum_adds_dels/1000)^1.05)^0.38,2)]

#COST BASED ON Additions - Deletions
counts_by_year[,net_wo_gross := round(22094.19 * 2.5 * (2.4 * (net_adds_dels/1000)^1.05)^0.38,2)]
counts_by_year[,net_w_gross := round(27797.24 * 2.5 * (2.4 * (net_adds_dels/1000)^1.05)^0.38,2)]


conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

#counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_annual_0919_dd WHERE YEAR = 2019;")
counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc_0821 WHERE YEAR = 2019;")

# disconnect from postgresql database
dbDisconnect(conn)

counts_by_country[grepl("\\|", counts_by_country$country), "country"] <- "multiple"
table(counts_by_country$country)

# joints sector info and the cost estimates at repo level
repos_geo_joined <- counts_by_country %>%
  select(-year) %>%
  rename.(geo_commits = commits,
            geo_additions = additions,
            geo_deltions = deletions,
            geo_sum = sum_adds_dels,
            geo_net = net_adds_dels) %>%
  left_join.(counts_by_year, by = "slug") %>%
  select.(slug, country, year, everything())

# calculates the cost for sectors additions
repos_geo_joined <- repos_geo_joined %>%
  rename.(repo_additions = additions,
            repo_deletions = deletions) %>%
  mutate.(geo_fraction = round(geo_additions / repo_additions, 3),
            geo_cost_wo_gross = geo_fraction * adds_wo_gross,
            geo_cost_w_gross = geo_fraction * adds_w_gross) %>%
  arrange.(slug, country, geo_fraction)
repos_geo_joined$geo_cost_wo_gross[is.nan(repos_geo_joined$geo_cost_wo_gross)] <- 0
repos_geo_joined$geo_cost_w_gross[is.nan(repos_geo_joined$geo_cost_w_gross)] <- 0

costs_by_country <- repos_geo_joined %>%
  group_by(country) %>%
  summarize(geo_adds_wo_gross = sum(geo_cost_wo_gross),
            geo_adds_w_gross = sum(geo_cost_w_gross)) %>%
  arrange(-geo_adds_wo_gross); costs_by_country

costs_by_country_adj <- costs_by_country %>%
  mutate(geo_binary = "Other Countries") %>%
  mutate(country = replace_na(country, "missing")) %>%
  mutate(geo_binary = ifelse(country == "missing", "Missing",
                             ifelse(country == "united states", "United States", geo_binary))) %>%
  group_by(geo_binary) %>%
  summarize(geo_adds_wo_gross = sum(geo_adds_wo_gross),
            geo_adds_w_gross = sum(geo_adds_w_gross)) %>%
  add_row(geo_binary = "Totals",
          geo_adds_wo_gross = sum(costs_by_country$geo_adds_wo_gross),
          geo_adds_w_gross = sum(costs_by_country$geo_adds_w_gross))

costs_by_country_adj

# given that we only have 50.69023% of all data for countries in 2019,
# we take our cost from the us * that fraction and then * 2
53367806127 * (0.50 / 0.5069023) * 2 = 105282236116

setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/06_cost_dd_nmrc_jbsc")
write_csv(costs_by_country, "cost_bycountry_summary_2019.csv")
#write_csv(repos_geo_joined, "cost_bycountry_all_2019.csv")

setwd("/project/biocomplexity/sdad/projects_data/ncses/oss/oss_cost_estimations_0521/06_cost_dd_nmrc_jbsc/")
comparisons <- read_csv("cost_bycountry_summary_2019.csv")
