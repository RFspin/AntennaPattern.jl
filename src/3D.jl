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
    :color_scale_plotly => "Rainbow",
    :color_scale_pyplot => :jet,
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
# sph2cartData
Converts spherical data to cartesian data.

## Args:
- `θ::Vector{Float64}`: theta coordinate, [N x 1]
- `φ::Vector{Float64}`: phi coordinate, [M x 1]
- `data::Matrix{Float64}`: data to be converted, [N x M]
- `offset::Real`: offset of the data (sets the dynamic range of the data), default: `0` (no offset)
- `repeat_first_φ::Bool`: repeat first value of the data, default: `false`

## Returns:
- `x`: x coordinate, [N x M]
- `y`: y coordinate, [N x M]
- `z`: z coordinate, [N x M]
- `r_norm`: normalized data, [N x M]

"""
function sph2cartData(θ::Vector{Float64}, φ::Vector{Float64}, data::Vector{Float64}, offset::Real = 0, repeat_first_φ::Bool = false)
    
    θr = deg2rad.(θ)
    φr = deg2rad.(φ)
    
    θn = length(unique(θr))
    φn = length(unique(φr))
    
    # Reshape arrays
    θr = reshape(θr, θn, φn)
    φr = reshape(φr, θn, φn)
    r = reshape(data, θn, φn)

    if repeat_first_φ
        φr = hcat(φr, 2*pi.+φr[:, 1])
        θr = hcat(θr, θr[:, 1])
        r = hcat(r, r[:, 1])
    end
    
    # Apply transformations
    r[r .< -1*offset] .= -1*offset
    rn = copy(r)
    r .= r .+ offset

    X = r .* sin.(θr) .* cos.(φr)
    Y = r .* sin.(θr) .* sin.(φr)
    Z = r .* cos.(θr)
    
    return X, Y, Z, rn
end


"""
# antenna_pattern_3D
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
function antenna_pattern_3D(X::Matrix{Float64}, Y::Matrix{Float64}, Z::Matrix{Float64}, RN::Matrix{Float64}; kwargs...)


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