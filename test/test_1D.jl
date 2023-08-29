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
    @test set_engine_1D(:pyplot) == Plots.PlotlyJSBackend()
    @test set_engine_1D(:gr) == Plots.GRBackend()
    @test_throws AssertionError set_engine_1D(:test)
end

@testset "1D plot testing GR" begin
    set_engine_1D(:gr)
    @test_warn "Unrecognized argument: test_arg" antenna_pattern_polar(:Theta, 50.0, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], test_arg = 5)
    @test typeof(antenna_pattern_polar(:Theta, 50.0, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], label="CP", legend = :topleft)) == Plots.Plot{Plots.GRBackend}
    @test_throws AssertionError antenna_pattern_polar(:Theta, -100, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"]) 
    @test_throws AssertionError antenna_pattern_polar(:Phi, -100, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"]) 
    @test_throws AssertionError antenna_pattern_polar(:WrongSymbol, 90, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"])
    @test_throws AssertionError antenna_pattern_polar(:Theta, 0.17, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"]) 
    @test_throws AssertionError antenna_pattern_polar(:Phi, 0.17, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"]) 
end

@testset "1D plot testing pyplot" begin
    set_engine_1D(:pyplot)
    @test typeof(antenna_pattern_polar(:Theta, 50.0, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], label="CP", legend = :topleft)) == Plots.Plot{Plots.PlotlyJSBackend}
end