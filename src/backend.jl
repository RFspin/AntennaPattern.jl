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
"""
function set_engine_1D(engine::Symbol)
    @assert engine in [:gr] "Available engines are :gr"
    if engine == :gr
        gr()
    else
        error("Unsupported engine: $engine")
    end
end