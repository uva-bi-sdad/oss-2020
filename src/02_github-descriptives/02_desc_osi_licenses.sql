---First, we need to take all of the OSI-approved licenses from the gh.licenses table and make a new table with only the osi_licenses.
---Bayoan has also add a new process of automating this table to find out when new licenses are approved (see GHOSS.jl)

CREATE MATERIALIZED VIEW gh.desc_osi_licenses AS (
SELECT name, spdx FROM gh.licenses WHERE
spdx = '0BSD' OR spdx = 'AFL-3.0' OR spdx = 'AGPL-3.0' OR spdx = 'Apache-2.0' OR spdx = 'Artistic-2.0' OR
spdx = 'BSD-2-Clause' OR spdx = 'BSD-3-Clause' OR spdx = 'BSL-1.0' OR spdx = 'CECILL-2.1' OR spdx = 'ECL-2.0' OR
spdx = 'EPL-1.0' OR spdx = 'EPL-2.0' OR spdx = 'EUPL-1.2' OR spdx = 'GPL-2.0' OR spdx = 'GPL-3.0' OR
spdx = 'ISC' OR spdx = 'LGPL-2.1' OR spdx = 'LGPL-3.0' OR spdx = 'LPPL-1.3c' OR spdx = 'MIT' OR
spdx = 'MPL-2.0' OR spdx = 'MS-PL' OR spdx = 'MS-RL' OR spdx = 'NCSA' OR spdx = 'OFL-1.1' OR
spdx = 'OSL-3.0' OR spdx = 'PostgreSQL' OR spdx = 'UPL-1.0' OR spdx = 'Zlib'
);
