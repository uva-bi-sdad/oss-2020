--THIS CODE CREATES A TABLE THAT JOINS THE PROJECT ID AND PROJECT LANGUAGE DATA FROM GHTORRENT
--AND THEN JOINS IT BACK TO THE COMMITS_RAW DATA WE SCRAPED FROM GITHUB
--THE PRODUCT IS A DATASET WITH AROUND 2M UNIQUE SLUGS WITH OSI-APPROVED LICENSES

--WARNING: NOTE THAT THE LANGUAGE AND BYTES DATA ARE FOR THE REPO LEVEL AND THE NOT THE USER LEVEL
--WARNING: NOTE THAT THE COMMITS, ADDITIONS AND DELETIONS DATA ARE FOR THE USER LEVEL AND THE NOT THE REPO LEVEL


CREATE MATERIALIZED VIEW gh.sna_language_summary AS (
SELECT A.slug, A.language, A.bytes, A.created_at, B.login, B.commits, B.additions, B.deletions
FROM (SELECT DISTINCT ON (project_languages.project_id, project_languages.language)
  SUBSTRING(projects.url FROM '(?<=/.*/.*/.*/).*') AS slug,
  project_languages.language, project_languages.bytes, project_languages.created_at
FROM github_mirror.projects
FULL JOIN github_mirror.project_languages ON projects.id = project_languages.project_id
WHERE url IS NOT NULL) A
INNER JOIN
(SELECT slug, login, COUNT(*) AS commits, SUM(additions) AS additions, SUM(deletions) AS deletions
FROM gh.commits_raw
WHERE commits_raw.login IS NOT NULL
GROUP BY commits_raw.login, commits_raw.slug) B
ON A.slug = B.slug);

GRANT SELECT ON TABLE gh.sna_topic_language TO ncses_oss;
