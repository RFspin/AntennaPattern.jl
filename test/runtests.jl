using AntennaPattern
using Test

println("Test suite started...")

# Write your tests here.
include("test_tranformations.jl")
include("test_parser.jl")
include("test_3D.jl")
include("test_1D.jl")
