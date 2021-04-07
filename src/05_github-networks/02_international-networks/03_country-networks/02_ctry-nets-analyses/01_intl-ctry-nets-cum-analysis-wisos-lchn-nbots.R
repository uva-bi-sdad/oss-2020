
install.packages("intergraph", repos = "https://mirror.las.iastate.edu/CRAN/")
install.packages("sna", repos = "https://mirror.las.iastate.edu/CRAN/")

###### this is a direct copy of the full network no bots script with the SQL query updated for intl networks
###### then i updated the paths, added in centralization analyses,
#######################################################################################  load libraries & data

analyze_ctry_network <- function(analysis_year){

  #rm(list = ls())
  #analysis_year <- "0819"
  analysis_path <- "~/git/oss-2020/data/network-analysis/intl-ctry-nets-cum/wisos-lchn/"

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
  edgelist <- dbGetQuery(conn, str_c("SELECT country1, country2, repo_wts AS weight
                                      FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_", analysis_year, ";"))

  # disconnect from postgresql
  dbDisconnect(conn)

  ################################################################################## convert edgelist to network

  #edgelist <- edgelist %>%
  #  select(country1, country2, repo_wts) %>%
  #  rename(from = country1, to = country2, weight = repo_wts) %>%
  #  group_by(from, to) %>%
  #  summarize(weight = sum(weight)) %>%
  #  arrange(-weight)

  login_network <- graph.data.frame(edgelist, directed = FALSE)
  login_network <- simplify(login_network, remove.loops = FALSE)
  is_weighted(login_network)

  ######################################################################################## full network analyses

  # loading the network (if the instance crashes while doing network_stats)
  net_stats_start <- data.frame(event="net_stats_start", time=now("EST"))
  network_stats <- data.frame(year=analysis_year)

  # node and edge counts
  network_stats$node_count <- gorder(login_network)
  network_stats$edge_count <- gsize(login_network)
  network_stats$commits <- sum(edgelist$weight)

  # isolates (added trids as well)
  network_stats$isolates <- sum(degree(simplify(login_network))==0)
  oss_triads <- triad_census(login_network)
  network_stats$triads_003 <- oss_triads[1]
  network_stats$triads_102 <- oss_triads[3]
  network_stats$triads_201 <- oss_triads[11]
  network_stats$triads_300 <- oss_triads[16]
  net_counts <- data.frame(event="net_counts", time=now("EST"))
  time_log <- rbind(net_stats_start, net_counts); rm(net_stats_start, net_counts)

  # density and transitivity
  network_stats$density <- edge_density(login_network, loops=FALSE)
  network_stats$transitivity <- transitivity(login_network)
  network_stats$diameter <- diameter(login_network,directed=FALSE,
                                     unconnected=if (network_stats$isolates == 0) {FALSE} else {TRUE}, weights=NA)
  network_stats$mean_distance <- mean_distance(login_network, directed = FALSE,
                                               unconnected = if (network_stats$isolates == 0) {FALSE} else {TRUE})
  net_globals <- data.frame(event="net_globals", time=now("EST"))
  time_log <- rbind(time_log, net_globals); rm(net_globals)

  # analyze centralization trends
  network_stats$centr_deg <- centr_degree(login_network)$centralization
  #network_stats$centr_clo <- centr_clo(login_network, mode = "all")$centralization
  network_stats$centr_btw <- centr_betw(login_network, directed = FALSE)$centralization
  network_stats$centr_eigen <- centr_eigen(login_network, directed = FALSE)$centralization

  # cache the results
  setwd(analysis_path)
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

  # added for country-level network
  nodelist$btw_cent <- round(sna::betweenness(intergraph::asNetwork(login_network), cmode="undirected"), 4)
  #nodelist$close_cent <- closeness(login_network, mode = "all")
  nodelist$alpha_cent <- alpha_centrality(login_network)
  nodelist$power_cent <- power_centrality(login_network)
  nodelist$load_cent <- sna::loadcent(get.adjacency(login_network,sparse=F))
  nodelist$info_cent <- sna::infocent(get.adjacency(login_network,sparse=F))
  nodelist$stress_cent <- sna::stresscent(get.adjacency(login_network,sparse=F))
  nodelist$subgraph_cent <- subgraph_centrality(login_network)
  nodelist$page_rank <- page_rank(login_network)$vector
  nodelist$local_trans <- transitivity(login_network, type = "local")
  nodelist$eccentricity <- eccentricity(login_network)

  # cache the results
  node_stats_end <- data.frame(event="node_stats_end", time=now("EST"))
  time_log <- rbind(time_log, node_stats_end); rm(node_stats_end, louvain, components)
  setwd(analysis_path)
  saveRDS(network_stats, str_c("global_netstats_",analysis_year,".rds"))
  saveRDS(decomposition_stats, str_c("decomp_stats_",analysis_year,".rds"))
  saveRDS(nodelist, str_c("nodelist_",analysis_year,".rds"))
  saveRDS(time_log, str_c("timelog_",analysis_year,".rds"))

} # end function

##################################################################################### for loop of all years

for (year in c("08", "0809", "0810", "0811", "0812", "0813", "0814", "0815", "0816", "0817", "0818", "0819")) {
  analyze_ctry_network(year)
}
