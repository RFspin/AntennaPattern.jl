using Plots
using AntennaPattern
using CSV
using DataFrames
using PyCall

# File paths
filename = joinpath(pwd(), "data", "pattern_CP_2.92GHz.txt")
outputfilename = joinpath(pwd(), "data", "pattern_CP_2.92GHz_processed.csv")

# preprocess data
preprocess_CST_3D_ASCII_file(filename, outputfilename)

# import data
df = CSV.read(outputfilename, DataFrame, header=@STANDARD_CST_3D_PATTERN_COLUMNS, skipto=3)


function antenna_pattern_polar(Constant::Symbol, CutAngle::Real, θ::Union{Vector{Real}, Vector{Float64}}, φ::Union{Vector{Real}, Vector{Float64}}, data::Union{Vector{Real}, Vector{Float64}}; repeatFirst::Bool = true, kwargs...)
    @assert Constant in [:Theta, :Phi] "Constant must be either :Theta or :Phi"
    @assert CutAngle >= 0 && CutAngle <= 360 "CutAngle must be between 0 and 360"

    if Constant == :Theta
        @assert CutAngle in θ "Desired angle is not in the data"
        indicies = θ .≈ CutAngle
        angles = φ[indicies]
        values = data[indicies]
        
    elseif Constant == :Phi
        @assert CutAngle in φ "Desired angle is not in the data" 
        indicies = φ .≈ CutAngle
        angles = θ[indicies]
        values = data[indicies]
    end

    if repeatFirst
        angles = vcat(angles, angles[1])
        values = vcat(values, values[1])
    end


    minl = floor(minimum(values) / 10) * 10
    maxl = ceil(maximum(values) / 10) * 10

    if backend() == Plots.GRBackend()
        println(values)
        p = plot(
            deg2rad.(angles), 
            values, 
            proj = :polar, 
            lims = (minl, maxl),
            legend = false,
        )

    elseif backend() == Plots.PlotlyJSBackend()
        println(angles)
        println(values)
        p = plot(
            deg2rad.(angles), 
            values, 
            proj = :polar,
            legend = false,
        )
        # this is a workaround to set the limits of the polar plot
        # I did not manage to find a better way
        plot!([0, 0], [minl, maxl], proj = :polar, linecolor=:white)
    else
        error("Backend not supported")
    end

    return p

end

set_engine_1D(:plotlyjs)
antenna_pattern_polar(:Theta, 90.0, df[!, "θ[deg.]"], df[!, "φ[deg.]"], df[!, "|Dir.|[dBi]"])