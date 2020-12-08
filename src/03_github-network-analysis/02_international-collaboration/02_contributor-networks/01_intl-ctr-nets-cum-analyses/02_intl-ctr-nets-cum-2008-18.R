

rm(list = ls())

# load packages
library("tidyverse")
library("igraph")
library("RPostgreSQL")
library("lubridate")
library("igraph")

source("~/git/oss-2020/scripts/longitudinal_network_funs.R")

# 2008
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
ctr_edgelist <- dbGetQuery(conn, "SELECT ctr1, ctr2, repo_wts
                           FROM gh.sna_intl_ctr_edgelist_08")
long_ctr_net_desc(edgelist = ctr_edgelist, years_analyzed = "2008", network_type = "cum_full")
dbDisconnect(conn); rm(ctr_edgelist)

# 2008-09
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
ctr_edgelist <- dbGetQuery(conn, "SELECT ctr1, ctr2, repo_wts
                           FROM gh.sna_intl_ctr_edgelist_0809")
long_ctr_net_desc(edgelist = ctr_edgelist, years_analyzed = "2008-09", network_type = "cum_full")
dbDisconnect(conn); rm(ctr_edgelist)

# 2008-10
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
ctr_edgelist <- dbGetQuery(conn, "SELECT ctr1, ctr2, repo_wts
                           FROM gh.sna_intl_ctr_edgelist_0810")
long_ctr_net_desc(edgelist = ctr_edgelist, years_analyzed = "2008-10", network_type = "cum_full")
dbDisconnect(conn); rm(ctr_edgelist)

# 2008-11
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
ctr_edgelist <- dbGetQuery(conn, "SELECT ctr1, ctr2, repo_wts
                           FROM gh.sna_intl_ctr_edgelist_0811")
long_ctr_net_desc(edgelist = ctr_edgelist, years_analyzed = "2008-11", network_type = "cum_full")
dbDisconnect(conn); rm(ctr_edgelist)

# 2008-12
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
ctr_edgelist <- dbGetQuery(conn, "SELECT ctr1, ctr2, repo_wts
                           FROM gh.sna_intl_ctr_edgelist_0812")
long_ctr_net_desc(edgelist = ctr_edgelist, years_analyzed = "2008-12", network_type = "cum_full")
dbDisconnect(conn); rm(ctr_edgelist)

# 2008-13
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
ctr_edgelist <- dbGetQuery(conn, "SELECT ctr1, ctr2, repo_wts
                           FROM gh.sna_intl_ctr_edgelist_0813")
long_ctr_net_desc(edgelist = ctr_edgelist, years_analyzed = "2008-13", network_type = "cum_full")
dbDisconnect(conn); rm(ctr_edgelist)

# 2008-14
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
ctr_edgelist <- dbGetQuery(conn, "SELECT ctr1, ctr2, repo_wts
                           FROM gh.sna_intl_ctr_edgelist_0814")
long_ctr_net_desc(edgelist = ctr_edgelist, years_analyzed = "2008-14", network_type = "cum_full")
dbDisconnect(conn); rm(ctr_edgelist)

# 2008-15
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
ctr_edgelist <- dbGetQuery(conn, "SELECT ctr1, ctr2, repo_wts
                           FROM gh.sna_intl_ctr_edgelist_0815")
long_ctr_net_desc(edgelist = ctr_edgelist, years_analyzed = "2008-16", network_type = "cum_full")
dbDisconnect(conn); rm(ctr_edgelist)

# 2008-16
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
ctr_edgelist <- dbGetQuery(conn, "SELECT ctr1, ctr2, repo_wts
                           FROM gh.sna_intl_ctr_edgelist_0816")
long_ctr_net_desc(edgelist = ctr_edgelist, years_analyzed = "2008-16", network_type = "cum_full")
dbDisconnect(conn); rm(ctr_edgelist)

# 2008-17
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
ctr_edgelist <- dbGetQuery(conn, "SELECT ctr1, ctr2, repo_wts
                                  FROM gh.sna_intl_ctr_edgelist_0817")
long_ctr_net_desc(edgelist = ctr_edgelist, years_analyzed = "2008-17", network_type = "cum_full")
dbDisconnect(conn); rm(ctr_edgelist)

# 2008-18
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
ctr_edgelist <- dbGetQuery(conn, "SELECT ctr1, ctr2, repo_wts
                                  FROM gh.sna_intl_ctr_edgelist_0818")
long_ctr_net_desc(edgelist = ctr_edgelist, years_analyzed = "2008-18", network_type = "cum_full")
dbDisconnect(conn); rm(ctr_edgelist)

# 2008-19
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad", host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
ctr_edgelist <- dbGetQuery(conn, "SELECT ctr1, ctr2, repo_wts
                                  FROM gh.sna_intl_ctr_edgelist_0819")
long_ctr_net_desc(edgelist = ctr_edgelist, years_analyzed = "2008-19", network_type = "cum_full")
dbDisconnect(conn); rm(ctr_edgelist)







