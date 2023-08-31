using AntennaPattern
using Test
using CSV
using DataFrames
using Plots
using PyCall

# File paths
filename = joinpath(pwd(), "data", "pattern_CP_2.92GHz.txt")
outputfilename = joinpath(pwd(), "data", "pattern_CP_2.92GHz_processed.csv")

# preprocess data
preprocess_CST_3D_ASCII_file(filename, outputfilename)

# import data
df = CSV.read(outputfilename, DataFrame, header=@STANDARD_CST_3D_PATTERN_COLUMNS, skipto=3)

@testset "Creating surface" begin
    # creating surface 
    θ1, φ1, r1 = createSurface(df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], repeatFirstφ=true, θf = :deg, φf = :deg)
    θ2, φ2, r2 = createSurface(deg2rad.(df[!, "θ[deg.]"]), deg2rad.(df[!, "φ[deg.]"]), df[!, "|Dir.|[dBi]"], repeatFirstφ=true)
    θ3, φ3, r3 = createSurface(df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], repeatFirstφ=false, θf = :deg, φf = :deg)
    θ4, φ4, r4 = createSurface(deg2rad.(df[!, "θ[deg.]"]), deg2rad.(df[!, "φ[deg.]"]), df[!, "|Dir.|[dBi]"], repeatFirstφ=false)
    @test_throws AssertionError createSurface(df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], θf = :test)
    @test_throws AssertionError createSurface(df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], φf = :test)
    @test_throws AssertionError createSurface(df[!, "θ[deg.]"], df[!, "φ[deg.]"], zeros(5, 5))
    @test size(θ1) == size(φ1) == size(r1) == (37, 73)
    @test size(θ2) == size(φ2) == size(r2) == (37, 73)
    @test size(θ3) == size(φ3) == size(r3) == (37, 72)
    @test size(θ4) == size(φ4) == size(r4) == (37, 72)
    @test θ1 == θ2
    @test φ1 == φ2
    @test r1 == r2
    @test θ3 == θ4
    @test φ3 == φ4
    @test r3 == r4
end

@testset "Testing cartesian pattern" begin
    x, y, z, r_norm = cartesianPattern(θ1, φ1, r1, -15)
    @test size(x) == size(y) == size(z) == size(r_norm) == (37, 73)
    @test_throws AssertionError cartesianPattern(θ1, φ1, r1, 15)
    @test_throws AssertionError cartesianPattern(zeros(5, 5), φ1, r1)
end

@testset "PlotlyJS" begin
    set_engine_3D(:plotlyjs)
    @test_throws AssertionError set_engine_3D(:test)
    @test backend() == Plots.PlotlyJSBackend()
    @test_warn "Unrecognized argument: test_arg" antennaPattern3D(x, y, z, r_norm, show_grid=false, show_axis=false, width=500, height=500, title="test_3D.jl ", test_arg=1)
    @test typeof(antennaPattern3D(x, y, z, r_norm)) == Plots.Plot{Plots.PlotlyJSBackend}
end

@testset "PyPlot" begin
    set_engine_3D(:pyplot)
    @test backend() == Plots.PyPlotBackend()
    @test typeof(antennaPattern3D(x, y, z, r_norm)) == Plots.Plot{Plots.PyPlotBackend}
end
