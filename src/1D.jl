using Plots

const DEFAULTS_1D = Dict(
    :width => 600, 
    :height => 500,
    :label => "Antenna Pattern",
    :legend => true,
    :line_width => 3.0,
    :color => :red
)


function antenna_pattern_polar(Constant::Symbol, CutAngle::Real, θ::Union{Vector{Real}, Vector{Float64}}, φ::Union{Vector{Real}, Vector{Float64}}, data::Union{Vector{Real}, Vector{Float64}}; repeatFirst::Bool = true, kwargs...)
    @assert Constant in [:Theta, :Phi] "Constant must be either :Theta or :Phi"
    @assert CutAngle >= 0 && CutAngle <= 360 "CutAngle must be between 0 and 360"

    if Constant == :Theta
        @assert CutAngle in θ "Desired angle is not in the data"
        indicies = θ .≈ CutAngle
        angles = deg2rad.(φ[indicies])
        values = data[indicies]
        
    elseif Constant == :Phi
        @assert CutAngle in φ "Desired angle is not in the data" 
        indicies = φ .≈ CutAngle
        angles = deg2rad.(θ[indicies])
        values = data[indicies]
    end

    if repeatFirst
        angles = vcat(angles, angles[1])
        values = vcat(values, values[1])
    end

    # Merge the user-provided kwargs with the default values
    attributes = merge(DEFAULTS_1D, Dict(kwargs))

    # Optional: Check for unrecognized arguments
    for key in keys(attributes)
        if !haskey(DEFAULTS_1D, key)
            @warn "Unrecognized argument: $key"
        end
    end

    # Set the default size
    default(size=(attributes[:width], attributes[:height]))

    # Set the default limits
    minl = floor(minimum(values))
    maxl = ceil(maximum(values))

    if backend() == Plots.GRBackend()
        p = plot(
            angles, 
            values, 
            proj = :polar, 
            lims = :round,
            legend = attributes[:legend],
            label = attributes[:label],
            linewidth = attributes[:line_width],
            color = attributes[:color],
        )

    elseif backend() == Plots.PyPlotBackend()
        p = plot(
            angles, 
            values, 
            proj = :polar,
            legend =  attributes[:legend],
            label = attributes[:label],
            linewidth = attributes[:line_width],
            color = attributes[:color],
            lims = :round
        )
        
        # main lobe
        
    else
        error("Backend not supported")
    end

    plot!([0, angles[findmax(values)[2]]], [minl, maxl], proj = :polar, linecolor=:blue, label="Main lobe")
    println("Main lobe magnitude: ", findmax(values)[1], " dB")
    println("Main lobe direction: ", rad2deg(angles[findmax(values)[2]]), "°")
    return p

end