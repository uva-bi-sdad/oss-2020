
rm(list = ls())
library(tidyverse)
library(tidyorgs)
library(diverstidy)
library(RPostgreSQL)
library(tidytable)

conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
counts_by_year <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_year_0919_dd_nmrc_jbsc;")
dbDisconnect(conn)

counts_by_year <- data.table::as.data.table(counts_by_year)

#COST BASED ON Additions
counts_by_year[,person_months := round(2.5 * (2.4 * (additions/1000)^1.05)^0.38,2)]

conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
counts_by_country <- dbGetQuery(conn, "SELECT * FROM gh_cost.cost_by_country_yr_0919_lchn_frac_110621;")
dbDisconnect(conn)

table(counts_by_country$country)

# joints sector info and the cost estimates at repo level
repos_geo_joined <- counts_by_country %>%
  rename.(geo_additions = frac_additions) %>%
  left_join(counts_by_year, by = c("slug", "year")) %>%
  select(slug, country, year, everything())
sum(repos_geo_joined$geo_additions) # matches 654786581008 from sql code

# calculates the cost for sectors additions
repos_geo_joined <- repos_geo_joined %>%
  rename.(repo_additions = additions,
          repo_deletions = deletions) %>%
  mutate.(geo_fraction = round(geo_additions / repo_additions, 3),
          geo_person_months = geo_fraction * person_months) %>%
  arrange.(slug, country, geo_fraction)
repos_geo_joined$geo_person_months[is.nan(repos_geo_joined$geo_person_months)] <- 0


# taken from ledia proposal 2 in wage_alternatives_oews_2009-2019 in carol's email from 10/28/21
wage_table <- data.frame(year = c(2009, 2010, 2011, 2012, 2013, 2014,
                                  2015, 2016, 2017, 2018, 2019),
                         wages = c(83574.08349,	84197.43403, 86098.45741,
                                   88011.44974, 91252.34, 94383.22369,
                                   97192.85349, 99432.04656,
                                   102379.0605,	104318.9007, 106953.8709))

investment_pre <- repos_geo_joined %>%
  #slice(1:1000) %>%
  select(slug, country, year, geo_person_months) %>%
  left_join(wage_table, by = "year") %>%
  mutate(month_wages = (wages / 12),
         investment = (geo_person_months * month_wages) * 2.02) # just added the blowup factor back in

investment_pre %>%
  filter(country == "United States") %>%
  group_by(year) %>%
  summarise(person_months = sum(geo_person_months)) %>%
  arrange(year)

conn <- dbConnect(drv = PostgreSQL(), dbname = "sdad",
                  host = "10.250.124.195", port = 5432,
                  user = Sys.getenv("db_userid"), password = Sys.getenv("db_pwd"))
us_sector_fractioned <- dbGetQuery(conn, "SELECT *
                                   FROM gh_cost.cost_us_frac_by_sector_0919_lchn_110621;")
dbDisconnect(conn)

us_sector_fractioned <- us_sector_fractioned %>%
  mutate(unsectored = (us_additions - (us_bus_frac+us_gov_frac+us_np_frac+us_hh_frac)),
         unsectored_minus_ac = (unsectored - us_acad_frac))

sum(us_sector_fractioned$us_additions)
sum(us_sector_fractioned$unsectored)+sum(us_sector_fractioned$us_bus_frac)+
  sum(us_sector_fractioned$us_gov_frac)+sum(us_sector_fractioned$us_np_frac)+sum(us_sector_fractioned$us_hh_frac)


investment_table <- investment_pre %>%
  left_join(us_sector_fractioned, by = c("slug", "year", "country")) %>%
  filter(country == "United States") %>%
  mutate.(us_acad_inv = investment * (us_acad_frac/additions),
          us_bus_inv = investment * (us_bus_frac/additions),
          us_gov_inv = investment * (us_gov_frac/additions),
          us_np_inv = investment * (us_np_frac/additions),
          us_hh_inv = investment * (us_hh_frac/additions),
          us_acad_pm = geo_person_months * (us_acad_frac/additions),
          us_bus_pm = geo_person_months * (us_bus_frac/additions),
          us_gov_pm = geo_person_months * (us_gov_frac/additions),
          us_np_pm = geo_person_months * (us_np_frac/additions),
          us_hh_pm = geo_person_months * (us_hh_frac/additions),
          unsectored_pm = (geo_person_months-us_bus_pm-us_gov_pm-us_np_pm-us_hh_pm),
          unsectored_ac_included_pm = (geo_person_months-us_acad_pm-us_bus_pm-us_gov_pm-us_np_pm-us_hh_pm),
          chk_pm = (us_bus_pm+us_gov_pm+us_np_pm+us_hh_pm+unsectored_pm)) %>%
  replace(is.na(.), 0) %>%
  select(slug, country, year, geo_person_months, wages, additions, us_additions,
         investment, ends_with("_inv"), unsectored, ends_with("_pm"))

sum_by_year <- investment_table %>%
  group_by(year) %>%
  summarise(us_person_months = sum(geo_person_months),
            us_wages = mean(wages),
            us_additions = sum(us_additions),
            us_acad_inv = sum(us_acad_inv),
            us_bus_inv = sum(us_bus_inv),
            us_gov_inv = sum(us_gov_inv),
            us_np_inv = sum(us_np_inv),
            us_hh_inv = sum(us_hh_inv),
            total_investment = ((us_person_months/12) * us_wages)*2.02,
            us_acad_pm = sum(us_acad_pm),
            us_bus_pm = sum(us_bus_pm),
            us_gov_pm = sum(us_gov_pm),
            us_np_pm = sum(us_np_pm),
            us_hh_pm = sum(us_hh_pm)#,
            #unsectored_pm = sum(unsectored_pm),
            #unsectored_ac_included_pm = sum(unsectored_ac_included_pm),
            #chk_pm = sum(chk_pm)
            ) %>%
  arrange(year) %>%
  janitor::adorn_totals() %>%
  mutate(total_investment = format(total_investment,scientific=FALSE))

sum_by_year <- sum_by_year %>%
  mutate(total_investment = as.numeric(total_investment),
         all_sectors_w_ac = us_acad_inv+us_bus_inv+us_gov_inv+us_np_inv+us_hh_inv,
         all_sectors_wo_ac = us_bus_inv+us_gov_inv+us_np_inv+us_hh_inv,
         unsectored_w_ac = total_investment - all_sectors_w_ac,
         unsectored_wo_ac = total_investment - all_sectors_wo_ac)

sum_by_year_pm <- sum_by_year %>%
  mutate(all_sectors_pm = us_acad_pm+us_bus_pm+us_gov_pm+us_np_pm+us_hh_pm,
         all_sectors_wo_ac_pm = us_bus_pm+us_gov_pm+us_np_pm+us_hh_pm,
         unsectored_pm = us_person_months-us_acad_pm-us_bus_pm-us_gov_pm-us_np_pm-us_hh_pm,
         unsectored_wo_ac_pm = us_person_months-us_bus_pm-us_gov_pm-us_np_pm-us_hh_pm,)

write_csv(sum_by_year, "/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/total_investments_0919.csv")

transposed <- as.data.frame(sum_by_year %>%
  select(year, total_investment, all_sectors_w_ac, all_sectors_wo_ac, unsectored_w_ac, unsectored_wo_ac,
         us_bus_inv, us_np_inv, us_hh_inv, us_gov_inv, us_acad_inv) %>%
  mutate(total_investment = as.numeric(total_investment)) %>%
  rename(Academic = us_acad_inv,
         Business = us_bus_inv,
         Government = us_gov_inv,
         Nonprofit = us_np_inv,
         Household = us_hh_inv,
         AllSectorswAc = all_sectors_w_ac,
         AllSectorswoAc = all_sectors_wo_ac,
         UnsectoredwAc = unsectored_w_ac,
         UnsectoredwoAc = unsectored_wo_ac,
         Total = total_investment) %>%
  t %>%
  janitor::row_to_names(row_number = 1)) %>%
  mutate_at(vars(`2009`:Total),funs(as.numeric)) %>%
  rownames_to_column("sector")
transposed
write_csv(transposed, "/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/investments_by_sector_0919.csv")

transposed_pm <- as.data.frame(sum_by_year_pm %>%
                              select(year, us_person_months, unsectored_pm, unsectored_wo_ac_pm,
                                     all_sectors_pm, all_sectors_wo_ac_pm,
                                     us_bus_pm, us_np_pm, us_hh_pm, us_gov_pm, us_acad_pm) %>%
                              mutate(total_person_months = as.numeric(us_person_months)) %>%
                              rename(AllSectors = all_sectors_pm,
                                     AllSectorsNonAcademic = all_sectors_wo_ac_pm,
                                     Unsectored = unsectored_pm,
                                     UnsectoredNonAcademic = unsectored_wo_ac_pm,
                                     Academic = us_acad_pm,
                                     Business = us_bus_pm,
                                     Government = us_gov_pm,
                                     Nonprofit = us_np_pm,
                                     Household = us_hh_pm,
                                     Total = total_person_months) %>%
                              t %>%
                              janitor::row_to_names(row_number = 1)) %>%
  mutate_at(vars(`2009`:Total),funs(as.numeric)) %>%
  rownames_to_column("sector")
transposed_pm
write_csv(transposed_pm, "/sfs/qumulo/qhome/kb7hp/git/oss-2020/data/person_months_by_sector_0919.csv")

