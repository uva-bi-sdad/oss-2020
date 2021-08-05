-- get counts of users and repos for cost paper

with A as (
  select slug, EXTRACT(YEAR from committed_date)::int AS year
  from gh.commits_dd_nmrc_jbsc
)

select count(distinct(slug))
from A where year > 2008 and year < 2020;


with A as (
  select login, EXTRACT(YEAR from committed_date)::int AS year
  from gh.commits_dd_nmrc_jbsc
)

select count(distinct(login))
from A where year > 2008 and year < 2020;


