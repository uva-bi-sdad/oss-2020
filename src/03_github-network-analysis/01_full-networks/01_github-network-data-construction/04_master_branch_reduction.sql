
-- encountered problems with making an edgelist out of the commits data
-- basically, it seems like commits made to one central repo then get
-- incorported other repos in many cases, leading to a much higher degree
-- total for contributors to large repos (see 'frockenstein' who committed
-- four lines of code to js/reveal.js on may 14, 2012 and then ended up having
-- a degree dist of ~4000 people)
-- https://github.com/OpenSourceScholars/os-preso/commits/master?after=4252429b4d9f9306791b5d40a198179ce66c73c1+594&branch=master

-- in this table, you can see 'frockenstein' high on the edge counts

SELECT *
FROM gh.sna_ctr_edgelist_0812
LIMIT 100

-- here you can see 1000 of his commits and note that they all happen at the same second

SELECT *
FROM gh.commits_raw
WHERE login = 'frockenstein'
LIMIT 1000;

-- thus, it shows that that commit history was actually incorporated by others as identified in the
-- '^Merge branch ''master'' (of|into)' comment
-- to correct this we went to the ghtorrent data to find commit_comments
-- we joined the commit_comments to the sha and then filtered out all of the
-- problematic entries from the commits_raw table doing this:

-- version 1 has redundant parts and the regex is too specific

WITH merge_issues AS (
	SELECT id, body,
	-- recodes all of merge branch issues as 1/0
	CASE WHEN body ~ '^Merge branch ''master'' (of|into)'
	THEN 1 ELSE 0 END AS merge_issue
	FROM github_mirror.commit_comments
	-- filters table so it only includes merge branch issues
	WHERE body ~ '^Merge branch ''master'' (of|into)'
	ORDER BY id ASC LIMIT 100
), comment_table AS (
	SELECT A.sha, B.body, B.merge_issue, A.created_at
	FROM github_mirror.commits A
	-- joins the sha to the merge_issues table
	INNER JOIN merge_issues B
	ON A.id = B.id
	WHERE sha IS NOT NULL
	LIMIT 1000
)
SELECT login, slug, body AS commit_msg, additions, deletions, created_at, as_of, sha,
	   -- recodes all the nulls to 0 in the merge_issue column
	   coalesce(merge_issue, 0) as merge_issue
FROM gh.commits_raw A
-- joins commits table with comments table
FULL JOIN comment_table B
ON A.hash = B.sha
LIMIT 1000;

-- version 2: works well after regex changed and we removed the `case when` approach

WITH merge_issues AS (
	SELECT id, body
	FROM github_mirror.commit_comments
	WHERE body ~ '^Merge branch ''.*'' (of|into)'
	ORDER BY id ASC LIMIT 100
), comment_table AS (
	SELECT A.sha, B.body, A.created_at
	FROM github_mirror.commits A
	INNER JOIN merge_issues B
	ON A.id = B.id
	WHERE sha IS NOT NULL
	LIMIT 100
)
SELECT login, slug, body, additions, deletions, created_at, as_of, sha
FROM gh.commits_raw A
LEFT JOIN comment_table B
ON A.hash = B.sha
WHERE body IS NULL -- filters out merge branch issues
LIMIT 100;

-- this did not catch all of the 'frockenstein' errors because there are two hashes
-- (one is the SHA-1 and another is the github API ID, which bayoan mistakenly used)
-- now, we are shifting to the new data since this approach seems untenable




