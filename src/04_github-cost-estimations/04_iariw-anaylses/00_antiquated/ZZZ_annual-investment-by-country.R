
library(RPostgreSQL)
library(tidytable)

conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
us_commits <- dbGetQuery(conn, "SELECT * FROM gh_cost.us_commits_sectored_110221
                                WHERE year > 2008 AND year < 2020 LIMIT 100;")
dbDisconnect(conn)


sectored_additions <- us_commits %>%
  select.(slug, year, additions, is_us, us_academic,
         us_business, us_gov, us_nonprofit, us_household) %>%
  mutate.(us_academic_adds = additions * us_academic,
         us_business_adds = additions * us_business,
         us_gov_adds = additions * us_gov,
         us_nonprofit_adds = additions * us_nonprofit,
         us_household_adds = additions * us_household)

cost_sums <- sectored_additions %>%
  summarise.(total_adds = sum(additions),
            us_academic_adds = sum(us_academic_adds),
            us_business_adds = sum(us_business_adds),
            us_gov_adds = sum(us_gov_adds),
            us_nonprofit_adds = sum(us_nonprofit_adds),
            us_household_adds = sum(us_household_adds), .by = year) %>%
  left_join.(wage_table, by = "year") %>%
  select.(year, wages, everything())

cost_calcs <- cost_sums %>%
  mutate.(us_total_pmonths = (2.5 * (2.4 * (total_adds/1000)^1.05)^0.38),
         us_ac_pmonths = (2.5 * (2.4 * (us_academic_adds/1000)^1.05)^0.38),
         us_bus_pmonths = (2.5 * (2.4 * (us_business_adds/1000)^1.05)^0.38),
         us_gov_pmonths = (2.5 * (2.4 * (us_gov_adds/1000)^1.05)^0.38),
         us_np_pmonths = (2.5 * (2.4 * (us_nonprofit_adds/1000)^1.05)^0.38),
         us_hh_pmonths = (2.5 * (2.4 * (us_household_adds/1000)^1.05)^0.38),
         us_total_invest = (wages * us_total_pmonths) * 2.02,
         us_ac_invest = (wages * us_ac_pmonths) * 2.02,
         us_bus_invest = (wages * us_bus_pmonths) * 2.02,
         us_gov_invest = (wages * us_gov_pmonths) * 2.02,
         us_np_invest = (wages * us_np_pmonths) * 2.02,
         us_hh_invest = (wages * us_hh_pmonths) * 2.02) %>%
  arrange.(year) %>%
  janitor::adorn_totals() %>%
  select(year, wages, total_adds, us_total_pmonths, us_total_invest, everything())









setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations")
person_months_by_country <- read_csv("person_months_by_country_103121.csv")
person_months_by_country <- person_months_by_country %>%
  filter(country == "United States") %>%
  pivot_longer(!country, names_to = "year", values_to = "person_months")



library(RPostgreSQL)

conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
cost_by_sector <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_sector_us_annual_0919_110221;")
dbDisconnect(conn)

# taken from ledia proposal 2 in wage_alternatives_oews_2009-2019 in carol's email from 10/28/21
wage_table <- data.frame(year = c(2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019),
                         wages = c(83574.08349,	84197.43403,	86098.45741,	88011.44974,	91252.34,
                                   94383.22369,	97192.85349,	99432.04656,	102379.0605,	104318.9007,	106953.8709))

cost_by_sector <- cost_by_sector %>%
  left_join(wage_table, by = "year") %>%
  rename_all(~stringr::str_replace_all(.,"us_",""))

investment_by_sector <- cost_by_sector %>%
  mutate(academic_pmonths = (2.5 * (2.4 * (academic_additions/1000)^1.05)^0.38),
         academic_investment = (wages * academic_pmonths) * 2.02,

         business_pmonths = (2.5 * (2.4 * (business_additions/1000)^1.05)^0.38),
         business_investment = (wages * business_pmonths) * 2.02,

         gov_pmonths = (2.5 * (2.4 * (gov_additions/1000)^1.05)^0.38),
         gov_investment = (wages * gov_pmonths) * 2.02,

         nonprofit_pmonths = (2.5 * (2.4 * (nonprofit_additions/1000)^1.05)^0.38),
         nonprofit_investment = (wages * nonprofit_pmonths) * 2.02,

         household_pmonths = (2.5 * (2.4 * (household_additions/1000)^1.05)^0.38),
         household_investment = (wages * household_pmonths) * 2.02,

         nonsectored_pmonths = (2.5 * (2.4 * (nonsectored_additions/1000)^1.05)^0.38),
         nonsectored_investment = (wages * nonsectored_pmonths) * 2.02,

         total_pmonths = (2.5 * (2.4 * (total_additions/1000)^1.05)^0.38),
         total_investment = (wages * total_pmonths) * 2.02

         ) %>%
  select(year, wages, contains("business"), contains("nonprofit"), contains("household"),
         contains("gov"), contains("academic"), contains("nonsectored"), contains("total"))



investment_by_sector_wide <- investment_by_sector %>%
  pivot_longer(!year, names_to = "sector", values_to = "counts") %>%
  filter(grepl("investment", sector)) %>%
  mutate(sector = str_replace(sector, "_investment", ""),
         sector = str_replace(sector, "gov", "government")) %>%
  pivot_wider(names_from = year, values_from = counts) %>%
  mutate(`All Years` = `2009`+`2010`+`2011`+`2012`+`2013`+`2014`+`2015`+`2016`+`2017`+`2018`+`2019`) %>%
  janitor::adorn_totals("row") %>%
  mutate(sector = str_replace(sector, "Total", "totals"))

sum(investment_by_sector_wide$`All Years`)

pmonths_by_sector_wide <- investment_by_sector %>%
  pivot_longer(!year, names_to = "sector", values_to = "counts") %>%
  filter(grepl("pmonths", sector)) %>%
  mutate(sector = str_replace(sector, "_pmonths", ""),
         sector = str_replace(sector, "gov", "government")) %>%
  pivot_wider(names_from = year, values_from = counts) %>%
  mutate(`All Years` = `2009`+`2010`+`2011`+`2012`+`2013`+`2014`+`2015`+`2016`+`2017`+`2018`+`2019`)



transposed <- t(investment_by_sector)
colnames(transposed) <- transposed[1,]
transposed <- as.data.frame(transposed)
transposed = transposed[-1,]
