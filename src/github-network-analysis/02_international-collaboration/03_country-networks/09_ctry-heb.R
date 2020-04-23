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
  rename(from = new_comm, to = id) %>%
  arrange(from, -deg_cent) %>%
  select(from, to)

# bind levels into a hierarchy, remove levels
hierarchy <- rbind(first_level, second_level)
rm(first_level, second_level)

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
#ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
#  geom_edge_diagonal() +
#  theme_void()

# get the edgelist and cut it down
setwd("/sfs/qumulo/qhome/kb7hp/oss-data/intl-ctry-nets-cum/edgelists")
connect <- read_csv("intl_ctry_edgelist_gephi_2008-19.csv")
connect <- connect %>%
  rename(from = source, to = target) %>%
  filter(from != to) %>%
  #top_n(5000, weight) %>%
  top_frac(0.25, weight) %>%
  mutate(weight = weight) %>%
  mutate(weight = (weight-min(weight))/(max(weight)-min(weight))) %>%
  rename(value = weight)

#set degree
deg <- 360/length(unique(nodelist$name))
#first_level
first_level <- c(0,0,0,0,0)
#first
subset1 <- c(deg*13,deg*12,deg*11,deg*10,deg*9,deg*8,deg*7,deg*6,deg*5,deg*4,deg*3,deg*2,deg, 0)
#second
subset2 = c(1:53)
for (i in 1:53) {subset2[i] = 0 - (i * deg)}
#third
subset3 = c(1:53)
for (i in 1:53) {subset3[i] = 90 - (i * deg)}
#fourth
subset4 = c(1:53)
for (i in 1:53) {subset4[i] = 0 - (i * deg)}
#fifth
subset5 = c(1:41)
for (i in 1:41) {subset5[i] = 90 - (i * deg)}
## new experiment
vertices$new_angle <- c(first_level,subset1,subset2,subset3,subset4,subset5)

## create hjust
hjust1 = c(1:67)
for (i in 1:67) {hjust1[i] = 0}
hjust2 = c(1:106)
for (i in 1:106) {hjust2[i] = 1}
hjust3 = c(1:41)
for (i in 1:41) {hjust3[i] = 0}
vertices$hjust <- c(first_level,hjust1,hjust2,hjust3)

# customized node labels
vertices <- vertices %>%
  mutate(label = name) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "United States"), yes = "USA", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "United Arab Emirates"), yes = "UAB", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "\\b(?i)(Myanmar)\\b"), yes = "Myanmar", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Bosnia & Herzegovina"), yes = "Bosnia", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Palestinian Territories"), yes = "Palestine", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Congo - Brazzaville"), yes = "RepCongo", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Northern Mariana Islands"), yes = "CNMI", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Congo - Kinshasa"), yes = "DemRepCongo", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "\\b(?i)(Saint Martin)\\b"), yes = "St Martin", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "St. Vincent & Grenadines"), yes = "St Vincent", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Turks & Caicos Islands"), yes = "Turks", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "British Indian Ocean Territory"), yes = "BIOT", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Hong Kong SAR China"), yes = "Hong Kong", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "United Kingdom"), yes = "UK", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Macau SAR China"), yes = "Macau", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "São Tomé & Príncipe"), yes = "São Tomé", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Cayman Islands"), yes = "Cayman Is", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Svalbard & Jan Mayen"), yes = "Svalbard", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Dominican Republic"), yes = "Dom Rep", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Papua New Guinea"), yes = "Papau NG", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Caribbean Netherlands"), yes = "BES Is", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Antigua & Barbuda"), yes = "Ant&Bar", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "French Polynesia"), yes = "Fr Polyn", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Dominican Republic"), yes = "Dom Rep", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Marshall Islands"), yes = "Marshall Is", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Dominican Republic"), yes = "Dom Rep", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "U.S. Virgin Islands"), yes = "USVI", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Wallis & Futuna"), yes = "Wal&Futuna", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Trinidad & Tobago"), yes = "Trinidad", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Solomon Islands"), yes = "Solomon Is", no = label)) %>%
  mutate(label = ifelse(test = str_detect(string = label, pattern = "Turkmenistan"), yes = "Turkmen.", no = label))

top20btw <- "USA|Canada|Germany|UK|^China|Spain|Italy|Russia|France|^India|Argentina|Australia|^Netherlands|Switzerland|New Zealand|Japan|Brazil|Togo|Sweden|Portugal|Nigeria|Poland|Norway|Belguim|Mexico"

heb_aesthetics <- vertices %>%
  drop_na(deg_cent) %>%
  mutate(heb_colors = ifelse(test = str_detect(string = label, pattern = top20btw), yes = "black", no = "#A9A9A9")) %>%
  mutate(heb_sizes = ifelse(test = str_detect(string = label, pattern = top20btw), yes = 3.3, no = 2.5))

# connect the datasets
from <- match( connect$from, vertices$name)
to <- match( connect$to, vertices$name)

# graph connections
ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_conn_bundle(data = get_con(from = from, to = to), tension = 0.5, aes(colour=..index..)) +
  scale_edge_colour_gradient(low = "#000000" , high = "#838383") +
  geom_node_text(aes(x = x*1.1, y=y*1.1, filter = leaf, label=vertices$label,
                     hjust=vertices$hjust, angle = vertices$new_angle),
                 size=heb_aesthetics$heb_sizes, alpha=1, colour=heb_aesthetics$heb_colors) +
  theme_void() +
  theme(legend.position="none", plot.margin=unit(c(0,0,0,0),"cm")) +
  expand_limits(x = c(-1.3, 1.3), y = c(-1.3, 1.3)) +
  geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05, colour=group, size=btw_cent, alpha = 0.7)) +
  scale_size_continuous( range = c(3,11) ) +
  scale_colour_manual(values= c("#232D4B", "#628ED8", "#E57200", "#990000"))

ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_conn_bundle(data = get_con(from = from, to = to), tension = 0.5, aes(colour=..index..)) +
  scale_edge_colour_gradient(low = "#838383" , high = "#000000") +
  geom_node_text(aes(x = x*1.1, y=y*1.1, filter = leaf, label=vertices$select,
                     hjust=vertices$hjust, angle = vertices$new_angle),
                 size=heb_aesthetics$heb_sizes, alpha=1, colour=heb_aesthetics$heb_colors) +
  theme_void() +
  theme(legend.position="none", plot.margin=unit(c(0,0,0,0),"cm")) +
  expand_limits(x = c(-1.3, 1.3), y = c(-1.3, 1.3)) +
  geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05, colour=group, size=btw_cent, alpha = 0.7)) +
  scale_size_continuous( range = c(3,11) ) +
  scale_colour_manual(values= c("#232D4B", "#628ED8", "#E57200", "#990000"))

ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_conn_bundle(data = get_con(from = from, to = to), tension = 0.5, aes(colour=..index..)) +
  scale_edge_colour_gradient(low = "#D3D3D3" , high = "#838383") +
  geom_node_text(aes(x = x*1.1, y=y*1.1, filter = leaf, label=vertices$select,
                     hjust=vertices$hjust, angle = vertices$new_angle),
                 size=heb_aesthetics$heb_sizes, alpha=1, colour=heb_aesthetics$heb_colors) +
  theme_void() +
  theme(legend.position="none", plot.margin=unit(c(0,0,0,0),"cm")) +
  expand_limits(x = c(-1.3, 1.3), y = c(-1.3, 1.3)) +
  geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05, colour=group, size=btw_cent, alpha = 0.7)) +
  scale_size_continuous( range = c(3,11) ) +
  scale_colour_manual(values= c("#232D4B", "#628ED8", "#E57200", "#990000"))

ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_conn_bundle(data = get_con(from = from, to = to), tension = 0.5, aes(colour=..index..)) +
  scale_edge_colour_gradient(low = "#838383" , high = "#D3D3D3") +
  geom_node_text(aes(x = x*1.1, y=y*1.1, filter = leaf, label=vertices$label,
                     hjust=vertices$hjust, angle = vertices$new_angle),
                 size=heb_aesthetics$heb_sizes, alpha=1, colour=heb_aesthetics$heb_colors) +
  theme_void() +
  theme(legend.position="none", plot.margin=unit(c(0,0,0,0),"cm")) +
  expand_limits(x = c(-1.3, 1.3), y = c(-1.3, 1.3)) +
  geom_node_point(aes(filter = leaf, x = x*1.05, y=y*1.05, colour=group, size=btw_cent, alpha = 0.7)) +
  scale_size_continuous( range = c(3,11) ) +
  scale_colour_manual(values= c("#232D4B", "#628ED8", "#E57200", "#990000"))


# References
# https://www.r-graph-gallery.com/311-add-labels-to-hierarchical-edge-bundling.html




