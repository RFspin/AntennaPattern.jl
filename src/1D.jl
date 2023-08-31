using Plots

"""
# Defaut values for the 1D antenna pattern plot
"""
const DEFAULTS_1D = Dict(
    :width => 600, 
    :height => 500,
    :label => "Antenna Pattern",
    :legend => true,
    :line_width => 3.0,
    :color => :red,
    :title => "Antenna Pattern",
    :mainlobe => true,
    :mainlobe_color => :blue,
    :mainlobe_linewidth => 1.5,
    :mainlobe_label => "Main lobe",
    :rotation => 0.0
)

"""
# polarPattern
Polar plot of an antenna pattern.

## Arguments
- `Constant::Symbol`: The constant angle to plot the antenna pattern at. Must be either `:Theta` or `:Phi`.
- `CutAngle::Real`: The angle at which to plot the antenna pattern. Must be between 0 and 360.
- `θ::Union{Vector{Real}, Vector{Float64}}`: The θ values of the antenna pattern (degrees).
- `φ::Union{Vector{Real}, Vector{Float64}}`: The φ values of the antenna pattern (degrees).
- `data::Union{Vector{Real}, Vector{Float64}}`: The data values of the antenna pattern.
- `repeatFirst::Bool`: Whether to repeat the first value of the antenna pattern at the end. Defaults to `true`.
- `kwargs...`: Keyword arguments to pass to the plot function.

## `kwargs`
- `width::Int`: The width of the plot. Defaults to 600.
- `height::Int`: The height of the plot. Defaults to 500.
- `label::String`: The label of the plot. Defaults to "Antenna Pattern".
- `legend::Bool`: Whether to show the legend. Defaults to `true`.
- `line_width::Float64`: The width of the line. Defaults to 3.0.
- `color::Symbol`: The color of the line. Defaults to `:red`.
- `title::String`: The title of the plot. Defaults to "Antenna Pattern".
- `mainlobe::Bool`: Whether to show the main lobe. Defaults to `true`.
- `mainlobe_color::Symbol`: The color of the main lobe. Defaults to `:blue`.
- `mainlobe_linewidth::Float64`: The width of the main lobe line. Defaults to 1.5.
- `mainlobe_label::String`: The label of the main lobe. Defaults to "Main lobe".
- `rotation::Float64`: The rotation of the plot in degrees. Defaults to 0.0.

## Returns
- `p::Plot`: The plot object.

"""
function polarPattern(Constant::Symbol, CutAngle::Real, θ::Union{Vector{Real}, Vector{Float64}}, φ::Union{Vector{Real}, Vector{Float64}}, data::Union{Vector{Real}, Vector{Float64}}; repeatFirst::Bool = true, kwargs...)
    @assert Constant in [:Theta, :Phi] "Constant must be either :Theta or :Phi"
    @assert CutAngle >= 0 && CutAngle <= 360 "CutAngle must be between 0 and 360"
    @assert backend() in [Plots.GRBackend()] "Backend not supported"

    if Constant == :Theta
        @assert CutAngle in θ "Desired angle is not in the data"
        indicies = θ .== CutAngle
        angles = deg2rad.(φ[indicies])
        values = data[indicies]
        
    elseif Constant == :Phi
        @assert CutAngle in φ "Desired angle is not in the data" 
        indicies = φ .== CutAngle
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

    if attributes[:rotation] != 0.0
        angles = angles .+ deg2rad(attributes[:rotation])
    end

    # Set the default size
    default(size=(attributes[:width], attributes[:height]))

    # Set the default limits
    minl = floor(minimum(values))
    maxl = ceil(maximum(values))

    p = plot(
        angles, 
        values, 
        proj = :polar,
        lims = :round,
        legend =  attributes[:legend],
        label = attributes[:label],
        linewidth = attributes[:line_width],
        color = attributes[:color],
        title = attributes[:title], 
        xtick = (collect(0:π/4:7π/4), ["0°", "45°", "90°", "135°", "180°", "225°", "270°", "315°"]),
    )

    if attributes[:mainlobe]
        plot!(
            [0, angles[findmax(values)[2]]], [minl, maxl], proj = :polar,
            linecolor=attributes[:mainlobe_color], label=attributes[:mainlobe_label],
            linewidth=attributes[:mainlobe_linewidth]
        )
    end
    
    println("Main lobe magnitude: ", findmax(values)[1], " dB")
    println("Main lobe direction: ", rad2deg(angles[findmax(values)[2]]), "°")
    return p

end