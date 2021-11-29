# performed on 10/13/21
conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
github_users <- dbGetQuery(conn, "SELECT login, company, location, email FROM gh.ctrs_clean_0821")
dbDisconnect(conn)

start_time = Sys.time()
classified_users <- github_users %>%
  detect_orgs(login, company, organization, academic, email,
              country = TRUE, parent_org = TRUE, org_type = TRUE) %>%
  rename(ac_country = country) %>%
  detect_geographies(login, location, "country", email)
end_time = Sys.time()
time_to_classify = end_time - start_time; time_to_classify

setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data")
saveRDS(classified_users, "github_sectored_101321.rds")


library(tidyverse)
library(tidyorgs)
library(diverstidy)
library(RPostgreSQL)


# analyzed on 10/15/21 and then updated with fractions on 10/20/21
setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data")
ctrs_by_ctry <- readRDS("../data/github_sectored_101321.rds")

with_country_data <- ctrs_by_ctry %>%
  filter(!is.na(country) | !is.na(ac_country)) %>%
  mutate(country = if_else(is.na(country), ac_country, country)) %>%
  mutate(country = str_replace(country, "Jersey\\|", ""),
         country = str_replace(country, "Jersey", "United States"),
         fraction = (1 / (str_count(country, "\\|") + 1))) %>%
  select(login, country, fraction) %>%
  mutate(country = strsplit(as.character(country), "\\|")) %>%
  unnest(country) %>%
  drop_na(country) %>%
  arrange(fraction)

country_counts <- with_country_data %>%
  unnest_legacy(country = base::strsplit(country, "\\|")) %>%
  filter(country != "NA") %>%
  group_by(country) %>%
  summarise(users = sum(fraction)) %>%
  arrange(-users)

conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
dbWriteTable(conn, c("gh_cost", "users_geo_102021"), with_country_data, row.names = FALSE)
dbDisconnect(conn)


# then run 02_cost_by_country_annual_0919_dd_nmrc_jbsc_1021.sql
