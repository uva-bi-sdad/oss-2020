using Cascadia: parsehtml, Selector, nodeText
using DataFrames
using LibPQ: Connection, load!, execute

const sel_tr = Selector("body > table > tbody > tr")

"""
    cran_packages()::Vector{String}

Downloads the list of all available packages in CRAN.
"""
function cran_packages()
    download("https://cran.r-project.org/web/packages/available_packages_by_name.html",
             joinpath("data", "oss", "original", "cran", "all_pkgs.html"))
    html = parsehtml(String(read(joinpath("data", "oss", "original", "cran", "all_pkgs.html"))))
    s = Selector("body > table > tbody > tr > td > a")
    nodeText.(eachmatch(s, html.root))
end

# Get all the package names
cran_pkgs = cran_packages()

# Download the HTML files with the metadata
for pkg in cran_pkgs
    path = joinpath("data", "oss", "original", "cran", "index", "$pkg.html")
    isfile(path) || download("https://cran.r-project.org/web/packages/$pkg/index.html", path)
end

output = DataFrame([String, Union{Missing,String}, Union{Missing,String}], [:pkg, :maintainer, :email], 0)

for pkg in cran_pkgs
    html = parsehtml(String(read(joinpath("data", "oss", "original", "cran", "index", "$pkg.html"))))
    tbl_rows = eachmatch(sel_tr, html.root)
    pos = findfirst(elem -> nodeText(elem[1]) == "Maintainer:", tbl_rows)
    name_email = nodeText(tbl_rows[pos][2])
    if name_email ≠ "ORPHANED"
        name, email = split(name_email, '<')
        name = strip(name)
        email = replace(email, " at " => '@')
        email = replace(email, r"( |>)" => "")
    else
        name = missing
        email = missing
    end
    push!(output, (pkg = pkg, maintainer = name, email = email))
end
unique!(output)

conn = Connection("dbname = sdad")
execute(conn, "BEGIN;")
load!(output, conn, "INSERT INTO cran.cran_maintainers VALUES(\$1, \$2, \$3);")
execute(conn, "COMMIT;")
close(conn)
