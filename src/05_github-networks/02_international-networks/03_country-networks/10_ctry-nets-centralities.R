rm(list = ls())

# Libraries
library(ggraph)
library(igraph)
library(tidyverse)
library(RColorBrewer)

# creating first level of hierarchy
# load packages
for (pkg in c("tidyverse", "data.table", "R.utils", "RPostgreSQL", "igraph",
              "cowplot", "maditr", "lubridate", "countrycode")) {library(pkg, character.only = TRUE)}

conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

setwd("~/git/oss-2020/data/network-analysis/intl-ctry-nets-cum/wisos-lchn/")
centralities <- read_rds("full_nodelist_cum.rds") %>% select(country, ends_with("0819"))

# query the bipartite edgelist data from github data
raw_nodelist <- dbGetQuery(conn, "SELECT country, users, repos, commits, additions, deletions FROM gh_sna.sna_intl_ctry_summary")

# query the bipartite edgelist data from github data
edgelist <- dbGetQuery(conn, "SELECT country1, country2, repo_wts AS weight FROM gh_sna.sna_intl_ctry_edgelist_dd_lchn_nbots_0819")
dbDisconnect(conn)

# make the network
intl_ctry_network <- simplify(graph.data.frame(edgelist, directed = FALSE),
                              edge.attr.comb = igraph_opt("edge.attr.comb"),
                              remove.loops = FALSE)

# add the community membership to the nodelist
nodelist <- data.frame(id = c(1:(igraph::vcount(intl_ctry_network))),
                                 country = igraph::V(intl_ctry_network)$name)

nodelist <- nodelist %>%
  inner_join(raw_nodelist, by = "country") %>%
  left_join(centralities, by = "country")
fstgrdy <- fastgreedy.community(intl_ctry_network)
nodelist$fstgrdy_comm <- fstgrdy$membership

nodelist %>%
  group_by(fstgrdy_comm) %>%
  count() %>%
  arrange(-n)

nodelist <- nodelist %>%
  mutate(fstgrdy_comm = if_else(fstgrdy_comm <= 25, fstgrdy_comm, 26)) %>%
  rename(deg_cent = deg_cent0819, btw_cent = btw_cent0819)

nodelist$Community <- recode(nodelist$fstgrdy_comm,
                             `1` = "Canada", `2` = "All Others", `3` = "All Others", `4` = "China", `5` = "All Others",
                             `6` = "All Others", `7` = "France", `8` = "USA", `9` = "Russia", `10` = "All Others",
                             `11` = "All Others", `12` = "Developing", `13` = "Germany", `14` = "All Others", `15` = "UK",
                             `16` = "All Others", `17` = "All Others", `18` = "All Others", `19` = "All Others", `20` = "All Others",
                             `21` = "All Others", `22` = "All Others", `23` = "Australia", `24` = "All Others", `25` = "All Others",
                             `26` = "All Others")

chk <- nodelist %>% select(country, deg_cent, btw_cent) %>% mutate(diff = deg_cent - btw_cent) %>% arrange(diff)

nodelist <- nodelist %>%
  mutate(country = ifelse(test = str_detect(string = country, pattern = "United States"), yes = "USA", no = country),
         country = ifelse(test = str_detect(string = country, pattern = "United Kingdom"), yes = "UK", no = country)) %>%
  mutate(labels = ifelse(test = str_detect(string = country,
        pattern = "USA|Canada|Germany|UK|^China|France|Germany|Nigeria|Kenya|India|Australia|Brazil"), yes = country, no = NA))

ggplot(nodelist) +
  geom_point(aes(x=deg_cent, y=btw_cent, color=Community, size = btw_cent)) +
  geom_text(aes(x=deg_cent, y=btw_cent, size=200, label=labels), hjust=1.4, vjust=0.5) +
  scale_colour_manual(values = c("Canada"="#990000", "France"="#5BC21C", "USA"="#cd6700",
                                 "Developing"="#232D4B", "Russia"="#0E879C", "UK"="#89cff0",
                                 "Australia"="#355e3b", "China"="#0AA18C", "Germany"="#628ed8", "All Others"="#D3D3D3")) +
  theme_minimal() + theme(plot.title = element_text(size = 11, hjust = 0.36, vjust = 2),
                          #legend.position=c(0.148,0.84),
                          #legend.title=element_blank(),
                          #legend.text = element_text(size = 9),
                          #legend.background = element_rect(colour = NA)
                          legend.position="none"
                          ) +
  guides(size = FALSE, colour = guide_legend(override.aes = list(size=3))) +
  xlab("Degree Centrality") + ylab("Betweenness Centrality") +
  labs(title= "Comparing Centrality Measures for Country-Country \n Collaboration Networks (GitHub, 2008-2019)")



cor(nodelist$deg_cent, nodelist$btw_cent)
cor(nodelist$deg_cent, nodelist$eigen_cent)
cor(nodelist$btw_cent, nodelist$eigen_cent)
cor(nodelist$page_rank, nodelist$eigen_cent)
