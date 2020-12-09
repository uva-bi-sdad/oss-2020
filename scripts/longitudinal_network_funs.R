

long_ctr_net_desc <- function(edgelist, years_analyzed, network_type){

  # import packages
  library(dplyr)
  library(igraph)

  # convert edgelist to network
  edgelist <- edgelist %>%
    select(ctr1, ctr2, repo_wts) %>%
    rename(from = ctr1, to = ctr2, weight = repo_wts) %>%
    group_by(from, to) %>%
    summarize(weight = sum(weight)) %>%
    arrange(-weight)

  network <- graph.data.frame(edgelist, directed = FALSE)
  network <- simplify(network, remove.loops = TRUE)

  if(is_weighted(network) != TRUE){
    stop("Network not weighted.")
  }

  # NETWORK STATS

  # loading the network (if the instance crashes while doing network_stats)
  net_stats_start <- data.frame(event="net_stats_start", time=now("EST"))
  network_stats <- data.frame(year=years_analyzed)

  # node and edge counts
  network_stats$node_count <- gorder(network)
  network_stats$edge_count <- gsize(network)
  network_stats$commits <- sum(ctr_edgelist$weight)

  # isolates, dyads and triads
  network_stats$isolates <- sum(degree(simplify(network))==0)
  oss_triads <- triad.census(network)
  network_stats$triads_003 <- oss_triads[1]
  network_stats$triads_102 <- oss_triads[3]
  network_stats$triads_201 <- oss_triads[11]
  network_stats$triads_300 <- oss_triads[16]
  net_counts <- data.frame(event="net_counts", time=now("EST"))
  time_log <- rbind(net_stats_start, net_counts); rm(net_stats_start, net_counts)

  # density and transitivity
  # network_stats$diameter <- diameter(network)
  network_stats$density <- edge_density(network, loops=FALSE)
  network_stats$transitivity <- transitivity(network)
  net_globals <- data.frame(event="net_globals", time=now("EST"))
  time_log <- rbind(time_log, net_globals); rm(net_globals)

  # community detection (using louvain method)
  louvain <- cluster_louvain(network)
  network_stats$louvain <- modularity(louvain)
  network_stats$louvain_scaled <- modularity(louvain) / gorder(network)
  network_stats$louvain_logged <- modularity(louvain) / log(gorder(network))

  # community detection (using fast & greedy method)
  fstgrdy <- fastgreedy.community(network)
  network_stats$fstgrdy <- modularity(fstgrdy)
  network_stats$fstgrdy_scaled <- modularity(fstgrdy) / gorder(network)
  network_stats$fstgrdy_logged <- modularity(fstgrdy) / log(gorder(network))

  # centralization statistics
  network_stats$centr_deg <- centr_degree(network)$centralization
  network_stats$centr_clo <- centr_clo(network, mode = "all")$centralization
  network_stats$centr_btw <- centr_betw(network, directed = FALSE)$centralization
  network_stats$centr_eigen <- centr_eigen(network, directed = FALSE)$centralization

  # decomposition statistics
  #decomposition_stats <- table(sapply(decompose.graph(network), vcount))

  net_comm_det <- data.frame(event="net_comm_det", time=now("EST"))
  time_log <- rbind(time_log, net_comm_det); rm(net_comm_det)

  # now, we need to construct a nodelist
  nodelist <- data.frame(id = c(1:(igraph::vcount(network))), login = igraph::V(network)$name)

  # degree, weighted degree, k core and modularity
  node_stats_start <- data.frame(event="node_stats_start", time=now("EST"))
  time_log <- rbind(time_log, node_stats_start); rm(node_stats_start)
  nodelist$deg_cent <- degree(network)
  nodelist$wtd_deg_cent <- strength(network)
  nodelist$eigen_cent <- eigen_centrality(network)$vector
  nodelist$page_rank <- page_rank(network)$vector
  nodelist$auth_score <- authority.score(network)$vector
  nodelist$hub_score <- hub.score(network)$vector
  nodelist$k_core <- coreness(network)
  components <- components(network)
  nodelist$component <- components$membership
  nodelist$louvain_comm <- louvain$membership
  nodelist$fstgrdy_comm <- fstgrdy$membership

  node_stats_end <- data.frame(event="node_stats_end", time=now("EST"))
  time_log <- rbind(time_log, node_stats_end); rm(node_stats_end, louvain, components)

  if(network_type == "cum_full"){
    setwd("~/git/oss-2020/data/intl-networks/intl-ctr-nets-cum")
    saveRDS(network_stats, str_c("global_cum_",years_analyzed,".rds"))
    #saveRDS(decomposition_stats, str_c("decomp_stats_cum_",years_analyzed,".rds"))
    saveRDS(nodelist, str_c("nodelist_cum_",years_analyzed,".rds"))
    saveRDS(time_log, str_c("timelog_cum_",years_analyzed,".rds"))
  }

  if(network_type == "cum_xeno"){
    setwd("~/git/oss-2020/data/intl-networks/intl-ctr-nets-cum-xeno")
    saveRDS(network_stats, str_c("global_cum_xeno_",years_analyzed,".rds"))
    #saveRDS(decomposition_stats, str_c("decomp_stats_cum_xeno_",years_analyzed,".rds"))
    saveRDS(nodelist, str_c("nodelist_cum_xeno_",years_analyzed,".rds"))
    saveRDS(time_log, str_c("timelog_cum_xeno_",years_analyzed,".rds"))
  }

  if(network_type == "yxy_full"){
    setwd("~/git/oss-2020/data/intl-networks/intl-ctr-nets-yxy")
    saveRDS(network_stats, str_c("global_yxy_",years_analyzed,".rds"))
    #saveRDS(decomposition_stats, str_c("decomp_stats_yxy_",years_analyzed,".rds"))
    saveRDS(nodelist, str_c("nodelist_yxy_",years_analyzed,".rds"))
    saveRDS(time_log, str_c("timelog_yxy_",years_analyzed,".rds"))
  }

  if(network_type == "yxy_xeno"){
    setwd("~/git/oss-2020/data/intl-networks/intl-ctr-nets-yxy-xeno")
    saveRDS(network_stats, str_c("global_yxy_xeno_",years_analyzed,".rds"))
    #saveRDS(decomposition_stats, str_c("decomp_stats_yxy_xeno_",years_analyzed,".rds"))
    saveRDS(nodelist, str_c("nodelist_yxy_xeno_",years_analyzed,".rds"))
    saveRDS(time_log, str_c("timelog_yxy_xeno_",years_analyzed,".rds"))
  }

  network_stats
  nodelist

}


### network descriptives for country-level networks


long_ctry_net_desc <- function(edgelist, years_analyzed, network_type){

  # import packages
  library(dplyr)
  library(igraph)
  library(expm)

  # convert edgelist to network
  edgelist <- edgelist %>%
    select(country1, country2, repo_wts) %>%
    rename(from = country1, to = country2, weight = repo_wts) %>%
    group_by(from, to) %>%
    summarize(weight = sum(weight)) %>%
    arrange(-weight)

  network <- graph.data.frame(edgelist, directed = FALSE)
  network <- simplify(network, remove.loops = FALSE,
                      edge.attr.comb = igraph_opt("edge.attr.comb"))

  if(is_weighted(network) != TRUE){
    stop("Network not weighted.")
  }

  # NETWORK STATS

  # loading the network (if the instance crashes while doing network_stats)
  net_stats_start <- data.frame(event="net_stats_start", time=now("EST"))
  network_stats <- data.frame(year=years_analyzed)

  # node and edge counts
  network_stats$node_count <- gorder(network)
  network_stats$edge_count <- gsize(network)
  network_stats$commits <- sum(edgelist$weight)
  network_stats$mean_deg <- mean(degree(network, mode = "all"))
  network_stats$mean_btw <- mean(round(sna::betweenness(intergraph::asNetwork(network), cmode="undirected"), 4))

  # isolates, dyads and triads
  network_stats$isolates <- sum(igraph::degree(simplify(network))==0)
  oss_triads <- igraph::triad.census(network)
  network_stats$triads_003 <- oss_triads[1]
  network_stats$triads_102 <- oss_triads[3]
  network_stats$triads_201 <- oss_triads[11]
  network_stats$triads_300 <- oss_triads[16]
  net_counts <- data.frame(event="net_counts", time=now("EST"))
  time_log <- rbind(net_stats_start, net_counts); rm(net_stats_start, net_counts)

  # density and transitivity
  # network_stats$diameter <- diameter(network)
  network_stats$diameter <- diameter(network, directed=FALSE,
                                     unconnected=if (network_stats$isolates == 0) {FALSE} else {TRUE}, weights=NA)
  network_stats$mean_distance <- mean_distance(network, directed = FALSE,
                                               unconnected = if (network_stats$isolates == 0) {FALSE} else {TRUE})
  network_stats$density <- edge_density(network, loops=TRUE)
  network_stats$transitivity <- transitivity(network, weights = TRUE, type = "undirected")
  net_globals <- data.frame(event="net_globals", time=now("EST"))
  time_log <- rbind(time_log, net_globals); rm(net_globals)

  # community detection (using louvain method)
  louvain <- cluster_louvain(network)
  network_stats$louvain <- modularity(louvain)
  network_stats$louvain_scaled <- modularity(louvain) / gorder(network)
  network_stats$louvain_logged <- modularity(louvain) / log(gorder(network))

  # community detection (using fast & greedy method)
  fstgrdy <- fastgreedy.community(network)
  network_stats$fstgrdy <- modularity(fstgrdy)
  network_stats$fstgrdy_scaled <- modularity(fstgrdy) / gorder(network)
  network_stats$fstgrdy_logged <- modularity(fstgrdy) / log(gorder(network))

  # centralization statistics
  network_stats$centr_deg <- round(centr_degree(network)$centralization, 3)
  network_stats$centr_clo <- round(centr_clo(network, mode = "all")$centralization, 3)
  network_stats$centr_btw <- round(centr_betw(network, directed = FALSE)$centralization, 3)
  network_stats$centr_eigen <- round(centr_eigen(network, directed = FALSE)$centralization, 3)
  #network_stats$centr_scores <- cbind(year, centr_deg, centr_clo, centr_btw, centr_eigen)

  # decomposition statistics
  #decomposition_stats <- table(sapply(decompose.graph(network), vcount))

  net_comm_det <- data.frame(event="net_comm_det", time=now("EST"))
  time_log <- rbind(time_log, net_comm_det); rm(net_comm_det)

  # now, we need to construct a nodelist
  nodelist <- data.frame(id = c(1:(igraph::vcount(network))), login = igraph::V(network)$name)

  # degree, weighted degree, k core and modularity
  node_stats_start <- data.frame(event="node_stats_start", time=now("EST"))
  time_log <- rbind(time_log, node_stats_start); rm(node_stats_start)

  nodelist$deg_cent <- igraph::degree(network, mode = "all")
  nodelist$wtd_deg_cent <- strength(network)
  nodelist$btw_cent <- round(sna::betweenness(intergraph::asNetwork(network), cmode="undirected"), 4)
  nodelist$close_cent <- closeness(network, mode = "all")
  nodelist$eigen_cent <- eigen_centrality(network)$vector
  nodelist$alpha_cent <- alpha_centrality(network)
  nodelist$power_cent <- power_centrality(network)
  nodelist$load_cent <- sna::loadcent(get.adjacency(network,sparse=F))
  nodelist$info_cent <- sna::infocent(get.adjacency(network,sparse=F))
  nodelist$stress_cent <- sna::stresscent(get.adjacency(network,sparse=F))
  nodelist$subgraph_cent <- subgraph_centrality(network)
  nodelist$page_rank <- page_rank(network)$vector
  nodelist$auth_score <- authority.score(network)$vector
  nodelist$hub_score <- hub.score(network)$vector
  nodelist$local_trans <- transitivity(network, type = "local")
  nodelist$eccentricity <- eccentricity(network)
  nodelist$k_core <- coreness(network)
  components <- components(network)
  nodelist$component <- components$membership
  nodelist$louvain_comm <- louvain$membership
  nodelist$fstgrdy_comm <- fstgrdy$membership
  nodelist$gilschmidt <- sna::gilschmidt(get.adjacency(network,sparse=F))
  nodelist$hyper_even <- netrankr::hyperbolic_index(network,type = "even")
  nodelist$hyper_odd <- netrankr::hyperbolic_index(network,type = "odd")
  nodelist$bottleneck <- centiserve::bottleneck(network)
  nodelist$close_latora <- centiserve::closeness.latora(network)
  nodelist$close_res <- centiserve::closeness.residual(network)
  nodelist$comm_bet <- centiserve::communibet(network)
  nodelist$diff_deg <- centiserve::diffusion.degree(network)
  nodelist$entropy <- 1/centiserve::entropy(network)
  nodelist$geokpath <- centiserve::geokpath(network)
  nodelist$laplacian <- centiserve::laplacian(network)
  nodelist$leverage <- centiserve::leverage(network)
  nodelist$lin_cent <- centiserve::lincent(network)
  nodelist$lobby <- centiserve::lobby(network)
  nodelist$markov_cent <- centiserve::markovcent(network)
  nodelist$mnc <- centiserve::mnc(network)
  nodelist$dmnc <- centiserve::dmnc(network)
  nodelist$epc <- centiserve::epc(network)
  nodelist$radiality <- centiserve::radiality(network)
  nodelist$topocoefficient <- 1/centiserve::topocoefficient(network)

  node_stats_end <- data.frame(event="node_stats_end", time=now("EST"))
  time_log <- rbind(time_log, node_stats_end); rm(node_stats_end, louvain, components)

  if(network_type == "cum_full"){

    setwd("~/git/oss-2020/data/intl-networks/intl-ctry-nets-cum")
    saveRDS(network_stats, str_c("global_cum_",years_analyzed,".rds"))
    #saveRDS(decomposition_stats, str_c("decomp_stats_cum_",years_analyzed,".rds"))
    saveRDS(nodelist, str_c("nodelist_cum_",years_analyzed,".rds"))
    saveRDS(time_log, str_c("timelog_cum_",years_analyzed,".rds"))

  }

  if(network_type == "cum_xeno"){

  setwd("~/git/oss-2020/data/intl-networks/intl-ctry-nets-cum-xeno")
  saveRDS(network_stats, str_c("global_cum_xeno_",years_analyzed,".rds"))
  #saveRDS(decomposition_stats, str_c("decomp_stats_cum_xeno_",years_analyzed,".rds"))
  saveRDS(nodelist, str_c("nodelist_cum_xeno_",years_analyzed,".rds"))
  saveRDS(time_log, str_c("timelog_cum_xeno_",years_analyzed,".rds"))

  }

  if(network_type == "yxy_full"){

    setwd("~/git/oss-2020/data/intl-networks/intl-ctry-nets-yxy")
    saveRDS(network_stats, str_c("global_yxy_",years_analyzed,".rds"))
    #saveRDS(decomposition_stats, str_c("decomp_stats_yxy_",years_analyzed,".rds"))
    saveRDS(nodelist, str_c("nodelist_yxy_",years_analyzed,".rds"))
    saveRDS(time_log, str_c("timelog_yxy_",years_analyzed,".rds"))

  }

  if(network_type == "yxy_xeno"){

    setwd("~/git/oss-2020/data/intl-networks/intl-ctry-nets-yxy-xeno")
    saveRDS(network_stats, str_c("global_yxy_xeno_",years_analyzed,".rds"))
    #saveRDS(decomposition_stats, str_c("decomp_stats_yxy_xeno_",years_analyzed,".rds"))
    saveRDS(nodelist, str_c("nodelist_yxy_xeno_",years_analyzed,".rds"))
    saveRDS(time_log, str_c("timelog_yxy_xeno_",years_analyzed,".rds"))

  }

  network_stats
  nodelist

}




