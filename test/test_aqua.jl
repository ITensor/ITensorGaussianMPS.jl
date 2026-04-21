using Aqua: Aqua
using ITensorGaussianMPS: ITensorGaussianMPS
using Test: @testset

@testset "Code quality (Aqua.jl)" begin
    # ITensorGaussianMPS extends ITensors.ITensor and ITensorMPS.MPS constructors
    # with LinearAlgebra.Givens / Circuit by design (piracies).
    # The Circuit type's `*` method has outstanding ambiguities with FillArrays /
    # LinearAlgebra.Adjoint/Transpose that should be addressed separately.
    Aqua.test_all(ITensorGaussianMPS; piracies = false, ambiguities = false)
end
