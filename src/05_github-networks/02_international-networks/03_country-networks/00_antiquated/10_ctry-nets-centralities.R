rm(list = ls())

# Libraries
library(ggraph)
library(igraph)
library(tidyverse)
library(RColorBrewer)

# creating first level of hierarchy
setwd("~/git/oss-2020/data/network-analysis/intl-ctry-nets-cum/wisos-lchn/")
nodelist <- read_csv("intl_ctry_nodelist_gephi_2008-19.csv")

nodelist$Community <- recode(nodelist$fstgrdy_comm,
                             `1` = "US-Centric",
                             `2` = "#990000", `3` = "#232D4B",
                             `4` = "#628ED8", `5` = "#628ED8")

nodelist <- nodelist %>%
  rename(name = id) %>%
  mutate(labels = ifelse(test = str_detect(string = name,
                         pattern = "United States|Canada|Germany|UK|^China|Spain|Argentina|Togo|Nigeria|Kenya"), yes = name, no = NA))

nodelist <- nodelist %>%
  mutate(Community = recode(nodelist$fstgrdy_comm, `1` = "American", `2` = "European",
                                    `3` = "Asian", `4` = "Southern", `5` = "Southern")) %>% filter(deg_cent > 65)

ggplot(nodelist) +
  geom_point(aes(x=deg_cent, y=btw_cent, color=Community, size = btw_cent)) +
  geom_text(aes(x=deg_cent, y=btw_cent, size=200,
                #label=ifelse(btw_cent>400,as.character(name),'')
                label=labels), hjust=1.3, vjust=0.5) +
  scale_colour_manual(values = c("American"="#E57200", "European"="#628ED8",
                                 "Asian"="#990000","Southern"="#232D4B")) +
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
