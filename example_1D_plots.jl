using AntennaPattern
using CSV
using DataFrames
using Test
using Plots

# File paths
filename = joinpath(pwd(), "data", "pattern_CP_2.92GHz.txt")
outputfilename = joinpath(pwd(), "data", "pattern_CP_2.92GHz_processed.csv")

# preprocess data
preprocess_CST_3D_ASCII_file(filename, outputfilename)

# import data
df = CSV.read(outputfilename, DataFrame, header=@STANDARD_CST_3D_PATTERN_COLUMNS, skipto=3)

## Plotting data with GR backend
setBackend1D(:gr)
p = polarPattern(:Theta, 0.0, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], label="CP", legend = :topleft, rotation = 0)
## Saving data
formats = [".png", ".svg", ".pdf", ".html"]
for format in formats
    Plots.savefig(p, "./export/gr/test$format") #replace with your path
end

## Animation
# Some sample animations you can do
anim = @animate for i in 0:360
    polarPattern(:Theta, 85, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], label="CP", legend = :topleft, rotation = i)
end

gif(anim, "CP.gif", fps = 30)