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

counts_by_year <- dbGetQuery(conn, "SELECT * FROM gh.cost_by_year_0919 WHERE YEAR = 2019;")

# disconnect from postgresql database
dbDisconnect(conn)

counts_by_year <- as.data.table(counts_by_year)


repos_by_year <- counts_by_year %>%
  group_by(slug) %>%
  summarize(commits = sum(commits),
            additions = sum(additions),
            deletions = sum(deletions),
            sum_adds_dels = sum(sum_adds_dels),
            net_adds_dels = sum(net_adds_dels))

# check all the dimensions to make sure
dim(repos_by_year)

repos_by_year <- as.data.table(repos_by_year)

#COST BASED ON Additions
repos_by_year[,adds_wo_gross := round(22094.19 * 2.5 * (2.4 * (additions/1000)^1.05)^0.38,2)]
repos_by_year[,adds_w_gross := round(27797.24 * 2.5 * (2.4 * (additions/1000)^1.05)^0.38,2)]

#COST BASED ON Additions + Deletions
repos_by_year[,sum_wo_gross := round(22094.19 * 2.5 * (2.4 * (sum_adds_dels/1000)^1.05)^0.38,2)]
repos_by_year[,sum_w_gross := round(27797.24 * 2.5 * (2.4 * (sum_adds_dels/1000)^1.05)^0.38,2)]

#COST BASED ON Additions - Deletions
repos_by_year[,net_wo_gross := round(22094.19 * 2.5 * (2.4 * (net_adds_dels/1000)^1.05)^0.38,2)]
repos_by_year[,net_w_gross := round(27797.24 * 2.5 * (2.4 * (net_adds_dels/1000)^1.05)^0.38,2)]

repos_by_year %>% count() # 7751144 repos
repos_by_year %>% distinct(slug) %>% count() # 7751144

length(na.omit(repos_by_year$net_w_gross))
dim(repos_by_year[which(repos_by_year$net_w_gross >= 0),])


# sum of the four cols
adds_wo_gross <- sum(repos_by_year$adds_wo_gross)
adds_w_gross <- sum(repos_by_year$adds_w_gross)
sum_wo_gross <- sum(repos_by_year$sum_wo_gross)
sum_w_gross <- sum(na.omit(repos_by_year$sum_w_gross))
net_wo_gross <- sum(na.omit(repos_by_year$net_wo_gross))
net_w_gross <- sum(na.omit(repos_by_year$net_w_gross))
measure <- c("adds_wo_gross", "adds_w_gross", "sum_wo_gross", "sum_w_gross", "net_wo_gross", "net_w_gross")
cost <- c(adds_wo_gross, adds_w_gross, sum_wo_gross, sum_w_gross, net_wo_gross, net_w_gross)
df <- data.frame(measure = measure, cost = cost)

counts_by_repo_top <- repos_by_year %>%
  top_n(adds_wo_gross, n = 100)

write_csv(counts_by_repo_top, "/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/repos_cost_2019_top.csv")
write_csv(repos_by_year, "/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/repos_cost_2019_all.csv")
write_csv(df, "/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/repos_cost_2019_summary.csv")

counts_by_repo_top <- counts_by_year %>%
  top_n(adds_wo_gross, n = 100)

write_csv(counts_by_year, "/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations/cost_by_repo_top.csv")
