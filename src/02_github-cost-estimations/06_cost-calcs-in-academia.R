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

#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919;")                # original_table
counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_dd_0919;")             # deduplicated_table
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_dd_nbots_0919;")       # no bots
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_dd_nmrc_0919;")        # no multi-repo commits
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_dd_nmrc_nbots_0919;")  # nmrc + nbots

# disconnect from postgresql database
dbDisconnect(conn)

counts_by_repo <- as.data.table(counts_by_repo)

#COST BASED ON Additions
counts_by_repo[,adds_wo_gross := round(22094.19 * 2.5 * (2.4 * (additions/1000)^1.05)^0.38,2)]
counts_by_repo[,adds_w_gross := round(27797.24 * 2.5 * (2.4 * (additions/1000)^1.05)^0.38,2)]

#COST BASED ON Additions + Deletions
counts_by_repo[,sum_wo_gross := round(22094.19 * 2.5 * (2.4 * (sum_adds_dels/1000)^1.05)^0.38,2)]
counts_by_repo[,sum_w_gross := round(27797.24 * 2.5 * (2.4 * (sum_adds_dels/1000)^1.05)^0.38,2)]

#COST BASED ON Additions - Deletions
counts_by_repo[,net_wo_gross := round(22094.19 * 2.5 * (2.4 * (net_adds_dels/1000)^1.05)^0.38,2)]
counts_by_repo[,net_w_gross := round(27797.24 * 2.5 * (2.4 * (net_adds_dels/1000)^1.05)^0.38,2)]


conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

cost_academic_geo <- dbGetQuery(conn, "SELECT * FROM gh.cost_academic_geo_0919;")

# disconnect from postgresql database
dbDisconnect(conn)

table(cost_academic_geo$inst_country)

# joints sector info and the cost estimates at repo level
repos_geo_joined <- cost_academic_geo %>%
  dt_rename(geo_commits = commits,
            geo_additions = additions,
            geo_deltions = deletions,
            geo_sum = sum_adds_dels,
            geo_net = net_adds_dels) %>%
  left_join(counts_by_repo, by = "slug")

check <- repos_geo_joined %>%
  slice_head.(100)


# calculates the cost for sectors additions
repos_geo_joined <- repos_geo_joined %>%
  dt_rename(repo_additions = additions,
            repo_deletions = deletions) %>%
  dt_mutate(geo_fraction = round(geo_additions / repo_additions, 3),
            geo_cost_wo_gross = geo_fraction * adds_wo_gross,
            geo_cost_w_gross = geo_fraction * adds_w_gross) %>%
  dt_arrange(slug, inst_country, geo_fraction)
repos_geo_joined$geo_cost_wo_gross[is.nan(repos_geo_joined$geo_cost_wo_gross)] <- 0
repos_geo_joined$geo_cost_w_gross[is.nan(repos_geo_joined$geo_cost_w_gross)] <- 0

costs_by_country <- repos_geo_joined %>%
  group_by(sector, inst_country) %>%
  summarize(geo_adds_wo_gross = sum(geo_cost_wo_gross),
            geo_adds_w_gross = sum(geo_cost_w_gross)) %>%
  arrange(-geo_adds_wo_gross); costs_by_country

costs_by_country <- costs_by_country %>%
  mutate(geo_binary = "Other Countries") %>%
  mutate(geo_binary = ifelse(country == "missing", "Missing",
                             ifelse(country == "us", "United States", geo_binary))) %>%
  group_by(geo_binary) %>%
  summarize(geo_adds_wo_gross = sum(geo_adds_wo_gross),
            geo_adds_w_gross = sum(geo_adds_w_gross))

sum(costs_by_country$geo_adds_w_gross)
sum(costs_by_country$geo_adds_wo_gross)

####


check <- repos_geo_joined %>%
  group_by(country) %>%
  summarize(totals = sum(geo_additions)) %>%
  arrange(-totals) %>%
  mutate(repo_totals = sum(repos_geo_joined$geo_additions),
         fraction = (totals / repo_totals) * 100)

double_check <- check %>% filter(country != "missing")
sum(double_check$fraction)

sum(repos_geo_joined$geo_additions)
sum(repos_geo_joined$repo_additions)

repos_geo_joined





######

costs_by_country$full_name <- countrycode(costs_by_country$country,
                                          origin = 'iso2c',
                                          destination = 'country.name')
costs_by_country$full_name[1] <- "Missing"

costs_by_country <- costs_by_country %>%
  select(full_name,
         geo_adds_wo_gross,
         geo_adds_w_gross) %>%
  rename(country = full_name)

sum(costs_by_country$geo_adds_w_gross)
sum(costs_by_country$geo_adds_wo_gross)


costs_by_country %>%
  mutate(geo_binary = "Other Countries") %>%
  mutate(geo_binary = replace_na(geo_binary, "Missing")) %>%
  mutate(geo_binary = ifelse(country == "Missing", "Missing",
                             ifelse(country == "United States", "United States", geo_binary))) %>%
  group_by(geo_binary) %>%
  summarize(geo_adds_wo_gross = sum(geo_adds_wo_gross),
            geo_adds_w_gross = sum(geo_adds_w_gross))


