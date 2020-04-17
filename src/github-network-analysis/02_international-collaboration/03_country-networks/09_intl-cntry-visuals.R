rm(list = ls())

# Libraries
library(ggraph)
library(igraph)
library(tidyverse)
library(RColorBrewer)

# creating first level of hierarchy
setwd("/sfs/qumulo/qhome/kb7hp/oss-data/intl-ctry-nets-cum/edgelists")
nodelist <- read_csv("intl_ctry_nodelist_gephi_2008-19.csv")
first_level <- nodelist %>%
  mutate(new_comm = recode(fstgrdy_comm, `1` = "Orange",
                           `2` = "LightBlue", `3` = "Red",
                           `4` = "DarkBlue", `5` = "DarkBlue"))
first_level <- data.frame(from="Origin",
                          to=c("Orange", "LightBlue",
                               "Red", "DarkBlue"))

# creating second level of hierarchy
setwd("/sfs/qumulo/qhome/kb7hp/oss-data/intl-ctry-nets-cum/edgelists")
second_level <- read_csv("intl_ctry_nodelist_gephi_2008-19.csv")
second_level <- second_level %>%
  mutate(new_comm = recode(fstgrdy_comm, `1` = "Orange",
                           `2` = "LightBlue", `3` = "Red",
                           `4` = "DarkBlue", `5` = "DarkBlue")) %>%
  select(new_comm, id) %>%
  rename(from = new_comm, to = id)

# bind levels into a hierarchy
hierarchy <- rbind(first_level, second_level)

# create a vertices data.frame. One line per object of our hierarchy, giving features of nodes.
vertices  <-  data.frame(
  name = unique(c(as.character(hierarchy$from), as.character(hierarchy$to)))
)
vertices$group  <-  hierarchy$from[ match( vertices$name, hierarchy$to ) ]
nodelist <- nodelist %>% rename(name = id)
vertices <- vertices %>% full_join(nodelist, by = "name")

# Create a graph object with the igraph library
mygraph <- graph_from_data_frame( hierarchy, vertices=vertices )

# graph as a dendrogram
ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_edge_diagonal() +
  theme_void()

# get the edgelist and cut it down
setwd("/sfs/qumulo/qhome/kb7hp/oss-data/intl-ctry-nets-cum/edgelists")
connect <- read_csv("intl_ctry_edgelist_gephi_2008-19.csv")
connect <- connect %>%
  rename(from = source, to = target) %>%
  filter(from != to) %>%
  top_n(5000, weight) %>%
  mutate(weight = weight * 2) %>%
  mutate(weight = (weight-min(weight))/(max(weight)-min(weight))) %>%
  rename(value = weight)

#adding info for the label we are going to add: angle, horizontal adjustement and potential flip
#calculate the ANGLE of the labels
vertices$id <- NA
myleaves <- which(is.na( match(vertices$name, hierarchy$from) ))
nleaves <- length(myleaves)
vertices$id[ myleaves ] <- seq(1:nleaves)
vertices$angle <- 90 - 360 * vertices$id / nleaves
vertices$hjust <- ifelse( vertices$angle < -90, 1, 0)
vertices$angle <- ifelse(vertices$angle < -90, vertices$angle+180, vertices$angle)

# connect the datasets
from <- match( connect$from, vertices$name)
to <- match( connect$to, vertices$name)

# graph connections
ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_conn_bundle(data = get_con(from = from, to = to), tension = 0.5, aes(colour=..index..)) +
  scale_edge_colour_gradient(low = "#D3D3D3" , high = "#838383") +
  geom_node_text(aes(x = x*1.1, y=y*1.1, filter = leaf, label=name, hjust=vertices$hjust, angle = vertices$angle
                     ), size=2, alpha=1) +
  #scale_size_continuous( range = vertices$deg_cent ) +
  theme(legend.position="none", plot.margin=unit(c(0,0,0,0),"cm")) +
  expand_limits(x = c(-1.2, 1.2), y = c(-1.2, 1.2)) +
  geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05, colour=group, size=btw_cent, alpha = 0.6)) +
  scale_size_continuous( range = c(2,10) ) +
  scale_colour_manual(values= c("#232D4B", "#628ED8", "#E57200", "#990000") )




