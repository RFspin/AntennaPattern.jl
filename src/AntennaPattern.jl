module AntennaPattern

using CSV, DataFrames

# Imports
include("transformations.jl")
include("parser.jl")
include("3D.jl")

# Exports
export cart2sph, sph2cart
export @STANDARD_CST_3D_PATTERN_COLUMNS, preprocess_CST_3D_ASCII_file
export sph2cartData, set_engine, antenna_pattern_3D
end
