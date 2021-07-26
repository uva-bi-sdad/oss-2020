

# syncing scraping 
library("tidyverse")
library("RPostgreSQL")

# connect to postgresql to get data (in rivanna)
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))

# query the bipartite edgelist data from github data
repos_table <- dbGetQuery(conn, "SELECT * FROM gh_2007_2020.repos;")

# disconnect from postgresql
dbDisconnect(conn)

repos_counts <- repos_table %>% 
  select(slug) %>% 
  separate(slug, c("owner", "repo"), "/") %>% 
  group_by(repo) %>% 
  count() %>% 
  arrange(-n) 

repos_counts_filtered <- repos_counts %>% 
  filter(n > 5)

sum(repos_counts_filtered$n)
  
  
  
  
  
  
  
  
  
  

