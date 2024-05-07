using ITensorGaussianMPS
using Documenter

DocMeta.setdocmeta!(
    ITensorGaussianMPS, :DocTestSetup, :(using ITensorGaussianMPS); recursive=true
)

makedocs(;
    modules=[ITensorGaussianMPS],
    authors="ITensor developers",
    sitename="ITensorGaussianMPS.jl",
    format=Documenter.HTML(;
        canonical="https://ITensor.github.io/ITensorGaussianMPS.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/ITensor/ITensorGaussianMPS.jl", devbranch="main")
