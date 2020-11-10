library(RPostgreSQL)
conn <- dbConnect(drv = PostgreSQL(),
                  host = "postgis_2",
                  dbname = "sdad_data",
                  user = "crobbins",
                  password = "crobbins"
db_tbls <- dbReadTable(conn = conn,
                       name = c(schema = "github", name = "commits_summary"))
close(con = conn)

```
