
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
ctr_edgelist <- dbGetQuery(conn, "SELECT * FROM gh.sna_intl_ctry_edgelist_yxy")

# disconnects from database
dbDisconnect(conn)

# create collaboration matrices for all years

oss_intl_collaborations_2008 <- as.data.frame(get.adjacency(graph.data.frame(
  ctr_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == "2008")), sparse = FALSE, attr='weight'))

oss_intl_collaborations_2009 <- as.data.frame(get.adjacency(graph.data.frame(
  ctr_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == "2009")), sparse = FALSE, attr='weight'))

oss_intl_collaborations_2010 <- as.data.frame(get.adjacency(graph.data.frame(
  ctr_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == "2010")), sparse = FALSE, attr='weight'))

oss_intl_collaborations_2011 <- as.data.frame(get.adjacency(graph.data.frame(
  ctr_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == "2011")), sparse = FALSE, attr='weight'))

oss_intl_collaborations_2012 <- as.data.frame(get.adjacency(graph.data.frame(
  ctr_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == "2012")), sparse = FALSE, attr='weight'))

oss_intl_collaborations_2013 <- as.data.frame(get.adjacency(graph.data.frame(
  ctr_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == "2013")), sparse = FALSE, attr='weight'))

oss_intl_collaborations_2014 <- as.data.frame(get.adjacency(graph.data.frame(
  ctr_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == "2014")), sparse = FALSE, attr='weight'))

oss_intl_collaborations_2015 <- as.data.frame(get.adjacency(graph.data.frame(
  ctr_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == "2015")), sparse = FALSE, attr='weight'))

oss_intl_collaborations_2016 <- as.data.frame(get.adjacency(graph.data.frame(
  ctr_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == "2016")), sparse = FALSE, attr='weight'))

oss_intl_collaborations_2017 <- as.data.frame(get.adjacency(graph.data.frame(
  ctr_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == "2017")), sparse = FALSE, attr='weight'))

oss_intl_collaborations_2018 <- as.data.frame(get.adjacency(graph.data.frame(
  ctr_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == "2018")), sparse = FALSE, attr='weight'))

oss_intl_collaborations_2019 <- as.data.frame(get.adjacency(graph.data.frame(
  ctr_edgelist %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    filter(year == "2019")), sparse = FALSE, attr='weight'))

# output data to data_folder

intl_collabs <- c("oss_intl_collaborations_2008", "oss_intl_collaborations_2009",
                  "oss_intl_collaborations_2010", "oss_intl_collaborations_2011",
                  "oss_intl_collaborations_2012", "oss_intl_collaborations_2013",
                  "oss_intl_collaborations_2014", "oss_intl_collaborations_2015",
                  "oss_intl_collaborations_2016", "oss_intl_collaborations_2017",
                  "oss_intl_collaborations_2018", "oss_intl_collaborations_2019")

for(i in 1:length(intl_collabs)) { write.csv2(get(intl_collabs[i]),
                                              paste0("~/git/oss-2020/data/intl-indicator-output/",
                                              intl_collabs[i], ".csv"), row.names = FALSE)
}






