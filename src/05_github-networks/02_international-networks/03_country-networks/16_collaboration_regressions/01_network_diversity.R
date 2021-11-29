
# this file calculates the two types of network diversity over time

rm(list = ls())

# this pulls in a function from the scripts folder
# thanks to Richard Paquin Morel for this function (https://ramorel.github.io/network-range/)
source("/sfs/qumulo/qhome/kb7hp/git/oss-2020/scripts/netrange.R")

network_diversity_over_time <- function(analysis_year){

  # load packages
  for (pkg in c("tidyverse", "igraph", "RPostgreSQL", "lubridate")) {library(pkg, character.only = TRUE)}

  # rm(list = ls())
  # analysis_year <- "08"

  # connect to postgresql to get data (in rivanna)
  conn <- dbConnect(drv = PostgreSQL(),
                    dbname = "sdad",
                    host = "10.250.124.195",
                    port = 5432,
                    user = Sys.getenv("db_userid"),
                    password = Sys.getenv("db_pwd"))

  # query the bipartite edgelist data from github data
  edgelist <- dbGetQuery(conn, str_c("SELECT country1 AS from, country2 AS to, repo_wts AS weight
                                     FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_", analysis_year, ";"))

  # disconnect from postgresql
  dbDisconnect(conn)

  ################################################################################## convert edgelist to network

  network = igraph::simplify(graph.data.frame(edgelist, directed = FALSE),
                             remove.multiple = TRUE, remove.loops = FALSE,
                             edge.attr.comb = igraph_opt("edge.attr.comb"))
  is_weighted(network)

  ################################################################################### network diversity measures

  # construct a nodelist
  nodelist <- data.frame(id = c(1:(igraph::vcount(network))), country = igraph::V(network)$name)
  nodelist$year <- analysis_year
  nodelist$diversity <- igraph::diversity(network)

  detach("package:igraph", unload=TRUE)
  library("statnet")
  library("intergraph")

  net_work <- intergraph::asNetwork(network)
  net_work %v% "louvain_comm" <- igraph::cluster_louvain(network)$membership
  net_work %v% "fstgrdy_comm" <- igraph::cluster_fast_greedy(network)$membership

  louvain_range <- netrange(net_work, net_work %v% "louvain_comm", directed = TRUE)
  fstgrdy_range <- netrange(net_work, net_work %v% "fstgrdy_comm", directed = TRUE)

  net_ranges <- data.frame(country = net_work %v% "vertex.names",
                           louvain_comm = net_work %v% "louvain_comm",
                           fstgrdy_comm = net_work %v% "fstgrdy_comm",
                           louvain_range = louvain_range,
                           fstgrdy_range = fstgrdy_range,
                           stringsAsFactors = F)

  nodelist <- nodelist %>% left_join(net_ranges, by = "country")

  detach("package:statnet", unload=TRUE)

  # cache the results
  setwd("~/git/oss-2020/data/network-analysis/intl-ctry-nets-cum/wisos-lchn/")
  saveRDS(nodelist, str_c("ctry_diversity_",analysis_year,".rds"))

} # end function

##################################################################################### for loop of all years

for (year in c("08", "0809", "0810", "0811", "0812", "0813", "0814", "0815", "0816", "0817", "0818", "0819")) {
  network_diversity_over_time(year)
}

##################################################################################### aggregate and save the data

setwd("~/git/oss-2020/data/network-analysis/intl-ctry-nets-cum/wisos-lchn/")
all_diversity_analyses <- list.files(pattern="ctry_diversity_*") %>%
  map_df(~read_rds(.)) %>%
  mutate(country_name = if_else(is.na(country), country_name, country),
         net_diversity = if_else(is.na(diversity), net_diversity, diversity)) %>%
  select(-country, -diversity) %>%
  distinct(id, country_name, year, net_diversity,
           louvain_comm, fstgrdy_comm, louvain_range, fstgrdy_range)
write_rds(all_diversity_analyses, "ctry_diversity_cum.rds")

setwd("/project/biocomplexity/sdad/projects_data/ncses/oss/oss_networks_2021/intl-ctry-nets-cum/wisos-lchn")
nodelist_2008 <- readRDS("nodelist_08.rds") %>% mutate(year = 2008)
nodelist_2009 <- readRDS("nodelist_0809.rds") %>% mutate(year = 2009)
nodelist_2010 <- readRDS("nodelist_0810.rds") %>% mutate(year = 2010)
nodelist_2011 <- readRDS("nodelist_0811.rds") %>% mutate(year = 2011)
nodelist_2012 <- readRDS("nodelist_0812.rds") %>% mutate(year = 2012)
nodelist_2013 <- readRDS("nodelist_0813.rds") %>% mutate(year = 2013)
nodelist_2014 <- readRDS("nodelist_0814.rds") %>% mutate(year = 2014)
nodelist_2015 <- readRDS("nodelist_0815.rds") %>% mutate(year = 2015)
nodelist_2016 <- readRDS("nodelist_0816.rds") %>% mutate(year = 2016)
nodelist_2017 <- readRDS("nodelist_0817.rds") %>% mutate(year = 2017)
nodelist_2018 <- readRDS("nodelist_0818.rds") %>% mutate(year = 2018)
nodelist_2019 <- readRDS("nodelist_0819.rds") %>% mutate(year = 2019)

nodelist <- bind_rows(nodelist_2008, nodelist_2009, nodelist_2010,
          nodelist_2011, nodelist_2012, nodelist_2013,
          nodelist_2014, nodelist_2015, nodelist_2016,
          nodelist_2017, nodelist_2012, nodelist_2019)
setwd("~/git/oss-2020/data/network-analysis/intl-ctry-nets-cum/wisos-lchn/")
write_rds(nodelist, "ctry_nodelist.rds")


