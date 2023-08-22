using APattern
using Test
using CSV
using DataFrames
using Plots

# File paths
filename = joinpath(pwd(), "data", "pattern_CP_2.92GHz.txt")
outputfilename = joinpath(pwd(), "data", "pattern_CP_2.92GHz_processed.csv")

# preprocess data
preprocess_CST_3D_ASCII_file(filename, outputfilename)

# import data
df = CSV.read(outputfilename, DataFrame, header=@STANDARD_CST_3D_PATTERN_COLUMNS, skipto=3)

# data processing
x, y, z, r_norm = sph2cartData(df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], 15, true)

# Engine
set_engine(:pyplot)
# Plot
p = antenna_pattern_3D(x, y, z, r_norm)