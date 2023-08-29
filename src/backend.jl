using Plots


"""
# set_engine_3D
Sets the plotting engine.
Available engines are:
- `:plotlyjs`
- `:pyplot`
"""
function set_engine_3D(engine::Symbol)
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
# set_engine_1D
Sets the plotting engine.
Available engines are:
- `:gr`
- `:pyplot`
"""
function set_engine_1D(engine::Symbol)
    @assert engine in [:gr, :pyplot] "Available engines are :gr, :pyplot" 
    if engine == :gr
        gr()
    elseif engine == :pyplot
        pyplot()
    else
        error("Unsupported engine: $engine")
    end
end