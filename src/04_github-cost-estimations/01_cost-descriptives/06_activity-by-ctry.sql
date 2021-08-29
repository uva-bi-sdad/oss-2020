select country, sum(commits) as commits, 
	sum(additions) as additions, sum(deletions) as deletions
from gh_cost.cost_by_country_annual_0919_dd_nmrc_jbsc_0821
where year = 2019
group by country 
order by commits desc; 
