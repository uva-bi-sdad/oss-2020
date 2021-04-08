rm(list = ls())

# Libraries
library(ggraph)
library(igraph)
library(tidyverse)

# creating first level of hierarchy
setwd("~/git/oss-2020/data/network-analysis/intl-ctry-nets-cum/wisos-lchn")
full_nodelist <- read_rds("full_nodelist_cum.rds")

year<-as.data.frame(c("2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019"))
names(year)[1] <- "year"

all <- as.data.frame(replicate(12, "All Countries"))
top10 <-  as.data.frame(replicate(12, "Top 10%"))
top25 <- as.data.frame(replicate(12, "Top 25%"))
colnames(all)[1] <- "group"
colnames(top25)[1] <- "group"
colnames(top10)[1] <- "group"
all$group <- as.character(all$group)
top25$group <- as.character(top25$group)
top10$group <- as.character(top10$group)

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

combined_btw <- rbind( btw_10, btw_25, btw_all)

ggplot(combined_btw, aes(x=year, y=btw_mean, supp=group, colour=group)) +
  geom_errorbar(aes(ymin=btw_mean-btw_sd, ymax=btw_mean+btw_sd), size = 1.3 , width=0.4) +
  geom_line(aes(group = group), size = 1.3) +
  theme_minimal() + theme(plot.title = element_text(size = 13, hjust = 0.5),
                          legend.title = element_text(hjust = 0.5),
                          legend.position=c(0.125,0.85),
                          axis.title.x = element_blank(),
                          legend.background = element_rect(colour = NA)) +
  scale_color_manual(values=c( "#628ed8", "#ff7f00", "#232D4B")) + ylab("Average Betweenness Centrality") +
  labs(title= "Figure 3D. Comparison of Average Betweenness Centrality \n of Top-10%, Top-25% and All Countries Over Time") +
  labs(color='Countries')



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
