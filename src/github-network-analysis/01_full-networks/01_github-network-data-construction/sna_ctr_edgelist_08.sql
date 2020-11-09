--THIS CODE CREATES AN EDGELIST FOR ALL
--THIS IS ESSENTIALLY THE SAME CODE AS THE YXY ABOVE EXCEPT THAT THE SELECT AND GROUP BY ON YEAR (FOR TABLE B)

-- 2008 TABLE
CREATE MATERIALIZED VIEW gh.sna_ctr_edgelist_08 AS (
SELECT ctr1,
       ctr2,
       COUNT(*) AS repo_wts
FROM
  (SELECT A.slug,
          A.year,
          A.login AS ctr1,
          B.login AS ctr2,
          A.commits
   FROM
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
               login) B ON A.slug = B.slug
   AND A.year = B.year
   WHERE A.login <= B.login AND B.YEAR > 2007 AND B.YEAR < 2009) A
GROUP BY ctr1,
         ctr2
);
