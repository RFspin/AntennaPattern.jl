using Plots


"""
# setBackend3D
Sets the plotting engine.
Available engines are:
- `:plotlyjs`
- `:pyplot`
"""
function setBackend3D(engine::Symbol)
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
# setBackend1D
Sets the plotting engine.
Available engines are:
- `:gr`
"""
function setBackend1D(engine::Symbol)
    @assert engine in [:gr] "Available engines are :gr" 
    if engine == :gr
        gr()
    else
        error("Unsupported engine: $engine")
    end
end