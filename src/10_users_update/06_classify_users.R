
devtools::install_github("brandonleekramer/tidyorgs")
devtools::install_github("brandonleekramer/diverstidy", force = TRUE)

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
github_users <- dbGetQuery(conn, "SELECT login, company, location, email
                           FROM gh.ctrs_clean_0821")
dbDisconnect(conn)

github_users <- readRDS("data/github_ctrs_clean_0821.rds")

start_time = Sys.time()
classified_users <- github_users %>%
  detect_orgs(login, company, organization, academic, email,
              country = TRUE, parent_org = TRUE, org_type = TRUE) %>%
  rename(ac_country = country) %>%
  detect_geographies(login, location, "country", email)
end_time = Sys.time()
time_to_classify = end_time - start_time; time_to_classify
# took just over an hour with 3.2m users

saveRDS(classified_users, "data/github_sectored_101321.rds")
classified_users <- readRDS("data/github_sectored_101321.rds")

with_some_info <- classified_users %>%
  filter(!is.na(location) | !is.na(company) | !is.na(email))

with_valid <- classified_users %>%
  drop_na(location)
nrow(with_valid) / nrow(classified_users)

with_loc_email <- classified_users %>%
  filter((!is.na(location) | !is.na(email)))

with_comp_email <- classified_users %>%
  filter((!is.na(company) | !is.na(email)))

with_country_data <- classified_users %>%
  filter(!is.na(country) | !is.na(ac_country)) %>%
  mutate(country = if_else(is.na(country), ac_country, country))

country_counts <- with_country_data %>%
  unnest_legacy(country = base::strsplit(country, "\\|")) %>%
  filter(country != "NA") %>%
  group_by(country) %>%
  count() %>%
  arrange(-n)

with_academic_data <- classified_users %>%
  filter(academic == 1) %>%
  select(login, company, organization, email, academic, everything())

academic_counts <- with_academic_data %>%
  unnest_legacy(organization = base::strsplit(organization, "\\|")) %>%
  group_by(organization) %>%
  count() %>%
  arrange(-n)
# university of wisconsion "madison"
# university of University of Michigan-Ann Arbor
# École Polytechnique de Montréal Université De Montréal
# University of Maryland-College Park-Baltimore County

chk <- with_academic_data %>%
  filter(grepl("\\|", organization))



checking_academia <- with_academic_data %>%
  left_join(academic_counts, by = "organization") %>%
  filter(organization != "Misc. Academic" & n < 232) %>%
  arrange(-n, organization, company) %>%
  select(login, company, organization, email, n, location)

nrow(with_country_data) / nrow(with_some_info) # 78%
nrow(with_country_data) / nrow(with_loc_email) # 82%
nrow(with_country_data) / nrow(with_loc_email)

# issues with country info ###############
# still introducing NAs at some point



checking_misc <- with_academic_data %>%
  left_join(academic_counts, by = "organization") %>%
  filter(organization == "Misc. Academic") %>%
  arrange(-n, organization, company) %>%
  select(login, company, organization, email, n, location) %>%
  mutate(company = tolower(company)) %>%
  count(company) %>%
  arrange(-n)



exempt_orgs <- read_rds("data/ExemptOrganizations.rds")








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










