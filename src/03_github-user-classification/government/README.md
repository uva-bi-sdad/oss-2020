README for /src/sectoring/government folder

The overall goal of this folder is threefold:
1. To develop a function that cleans messy government strings and standardize them for joining datasets and classifying government users
2. To create a hierarchical relational dataset where all institutions within the US Gov are available ordered by branch, agency, subagency, etc.
3. Develop an algorithm that classifies all government users into this sector by using self-reported data from GitHub users

01_standardizing_allnames_alldatasets.Rmd 

This file first pulls all of the unique names from six government datasets and tries to find the duplicate orgs with different names. This is the first draft and can generally be skipped over in favor of the other files. 

02_gov-azindex-to-relational.Rmd


