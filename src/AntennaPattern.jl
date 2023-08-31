module AntennaPattern

using CSV, DataFrames, Plots, LinearAlgebra, PyCall

# Imports
include("transformations.jl")
include("parser.jl")
include("3D.jl")
include("backend.jl")
include("1D.jl")

# Exports
export cart2sph, sph2cart
export @STANDARD_CST_3D_PATTERN_COLUMNS, preprocess_CST_3D_ASCII_file
export createSurface, cartesianPattern, antennaPattern3D
export setBackend3D, setBackend1D
export polarPattern

end
