
devtools::install_github("brandonleekramer/tidyorgs")

rm(list = ls())
library(tidyverse)
library(tidyorgs)
library(diverstidy)
library(RPostgreSQL)

conn <- dbConnect(drv = PostgreSQL(),
                  dbname = "sdad",
                  host = "10.250.124.195",
                  port = 5432,
                  user = Sys.getenv("db_userid"),
                  password = Sys.getenv("db_pwd"))
github_users <- dbGetQuery(conn, "SELECT login, company, location, email FROM gh.ctrs_clean_0821")
dbDisconnect(conn)

start_time = Sys.time()
classified_by_orgs <- github_users %>%
  detect_orgs(login, company, organization, academic, email,
              country = TRUE, parent_org = TRUE, org_type = TRUE) %>%
  rename(ac_country = country) %>%
  detect_geographies(login, location, "country", email)
end_time = Sys.time()
time_to_classify = end_time - start_time; time_to_classify
# took just over an hour with 3.2m users

saveRDS(classified_users, "~/git/oss-2020/data/sectored_100821.rds")

with_some_info <- classified_by_orgs %>%
  filter(!is.na(location) | !is.na(company) | !is.na(email))

# check for NAs
with_country_data <- classified_by_orgs %>%
  filter(!is.na(country) | !is.na(ac_country)) %>%
  mutate(new_country = if_else(is.na(country), ac_country, country))


with_country_data %>%
  dplyr::mutate(sector = replace_na(org_type, 0))



















# some people put company info in the wrong column
sector_terms <- tidyorgs::sector_terms
sector_terms <- na.omit(paste0(sector_terms$terms, collapse = "|"))
company_wrong_col <- classified_users %>%
  mutate(location = tolower(location)) %>%
  filter(academic != 1 & !is.na(location) & grepl(sector_terms, location)) %>%
  select(login, location, email, country) %>%
  rename(company = location) %>%
  rename(country_original = country) %>%
  detect_orgs(login, company, organization, academic, email,
              country = TRUE, parent_org = TRUE, org_type = TRUE)
new_df <- company_wrong_col %>%
  filter(!grepl("university city|university park|university place|state college,|college park|college station", location)) %>%
  mutate(organization = str_replace_all(organization, "Misc\\. Academic\\|", ""),
         organization = str_replace_all(organization, "\\|Misc\\. Academic", "")
         ) %>%
  filter(!(login %in% company_wrong_col)) %>%
  bind_rows(company_wrong_col)




country_users <- classified_users %>%
  drop_na(country)

academic_users <- classified_users %>%
  filter(academic == 1)

academic_counts <- classified_users %>%
  filter(academic == 1) %>%
  tidyr::unnest_legacy(organization = strsplit(organization, "\\|")) %>%
  group_by(organization) %>%
  count() %>%
  arrange(-n)










