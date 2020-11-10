CapStr <- function(y) {
  c <- strsplit(y, " ")[[1]]
  paste(toupper(substring(c, 1,1)), substring(c, 2),
        sep="", collapse=" ")
}

#map geocode to U.S. state
lonlat_to_state_sp <- function(pointsDF) {
  # Prepare SpatialPolygons object with one SpatialPolygon
  # per state (plus DC, minus HI & AK)
  states <- map('state', fill=TRUE, col="transparent", plot=FALSE)
  IDs <- sapply(strsplit(states$names, ":"), function(x) x[1])
  states_sp <- map2SpatialPolygons(states, IDs=IDs,
                                   proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  # Convert pointsDF to a SpatialPoints object 
  pointsSP <- SpatialPoints(pointsDF, 
                            proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  # Use 'over' to get _indices_ of the Polygons object containing each point 
  indices <- over(pointsSP, states_sp)
  
  # Return the state names of the Polygons object containing each point
  stateNames <- sapply(states_sp@polygons, function(x) x@ID)
  stateNames[indices]
}


#function: cleancity
#param: df, default to ctrs_extra in gh schema; country_code_dict, data hosted on pgAdmin
#output:a list with two data tables: clean and analysis. Clean table gives cleaned citycode, analysis table gives detailed city geographic locations that could be used for sanity check
#Example:
####ls_cleancity <- cleancity(ctrs_extra)
####city_clean_final <- ls_cleancity$cleaned_df
cleancity <- function(df = ctrs_extra, country_code_dict = country_code_dict){
  #exclude missing values
  df <-  df%>%
    as.data.table() %>%
    filter(!is.na(cc_multiple) & !is.na(city)) 

  #########################################
  #Part I. include multiple countries
  #split the original data into no multiple countries and multiple countrys
  #1. no multiple country code
  df_unique <- df%>%
    filter(cc_viz != "multiple")%>%
    select(-country_code, -cc_viz)%>%
    rename("country_code" = "cc_multiple")
  
  #2. multiple country codes
  df_multiple <- df%>%
    filter(cc_viz == "multiple")%>%
    mutate(id = 1:n())
  
  #split the cc_multiple column by comma, store into list
  split_ls <- stri_split_fixed(df_multiple$cc_multiple, ",")
  id <- 1:length(split_ls)
  
  #reformat into datafram
  #1756 users had 2 country codes, 12 users had 3 country codes, and 3 users had 4 country codes.
  #no user had more than 5 country codes, therefore we set up the bucket up to c4
  split_df <- data.frame(c1 = NA, c2=NA, c3=NA, c4 = NA)
  for (i in 1:length(split_ls)){
    id_i <- id[i]
    for (j in 1:length(split_ls[[i]])){
      split_df[i,j] <- split_ls[[i]][j]
    }
  }
   
  #combine the original data with the reformated country codes, country codes are in different columns
  df_multiple <- cbind(df_multiple, split_df)
  #transform multiple country columns into multiple rows
  df_multiple_gather <- df_multiple %>%
    gather("mul_country_i", "mul_country_name", -colnames(df_multiple)[1:11])%>%
    filter(!is.na(mul_country_name))%>%
    select(-country_code, -cc_viz, -id, -mul_country_i,-cc_multiple)%>%
    rename("country_code" = "mul_country_name")
  
  df_multiple_country <- rbind(df_multiple_gather, df_unique)
  table(duplicated(df_multiple_country$login))
  
  
  ##################################################
  #Part II. Construct city code
  #first step: form city_code variable, a concactinated form of country code and city name
  df_multiple_country <- df_multiple_country%>%
    dt_mutate(city = str_to_lower(city)) %>% #lowercase all city names
    dt_mutate(city_code  = paste(country_code, city, sep="_"))%>% #concactinate country name and city name
  #second step: form user_geo_location, a concactinated form of rounded longitude and latitude, which will be used for checking duplicates of same country+city code, but different long+lat
    dt_mutate(user_long = long, 
           user_lat = lat, 
           user_long_round = round(long,digits=0), 
           user_lat_round = round(lat, digits=0), 
           user_geo_location = paste(user_lat_round, user_long_round, sep="."))
  
  df_sum <- df_multiple_country %>%
    group_by(city_code, user_geo_location) %>%
    dplyr::summarize( ttl_users = n(), user_lat = mean(user_lat), user_long = mean(user_long), user_lat_round= mean(user_lat_round), user_long_round = mean(user_long_round))%>%
    arrange(desc(ttl_users))%>%
  # create an indicator for each row whether the city_code (country+city name) is duplicated
    group_by(city_code)%>%
    mutate(n_city_code=n(), duplicate = if_else(n_city_code > 1, T,F))  #Question1: I can't use dt_mutate here. couldn't find function for n()
  df_sum <- as.data.table(df_sum)

  df_multiple_country <- df_multiple_country%>%
    mutate(city_code = paste(city_code, user_geo_location, sep="_"))
  
  #df_dup: city codes that have duplicates
  #11.5% of city_code have duplicates (N=1502)
  df_dup <- df_sum%>%
    filter(duplicate)

  #df_no_dup: city codes that do not have duplicates  
  #88% of city_code do not have duplicates (N=11556)
  df_no_dup <- df_sum%>%
    filter(!duplicate)%>%
    select(city_code, user_geo_location)
  
  # duplicated city_code, in vector form
  city_code_dup <- unique(df_dup$city_code)
  df_dup <- as.data.table(df_dup)
  
  df_update_geocode <- c() #initialize data table
  df_analysis_citycode <- c() #initialize data table for 
  #  i =  grep("fr_paris", city_code_dup)  #check for one city, get the index of the city you are interested in checking in the city_code_dup vector
  #  i =  grep("us_san francisco", city_code_dup) 
  for ( i in 1: length(city_code_dup)){
    city_code_i = city_code_dup[i]
    message("city #", i, ":", city_code_i)
    df_dup_i <- df_dup %>%
      filter(city_code == city_code_i)%>%
      arrange(desc(ttl_users)) %>% 
      as.data.table()
    
    #identify the geo location where has the most users, treat this geo location as benchmark
    #Question2: I only bench marked once, currently don't think it's worth doing more than once
    long_col <- grep("user_long_round", colnames(df_dup_i)) 
    lat_col <- grep("user_lat_round", colnames(df_dup_i))
    actual_long <- unlist(df_dup_i[1, ..long_col])
    actual_lat <-  unlist(df_dup_i[1,  ..lat_col])
    
    # 1 degree difference = 1.5 hrs drive
    # 2 degrees difference = 2 hrs drive
    #Qeustion3: I didn't use dt_mutate here.
    df_dup_i_check <- df_dup_i %>%
      mutate(long_diff = abs(actual_long - user_long), lat_diff = abs(actual_lat - user_lat), diff_sum = long_diff+ lat_diff)%>%
      mutate(combine = ifelse(diff_sum <= 2 , T, F))%>%
      mutate(rowindex = 1:nrow(df_dup_i), benchmark = if_else(rowindex== 1, T,F))
    
    df_dup_i_check<- df_dup_i_check%>%
      select(-rowindex)
    
    df_analysis_citycode <- rbind(df_analysis_citycode, df_dup_i_check)
    
    ######### group cities within 2 degrees of the benchmarked city together
    df_cb <- df_dup_i_check%>%
      filter(combine)
    
    if(nrow(df_cb) > 1){
      message ("Resembling geocode identified, group ", nrow(df_cb), " geocode(s) for ", "city #", i, ":", city_code_i)
      geo_location_new  = as.vector(df_cb$user_geo_location)[1]
      
      df_cb <- df_cb%>%
        select(city_code, user_geo_location)%>%
        mutate(user_geo_location_new = geo_location_new)
      
    }else{
      message("Did not identify resembling geocode.")
      city_code = as.vector(df_cb$city_code)
      user_geo_location = as.vector(df_cb$user_geo_location)
      user_geo_location_new = as.vector(df_cb$user_geo_location)
      vector_update_geocode <- data.frame(city_code,user_geo_location, user_geo_location_new, stringsAsFactors=FALSE)
      
      df_cb <- df_cb %>%
        select(city_code, user_geo_location)%>%
        mutate(user_geo_location_new = user_geo_location)
    }
    
    
    df_nocb <- df_dup_i_check%>%
      filter(!combine)%>%
      select(city_code, user_geo_location)%>%
      mutate(user_geo_location_new = user_geo_location)
    
    update_geocode <- rbind(df_cb, df_nocb)
    
    df_update_geocode <- rbind(df_update_geocode, update_geocode)
  }
  
  #original dataset, user level
  
  #citycode that have duplicates
  df_dup <- df_update_geocode%>%
    mutate(city_code_rep = city_code)%>%
    mutate(city_code = paste(city_code, user_geo_location, sep = "_"))%>%
    mutate(city_code_new = paste(city_code_rep, user_geo_location_new, sep = "_"))%>%
    select(city_code, city_code_new)
  
  #citycode that does not have duplicates
  #new city code will be the same as the original city code
  df_no_dup <- df_no_dup%>%
    mutate(city_code = paste(city_code, user_geo_location, sep = "_"), city_code_new = city_code)%>%
    select(-user_geo_location)
  
  df_update_geocode_all <- rbind(df_dup, df_no_dup)
  
  df_cleaned <- left_join(df_multiple_country, df_update_geocode_all, by="city_code")
  
  #https://datahub.io/JohnSnowLabs/country-and-continent-codes-list/r/0.html
  #data hosted on pgAdmin under datahub schema
  country_code_dict <- country_code_dict%>%
    mutate(Two_Letter_Country_Code = str_to_lower(Two_Letter_Country_Code)) %>%
    mutate(Country_Name = if_else(grepl(",", Country_Name), str_extract(Country_Name, "(?:(?!,).)*"), Country_Name))%>%
    mutate(Country_Name = if_else(grepl("&", Country_Name), str_extract(Country_Name, "(?:(?!&).)*"), Country_Name))
  
  
  country_code_dict$Country_Name <- trimws(country_code_dict$Country_Name)

  df_cleaned <- df_cleaned%>%
    left_join(country_code_dict, by = c("country_code" = "Two_Letter_Country_Code"))%>%
    rename("raw_login" = "login", "raw_created_at" = "created_at", "raw_city" = "city", "raw_state" = "state", "raw_country_code"="country_code",
           "raw_location" = "location", "raw_long" = "long", "raw_lat" = "lat", "c_geo_code"= "user_geo_location", "c_city_code"="city_code_new", "c_continent_name" = "Continent_Name", "c_continent_code" = "Continent_Code","c_country_name" = "Country_Name")%>%
    select(raw_login, raw_created_at, raw_city, raw_state, raw_country_code, raw_location, raw_long, raw_lat, c_geo_code, c_city_code, c_continent_name,c_continent_code, c_country_name) %>%
  mutate(c_country_name = if_else(c_country_name == "United Kingdom of Great Britain", "United Kingdom", 
                                    if_else(c_country_name == "Russian Federation", "Russia",
                                    if_else(c_country_name == "United States of America", "US", c_country_name))))%>%
    mutate(c_continent_name = if_else(raw_country_code == "africa", "Africa",
                              if_else(raw_country_code == "americas", "North America", #manually check the location indicate north america
                              if_else(raw_country_code == "asia", "Asia",
                              if_else(raw_country_code %in% c("europe", "xk"), "Europe", c_continent_name)))))%>%
    mutate(raw_country_code = if_else(raw_country_code == "xk", "Kosovo", raw_country_code))
  
  
  #for U.S. cities, map from geocode to state
  us_city <- df_cleaned%>%
    filter(raw_country_code == "us")
  us_city_unique <- us_city[!duplicated(us_city$c_city_code), ]
  
  
  city_code_split <- strsplit(us_city_unique$c_city_code, '_')
  geocode <- as.data.frame(unlist(lapply(city_code_split, '[[', 3)))
  colnames(geocode) <- "c_geocode"
  
  
  geocode_split <- strsplit(geocode$c_geocode, '.', fixed = TRUE)
  lat <- as.data.frame(unlist(lapply(geocode_split, '[[', 1)))
  colnames(lat) <- "y"
  long <- as.data.frame(unlist(lapply(geocode_split, '[[', 2)))
  colnames(long) <- "x"
  
  city_geo_state <- cbind(us_city_unique,long, lat)
  city_geo_state <- city_geo_state%>%
    select(c_city_code, x, y)

  city_geo <- city_geo_state%>%
    select(x, y)
  
  city_geo$x <- as.numeric(city_geo$x)   
  city_geo$y <- as.numeric(city_geo$y)   
  
  state <- lonlat_to_state_sp(city_geo)
  
  city_geo_state <- cbind(city_geo_state, state)

  city_geo_state <- city_geo_state%>%
    filter(!is.na(state))%>%
    select(-x, -y)%>%
    rename(c_us_state = state)
  
  #add state to the original data
  df_cleaned <- df_cleaned%>%
    left_join(city_geo_state, by = "c_city_code")
  
  
  ls_citycode  <- list()
  ls_citycode[[1]] <-  df_analysis_citycode
  ls_citycode[[2]]  <- df_cleaned
  
  names(ls_citycode) <- c("analysis_df", "cleaned_df")
  
  return(ls_citycode)
}
