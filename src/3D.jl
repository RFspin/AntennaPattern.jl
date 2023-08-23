using Plots
using LinearAlgebra
using PyCall

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
# set_engine
Sets the plotting engine.
Available engines are:
- `:plotlyjs`
- `:pyplot`
"""
function set_engine(engine::Symbol)
    @assert engine in [:plotlyjs, :pyplot] "Available engines are :plotlyjs, :pyplot"
    if engine == :plotlyjs
        plotlyjs()
    elseif engine == :pyplot
        pyplot()
    else
        error("Unsupported engine: $engine")
    end
end

"""
# antenna_pattern_3D
Plots the 3D antenna pattern.

## Args:
- `X::Matrix{Float64}`: x coordinate, [N x M]
- `Y::Matrix{Float64}`: y coordinate, [N x M]
- `Z::Matrix{Float64}`: z coordinate, [N x M]
- `RN::Matrix{Float64}`: normalized data, [N x M]
- `attributes::Dict`: attributes of the plot, default: 
    `Dict(:common => Dict(
        :xlabel => "X", 
        :ylabel => "Y", 
        :zlabel => "Z", 
        :title => "3D Antenna Pattern", 
        :colorbar_title => "Normalized Power [dB]"), 
        :plots_specific => Dict(
            :color_scale => "Rainbow")
            )`

## Returns:
- `p`: plot
"""
function antenna_pattern_3D(X::Matrix{Float64}, Y::Matrix{Float64}, Z::Matrix{Float64}, 
    RN::Matrix{Float64}, 
    attributes = Dict(
        :common => Dict(
            :width => 800,
            :height => 800,
            :xlabel => "X",
            :ylabel => "Y",
            :zlabel => "Z",
            :title => "Antenna directivity [dBi]",
            :show_grid => false,
            :show_axis => false,
            :legend => true,
            ), 
        :antenna_axis => Dict(
            :show => true,
            :theta => 90,
            :phi => 0,
            :color => :blue,
            :linewidth => 3,
            :linestyle => :auto, # [:auto, :dash, :dashdot, :dot, :solid]
            :label => "",
            :axis_multiplier => 1.3
            ),
        :plots_specific => Dict(
            :color_scale_plotly => "Rainbow",
            :color_scale_pyplot => :jet)
            )
    )

    # Ticks for the colorbar
    ticks = round.(collect(LinRange(minimum(RN), maximum(RN), round(Int64, abs(maximum(RN) - minimum(RN))))), digits=2)
    # get the set backend
    engine = backend()
    default(size=(attributes[:common][:width], attributes[:common][:height]))

    if engine == Plots.PlotlyJSBackend()
        p = surface(X, Y, Z, surfacecolor = RN, 
        colorscale = attributes[:plots_specific][:color_scale_plotly],
        xlabel = attributes[:common][:xlabel],
        ylabel = attributes[:common][:ylabel],
        zlabel = attributes[:common][:zlabel],
        title = attributes[:common][:title],
        xgrid = attributes[:common][:show_grid],
        ygrid = attributes[:common][:show_grid],
        zgrid = attributes[:common][:show_grid],
        axis = attributes[:common][:show_axis],
        legend = attributes[:common][:legend],
        )

    elseif engine == Plots.PyPlotBackend()
        pygui(true)
        p = surface(X, Y, Z, surfacecolor = RN, 
        cmap = attributes[:plots_specific][:color_scale_pyplot],
        xlabel = attributes[:common][:xlabel],
        ylabel = attributes[:common][:ylabel],
        zlabel = attributes[:common][:zlabel],
        title = attributes[:common][:title],
        grid = attributes[:common][:show_grid],
        ticks = attributes[:common][:show_grid],
        showaxis = attributes[:common][:show_axis],
        legend = attributes[:common][:legend],
        clim = (minimum(RN), maximum(RN)),
        antialiased= true,
        colorbar_ticks = ticks
        )
    else
        error("Unsupported engine: $engine")
    end

    if attributes[:antenna_axis][:show]
        theta = attributes[:antenna_axis][:theta]
        phi = attributes[:antenna_axis][:phi]
        r = attributes[:antenna_axis][:axis_multiplier] * maximum(Z)
        x = r .* [0, cos(deg2rad(theta)) * cos(deg2rad(phi))]
        y = r .* [0, cos(deg2rad(theta)) * sin(deg2rad(phi))]
        z = r .* [0, sin(deg2rad(theta))]
        plot3d!(x, y, z, 
            color = attributes[:antenna_axis][:color], 
            linewidth = attributes[:antenna_axis][:linewidth], 
            linestyle = attributes[:antenna_axis][:linestyle], 
            label = attributes[:antenna_axis][:label], 
        )
    end
    
    return p

end