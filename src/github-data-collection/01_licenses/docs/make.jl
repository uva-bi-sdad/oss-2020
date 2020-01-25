  
push!(LOAD_PATH, joinpath("..", "src"))

using Documenter, Licenses

DocMeta.setdocmeta!(Licenses,
                    :DocTestSetup,
                    :(using Licenses),
                    recursive = true)

makedocs(sitename = "OSS-2020",
         modules = [Licenses],
         pages = [
             "Home" => "index.md",
             "Licenses" => "licences.md"
         ]
)

deploydocs(
    repo   = "github.com/uva-bi-sdad/OSS-2020.jl.git",
    push_preview = true
)
