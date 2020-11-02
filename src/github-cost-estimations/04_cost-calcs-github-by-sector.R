rm(list = ls())
library(RPostgreSQL)
library(tidyverse)
library(tidytable)

conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh.cost_by_repo_0919;")

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

counts_by_sector <- dbGetQuery(conn, "SELECT * FROM gh.cost_by_sector_0919_alt;")

# disconnect from postgresql database
dbDisconnect(conn)

table(counts_by_sector$sector)

repos_sectors_joined <- counts_by_sector %>%
  dt_rename(sector_commits = commits,
            sector_additions = additions,
            sector_deltions = deletions,
            sector_sum = sum_adds_dels,
            sector_net = net_adds_dels) %>%
  left_join(counts_by_repo, by = "slug")

repos_sectors_joined <- repos_sectors_joined %>%
  dt_rename(repo_additions = additions,
            repo_deletions = deletions) %>%
  dt_mutate(sector_fraction = round(sector_additions / repo_additions, 3),
            sector_cost_wo_gross = sector_fraction * adds_wo_gross,
            sector_cost_w_gross = sector_fraction * adds_w_gross) %>%
  dt_arrange(slug, sector, sector_fraction)

check <- repos_sectors_joined %>%
  slice_head.(n = 100)

repos_sectors_joined  %>%
  slice_head.(n = 100) %>%
  group_by(sector) %>%
  summarize(cost_by_sector = sum(sector_cost_w_gross))









