using Documenter
push!(LOAD_PATH, "../src/")
using OdysseusEngine

DocMeta.setdocmeta!(OdysseusEngine, :DocTestSetup, :(using OdysseusEngine); recursive=true)

makedocs(
    sitename="OdysseusEngine Documentation",
    modules = [OdysseusEngine],
    pages = [
        "OdysseusEngine" => "index.md",
        "API" => "api.md"
    ],
    format = Documenter.HTML(
        assets = ["assets/favicon.ico"],
    )
)

deploydocs(
    repo = "github.com/OmegaLambda1998/OdysseusEngine.jl.git"
)
