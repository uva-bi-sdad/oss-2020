
rm(list = ls())
library("tidyverse")
library("RPostgreSQL")
library("janitor")

# connect to postgresql to get our data
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))
ghtorrent_data <- dbGetQuery(conn, "SELECT login, country_code, location, city, long, lat, email, company FROM gh.ctrs_extra")
dbDisconnect(conn)

setwd("/project/biocomplexity/sdad/projects_data/ncses/oss/github_user_data/")
scraped_data <- list.files(pattern="github_user_data.csv$") %>%
  map_df(~read_csv(.)) %>%
  distinct(across(-repos_public), .keep_all = TRUE)
write_csv(scraped_data, "/project/biocomplexity/sdad/projects_data/ncses/oss/github_user_data/github_user_data_raw_0821.csv")
dupes <- scraped_data %>%
  get_dupes(login) %>%
  slice(which(row_number() %% 2 == 1)) %>%
  select(-dupe_count)
scraped_data <- scraped_data %>%
  filter(!(login %in% dupes$login)) %>%
  bind_rows(dupes)
dupes_chk <- scraped_data %>%
  get_dupes(login)

# plucking out both datasets
# adding ghtorrent at the end to prioritize scraped data
# also removing all of the entries that are just NA
joined_data <- scraped_data %>%
  select(login, email, company, location) %>%
  mutate(dataset = "scraped") %>%
  bind_rows(ghtorrent_data %>%
              select(login, email, company, location) %>%
              mutate(dataset = "ghtorrent")) %>%
  arrange(login) %>%
  filter(!is.na(email) | !is.na(company) | !is.na(location)) %>%
  distinct(login, email, company, location, dataset)

joined_data$duplicate <- duplicated(joined_data$login)
duplicate_logins <- joined_data %>% filter(duplicate == TRUE)

deduplicating <- joined_data %>%
  filter(login %in% duplicate_logins$login) %>%
  select(-duplicate) %>%
  distinct(login, email, company, location) %>%
  arrange(login)

email_dd <- deduplicating %>%
  drop_na(email) %>%
  distinct(login, email) %>%
  group_by(login) %>%
  mutate(email = paste(email, collapse = "|")) %>%
  distinct(login, email)

company_dd <- deduplicating %>%
  drop_na(company) %>%
  distinct(login, company) %>%
  group_by(login) %>%
  mutate(company = paste(company, collapse = " | ")) %>%
  distinct(login, company)

location_dd <- deduplicating %>%
  drop_na(location) %>%
  distinct(login, location) %>%
  group_by(login) %>%
  mutate(location = paste(location, collapse = " | ")) %>%
  distinct(login, location)

joined_dd <- email_dd %>%
  full_join(company_dd, by = "login") %>%
  full_join(location_dd, by = "login")

logins_to_filter <- joined_dd$login

consolidated_data <- joined_data %>%
  select(-dataset, -duplicate) %>%
  filter(!(login %in% logins_to_filter)) %>%
  bind_rows(joined_dd) %>%
  arrange(login)

cleaned_data <- consolidated_data %>%
  left_join(scraped_data %>%
              select(-company, -location, -email), by = "login") %>%
  left_join(ghtorrent_data %>% select(login, country_code), by = "login") %>%
  select(login, name, email, company, bio, blog, location,
         country_code, everything(), -created_at, created_at) %>%
  mutate(last_updated = format(Sys.time(), "%x %X"))
cleaned_data <- distinct_all(cleaned_data)

dupes_chk <- cleaned_data %>%
  get_dupes(login)

# fixing a couple of weird dupes i'll

weird_ones1 <- dupes_chk[2,]
weird_ones2 <- dupes_chk[4,]
weird_ones <- bind_rows(weird_ones1, weird_ones2)

cleaned_data <- cleaned_data %>%
  filter(!login %in% c("eddycjy", "jishanshaikh4")) %>%
  bind_rows(weird_ones) %>%
  select(-dupe_count, -last_updated)

# adding all of the NAs back in now
logins_removed_earlier <- scraped_data %>%
  filter(!login %in% cleaned_data$login) %>%
  mutate(country_code = NA) %>%
  select(login, name, email, bio, blog, location, country_code, created_at,
         company, orgs_url, collaborators, gists_public, gists_private,
         repos_public, repos_private, repos_url,
         followers, followers_url, following, following_url)

cleaned_data <- cleaned_data %>%
  select(login, name, email, bio, blog, location, country_code, created_at,
         company, orgs_url, collaborators, gists_public, gists_private,
         repos_public, repos_private, repos_url,
         followers, followers_url, following, following_url) %>%
  bind_rows(logins_removed_earlier) %>%
  arrange(login)


# write back to the database
conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))
dbWriteTable(conn, c("gh", "ctrs_raw_0821"), scraped_data, row.names = FALSE)
dbWriteTable(conn, c("gh", "ctrs_clean_0821"), cleaned_data, row.names = FALSE)
dbDisconnect(conn)


```{sql}
--- run this in the psql terminal or pgadmin
ALTER TABLE gh.ctrs_raw_0821 OWNER TO ncses_oss;
ALTER TABLE gh.ctrs_clean_0821 OWNER TO ncses_oss;
```




chk_location <- cleaned_data %>%
  drop_na(location)

chk_email <- cleaned_data %>%
  drop_na(email)





