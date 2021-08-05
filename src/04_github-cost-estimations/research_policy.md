
## *Research Policy* Notes

This document summarizes where all of the code for figures and statistics are for the *Research Policy* paper.

### Introduction - Related Work

All of these figures are adapted from past work or created by Bayoan, Carol and Gizem.

### Data Section 

All of the analyses for this paper were originally based on the 2009-2009 data scraped data (`gh.commits_raw`). 
However, after examining these date, we found duplicates entered the data during the original scraping procedure,
which we then removed (`gh.commits_dd`). In turn, we also identified that commit histories were being duplicated 
when users cloned repos locally and then pushed those back to different repositories. We refer to this refinement 
as the removing "legacy" commits or as keeping the "longest chain" of commits (`gh.commits_dd_nmrc_jbsc`). This 
refinement process and its implications is detailed in this [Google doc](https://docs.google.com/document/d/1L9HEeY1V-jeGwGdyBx41eKjx2oH94dWkYGqfdczZUkY/edit).

The code for the descriptives used in the paper are here: 
`oss-2020/src/04_github-cost-estimates/01_cost-descriptives/`

The code for creating the summary tables before the cost calcs are here: 
`oss-2020/src/04_github-cost-estimates/03_cost-calculations/`

The code for calculating the actual costs are here: 
`oss-2020/src/04_github-cost-estimates/03_cost-calculations/`



















