using APattern
using Test
using CSV
using DataFrames
using Plots
using PyCall

# File paths
filename = joinpath(dirname(pwd()), "data", "pattern_CP_2.92GHz.txt")
outputfilename = joinpath(dirname(pwd()), "data", "pattern_CP_2.92GHz_processed.csv")

# preprocess data
preprocess_CST_3D_ASCII_file(filename, outputfilename)

# import data
df = CSV.read(outputfilename, DataFrame, header=@STANDARD_CST_3D_PATTERN_COLUMNS, skipto=3)

# data processing
x, y, z, r_norm = sph2cartData(df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], 15, true)

@testset "Data processing" begin
    @test size(x) == size(y) == size(z) == size(r_norm) == (37, 73)
end

@testset "PlotlyJS" begin
    set_engine(:plotlyjs)
    @test_throws AssertionError set_engine(:test)
    @test backend() == Plots.PlotlyJSBackend()
    @test_warn "Unrecognized argument: test_arg" antenna_pattern_3D(x, y, z, r_norm, show_grid=false, show_axis=false, width=500, height=500, title="test_3D.jl ", test_arg=1)
    @test typeof(antenna_pattern_3D(x, y, z, r_norm)) == Plots.Plot{Plots.PlotlyJSBackend}
end

@testset "PyPlot" begin
    set_engine(:pyplot)
    @test backend() == Plots.PyPlotBackend()
    @test typeof(antenna_pattern_3D(x, y, z, r_norm)) == Plots.Plot{Plots.PyPlotBackend}
end
