  
push!(LOAD_PATH, joinpath("..", "src"))

using Documenter, SPDXQueries

DocMeta.setdocmeta!(SPDXQueries,
                    :DocTestSetup,
                    :(using SPDXQueries),
                    recursive = true)

makedocs(sitename = "OSS-2020",
         modules = [SPDXQueries],
         pages = [
             "Home" => "index.md",
             "SPDXQueries" => "spdx-queries.md"
         ]
)

deploydocs(
    repo   = "github.com/uva-bi-sdad/OSS-2020.jl.git",
    push_preview = true
)
