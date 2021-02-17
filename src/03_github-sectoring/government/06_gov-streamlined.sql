---
title: "Untitled"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```


```{r, include = FALSE}
rm(list = ls())

for (pkg in c("tidyverse", "igraph", "data.table", "R.utils", "countrycode",
              "RPostgreSQL", "cowplot", "maditr", "gt", "tidytext")) {library(pkg, character.only = TRUE)}

# connect to postgresql to get our data
conn <- dbConnect(drv = PostgreSQL(), 
                  dbname = "sdad", 
                  host = "10.250.124.195",
                  port = 5432, 
                  user = Sys.getenv("db_userid"), 
                  password = Sys.getenv("db_pwd"))

#github user with emails
gh_extra <- dbGetQuery(conn, "SELECT * FROM gh.ctrs_extra")

# disconnect from postgresql database 
dbDisconnect(conn)

# goverment email domains
#https://home.dotgov.gov/data/ (All .gov domains)
#The official public list of .gov domains is updated about every two weeks:
#List of .gov domains - includes all federal, state, interstate, local, and tribal .gov and .fed.us domains.
email_domain_gov <- read_csv("~/git/oss-2020/data/government/email_domain_federal_full.csv") %>%
  rename("domain_name" = "Domain Name", "domain_type" ="Domain Type") %>%
  select(-"Security Contact Email", -"City", -"State") %>%
  mutate(domain_name = tolower(domain_name), gov = T)

#email domain country from https://www.sitepoint.com/complete-list-country-code-top-level-domains/
email_domain_cc <- read_csv("~/git/oss-2020/data/government/email_domain_by_country.csv")
#remove dot in the email domain and add in country_code
email_domain_cc$email_domain <- str_replace_all(email_domain_cc$domain, fixed("."), "")
email_domain_cc$ctry_code <- countrycode(email_domain_cc$country_name, origin = 'country.name', destination = 'iso2c')

```

# Count of missingness 

```{r}
gh_extra %>% drop_na(email) %>% count() / gh_extra %>% count()
gh_extra %>% drop_na(company) %>% count() / gh_extra %>% count()
gh_extra %>% drop_na(company, email) %>% count() / gh_extra %>% count()
```

# First lets classify gov users based on emails 

```{r}
#match email adress domain
gh_email <- gh_extra %>%
  as.data.table() %>% 
  # extracts all strings after @
  mutate(email_domain_full =  str_extract(email, "(?<=@).*")) %>% 
  # new col with all missings 
  mutate(is_gov = NA)

#construct a list of country email domain
email_domain_country_vector <- unlist(email_domain_cc$email_domain)
email_domain_country_pattern <- paste(email_domain_country_vector, collapse="$|")

#format into regex search pattern
email_domain_country_pattern <- paste("\\b(?i)(", email_domain_country_pattern, "$)\\b", sep="")

gh_email <- gh_email %>%
  #select(login, email, company, cc_multiple, email_domain_full)%>% # (might add cc_multiple later)
  #first part of the full domain
  mutate(email_domain_first = str_extract(email_domain_full, ".*(?=[.])"))%>% 
  #match goverment email domain (gov, fed.us, mil)
  #note that we are matching any string that contains gov 
  mutate(is_gov_email_domain = if_else(str_detect(email_domain_full, "\\b(?i)(gov|fed.us|.mil)\\b") == T, T, F)) %>% 
  #filter(!is.na(email_domain_full))%>%
  #check if the the gh user email domain match the country domain list
  mutate(is.country_email_domain = if_else(str_detect(email_domain_full, email_domain_country_pattern) == T, T, F))%>%
  #extract the country email domain from the full email domain 
  mutate(country_domain = if_else(is.country_email_domain, str_sub(email_domain_full,-2,-1), "NA"))%>%
  #add country name to the dataset by joining with the email domain data
  left_join(email_domain_cc, by = c("country_domain"="email_domain"))%>%
  rename(country_domain_name = ctry_code)

# get the count
table(gh_email$is_gov_email_domain) 
#726 gh users had .gov (717) or fed.us (only 1), or .mil (only 8) emails

#join the cleaned email from gh with the gov email domain data
gh_email <- gh_email %>%
  left_join(email_domain_gov, by = c("email_domain_full" = "domain_name")) %>%
  mutate(is.usgov = if_else(is.na(domain_type), F, T)) %>%
  dplyr::mutate(gov= replace_na(gov, FALSE))

table(gh_email$gov, gh_email$is_gov_email_domain) 
#430 gh users matched with the email_domain_gov, 296 didn't match (these might be foreign gov)

gh_email <- gh_email %>%
  mutate(is.gov = if_else(is_gov_email_domain == T | gov==T, T, F))%>%
  select(-is_gov_email_domain, -gov)

table(gh_email$is.gov) 
#consistent with the first match, 726 gh users are gov related

#There are 163 unique gov ending emails. 
length(unique(filter(gh_email, is.gov)$email_domain_full))

gh_email %>%
  group_by(is.gov,is.usgov, is.country_email_domain )%>%
  summarize(N=n())

```


Basically, we found that 726 users can be classified into the government sector via email with 429 being in the US and 225 being from outside of the US. 

Second we will use the `company` column 

Step 2A: We are going to clean the company code by implementing all of Daniel's techniques 

```{r}
# implementing daniel's approaches 
legal_entities <- read.csv("~/git/oss-2020/data/ossPy-files/curatedLegalEntitesRaw.csv", header=FALSE)
legal_entities <- legal_entities %>% 
  rename(strings = V1) %>% 
  mutate(strings = as.character(strings))
legal_entities$strings <- substring(legal_entities$strings, 2)
legal_entities$strings <- substr(legal_entities$strings,1, nchar(legal_entities$strings)-1)

symbol_strings <- read.csv("~/git/oss-2020/data/ossPy-files/symbolRemove.csv", header=FALSE)
symbol_strings <- symbol_strings %>% 
  rename(strings = V1) %>% 
  mutate(strings = as.character(strings))
symbol_strings$strings <- substring(symbol_strings$strings, 2)
symbol_strings$strings <- substr(symbol_strings$strings,1, nchar(symbol_strings$strings)-1)
symbol_strings <- symbol_strings %>% slice(-17:-20)

curated_domains <- read.csv("~/git/oss-2020/data/ossPy-files/curatedDomains.csv", header=FALSE)
curated_domains <- curated_domains %>% 
  rename(strings = V1) %>% 
  mutate(strings = as.character(strings))
curated_domains$strings <- substring(curated_domains$strings, 2)
curated_domains$strings <- substr(curated_domains$strings,1, nchar(curated_domains$strings)-1)

gh_extra_company <- gh_email %>% 
  mutate(company_original = company) %>%
  mutate(company = str_replace_all(company, paste(c("(?i)(zqx", na.omit(legal_entities$strings), 
                                                    "zqx|, Inc.)"), collapse = "|"), "")) %>% 
  mutate(company = str_replace_all(company, paste(c("(?i)(zqx", na.omit(symbol_strings$strings), 
                                                    ", $|,$|zqx)"), collapse = "|"), "")) %>%
  mutate(company = str_replace_all(company, paste(c("(?i)(zqx", na.omit(curated_domains$strings), 
                                                    "zqx)"), collapse = "|"), "")) %>% 
  mutate(company = tolower(company),
         company = trimws(company),
         company = str_replace_all(company, fixed("u.s."), "united states"),
         company = str_replace_all(company, "\\b(?i)( us|^us)\\b", "united states"),
         company = str_replace_all(company,"[^[:alnum:]]", " ")) 
        
gh_extra_company
```

Next we are going to pull out all of the strings that have already been matched and then use those to match others  

```{r}
# pulls out the table of matching institutions from company_col
company_confirm_gov <- gh_extra_company %>%
  filter(is.gov == TRUE) %>%
  group_by(company) %>%
  summarize(N=n()) %>%
  filter(company != "") %>%
  filter(!is.na(company)) %>%
  arrange(desc(N)) %>%
  #cutoff threshold: 1
  filter(N > 1) 

`%notin%` <- Negate(`%in%`)

company_confirm_gov <- company_confirm_gov %>% 
  filter(company %notin% c("home office", "companieshouse", "oxford physics"))

#full string matching
company_confirm_gov_vector <- unlist(company_confirm_gov$company)
company_confirm_gov_pattern<-paste(company_confirm_gov_vector, collapse="|")
company_confirm_gov_pattern <- paste("\\b(?i)(", company_confirm_gov_pattern, ")\\b", sep="")

# apply the string matching technique 
gh_extra_company <- gh_extra_company%>%
  mutate(company_match_gov = if_else(str_detect(company, company_confirm_gov_pattern) == T, T, F))%>%
  mutate(company_match_gov= replace_na(company_match_gov, FALSE)) %>%
  mutate(is.gov = if_else(company_match_gov==T, T, is.gov))

gh_extra_company %>% 
  filter(is.gov == TRUE) %>% 
  count(company) %>% 
  arrange(-n)

gh_extra_company %>% 
  filter(is.gov == TRUE & is.na(company))

table(gh_extra_company$is.gov)

```

Now, let's 







```{r}
# to add 9/14
# province of british columbia
# ufrn.edu.br = Colombian education dept 
# Interpol, United Nations, etc can all have multiple countries attached to organization 
```













