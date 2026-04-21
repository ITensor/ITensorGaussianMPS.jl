using Documenter: Documenter, DocMeta, deploydocs, makedocs
using ITensorFormatter: ITensorFormatter
using ITensorGaussianMPS: ITensorGaussianMPS

DocMeta.setdocmeta!(
    ITensorGaussianMPS, :DocTestSetup, :(using ITensorGaussianMPS); recursive = true
)

ITensorFormatter.make_index!(pkgdir(ITensorGaussianMPS))

makedocs(;
    modules = [ITensorGaussianMPS],
    authors = "ITensor developers <support@itensor.org> and contributors",
    sitename = "ITensorGaussianMPS.jl",
    format = Documenter.HTML(;
        canonical = "https://itensor.github.io/ITensorGaussianMPS.jl",
        edit_link = "main",
        assets = ["assets/favicon.ico", "assets/extras.css"]
    ),
    pages = ["Home" => "index.md", "Reference" => "reference.md"]
)

deploydocs(;
    repo = "github.com/ITensor/ITensorGaussianMPS.jl", devbranch = "main",
    push_preview = true
)
