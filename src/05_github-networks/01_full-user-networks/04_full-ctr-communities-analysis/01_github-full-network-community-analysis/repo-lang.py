# how to get pandas data from postgree sql using python
import psycopg2 as pg
import pandas.io.sql as psql
import pandas as pd
connection = pg.connect(host = 'postgis1',database = 'sdad', user = 'login',password = 'pwd')

postgreSQL_select_Query = '''
SELECT projects.name, projects.description,project_languages.language, project_languages.bytes, project_languages.created_at
FROM github_mirror.projects
FULL JOIN github_mirror.project_languages ON projects.id = project_languages.project_id
'''

df = pd.read_sql_query(postgreSQL_select_Query,con=connection)

df.to_csv('/home/bm7mp/bii_data/repo_db.csv')
