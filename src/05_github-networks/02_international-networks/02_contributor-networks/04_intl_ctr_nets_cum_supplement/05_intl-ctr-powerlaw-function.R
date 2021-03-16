

# ~/git/oss-2020/src/05_github-networks/02_international-networks/02_contributor-networks/04_intl_ctr_nets_cum_supplement
# 06_intl-ctr-powerlaw.slurm

#######################################################################################  load libraries & data

test_if_power_law <- function(analysis_year){

  #rm(list = ls())
  #analysis_year <- "08"
  # load packages
  for (pkg in c("tidyverse", "igraph", "RPostgreSQL", "lubridate", "poweRlaw")) {library(pkg, character.only = TRUE)}

  # connect to postgresql to get data (in rivanna)
  conn <- dbConnect(drv = PostgreSQL(),
                    dbname = "sdad",
                    host = "10.250.124.195",
                    port = 5432,
                    user = Sys.getenv("db_userid"),
                    password = Sys.getenv("db_pwd"))

  # query the bipartite edgelist data from github data
  ctr_edgelist <- dbGetQuery(conn, str_c("SELECT ctr1, ctr2, repo_wts
                                         FROM gh_sna.sna_intl_ctr_edgelist_dd_lchn_",analysis_year,";"))

  # disconnect from postgresql
  dbDisconnect(conn)

  #######################################################################################  convert to a network

  # convert edgelist to network
  ctr_edgelist <- ctr_edgelist %>%
    select(ctr1, ctr2, repo_wts) %>%
    rename(from = ctr1, to = ctr2, weight = repo_wts) %>%
    group_by(from, to) %>%
    summarize(weight = sum(weight)) %>%
    arrange(-weight)

  login_network <- graph.data.frame(ctr_edgelist, directed = FALSE)
  login_network <- simplify(login_network, remove.loops = TRUE)
  is_weighted(login_network)

  #######################################################################################  fit the power law

  # get the degree of all nodes, remove all of the degree < 0
  data <- degree(login_network)
  data <- data[data>0]

  # fit the power law to see its distribution
  data_dist <- data.frame(k=0:max(data), p_k=degree_distribution(login_network))
  data_dist <- data_dist[data_dist$p_k>0,]

  # run initial estimation
  m_pl <- displ$new(data)
  est_pl <- estimate_xmin(m_pl)
  # initial estimation of kmin
  est_pl$xmin
  # initial estimation of γ
  est_pl$pars
  # calculate D with Kolgomorov-Smirnov test
  est_pl$gof

  # estimates the pars and xmin
  (est = estimate_pars(m_pl))
  (est = estimate_xmin(m_pl))
  m_pl$setXmin(est)

  # finish remainder of process using https://rpubs.com/lgadar/power-law
  data_s <- unique(data)
  d_est <- data.frame(K_min=sort(data_s)[1:(length(data_s)-2)],
                      gamma=rep(0,length(data_s)-2), D=rep(0,length(data_s)-2))

  for (i in d_est$K_min){
    d_est[which(d_est$K_min == i),2] <- estimate_xmin(m_pl, xmins = i)$pars
    d_est[which(d_est$K_min == i),3] <- estimate_xmin(m_pl, xmins = i)$gof
  }

  setwd("~/git/oss-2020/data/network-analysis/intl-ctr-nets-cum/wisos-lchn/")
  saveRDS(d_est, "d_est_0819.rds")

  m_pl$setXmin(est_pl)
  plot.data <- plot(m_pl, draw = F)
  fit.data <- lines(m_pl, draw = F)

  # bootstrapping process
  threads_detected = parallel::detectCores() - 1
  bs_pl <- bootstrap_p(m_pl, no_of_sims=1000,
                       threads=threads_detected, seed = 123)
  df_bs_pl <- bs_pl$bootstraps

  setwd("~/git/oss-2020/data/network-analysis/intl-ctr-nets-cum/wisos-lchn/")
  saveRDS(bs_pl, "bs_pl_0819.rds")

  K.min_D.min <- d_est[which.min(d_est$D), 1]
  df_bs_pl <- bs_pl$bootstraps
  gamma_D.min <- d_est[which.min(d_est$D), 2]
  D.min <- d_est[which.min(d_est$D), 3]

  #lognormal
  m_ln = dislnorm$new(data)
  est_ln <- estimate_xmin(m_ln)
  m_ln$setXmin(est_ln)

  #exponential
  m_exp = disexp$new(data)
  est_exp <- estimate_xmin(m_exp)
  m_exp$setXmin(est_exp)

  #poisson
  m_poi = dispois$new(data)
  est_poi <- estimate_xmin(m_poi)
  m_poi$setXmin(est_poi)

  # save all the results in the same place
  alpha <- est$pars
  alpha_sd <- sd(bs_pl$bootstraps$pars)
  xmin <- est$xmin
  xmin_sd <- sd(bs_pl$bootstraps$xmin)
  gof <- bs_pl$gof
  pvalue <- bs_pl$p
  power_law_data <- as.data.frame(cbind(analysis_year, alpha, alpha_sd, xmin, xmin_sd, pvalue, gof))

  setwd("~/git/oss-2020/data/network-analysis/intl-ctr-nets-cum/wisos-lchn/")
  saveRDS(power_law_data, str_c("power_law_data_",analysis_year,".rds"))

} # end function

##################################################################################### for loop of all years

for (year in c("08", "0809", "0810", "0811", "0812", "0813", "0814", "0815", "0816", "0817", "0818", "0819")) {
  test_if_power_law(year)
}

##################################################################################### aggregate

setwd("~/git/oss-2020/data/network-analysis/intl-ctr-nets-cum/wisos-lchn/")

# percentages for all sets
all_power_law_data <- list.files(pattern="power_law_data_*") %>%
  map_df(~read_rds(.))
write_rds(all_power_law_data, "power_law_data_allyears.rds")

##################################################################################### references

#https://rpubs.com/lgadar/power-law
#https://cran.r-project.org/web/packages/poweRlaw/vignettes/a_introduction.pdf
#https://cran.r-project.org/web/packages/poweRlaw/vignettes/b_powerlaw_examples.pdf
#https://epubs.siam.org/doi/pdf/10.1137/070710111?casa_token=XROmDjUk7MsAAAAA%3AHTfw7zmR_dZO0ef1kETfiD27rsTeqbh88DZ2hRV7tv5lGtB-lgny7rOlxi_7Htv3A30gXpgxlnrl&



