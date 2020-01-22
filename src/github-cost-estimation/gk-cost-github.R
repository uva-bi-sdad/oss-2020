library(RPostgreSQL)
conn <- dbConnect(drv = PostgreSQL(),
                  host = "postgis_1",
                  dbname = "sdad_data",
                  user = Sys.getenv(x = "db_userid"),
                  password = Sys.getenv(x = "db_pwd"))
db_tbls <- dbReadTable(conn = conn,
                       name = c(schema = "github", name = "commits_summary"))
close(con = conn)

```



From Rivanna,



```

library(RPostgreSQL)
conn <- dbConnect(drv = PostgreSQL(),
                  host = "postgis1",
                  dbname = "sdad",
                  user = Sys.getenv(x = "db_userid"),
                  password = Sys.getenv(x = "db_pwd"))
db_tbls <- dbReadTable(conn = conn,
                       name = c(schema = "github", name = "commits_summary"))
close(con = conn)
