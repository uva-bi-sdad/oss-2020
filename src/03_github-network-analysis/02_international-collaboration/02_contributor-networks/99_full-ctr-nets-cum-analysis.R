
################################################################################## install packages (for slurm)

install.packages("igraph", repos = "http://cran.us.r-project.org")
install.packages("lubridate", repos = "http://cran.us.r-project.org")

#######################################################################################  load libraries & data

analyze_ctr_network <- function(analysis_year){

  # load packages
  for (pkg in c("tidyverse", "igraph", "RPostgreSQL", "lubridate")) {library(pkg, character.only = TRUE)}

  # connect to postgresql to get data (in rivanna)
  conn <- dbConnect(drv = PostgreSQL(),
                    dbname = "sdad",
                    host = "10.250.124.195",
                    port = 5432,
                    user = Sys.getenv("db_userid"),
                    password = Sys.getenv("db_pwd"))

  # query the bipartite edgelist data from github data
  ctr_edgelist <- dbGetQuery(conn, str_c("SELECT ctr1, ctr2, repo_wts
                                          FROM gh.sna_ctr_edgelist_",analysis_year,";"))

  # disconnect from postgresql
  dbDisconnect(conn)

  ##################################################################################  filter nulls, bots, loops

  ctr_edgelist <- ctr_edgelist %>%
    filter(!grepl("null", ctr1) | !grepl("null", ctr2)) %>%
    arrange(-repo_wts)

  ctr_edgelist <- ctr_edgelist %>%
    filter(!grepl("bot$|bot\\]$", ctr1) | !grepl("bot$|bot\\]$", ctr2)) %>%
    arrange(-repo_wts)

  ctr_edgelist <- ctr_edgelist %>%
    filter(ctr1 != ctr2)

  ################################################################################## convert edgelist to network

  ctr_edgelist <- ctr_edgelist %>%
    select(ctr1, ctr2, repo_wts) %>%
    rename(from = ctr1, to = ctr2, weight = repo_wts) %>%
    group_by(from, to) %>%
    summarize(weight = sum(weight)) %>%
    arrange(-weight)

  login_network <- graph.data.frame(ctr_edgelist, directed = FALSE)
  login_network <- simplify(login_network, remove.loops = TRUE)
  is_weighted(login_network)

  ######################################################################################## full network analyses

  # loading the network (if the instance crashes while doing network_stats)
  net_stats_start <- data.frame(event="net_stats_start", time=now("EST"))
  network_stats <- data.frame(year=analysis_year)

  # node and edge counts
  network_stats$node_count <- gorder(login_network)
  network_stats$edge_count <- gsize(login_network)
  network_stats$commits <- sum(ctr_edgelist$weight)

  # isolates
  network_stats$isolates <- sum(degree(simplify(login_network))==0)
  net_counts <- data.frame(event="net_counts", time=now("EST"))
  time_log <- rbind(net_stats_start, net_counts); rm(net_stats_start, net_counts)

  # density and transitivity
  network_stats$density <- edge_density(login_network, loops=FALSE)
  network_stats$transitivity <- transitivity(login_network)
  net_globals <- data.frame(event="net_globals", time=now("EST"))
  time_log <- rbind(time_log, net_globals); rm(net_globals)

  # cache the results
  setwd("~/oss-data/full-ctr-nets-cum")
  saveRDS(network_stats, str_c("global_netstats_",analysis_year,".rds"))

  # community detection (using louvain method)
  louvain <- cluster_louvain(login_network)
  network_stats$louvain <- modularity(louvain)
  network_stats$louvain_scaled <- modularity(louvain) / gorder(login_network)
  network_stats$louvain_logged <- modularity(louvain) / log(gorder(login_network))

  # community detection (using fast & greedy method)
  fstgrdy <- fastgreedy.community(login_network)
  network_stats$fstgrdy <- modularity(fstgrdy)
  network_stats$fstgrdy_scaled <- modularity(fstgrdy) / gorder(login_network)
  network_stats$fstgrdy_logged <- modularity(fstgrdy) / log(gorder(login_network))

  # decomposition statistics
  decomposition_stats <- table(sapply(decompose.graph(login_network), vcount))

  # cache the results
  net_comm_det <- data.frame(event="net_comm_det", time=now("EST"))
  time_log <- rbind(time_log, net_comm_det); rm(net_comm_det)

  ################################################################################### contributor-level analyses

  # construct a nodelist
  nodelist <- data.frame(id = c(1:(igraph::vcount(login_network))), login = igraph::V(login_network)$name)

  # degree, weighted degree, k core and modularity
  node_stats_start <- data.frame(event="node_stats_start", time=now("EST"))
  time_log <- rbind(time_log, node_stats_start); rm(node_stats_start)
  nodelist$deg_cent <- degree(login_network)
  nodelist$wtd_deg_cent <- strength(login_network)
  nodelist$eigen_cent <- eigen_centrality(login_network)$vector
  nodelist$page_rank <- page_rank(login_network)$vector
  nodelist$auth_score <- authority.score(login_network)$vector
  nodelist$hub_score <- hub.score(login_network)$vector
  nodelist$k_core <- coreness(login_network)
  components <- components(login_network)
  nodelist$component <- components$membership
  nodelist$louvain_comm <- louvain$membership
  nodelist$fstgrdy_comm <- fstgrdy$membership

  # cache the results
  node_stats_end <- data.frame(event="node_stats_end", time=now("EST"))
  time_log <- rbind(time_log, node_stats_end); rm(node_stats_end, louvain, components)
  setwd("~/oss-data/full-ctr-nets-cum")
  saveRDS(network_stats, str_c("global_netstats_",analysis_year,".rds"))
  saveRDS(decomposition_stats, str_c("decomp_stats_",analysis_year,".rds"))
  saveRDS(nodelist, str_c("nodelist_",analysis_year,".rds"))
  saveRDS(time_log, str_c("timelog_",analysis_year,".rds"))

} # end function

##################################################################################### for loop of all years

for (year in c("08", "0809", "0810", "0811", "0812", "0813", "0814", "0815", "0816", "0817", "0818", "0819")) {
  analyze_ctr_network(year)
}
