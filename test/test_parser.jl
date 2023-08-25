using Test
using AntennaPattern
using CSV
using DataFrames

# File paths
filename = joinpath(dirname(pwd()), "data", "pattern_CP_2.92GHz.txt")
outputfilename = joinpath(dirname(pwd()), "data", "pattern_CP_2.92GHz_processed.csv")

# preprocess data
preprocess_CST_3D_ASCII_file(filename, outputfilename)

# import data
df = CSV.read(outputfilename, DataFrame, header=@STANDARD_CST_3D_PATTERN_COLUMNS, skipto=3)


# Test preprocessing
@testset "Data processing and import" begin
    @test size(df) == (2664, 8)
    @test all(all.(x -> x isa Float64, eachcol(df)))
    @test !all(any.(ismissing, eachcol(df)))
end
