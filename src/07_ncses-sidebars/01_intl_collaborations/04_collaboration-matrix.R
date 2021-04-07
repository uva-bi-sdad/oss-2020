
rm(list = ls())

# load packages
library("tidyverse")
library("igraph")
library("RPostgreSQL")
library("lubridate")
library("igraph")

# connects to database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))

# pulls in contributor collaboration edgelist for one year
# note: bots, loops and nulls have already been filtered out in the previous stage
ctr_edgelist <- dbGetQuery(conn, "SELECT * FROM gh_sna.sna_intl_ctry_edgelist_yxy_lchn;")

# disconnects from database
dbDisconnect(conn)

# set functions for collapsing edgelists and mirroring matrices

collaboration_matrix <- function(wtd_edgelist, analysis_year){

  library(igraph)
  library(tidyverse)

  mirror_matrix <- function(m) {
    m[lower.tri(m)] <- t(m)[lower.tri(m)]
    m
  }

  wtd_edgelist <- wtd_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == analysis_year) %>% select(-year)

  directed_graph <- graph.data.frame(wtd_edgelist, directed = TRUE)
  undirected_wtd_graph <- as.undirected(directed_graph, mode = "collapse", edge.attr.comb = "sum")
  collapsed_wtd_edgelist <- as.tibble(as_data_frame(undirected_wtd_graph))

  matrix_to_convert <- as.data.frame(get.adjacency(graph.data.frame(collapsed_wtd_edgelist),
                              sparse = FALSE, type="both", attr='weight'))
  converted_matrix <- mirror_matrix(matrix_to_convert)
  final_matrix <- rownames_to_column(converted_matrix, var = "Country")
  final_matrix

}


# create collaboration matrices for all years

oss_intl_collaborations_matrix_2008 <- collaboration_matrix(ctr_edgelist, "2008")
oss_intl_collaborations_matrix_2009 <- collaboration_matrix(ctr_edgelist, "2009")
oss_intl_collaborations_matrix_2010 <- collaboration_matrix(ctr_edgelist, "2010")
oss_intl_collaborations_matrix_2011 <- collaboration_matrix(ctr_edgelist, "2011")
oss_intl_collaborations_matrix_2012 <- collaboration_matrix(ctr_edgelist, "2012")
oss_intl_collaborations_matrix_2013 <- collaboration_matrix(ctr_edgelist, "2013")
oss_intl_collaborations_matrix_2014 <- collaboration_matrix(ctr_edgelist, "2014")
oss_intl_collaborations_matrix_2015 <- collaboration_matrix(ctr_edgelist, "2015")
oss_intl_collaborations_matrix_2016 <- collaboration_matrix(ctr_edgelist, "2016")
oss_intl_collaborations_matrix_2017 <- collaboration_matrix(ctr_edgelist, "2017")
oss_intl_collaborations_matrix_2018 <- collaboration_matrix(ctr_edgelist, "2018")
oss_intl_collaborations_matrix_2019 <- collaboration_matrix(ctr_edgelist, "2019")

# output data to data_folder

intl_collabs <- c("oss_intl_collaborations_matrix_2008", "oss_intl_collaborations_matrix_2009",
                  "oss_intl_collaborations_matrix_2010", "oss_intl_collaborations_matrix_2011",
                  "oss_intl_collaborations_matrix_2012", "oss_intl_collaborations_matrix_2013",
                  "oss_intl_collaborations_matrix_2014", "oss_intl_collaborations_matrix_2015",
                  "oss_intl_collaborations_matrix_2016", "oss_intl_collaborations_matrix_2017",
                  "oss_intl_collaborations_matrix_2018", "oss_intl_collaborations_matrix_2019")

for(i in 1:length(intl_collabs)) { write.csv2(get(intl_collabs[i]),
                                              paste0("~/git/oss-2020/data/intl-indicator-output/",
                                              intl_collabs[i], ".csv"), row.names = FALSE)
}






