using AntennaPattern
using CSV
using DataFrames
using Test
using Plots

# File paths
filename = joinpath(dirname(pwd()), "data", "pattern_CP_2.92GHz.txt")
outputfilename = joinpath(dirname(pwd()), "data", "pattern_CP_2.92GHz_processed.csv")

# preprocess data
preprocess_CST_3D_ASCII_file(filename, outputfilename)

# import data
df = CSV.read(outputfilename, DataFrame, header=@STANDARD_CST_3D_PATTERN_COLUMNS, skipto=3)

@testset "1D engine" begin
    @test setBackend1D(:gr) == Plots.GRBackend()
    @test_throws AssertionError setBackend1D(:test)
end

@testset "1D plot testing GR" begin
    setBackend1D(:gr)
    @test_warn "Unrecognized argument: test_arg" polarPattern(:Theta, 50.0, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], test_arg = 5)
    @test typeof(polarPattern(:Theta, 50.0, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], label="CP", legend = :topleft)) == Plots.Plot{Plots.GRBackend}
    @test_throws AssertionError polarPattern(:Theta, -100, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"]) 
    @test_throws AssertionError polarPattern(:Phi, -100, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"]) 
    @test_throws AssertionError polarPattern(:WrongSymbol, 90, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"])
    @test_throws AssertionError polarPattern(:Theta, 0.17, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"]) 
    @test_throws AssertionError polarPattern(:Phi, 0.17, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"]) 
end