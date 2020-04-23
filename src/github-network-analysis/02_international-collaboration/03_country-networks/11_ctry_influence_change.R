rm(list = ls())

# Libraries
library(ggraph)
library(igraph)
library(tidyverse)

# creating first level of hierarchy
setwd("/sfs/qumulo/qhome/kb7hp/oss-data/intl-ctry-nets-cum")
full_nodelist <- read_rds("full_nodelist_cum.rds")

year<-as.data.frame(c("2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019"))
names(year)[1] <- "year"

all <- as.data.frame(c("All", "All", "All", "All", "All", "All", "All", "All", "All", "All", "All", "All"))
top25 <- as.data.frame(c("Top25","Top25","Top25","Top25","Top25","Top25","Top25","Top25","Top25","Top25","Top25","Top25"))
top10 <-  as.data.frame(c("Top10","Top10","Top10","Top10","Top10","Top10","Top10","Top10","Top10","Top10","Top10","Top10"))
colnames(all)[1] <- "group"
colnames(top25)[1] <- "group"
colnames(top10)[1] <- "group"

btw_all <- cbind(year,rbind(
full_nodelist %>% summarise(btw_mean = mean(btw_cent08, na.rm = TRUE),   btw_sd = sd(btw_cent08, na.rm = TRUE)) ,
full_nodelist %>% summarise(btw_mean = mean(btw_cent0809, na.rm = TRUE), btw_sd = sd(btw_cent0809, na.rm = TRUE)),
full_nodelist %>% summarise(btw_mean = mean(btw_cent0810, na.rm = TRUE), btw_sd = sd(btw_cent0810, na.rm = TRUE)),
full_nodelist %>% summarise(btw_mean = mean(btw_cent0811, na.rm = TRUE), btw_sd = sd(btw_cent0811, na.rm = TRUE)),
full_nodelist %>% summarise(btw_mean = mean(btw_cent0812, na.rm = TRUE), btw_sd = sd(btw_cent0812, na.rm = TRUE)),
full_nodelist %>% summarise(btw_mean = mean(btw_cent0813, na.rm = TRUE), btw_sd = sd(btw_cent0813, na.rm = TRUE)),
full_nodelist %>% summarise(btw_mean = mean(btw_cent0814, na.rm = TRUE), btw_sd = sd(btw_cent0814, na.rm = TRUE)),
full_nodelist %>% summarise(btw_mean = mean(btw_cent0815, na.rm = TRUE), btw_sd = sd(btw_cent0815, na.rm = TRUE)),
full_nodelist %>% summarise(btw_mean = mean(btw_cent0816, na.rm = TRUE), btw_sd = sd(btw_cent0816, na.rm = TRUE)),
full_nodelist %>% summarise(btw_mean = mean(btw_cent0817, na.rm = TRUE), btw_sd = sd(btw_cent0817, na.rm = TRUE)),
full_nodelist %>% summarise(btw_mean = mean(btw_cent0818, na.rm = TRUE), btw_sd = sd(btw_cent0818, na.rm = TRUE)),
full_nodelist %>% summarise(btw_mean = mean(btw_cent0819, na.rm = TRUE), btw_sd = sd(btw_cent0819, na.rm = TRUE))), all)

btw_25 <- cbind(year,rbind(
full_nodelist %>% top_frac(0.25, btw_cent08) %>% summarise(btw_mean = mean(btw_cent08, na.rm = TRUE), btw_sd = sd(btw_cent08, na.rm = TRUE)),
full_nodelist %>% top_frac(0.25, btw_cent0809) %>% summarise(btw_mean = mean(btw_cent0809, na.rm = TRUE), btw_sd = sd(btw_cent0809, na.rm = TRUE)),
full_nodelist %>% top_frac(0.25, btw_cent0810) %>% summarise(btw_mean = mean(btw_cent0810, na.rm = TRUE), btw_sd = sd(btw_cent0810, na.rm = TRUE)),
full_nodelist %>% top_frac(0.25, btw_cent0811) %>% summarise(btw_mean = mean(btw_cent0811, na.rm = TRUE), btw_sd = sd(btw_cent0811, na.rm = TRUE)),
full_nodelist %>% top_frac(0.25, btw_cent0812) %>% summarise(btw_mean = mean(btw_cent0812, na.rm = TRUE), btw_sd = sd(btw_cent0812, na.rm = TRUE)),
full_nodelist %>% top_frac(0.25, btw_cent0813) %>% summarise(btw_mean = mean(btw_cent0813, na.rm = TRUE), btw_sd = sd(btw_cent0813, na.rm = TRUE)),
full_nodelist %>% top_frac(0.25, btw_cent0814) %>% summarise(btw_mean = mean(btw_cent0814, na.rm = TRUE), btw_sd = sd(btw_cent0814, na.rm = TRUE)),
full_nodelist %>% top_frac(0.25, btw_cent0815) %>% summarise(btw_mean = mean(btw_cent0815, na.rm = TRUE), btw_sd = sd(btw_cent0815, na.rm = TRUE)),
full_nodelist %>% top_frac(0.25, btw_cent0816) %>% summarise(btw_mean = mean(btw_cent0816, na.rm = TRUE), btw_sd = sd(btw_cent0816, na.rm = TRUE)),
full_nodelist %>% top_frac(0.25, btw_cent0817) %>% summarise(btw_mean = mean(btw_cent0817, na.rm = TRUE), btw_sd = sd(btw_cent0817, na.rm = TRUE)),
full_nodelist %>% top_frac(0.25, btw_cent0818) %>% summarise(btw_mean = mean(btw_cent0818, na.rm = TRUE), btw_sd = sd(btw_cent0818, na.rm = TRUE)),
full_nodelist %>% top_frac(0.25, btw_cent0819) %>% summarise(btw_mean = mean(btw_cent0819, na.rm = TRUE), btw_sd = sd(btw_cent0819, na.rm = TRUE))), top25)

btw_10 <- cbind(year,rbind(
  full_nodelist %>% top_frac(0.10, btw_cent08) %>% summarise(btw_mean = mean(btw_cent08, na.rm = TRUE), btw_sd = sd(btw_cent08, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, btw_cent0809) %>% summarise(btw_mean = mean(btw_cent0809, na.rm = TRUE), btw_sd = sd(btw_cent0809, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, btw_cent0810) %>% summarise(btw_mean = mean(btw_cent0810, na.rm = TRUE), btw_sd = sd(btw_cent0810, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, btw_cent0811) %>% summarise(btw_mean = mean(btw_cent0811, na.rm = TRUE), btw_sd = sd(btw_cent0811, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, btw_cent0812) %>% summarise(btw_mean = mean(btw_cent0812, na.rm = TRUE), btw_sd = sd(btw_cent0812, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, btw_cent0813) %>% summarise(btw_mean = mean(btw_cent0813, na.rm = TRUE), btw_sd = sd(btw_cent0813, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, btw_cent0814) %>% summarise(btw_mean = mean(btw_cent0814, na.rm = TRUE), btw_sd = sd(btw_cent0814, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, btw_cent0815) %>% summarise(btw_mean = mean(btw_cent0815, na.rm = TRUE), btw_sd = sd(btw_cent0815, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, btw_cent0816) %>% summarise(btw_mean = mean(btw_cent0816, na.rm = TRUE), btw_sd = sd(btw_cent0816, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, btw_cent0817) %>% summarise(btw_mean = mean(btw_cent0817, na.rm = TRUE), btw_sd = sd(btw_cent0817, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, btw_cent0818) %>% summarise(btw_mean = mean(btw_cent0818, na.rm = TRUE), btw_sd = sd(btw_cent0818, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, btw_cent0819) %>% summarise(btw_mean = mean(btw_cent0819, na.rm = TRUE), btw_sd = sd(btw_cent0819, na.rm = TRUE))), top10)

combined_btw <- rbind( btw_10, btw_25,
                       btw_all)

ggplot(combined_btw, aes(x=year, y=btw_mean, supp=group, colour=group)) +
  geom_errorbar(aes(ymin=btw_mean-btw_sd, ymax=btw_mean+btw_sd), size = 2 , width=0.4) +
  geom_line(aes(group = group), size = 2) +
  theme_minimal() + theme(legend.title = element_blank(),
                          #legend.position=c(0.125,0.87),
                          axis.title.x = element_blank(),
                          legend.background = element_rect(colour = NA)) +
  scale_color_manual(values=c( "#628ed8", "#E57200", "#232D4B")) + ylab("Betweenness Centrality") +
  labs(title= "Comparison of Betweenness Centrality Means and SDs Over Time")


eigen_all <- cbind(year,rbind(
  full_nodelist %>% summarise(eigen_mean = mean(eigen_cent08, na.rm = TRUE),   eigen_sd = sd(eigen_cent08, na.rm = TRUE)) ,
  full_nodelist %>% summarise(eigen_mean = mean(eigen_cent0809, na.rm = TRUE), eigen_sd = sd(eigen_cent0809, na.rm = TRUE)),
  full_nodelist %>% summarise(eigen_mean = mean(eigen_cent0810, na.rm = TRUE), eigen_sd = sd(eigen_cent0810, na.rm = TRUE)),
  full_nodelist %>% summarise(eigen_mean = mean(eigen_cent0811, na.rm = TRUE), eigen_sd = sd(eigen_cent0811, na.rm = TRUE)),
  full_nodelist %>% summarise(eigen_mean = mean(eigen_cent0812, na.rm = TRUE), eigen_sd = sd(eigen_cent0812, na.rm = TRUE)),
  full_nodelist %>% summarise(eigen_mean = mean(eigen_cent0813, na.rm = TRUE), eigen_sd = sd(eigen_cent0813, na.rm = TRUE)),
  full_nodelist %>% summarise(eigen_mean = mean(eigen_cent0814, na.rm = TRUE), eigen_sd = sd(eigen_cent0814, na.rm = TRUE)),
  full_nodelist %>% summarise(eigen_mean = mean(eigen_cent0815, na.rm = TRUE), eigen_sd = sd(eigen_cent0815, na.rm = TRUE)),
  full_nodelist %>% summarise(eigen_mean = mean(eigen_cent0816, na.rm = TRUE), eigen_sd = sd(eigen_cent0816, na.rm = TRUE)),
  full_nodelist %>% summarise(eigen_mean = mean(eigen_cent0817, na.rm = TRUE), eigen_sd = sd(eigen_cent0817, na.rm = TRUE)),
  full_nodelist %>% summarise(eigen_mean = mean(eigen_cent0818, na.rm = TRUE), eigen_sd = sd(eigen_cent0818, na.rm = TRUE)),
  full_nodelist %>% summarise(eigen_mean = mean(eigen_cent0819, na.rm = TRUE), eigen_sd = sd(eigen_cent0819, na.rm = TRUE))), all)

eigen_25 <- cbind(year,rbind(
  full_nodelist %>% top_frac(0.25, eigen_cent08) %>% summarise(eigen_mean = mean(eigen_cent08, na.rm = TRUE), eigen_sd = sd(eigen_cent08, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.25, eigen_cent0809) %>% summarise(eigen_mean = mean(eigen_cent0809, na.rm = TRUE), eigen_sd = sd(eigen_cent0809, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.25, eigen_cent0810) %>% summarise(eigen_mean = mean(eigen_cent0810, na.rm = TRUE), eigen_sd = sd(eigen_cent0810, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.25, eigen_cent0811) %>% summarise(eigen_mean = mean(eigen_cent0811, na.rm = TRUE), eigen_sd = sd(eigen_cent0811, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.25, eigen_cent0812) %>% summarise(eigen_mean = mean(eigen_cent0812, na.rm = TRUE), eigen_sd = sd(eigen_cent0812, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.25, eigen_cent0813) %>% summarise(eigen_mean = mean(eigen_cent0813, na.rm = TRUE), eigen_sd = sd(eigen_cent0813, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.25, eigen_cent0814) %>% summarise(eigen_mean = mean(eigen_cent0814, na.rm = TRUE), eigen_sd = sd(eigen_cent0814, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.25, eigen_cent0815) %>% summarise(eigen_mean = mean(eigen_cent0815, na.rm = TRUE), eigen_sd = sd(eigen_cent0815, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.25, eigen_cent0816) %>% summarise(eigen_mean = mean(eigen_cent0816, na.rm = TRUE), eigen_sd = sd(eigen_cent0816, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.25, eigen_cent0817) %>% summarise(eigen_mean = mean(eigen_cent0817, na.rm = TRUE), eigen_sd = sd(eigen_cent0817, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.25, eigen_cent0818) %>% summarise(eigen_mean = mean(eigen_cent0818, na.rm = TRUE), eigen_sd = sd(eigen_cent0818, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.25, eigen_cent0819) %>% summarise(eigen_mean = mean(eigen_cent0819, na.rm = TRUE), eigen_sd = sd(eigen_cent0819, na.rm = TRUE))), top25)

eigen_10 <- cbind(year,rbind(
  full_nodelist %>% top_frac(0.10, eigen_cent08) %>% summarise(eigen_mean = mean(eigen_cent08, na.rm = TRUE), eigen_sd = sd(eigen_cent08, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, eigen_cent0809) %>% summarise(eigen_mean = mean(eigen_cent0809, na.rm = TRUE), eigen_sd = sd(eigen_cent0809, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, eigen_cent0810) %>% summarise(eigen_mean = mean(eigen_cent0810, na.rm = TRUE), eigen_sd = sd(eigen_cent0810, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, eigen_cent0811) %>% summarise(eigen_mean = mean(eigen_cent0811, na.rm = TRUE), eigen_sd = sd(eigen_cent0811, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, eigen_cent0812) %>% summarise(eigen_mean = mean(eigen_cent0812, na.rm = TRUE), eigen_sd = sd(eigen_cent0812, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, eigen_cent0813) %>% summarise(eigen_mean = mean(eigen_cent0813, na.rm = TRUE), eigen_sd = sd(eigen_cent0813, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, eigen_cent0814) %>% summarise(eigen_mean = mean(eigen_cent0814, na.rm = TRUE), eigen_sd = sd(eigen_cent0814, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, eigen_cent0815) %>% summarise(eigen_mean = mean(eigen_cent0815, na.rm = TRUE), eigen_sd = sd(eigen_cent0815, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, eigen_cent0816) %>% summarise(eigen_mean = mean(eigen_cent0816, na.rm = TRUE), eigen_sd = sd(eigen_cent0816, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, eigen_cent0817) %>% summarise(eigen_mean = mean(eigen_cent0817, na.rm = TRUE), eigen_sd = sd(eigen_cent0817, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, eigen_cent0818) %>% summarise(eigen_mean = mean(eigen_cent0818, na.rm = TRUE), eigen_sd = sd(eigen_cent0818, na.rm = TRUE)),
  full_nodelist %>% top_frac(0.10, eigen_cent0819) %>% summarise(eigen_mean = mean(eigen_cent0819, na.rm = TRUE), eigen_sd = sd(eigen_cent0819, na.rm = TRUE))), top10)

combined_eigen <- rbind(eigen_10, eigen_25, eigen_all)

ggplot(combined_eigen, aes(x=year, y=eigen_mean, supp=group, colour=group)) +
  geom_errorbar(aes(ymin=eigen_mean-eigen_sd, ymax=eigen_mean+eigen_sd), size = 2 , width=0.4) +
  geom_line(aes(group = group), size = 2) +
  theme_minimal() + theme(legend.title = element_blank(),
                          #legend.position=c(0.125,0.87),
                          axis.title.x = element_blank(),
                          legend.background = element_rect(colour = NA)) +
  scale_color_manual(values=c("#628ed8", "#E57200", "#232D4B")) + ylab("Eigenvector Centrality") +
  labs(title= "Comparison of Eigenvector Centrality Means and SDs Over Time")
