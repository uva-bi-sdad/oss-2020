--this code creates the year by year (yxy) edgelist from the github data from start (2008) until the end of 2019

CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_yxy AS (
SELECT ctr1,
       ctr2,
       YEAR,
       COUNT(*) AS repo_wts
FROM
  (SELECT A.slug,
          A.year,
          A.login AS ctr1,
          B.login AS ctr2,
          A.commits
   FROM
     (SELECT slug,    --START OF THE JOIN
             YEAR,
             login,
             COUNT(*) AS commits
      FROM
        (SELECT login,
                slug,
                EXTRACT(YEAR
                        FROM committed_date)::int AS YEAR
         FROM gh.commits_pre
         WHERE login IS NOT NULL) A
      GROUP BY slug,
               YEAR,
               login) A
   INNER JOIN
     (SELECT slug,
             YEAR,
             login,
             COUNT(*) AS commits
      FROM
        (SELECT login,
                slug,
                EXTRACT(YEAR
                        FROM committed_date)::int AS YEAR
         FROM gh.commits_pre
         WHERE login IS NOT NULL) A
      GROUP BY slug,
               YEAR,
               login) B ON A.slug = B.slug   -- END OF THE JOIN
   AND A.year = B.year
   WHERE A.login <= B.login) A  --- corrected code for self-loops
GROUP BY YEAR,
         ctr1,
         ctr2
);

CREATE INDEX sna_ctr_edgelist_ctr1_idx ON gh.sna_ctr_edgelist (ctr1);
CREATE INDEX sna_ctr_edgelist_ctr2_idx ON gh.sna_ctr_edgelist (ctr2);
