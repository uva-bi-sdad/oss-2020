rm(list = ls())
library(RPostgreSQL)
library(dplyr)
library(data.table)
library(tidyverse)

conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_raw;")            # original_table
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_dd;")             # deduplicated_table
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_dd_nbots;")       # no bots
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_dd_nmrc;")        # no multi-repo commits
#counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_dd_nmrc_nbots;")  # nmrc + nbots
counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_dd_nmrc_jbsc;")
# counts_by_repo <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_repo_0919_dd_nmrc_jbsc_nbots;")
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

counts_by_repo %>% count() # 7751144 repos
counts_by_repo %>% distinct(slug) %>% count() # 7751144

# check all the dimensions to make sure
dim(counts_by_repo)
length(na.omit(counts_by_repo$w_gross))
dim(counts_by_repo[which(counts_by_repo$net_adds_dels >= 0),])

# arrange
counts_by_repo <- counts_by_repo %>% arrange(-adds_wo_gross)
# get top-100 repos
counts_by_repo_top <- counts_by_repo %>% top_n(adds_wo_gross, n = 100)

# sum of the four cols
adds_wo_gross <- sum(counts_by_repo$adds_wo_gross)
adds_w_gross <- sum(counts_by_repo$adds_w_gross)
sum_wo_gross <- sum(counts_by_repo$sum_wo_gross)
sum_w_gross <- sum(na.omit(counts_by_repo$sum_w_gross))
net_wo_gross <- sum(na.omit(counts_by_repo$net_wo_gross))
net_w_gross <- sum(na.omit(counts_by_repo$net_w_gross))
measure <- c("adds_wo_gross", "adds_w_gross", "sum_wo_gross", "sum_w_gross", "net_wo_gross", "net_w_gross")
cost <- c(adds_wo_gross, adds_w_gross, sum_wo_gross, sum_w_gross, net_wo_gross, net_w_gross)
summary_df <- data.frame(measure = measure, cost = cost)

#setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/01_cost_raw")        # original_table
#setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/02_cost_dd")              # deduplicated_table
#setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/03_cost_dd_nbots")        # dd_nbots
#setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/04_cost_dd_nmrc")         # dd_nmrc
#setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/05_cost_dd_nmrc_nbots")   # dd_nmrc_nbots
#setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/06_cost_dd_nmrc_jbsc")
setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/07_cost_dd_nmrc_jbsc_nbots")
write_csv(summary_df, "cost_estimates_summary_0919.csv")
write_csv(counts_by_repo, "cost_by_repo_all_0919.csv")
write_csv(counts_by_repo_top, "cost_by_repo_top_0919.csv")


