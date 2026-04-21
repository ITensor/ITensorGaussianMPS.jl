# # ITensorGaussianMPS.jl
#
# [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://itensor.github.io/ITensorGaussianMPS.jl/stable/)
# [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://itensor.github.io/ITensorGaussianMPS.jl/dev/)
# [![Build Status](https://github.com/ITensor/ITensorGaussianMPS.jl/actions/workflows/Tests.yml/badge.svg?branch=main)](https://github.com/ITensor/ITensorGaussianMPS.jl/actions/workflows/Tests.yml?query=branch%3Amain)
# [![Coverage](https://codecov.io/gh/ITensor/ITensorGaussianMPS.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/ITensor/ITensorGaussianMPS.jl)
# [![Code Style](https://img.shields.io/badge/code_style-ITensor-purple)](https://github.com/ITensor/ITensorFormatter.jl)
# [![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
#
# |**Citation**                                                                     |**Open-access preprint**                               |
# |:-------------------------------------------------------------------------------:|:-----------------------------------------------------:|
# | [![DOI](http://img.shields.io/badge/PRB-10.1103/PhysRevB.92.075132-B31B1B.svg)](https://doi.org/10.1103/PhysRevB.92.075132) | [![arXiv](https://img.shields.io/badge/arXiv-1504.07701-b31b1b.svg)](https://arxiv.org/abs/1504.07701) |
#
# A package for creating the matrix product state of a free fermion (Gaussian) state.

# ## Support
#
# {CCQ_LOGO}
#
# ITensorGaussianMPS.jl is supported by the Flatiron Institute, a division of the Simons Foundation.

# ## Installation instructions

# This package resides in the `ITensor/ITensorRegistry` local registry.
# In order to install, simply add that registry through your package manager.
# This step is only required once.
#=
```julia
julia> using Pkg: Pkg

julia> Pkg.Registry.add(url = "https://github.com/ITensor/ITensorRegistry")
```
=#
# or:
#=
```julia
julia> Pkg.Registry.add(url = "git@github.com:ITensor/ITensorRegistry.git")
```
=#
# if you want to use SSH credentials, which can make it so you don't have to enter your Github ursername and password when registering packages.

# Then, the package can be added as usual through the package manager:

#=
```julia
julia> Pkg.add("ITensorGaussianMPS")
```
=#

# ## Examples

# `ITensorGaussianMPS.jl` can help create starting states for DMRG. For example:

using ITensorGaussianMPS: slater_determinant_to_mps
using ITensorMPS: MPO, OpSum, dmrg, inner, random_mps, siteinds
using LinearAlgebra: Hermitian, diagm, eigen

## Half filling
N = 20
Nf = N ÷ 2

@show N, Nf

## Hopping
t = 1.0

## Free fermion hopping Hamiltonian
h = Hermitian(diagm(1 => fill(-t, N - 1), -1 => fill(-t, N - 1)))
_, u = eigen(h)

## Get the Slater determinant
Φ = u[:, 1:Nf]

## Create an mps for the free fermion ground state
s = siteinds("Fermion", N; conserve_qns = true)
ψ0 = slater_determinant_to_mps(s, Φ; maxblocksize = 4)

## Make an interacting Hamiltonian
U = 1.0
@show U

os = OpSum()
for b in 1:(N - 1)
    os .+= -t, "Cdag", b, "C", b + 1
    os .+= -t, "Cdag", b + 1, "C", b
end
for b in 1:N
    os .+= U, "Cdag * C", b
end
H = MPO(os, s)

println("\nFree fermion starting energy")
@show inner(ψ0', H, ψ0)

## Random starting state
ψr = random_mps(s, n -> n ≤ Nf ? "1" : "0")

println("\nRandom state starting energy")
@show inner(ψr', H, ψr)

println("\nRun dmrg with random starting state")
dmrg(H, ψr; nsweeps = 10, maxdim = [10, 20, 40, 60], cutoff = 1.0e-12)

println("\nRun dmrg with free fermion starting state")
dmrg(H, ψ0; nsweeps = 4, maxdim = 60, cutoff = 1.0e-12)

# This will output something like:
#=
```
(N, Nf) = (20, 10)
U = 1.0

Free fermion starting energy
inner(ψ0', H, ψ0) = -2.3812770621299357

Random state starting energy
inner(ψr', H, ψr) = 10.0

Run dmrg with random starting state
After sweep 1 energy=6.261701784151 maxlinkdim=2 time=0.041
After sweep 2 energy=2.844954346204 maxlinkdim=5 time=0.056
After sweep 3 energy=0.245282430911 maxlinkdim=14 time=0.071
After sweep 4 energy=-1.439072132586 maxlinkdim=32 time=0.098
After sweep 5 energy=-2.220202191945 maxlinkdim=59 time=0.148
After sweep 6 energy=-2.376787647893 maxlinkdim=60 time=0.186
After sweep 7 energy=-2.381484153892 maxlinkdim=60 time=0.167
After sweep 8 energy=-2.381489999291 maxlinkdim=57 time=0.233
After sweep 9 energy=-2.381489999595 maxlinkdim=49 time=0.175
After sweep 10 energy=-2.381489999595 maxlinkdim=49 time=0.172

Run dmrg with free fermion starting state
After sweep 1 energy=-2.381489929965 maxlinkdim=49 time=0.139
After sweep 2 energy=-2.381489999588 maxlinkdim=49 time=0.165
After sweep 3 energy=-2.381489999594 maxlinkdim=48 time=0.161
After sweep 4 energy=-2.381489999594 maxlinkdim=48 time=0.169
```
=#
