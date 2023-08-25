using AntennaPattern
using Documenter

DocMeta.setdocmeta!(AntennaPattern, :DocTestSetup, :(using AntennaPattern); recursive=true)

makedocs(;
    modules=[AntennaPattern],
    authors="bosakRFSpin <bosak@rfspin.com> and contributors",
    repo="https://github.com/RFspin/AntennaPattern.jl/blob/{commit}{path}#{line}",
    sitename="AntennaPattern.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://RFspin.github.io/AntennaPattern.jl",
        edit_link="dev",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/RFspin/AntennaPattern.jl",
    devbranch="dev",
)
