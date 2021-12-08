

library(tidyverse)


github_original <- read_rds('~/git/oss-2020/data/iariw-aea/github_ctrs_clean_0821.rds')
github_sectored <- read_rds('~/git/oss-2020/data/iariw-aea/github_sectors_110521.rds')
github_data_countries <- read_rds('~/git/oss-2020/data/iariw-aea/github_sectored_101321.rds') %>% select(login, country)

github_all <- github_original %>%
  left_join(github_sectored, by = "login") %>%
  left_join(github_data_countries, by = "login") %>%
  select(login, email, company, organization, location, country, contains("is_"))

saveRDS(github_all, '~/git/oss-2020/data/iariw-aea/github_iariw_final_1121.rds')
