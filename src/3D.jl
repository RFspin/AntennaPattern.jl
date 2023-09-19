using Plots
using LinearAlgebra
using PyCall

const DEFAULTS = Dict(
    :width => 800, 
    :height => 800, 
    :xlabel => "X", 
    :ylabel => "Y", 
    :zlabel => "Z",
    :title => "3D Antenna Pattern",
    :show_grid => false,
    :show_axis => false,
    :legend => true,
    :color_scale_plotly => "Magma",
    :color_scale_pyplot => :magma,
    :aaxis_show => true,
    :aaxis_theta => 90.0,
    :aaxis_phi => 0.0,
    :aaxis_color => :blue,
    :aaxis_linewidth => 3.0,
    :aaxis_linestyle => :auto,
    :aaxis_label => "",
    :aaxis_axis_multiplier => 1.3,
    :python_interactive => true,
)

"""
# createSurface
Creates a surface from the given data.

## Args:
- `θ::Union{Vector{Real}, Vector{Float64}}`: θ coordinate in radians
- `φ::Union{Vector{Real}, Vector{Float64}}`: φ coordinate in radians
- `data::Union{Vector{Float64}, Vector{Real}, Matrix{Real}, Matrix{Float64}}`: data
- `repeatFirstφ::Bool`: repeat first φ value at the end, default: `false`
- `θf::Symbol`: θ format, default: `:rad`
- `φf::Symbol`: φ format, default: `:rad`

## Possible combinations of θ, φ and data:
- `θ::Vector, φ::Vector, data::Vector` - data must be of size (θn*φn)
- `θ::Vector, φ::Vector, data::Matrix` - data must be of size (θn, φn)

## Returns:
- `θr`: θ coordinate in radians, [N x M]
- `φr`: φ coordinate in radians, [N x M]
- `r`: r, [N x M]

"""
function createSurface(θ::Union{Vector{Real}, Vector{Float64}}, φ::Union{Vector{Real}, Vector{Float64}}, data::Union{Vector{Float64}, Vector{Real}, Matrix{Real}, Matrix{Float64}}; repeatFirstφ::Bool = false, θf::Symbol = :rad, φf::Symbol = :rad)
    
    θr = copy(θ)
    φr = copy(φ)
    r = copy(data)
    θn = length(unique(θr))
    φn = length(unique(φr))
    
    @assert θf == :deg || θf == :rad "θf must be either :deg or :rad"
    @assert φf == :deg || φf == :rad "φf must be either :deg or :rad"
    θr = θf == :deg ? deg2rad.(θr) : θr
    φr = φf == :deg ? deg2rad.(φr) : φr
    
    if typeof(data) == Vector{Real} || typeof(data) == Vector{Float64}
        @assert size(r) == size(θr) == size(φr) "data, θ and φ must be of the same size"
        # Reshape arrays
        θr = reshape(θr, θn, φn)
        φr = reshape(φr, θn, φn)
        r = reshape(r, θn, φn)
    elseif typeof(data) == Matrix{Real} || typeof(data) == Matrix{Float64}
        @assert size(r) == (θn, φn) "data must be either a vector or a matrix of size (θn, φn)"
        θr = repeat(θ, 1, φn)
        φr = repeat(φ', θn, 1)
    end

    if repeatFirstφ
        φr = hcat(φr, 2*pi.+φr[:, 1])
        θr = hcat(θr, θr[:, 1])
        r = hcat(r, r[:, 1])
    end
    
    return θr, φr, r
end


"""
# cartesianPattern
Converts spherical pattern to cartesian pattern and sets its dynamic range.

## Args:
- `θ::Union{Matrix{Float64}, Matrix{Real}}`: θ coordinate in radians, [N x M]
- `φ::Union{Matrix{Float64}, Matrix{Real}}`: φ coordinate in radians, [N x M]
- `r::Union{Matrix{Float64}, Matrix{Real}}`: r, [N x M]
- `dymanicMinimum::Real`: dymanicMinimum, default: `0`, sets the dynamic range of the data to [dymanicMinimum, max(data)], must be lesser or equal to 0

## Returns:
- `x`: x coordinate, [N x M]
- `y`: y coordinate, [N x M]
- `z`: z coordinate, [N x M]
- `r_norm`: normalized `r`, [N x M]

"""
function cartesianPattern(θ::Union{Matrix{Float64}, Matrix{Real}}, φ::Union{Matrix{Float64}, Matrix{Real}}, r::Union{Matrix{Float64}, Matrix{Real}}, dymanicMinimum::Real = 0)

    @assert size(θ) == size(φ) == size(r) "θ, φ and data must be of the same size"
    @assert dymanicMinimum <= 0 "dymanicMinimum must be lesser than 0"
    
    # Apply transformations
    r[r .< dymanicMinimum] .= dymanicMinimum
    rn = copy(r)
    r .= r .- dymanicMinimum

    X = r .* sin.(θ) .* cos.(φ)
    Y = r .* sin.(θ) .* sin.(φ)
    Z = r .* cos.(θ)
    
    return X, Y, Z, rn
end


"""
# antennaPattern3D
Plots the 3D antenna pattern.

## Args:
- `X::Matrix{Float64}`: x coordinate, [N x M]
- `Y::Matrix{Float64}`: y coordinate, [N x M]
- `Z::Matrix{Float64}`: z coordinate, [N x M]
- `RN::Matrix{Float64}`: normalized data, [N x M]
- `kwargs...`: keyword arguments
    - `width::Int`: width of the plot, default: `800`
    - `height::Int`: height of the plot, default: `800`
    - `xlabel::String`: x label, default: `"X"`
    - `ylabel::String`: y label, default: `"Y"`
    - `zlabel::String`: z label, default: `"Z"`
    - `title::String`: title of the plot, default: `"3D Antenna Pattern"`
    - `show_grid::Bool`: show grid, default: `false`
    - `show_axis::Bool`: show axis, default: `false`
    - `legend::Bool`: show legend, default: `true`
    - `color_scale_plotly::String`: color scale for PlotlyJS, default: `"Rainbow"`
    - `color_scale_pyplot::Symbol`: color scale for PyPlot, default: `:jet`
    - `aaxis_show::Bool`: show axis, default: `true`
    - `aaxis_theta::Float64`: theta angle of the axis, default: `90.0`
    - `aaxis_phi::Float64`: phi angle of the axis, default: `0.0`
    - `aaxis_color::Symbol`: color of the axis, default: `:blue`
    - `aaxis_linewidth::Float64`: line width of the axis, default: `3.0`
    - `aaxis_linestyle::Symbol`: line style of the axis, default: `:auto`
    - `aaxis_label::String`: label of the axis, default: `""`
    - `aaxis_axis_multiplier::Float64`: axis multiplier, default: `1.3`

## Returns:
- `p`: plot
"""
function antennaPattern3D(X::Matrix{Float64}, Y::Matrix{Float64}, Z::Matrix{Float64}, RN::Matrix{Float64}; kwargs...)


    # Merge the user-provided kwargs with the default values
    attributes = merge(DEFAULTS, Dict(kwargs))

    # Optional: Check for unrecognized arguments
    for key in keys(attributes)
        if !haskey(DEFAULTS, key)
            @warn "Unrecognized argument: $key"
        end
    end

    # Ticks for the colorbar
    ticks = round.(collect(LinRange(minimum(RN), maximum(RN), round(Int64, abs(maximum(RN) - minimum(RN))))), digits=2)
    # get the set backend
    engine = backend()
    default(size=(attributes[:width], attributes[:height]))

    if engine == Plots.PlotlyJSBackend()
        p = surface(X, Y, Z, surfacecolor = RN, 
        colorscale = attributes[:color_scale_plotly],
        xlabel = attributes[:xlabel],
        ylabel = attributes[:ylabel],
        zlabel = attributes[:zlabel],
        title = attributes[:title],
        xgrid = attributes[:show_grid],
        ygrid = attributes[:show_grid],
        zgrid = attributes[:show_grid],
        axis = attributes[:show_axis],
        legend = attributes[:legend],
        )

    elseif engine == Plots.PyPlotBackend()
        pygui(attributes[:python_interactive])
        p = surface(X, Y, Z, surfacecolor = RN, 
        cmap = attributes[:color_scale_pyplot],
        xlabel = attributes[:xlabel],
        ylabel = attributes[:ylabel],
        zlabel = attributes[:zlabel],
        title = attributes[:title],
        grid = attributes[:show_grid],
        ticks = attributes[:show_grid],
        showaxis = attributes[:show_axis],
        legend = attributes[:legend],
        clim = (minimum(RN), maximum(RN)),
        antialiased= true,
        colorbar_ticks = ticks
        )
    else
        error("Unsupported engine: $engine")
    end

    if attributes[:aaxis_show]
        theta = attributes[:aaxis_theta]
        phi = attributes[:aaxis_phi]
        r = attributes[:aaxis_axis_multiplier] * maximum(Z)
        x = r .* [0, cos(deg2rad(theta)) * cos(deg2rad(phi))]
        y = r .* [0, cos(deg2rad(theta)) * sin(deg2rad(phi))]
        z = r .* [0, sin(deg2rad(theta))]
        plot3d!(x, y, z, 
            color = attributes[:aaxis_color], 
            linewidth = attributes[:aaxis_linewidth], 
            linestyle = attributes[:aaxis_linestyle], 
            label = attributes[:aaxis_label], 
        )
    end
    
    return p

end