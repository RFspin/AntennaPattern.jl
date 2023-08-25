"""
Welcome to AntennaPattern.jl by RFspin
Feel free to fork this repo. and do your magic!
By antenna masters for antenna masters!

In this file you will find an example usage of the package for 3D plotting and manipulation. Be aware that this is a blazing hot development. If you are missing a feature or find an issue post it on Github or contact me @bosakRFSpin.
"""
##
using AntennaPattern
using CSV
using DataFrames
using Plots

# File paths - this setting points to the example data of a circular patch antenna at 2.29 GHz
# The data come from a CST simulation in ASCII format
filename = joinpath(pwd(), "data", "pattern_CP_2.92GHz.txt")
outputfilename = joinpath(pwd(), "data", "pattern_CP_2.92GHz_processed.csv")
# The logic here is to preprocess the data once and then use the processed data for plotting
# Preprocessing is done by the function preprocess_CST_3D_ASCII_file
# The processed data are saved in a CSV file
# The CSV file is then imported as a DataFrame
# The DataFrame is then used for plotting
preprocess_CST_3D_ASCII_file(filename, outputfilename)
df = CSV.read(outputfilename, DataFrame, header=@STANDARD_CST_3D_PATTERN_COLUMNS, skipto=3)
# Once the data are imported, they are processed by the function sph2cartData
# The function sph2cartData returns the data in the Cartesian coordinate system and as surfaces
x, y, z, r_norm = sph2cartData(df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"], 15, true)

## PyPlot backend
# Run the set_engine function to set the plotting engine
# In Plots.jl the default plotting engine is GR
# The available engines are :plotlyjs and :pyplot
set_engine(:pyplot)
# Plot the data
p = antenna_pattern_3D(x, y, z, r_norm)

## PlotlyJS backend
# The following code cell shows how to generate a 3D surface plot using PlotlyJS backend with Plots.jl.
# Run the set_engine function to set the plotting engine
# In Plots.jl the default plotting engine is GR
# The available engines are :plotlyjs and :pyplot
set_engine(:plotlyjs)
# Plot the data
p = antenna_pattern_3D(x, y, z, r_norm)