rm(list = ls())
library(RPostgreSQL)
library(tidyverse)
library(tidytable)
library(data.table)

conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919;")                # original_table
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_dd_0919;")             # deduplicated_table
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_dd_nbots_0919;")       # no bots
counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_dd_nmrc_jbsc;")        # no multi-repo commits
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

#counts_by_sector <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_sector_0919;")
#counts_by_sector <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_sector_0919_dd;")
#counts_by_sector <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_sector_0919_dd_nbots;")
#counts_by_sector <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_sector_0919_dd_nmrc;")
counts_by_sector <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_sector_0919_dd_nmrc_nbots;")

# disconnect from postgresql database
dbDisconnect(conn)

table(counts_by_sector$sector)

# joints sector info and the cost estimates at repo level
repos_sectors_joined <- counts_by_sector %>%
  dt_rename(sector_commits = commits,
            sector_additions = additions,
            sector_deltions = deletions,
            sector_sum = sum_adds_dels,
            sector_net = net_adds_dels) %>%
  left_join(counts_by_repo, by = "slug")

# calculates the cost for sectors additions
repos_sectors_joined <- repos_sectors_joined %>%
  dt_rename(repo_additions = additions,
            repo_deletions = deletions) %>%
  dt_mutate(sector_fraction = round(sector_additions / repo_additions, 3),
            sector_cost_wo_gross = sector_fraction * adds_wo_gross,
            sector_cost_w_gross = sector_fraction * adds_w_gross) %>%
  dt_arrange(slug, sector, sector_fraction)
repos_sectors_joined$sector_cost_wo_gross[is.nan(repos_sectors_joined$sector_cost_wo_gross)] <- 0
repos_sectors_joined$sector_cost_w_gross[is.nan(repos_sectors_joined$sector_cost_w_gross)] <- 0

costs_by_sector <- repos_sectors_joined %>%
  group_by(sector) %>%
  summarize(sector_adds_wo_gross = sum(sector_cost_wo_gross),
            sector_adds_w_gross = sum(sector_cost_w_gross))
costs_by_sector

sum(counts_by_repo$adds_wo_gross)
sum(counts_by_repo$adds_w_gross)
sum(costs_by_sector$sector_adds_wo_gross)
sum(costs_by_sector$sector_adds_w_gross)

setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/07_cost_dd_nmrc_jbsc_nbots")
write_csv(costs_by_country, "cost_by_sector_2019.csv")


check <- repos_sectors_joined %>%
  group_by(sector) %>%
  summarize(totals = sum(sector_additions)) %>%
  arrange(-totals) %>%
  mutate(total_additions = sum(repos_sectors_joined$sector_additions),
         fraction = (totals / total_additions) * 100)
check

double_check <- check %>% filter(country != "missing")
sum(double_check$fraction)

sum(repos_geo_joined$geo_additions)
sum(repos_geo_joined$repo_additions)

repos_geo_joined






