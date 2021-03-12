rm(list = ls())

# Libraries
library(ggraph)
library(igraph)
library(tidyverse)
library(RColorBrewer)
library(HiveR)

setwd("/sfs/qumulo/qhome/kb7hp/oss-data/intl-ctry-nets-cum/edgelists")
nodelist <- read_csv("intl_ctry_nodelist_gephi_2008-19.csv")
centralities <- nodelist %>% select(-id)

# deg_cent, btw_cent, page_rank, power_cent, auth_score

setwd("/sfs/qumulo/qhome/kb7hp/oss-data/intl-ctry-nets-cum/edgelists")
edgelist <- read_csv("intl_ctry_edgelist_gephi_2008-19.csv")
edgelist <- as.data.frame(edgelist) %>%
  rename(node1 = source, node2 = target) %>%
  filter(node1 != node2) %>%
  top_frac(0.005, weight) %>%
  mutate(weight = round(weight / 100000, 2))
  #mutate(weight = (weight-min(weight))/(max(weight)-min(weight))*10)

vertices  <-  data.frame(id = unique(c(as.character(edgelist$node1), as.character(edgelist$node2))))
vertices <- vertices %>%
  inner_join(nodelist, by = "id") %>%
  select(id, deg_cent, btw_cent, page_rank, auth_score, fstgrdy_comm) %>%
  mutate(colors = recode(fstgrdy_comm, `1` = "#E57200", `2` = "#232D4B", `3` = "#990000", `4` = "#628ed8"))

# create give plot
intl_hive <- edge2HPD(edge_df = edgelist, axis.cols = rep("black", 3), type = "2D")

# set features of hive plot
intl_hive$nodes$axis <- as.integer(c(1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3))
intl_hive$nodes$radius <- as.numeric(vertices$deg_cent) # but none of these are below 0
intl_hive$nodes$size <- as.numeric(vertices$deg_cent/100)
intl_hive$edges$color <- "black"
intl_hive$nodes$color <- as.character(vertices$colors)
intl_hive

plotHive(intl_hive, method = "norm", bkgnd = "white")



#Error in if (any(HPD$nodes$radius < 0)) warning("Some node radii < 0; the behavior of these is unknown") :
#  missing value where TRUE/FALSE needed


?HPD
?HEC
chkHPD(intl_hive)
















#mutate(deg_cent = (deg_cent-min(deg_cent))/(max(deg_cent)-min(deg_cent))) %>%
#mutate(btw_cent = (btw_cent-min(btw_cent))/(max(btw_cent)-min(btw_cent))) %>%
#mutate(power_cent = (power_cent-min(power_cent))/(max(power_cent)-min(power_cent))) %>%
#mutate(page_rank = (page_rank-min(page_rank))/(max(page_rank)-min(page_rank))) %>%
#mutate(auth_score = (auth_score-min(auth_score))/(max(auth_score)-min(auth_score)))
