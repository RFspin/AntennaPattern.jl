using APattern
using Test

println("Test suite started...")

@testset "APattern.jl" begin
    # Write your tests here.
    include("test_tranformations.jl")
end
