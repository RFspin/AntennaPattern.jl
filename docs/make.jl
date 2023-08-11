using APattern
using Documenter

DocMeta.setdocmeta!(APattern, :DocTestSetup, :(using APattern); recursive=true)

makedocs(;
    modules=[APattern],
    authors="bosakRFSpin <bosak@rfspin.com> and contributors",
    repo="https://github.com/Public/APattern.jl/blob/{commit}{path}#{line}",
    sitename="APattern.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Public.github.io/APattern.jl",
        edit_link="dev",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Public/APattern.jl",
    devbranch="dev",
)
