##############################################################################################################################
# below are some addtional notes that i need to come back to later

#rm(list = ls())
rm(counts_by_repo_top)
rm(conn)

library(RPostgreSQL)
library(dplyr)
library(data.table)
library(maditr)
library(tidytable)

conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))


counts_by_sector <- dbGetQuery(conn, "SELECT * FROM gh.cost_by_sector_0919;")

# disconnect from postgresql database
dbDisconnect(conn)

head(counts_by_sector %>% arrange(slug))
dim(cost_by_login)
table(counts_by_sector$sector)

repos_sectors_joined <- counts_by_sector %>%
  dt_select(-repo_additions) %>%
  left_join(counts_by_repo, by = "slug")

repos_sectors_joined <- repos_sectors_joined %>%
  dt_rename(repo_additions = additions) %>%
  dt_mutate(sector_fraction = sector_additions / repo_additions * 100,
            sector_cost_wo_gross = sector_fraction * adds_wo_gross,
            sector_cost_w_gross = sector_fraction * adds_w_gross) %>%
  dt_arrange(slug)

repos_sectors_joined %>%
  dt_select(slug, sector_additions, repo_additions, sector_fraction) %>%
  dt_filter(sector_additions > repo_additions) %>%
  dt_arrange(slug)

counts_by_repo %>%
  filter(slug == "0-Eclipse-0/-InBox-")



round(22094.19 * 2.5 * (2.4 * (additions/1000)^1.05)^0.38,2) # where additions is total additions at the repo level




#COST BASED ON Additions
counts_by_sector[,wo_gross_adds := round(22094.19 * 2.5 * (2.4 * (additions/1000)^1.05)^0.38,2)]
counts_by_sector[,w_gross_adds := round(27797.24 * 2.5 * (2.4 * (additions/1000)^1.05)^0.38,2)]

#COST BASED ON Additions + Deletions
counts_by_repo[,wo_gross_sum := round(22094.19 * 2.5 * (2.4 * (sum_adds_dels/1000)^1.05)^0.38,2)]
counts_by_repo[,w_gross_sum := round(27797.24 * 2.5 * (2.4 * (sum_adds_dels/1000)^1.05)^0.38,2)]

#COST BASED ON Additions - Deletions
counts_by_repo[,wo_gross_net := round(22094.19 * 2.5 * (2.4 * (net_adds_dels/1000)^1.05)^0.38,2)]
counts_by_repo[,w_gross_net := round(27797.24 * 2.5 * (2.4 * (net_adds_dels/1000)^1.05)^0.38,2)]












dim(db_tbls)
#7799203

length(unique(db_tbls$slug))
#5188818 unique repos

db_tbls_rm70 <- db_tbls[which(db_tbls$year != "1970"),]
db_tbls_70 <- db_tbls[which(db_tbls$year == "1970"),]
length(unique(db_tbls_70$slug))












library(data.table)
#### COMMIT BY YEAR
dt <- data.table(db_tbls)

commit_loc_by_year <- dt[,.(sum(count_commits),sum(total_additions),sum(total_deletions)),year]
colnames(commit_loc_by_year) <- c("year","sum_commits","total_additions","total_deletions")
commit_loc_by_year <- setorder(commit_loc_by_year,year,na.last=TRUE)

#### NUMber of contributors by repo
#not possible with this data


### Group by repo

commit_loc_by_repo <- dt[,.(sum(count_commits),sum(total_additions),sum(total_deletions)),slug]
colnames(commit_loc_by_repo) <- c("slug","sum_commits","total_additions","total_deletions")
commit_loc_by_repo <- setorder(commit_loc_by_repo,-sum_commits,na.last=TRUE)

commit_loc_by_repo$sum_loc <- rowSums(commit_loc_by_repo[,3:4])
commit_loc_by_repo$sum_kloc <- (commit_loc_by_repo$sum_loc)/1000
commit_loc_by_repo$net_loc <- commit_loc_by_repo[,3]-commit_loc_by_repo[,4]
commit_loc_by_repo$net_kloc <- (commit_loc_by_repo$net_loc)/1000

#calculate_cost_from_kloc <- function(commit_loc_by_repo) {
#  costs_df <- commit_loc_by_repo %>%
#    dplyr::mutate(cost_18096.47 = round(18096.47 * 2.5 * (2.4 * (sum_kloc)^1.05)^0.38, 2),
#                  cost_19963.55 = round(19963.55 * 2.5 * (2.4 * (sum_kloc)^1.05)^0.38, 2)
#    ) %>%
#    select(-cost)
#  return(costs_df)
#}
#COST BASED ON Additions
commit_loc_by_repo[,cost_additions_18096.47 := round(18096.47 * 2.5 * (2.4 * (total_additions/1000)^1.05)^0.38,2)]
commit_loc_by_repo[,cost_additions_19963.55 := round(19963.55 * 2.5 * (2.4 * (total_additions/1000)^1.05)^0.38,2)]

#COST BASED ON Additions + Deletions
commit_loc_by_repo[,cost_sum_kloc_18096.47 := round(18096.47 * 2.5 * (2.4 * (sum_kloc)^1.05)^0.38,2)]
commit_loc_by_repo[,cost_sum_kloc_19963.55 := round(19963.55 * 2.5 * (2.4 * (sum_kloc)^1.05)^0.38,2)]

#COST BASED ON Additions - Deletions
commit_loc_by_repo[,cost_net_kloc_18096.47 := round(18096.47 * 2.5 * (2.4 * (net_kloc)^1.05)^0.38,2)]
commit_loc_by_repo[,cost_net_kloc_19963.55 := round(19963.55 * 2.5 * (2.4 * (net_kloc)^1.05)^0.38,2)]


## COUNTRIES

dt_commit_country <- data.table(commit_country)
loc_by_country <- dt_commit_country[,.(sum(additions),sum(deletions)),country_code]
colnames(loc_by_country) <- c("country_code","additions","deletions")
