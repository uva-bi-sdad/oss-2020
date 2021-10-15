
rm(list = ls())
library(tidyverse)
library(tidyorgs)
library(diverstidy)
library(RPostgreSQL)

# performed on 10/13/21
conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
github_users <- dbGetQuery(conn, "SELECT login, company, location, email FROM gh.ctrs_clean_0821")
dbDisconnect(conn)
start_time = Sys.time()
classified_users <- github_users %>%
  detect_orgs(login, company, organization, academic, email,
              country = TRUE, parent_org = TRUE, org_type = TRUE) %>%
  rename(ac_country = country) %>%
  detect_geographies(login, location, "country", email)
end_time = Sys.time()
time_to_classify = end_time - start_time; time_to_classify


# analyzed on 10/15/21
classified_users <- readRDS("data/github_sectored_101321.rds")

with_country_data <- classified_users %>%
  filter(!is.na(country) | !is.na(ac_country)) %>%
  mutate(country = if_else(is.na(country), ac_country, country)) %>%
  mutate(country = str_replace(country, "Jersey\\|", ""),
         country = str_replace(country, "Jersey", "United States"),
         country = sub("\\|.*", "", country)) %>%
  select(login, country)

country_counts <- with_country_data %>%
  unnest_legacy(country = base::strsplit(country, "\\|")) %>%
  filter(country != "NA") %>%
  group_by(country) %>%
  count() %>%
  arrange(-n)

conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
dbWriteTable(conn, c("gh_cost", "users_geo_101521"), with_country_data, row.names = FALSE)
dbDisconnect(conn)

# then run 04_cost_by_country_annual_0919_dd_nmrc_jbsc_1021.sql

rm(list = ls())
library(tidyverse)
library(RPostgreSQL)
library(tidytable)

conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
counts_by_year <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_year_0919_dd_nmrc_jbsc;")
dbDisconnect(conn)

counts_by_year <- as.data.table(counts_by_year)

#COST BASED ON Additions
counts_by_year[,adds_wo_gross := round(2.5 * (2.4 * (additions/1000)^1.05)^0.38,2)]
counts_by_year[,adds_w_gross := round(2.5 * (2.4 * (additions/1000)^1.05)^0.38,2)]

#COST BASED ON Additions + Deletions
counts_by_year[,sum_wo_gross := round(2.5 * (2.4 * (sum_adds_dels/1000)^1.05)^0.38,2)]
counts_by_year[,sum_w_gross := round(2.5 * (2.4 * (sum_adds_dels/1000)^1.05)^0.38,2)]

#COST BASED ON Additions - Deletions
counts_by_year[,net_wo_gross := round(2.5 * (2.4 * (net_adds_dels/1000)^1.05)^0.38,2)]
counts_by_year[,net_w_gross := round(2.5 * (2.4 * (net_adds_dels/1000)^1.05)^0.38,2)]


conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc_101521;")
dbDisconnect(conn)

table(counts_by_country$country)

# joints sector info and the cost estimates at repo level
repos_geo_joined <- counts_by_country %>%
  select(-year) %>%
  rename.(geo_commits = commits,
            geo_additions = additions,
            geo_deltions = deletions,
            geo_sum = sum_adds_dels,
            geo_net = net_adds_dels) %>%
  left_join(counts_by_year, by = "slug") %>%
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
  group_by(country, year) %>%
  summarize(person_months = sum(geo_cost_wo_gross)) %>%
  arrange(country, year); costs_by_country

costs_by_country_simplified <- costs_by_country %>%
  mutate(geo_binary = "Other Countries") %>%
  mutate(geo_binary = ifelse(country == "Missing", "Missing",
                             ifelse(country == "United States", "United States", geo_binary))) %>%
  group_by(geo_binary, year) %>%
  summarize(person_months = sum(person_months)) %>%
  rename(geography = geo_binary)

setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations")
write_csv(costs_by_country_simplified, "cost_bycountry_summary_2019_pms_101521.csv")



