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

counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_hbs;")
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_raw;")                # original_table
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_dd;")             # deduplicated_table
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_dd_nbots;")       # no bots
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_dd_nmrc;")        # no multi-repo commits
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_dd_nmrc_nbots;")  # nmrc + nbots
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_dd_nmrc_jbsc;")

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

counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_0919_hbs;")
#counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_0919_raw;")
#counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_0919_dd;")
#counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_0919_dd_nbots;")
#counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_0919_dd_nmrc;")
#counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_0919_dd_nmrc_jbsc;")

# disconnect from postgresql database
dbDisconnect(conn)

table(counts_by_country$country)

# joints sector info and the cost estimates at repo level
repos_geo_joined <- counts_by_country %>%
  dt_rename(geo_commits = commits,
            geo_additions = additions,
            geo_deltions = deletions,
            geo_sum = sum_adds_dels,
            geo_net = net_adds_dels) %>%
  left_join(counts_by_repo, by = "slug")

# calculates the cost for sectors additions
repos_geo_joined <- repos_geo_joined %>%
  dt_rename(repo_additions = additions,
            repo_deletions = deletions) %>%
  dt_mutate(geo_fraction = round(geo_additions / repo_additions, 3),
            geo_cost_wo_gross = geo_fraction * adds_wo_gross,
            geo_cost_w_gross = geo_fraction * adds_w_gross) %>%
  dt_arrange(slug, country, geo_fraction)
repos_geo_joined$geo_cost_wo_gross[is.nan(repos_geo_joined$geo_cost_wo_gross)] <- 0
repos_geo_joined$geo_cost_w_gross[is.nan(repos_geo_joined$geo_cost_w_gross)] <- 0

costs_by_country <- repos_geo_joined %>%
  group_by(country) %>%
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

costs_by_country <- costs_by_country %>%
  add_row(geo_binary = "Totals",
          geo_adds_wo_gross = sum(costs_by_country$geo_adds_wo_gross),
          geo_adds_w_gross = sum(costs_by_country$geo_adds_w_gross))

costs_by_country

#setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/01_cost_raw")        # original_table
setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/02_cost_dd")              # deduplicated_table
#setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/03_cost_dd_nbots")        # dd_nbots
#setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/04_cost_dd_nmrc")         # dd_nmrc
#setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/05_cost_dd_nmrc_nbots")   # dd_nmrc_nbots
#setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/06_cost_dd_nmrc_jbsc")   # dd_nmrc_jbsc
#setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/07_cost_dd_nmrc_jbsc_nbots")
write_csv(costs_by_country, "country_cost_estimates_summary_0919.csv")



