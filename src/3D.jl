using Plots
using LinearAlgebra

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
- `:gr`
- `:pyplot`
- `:unicodeplots`
"""
function set_engine(engine::Symbol)
    @assert engine in [:plotlyjs, :gr, :pyplot, :unicodeplots] "Available engines are :plotly, :gr, :pyplot, :unicodeplots"
    if engine == :plotlyjs
        plotlyjs()
    elseif engine == :gr
        gr()
    elseif engine == :pyplot
        pyplot()
    elseif engine == :unicodeplots
        unicodeplots()
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
- `attributes::Dict`: attributes of the plot, default: `Dict(:common => Dict(:xlabel => "X", :ylabel => "Y", :zlabel => "Z", :title => "3D Antenna Pattern", :colorbar_title => "Normalized Power [dB]"), :plots_specific => Dict(:color_scale => "Rainbow"))`

## Returns:
- `p`: plot
"""
function antenna_pattern_3D(X::Matrix{Float64}, Y::Matrix{Float64}, Z::Matrix{Float64}, 
    RN::Matrix{Float64}, 
    attributes = Dict(
        :common => Dict(
            :xlabel => "X",
            :ylabel => "Y",
            :zlabel => "Z",
            :title => "3D Antenna Pattern",
            :colorbar_title => "Normalized Power [dB]"
            ), 
        :plots_specific => Dict(
            :color_scale => "Rainbow")
            )
    )

    # Ticks for the colorbar
    ticks = round.(collect(LinRange(minimum(RN), maximum(RN), round(Int64, abs(maximum(RN) - minimum(RN))))), digits=2)
    # get the set backend
    engine = backend()

    if engine == Plots.PlotlyJSBackend()
        p = surface(X, Y, Z, surfacecolor = RN, 
        colorbar_title = attributes[:common][:colorbar_title],
        colorscale = attributes[:plots_specific][:color_scale],
        xlabel = attributes[:common][:xlabel],
        ylabel = attributes[:common][:ylabel],
        zlabel = attributes[:common][:zlabel],
        title = attributes[:common][:title]
        )

    else
        error("Unsupported engine: $engine")
    end
    
    return p

end