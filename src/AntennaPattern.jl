module AntennaPattern

using CSV, DataFrames, Plots, LinearAlgebra, PyCall

# Imports
include("transformations.jl")
include("parser.jl")
include("3D.jl")
include("backend.jl")

# Exports
export cart2sph, sph2cart
export @STANDARD_CST_3D_PATTERN_COLUMNS, preprocess_CST_3D_ASCII_file
export sph2cartData, antenna_pattern_3D
export set_engine_3D, set_engine_1D

end
