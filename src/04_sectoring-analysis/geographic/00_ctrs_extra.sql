--------------------------------------------------------------
-- code makes gh.ctrs_extra
-- binds contributors data together 
-- with user emails (scraped from github)
-- and the recoded country_codes from the sna_intl project  
--------------------------------------------------------------

CREATE TABLE gh.ctrs_extra AS (
SELECT A.login, email, company, 
                 created_at, long, lat, 
		 country_code, state, city, location, 
		 cc_multiple, cc_di, cc_viz  
FROM gh.ctrs_raw AS A
FULL JOIN (SELECT login, email 
		   FROM gh.usr_email) AS B
ON A.login = B.login 
FULL JOIN (SELECT login, 
		   country_code AS cc_multiple, 
		   country_code_di AS cc_di, 
		   country_code_vis AS cc_viz
		   FROM gh.sna_ctr_ctry_codes) AS C
ON A.login = C.login 
); 
GRANT ALL PRIVILEGES ON TABLE gh.ctrs_extra TO ncses_oss, zz3hs, dnb3k, mek2p;  