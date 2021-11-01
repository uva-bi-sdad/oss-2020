



setwd("/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/cost_estimations")
write_csv(costs_by_country_wide, "person_months_by_country_103121.csv")




library(RPostgreSQL)

conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
cost_by_sector <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_sector_annual_0919_103121b;")
dbDisconnect(conn)

# taken from ledia proposal 2 in wage_alternatives_oews_2009-2019 in carol's email from 10/28/21
wage_table <- data.frame(year = c(2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019),
                         wages = c(83574.08349,	84197.43403,	86098.45741,	88011.44974,	91252.34,
                                   94383.22369,	97192.85349,	99432.04656,	102379.0605,	104318.9007,	106953.8709))

cost_by_sector <- cost_by_sector %>%
  left_join(wage_table, by = "year")

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
         nonsectored_investment = (wages * nonsectored_pmonths) * 2.02) %>%
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
