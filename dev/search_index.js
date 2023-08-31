var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = AntennaPattern","category":"page"},{"location":"#AntennaPattern","page":"Home","title":"AntennaPattern","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for AntennaPattern.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [AntennaPattern]","category":"page"},{"location":"#AntennaPattern.DEFAULTS_1D","page":"Home","title":"AntennaPattern.DEFAULTS_1D","text":"Defaut values for the 1D antenna pattern plot\n\n\n\n\n\n","category":"constant"},{"location":"#AntennaPattern.antennaPattern3D-NTuple{4, Matrix{Float64}}","page":"Home","title":"AntennaPattern.antennaPattern3D","text":"antennaPattern3D\n\nPlots the 3D antenna pattern.\n\nArgs:\n\nX::Matrix{Float64}: x coordinate, [N x M]\nY::Matrix{Float64}: y coordinate, [N x M]\nZ::Matrix{Float64}: z coordinate, [N x M]\nRN::Matrix{Float64}: normalized data, [N x M]\nkwargs...: keyword arguments\nwidth::Int: width of the plot, default: 800\nheight::Int: height of the plot, default: 800\nxlabel::String: x label, default: \"X\"\nylabel::String: y label, default: \"Y\"\nzlabel::String: z label, default: \"Z\"\ntitle::String: title of the plot, default: \"3D Antenna Pattern\"\nshow_grid::Bool: show grid, default: false\nshow_axis::Bool: show axis, default: false\nlegend::Bool: show legend, default: true\ncolor_scale_plotly::String: color scale for PlotlyJS, default: \"Rainbow\"\ncolor_scale_pyplot::Symbol: color scale for PyPlot, default: :jet\naaxis_show::Bool: show axis, default: true\naaxis_theta::Float64: theta angle of the axis, default: 90.0\naaxis_phi::Float64: phi angle of the axis, default: 0.0\naaxis_color::Symbol: color of the axis, default: :blue\naaxis_linewidth::Float64: line width of the axis, default: 3.0\naaxis_linestyle::Symbol: line style of the axis, default: :auto\naaxis_label::String: label of the axis, default: \"\"\naaxis_axis_multiplier::Float64: axis multiplier, default: 1.3\n\nReturns:\n\np: plot\n\n\n\n\n\n","category":"method"},{"location":"#AntennaPattern.cart2sph-Tuple{Real, Real, Real}","page":"Home","title":"AntennaPattern.cart2sph","text":"cart2sph\n\nTransforms carthesian coordinates to spherical coordinates\n\nINPUTS:\n\nx: x coordinate, Real\ny: y coordinate, Real\nz: z coordinate, Real\n\nOUTPUTS\n\nr: r coordinate in spherical coordinates, Real\nθ: theta coordinate in spherical coordinates, Real\nφ: phi coordinate in spherical coordinates, Real\ntype: [x, y, z]\n\n\n\n\n\n","category":"method"},{"location":"#AntennaPattern.cartesianPattern","page":"Home","title":"AntennaPattern.cartesianPattern","text":"cartesianPattern\n\nConverts spherical pattern to cartesian pattern and sets its dynamic range.\n\nArgs:\n\nθ::Union{Matrix{Float64}, Matrix{Real}}: θ coordinate in radians, [N x M]\nφ::Union{Matrix{Float64}, Matrix{Real}}: φ coordinate in radians, [N x M]\nr::Union{Matrix{Float64}, Matrix{Real}}: r, [N x M]\ndymanicMinimum::Real: dymanicMinimum, default: 0, sets the dynamic range of the data to [dymanicMinimum, max(data)], must be lesser or equal to 0\n\nReturns:\n\nx: x coordinate, [N x M]\ny: y coordinate, [N x M]\nz: z coordinate, [N x M]\nr_norm: normalized r, [N x M]\n\n\n\n\n\n","category":"function"},{"location":"#AntennaPattern.createSurface-Tuple{Union{Vector{Float64}, Vector{Real}}, Union{Vector{Float64}, Vector{Real}}, Union{Vector{Float64}, Matrix{Float64}, Vector{Real}, Matrix{Real}}}","page":"Home","title":"AntennaPattern.createSurface","text":"createSurface\n\nCreates a surface from the given data.\n\nArgs:\n\nθ::Union{Vector{Real}, Vector{Float64}}: θ coordinate in radians\nφ::Union{Vector{Real}, Vector{Float64}}: φ coordinate in radians\ndata::Union{Vector{Float64}, Vector{Real}, Matrix{Real}, Matrix{Float64}}: data\nrepeatFirstφ::Bool: repeat first φ value at the end, default: false\nθf::Symbol: θ format, default: :rad\nφf::Symbol: φ format, default: :rad\n\nReturns:\n\nθr: θ coordinate in radians, [N x M]\nφr: φ coordinate in radians, [N x M]\nr: r, [N x M]\n\n\n\n\n\n","category":"method"},{"location":"#AntennaPattern.polarPattern-Tuple{Symbol, Real, Union{Vector{Float64}, Vector{Real}}, Union{Vector{Float64}, Vector{Real}}, Union{Vector{Float64}, Vector{Real}}}","page":"Home","title":"AntennaPattern.polarPattern","text":"polarPattern\n\nPolar plot of an antenna pattern.\n\nArguments\n\nConstant::Symbol: The constant angle to plot the antenna pattern at. Must be either :Theta or :Phi.\nCutAngle::Real: The angle at which to plot the antenna pattern. Must be between 0 and 360.\nθ::Union{Vector{Real}, Vector{Float64}}: The θ values of the antenna pattern (degrees).\nφ::Union{Vector{Real}, Vector{Float64}}: The φ values of the antenna pattern (degrees).\ndata::Union{Vector{Real}, Vector{Float64}}: The data values of the antenna pattern.\nrepeatFirst::Bool: Whether to repeat the first value of the antenna pattern at the end. Defaults to true.\nkwargs...: Keyword arguments to pass to the plot function.\n\nkwargs\n\nwidth::Int: The width of the plot. Defaults to 600.\nheight::Int: The height of the plot. Defaults to 500.\nlabel::String: The label of the plot. Defaults to \"Antenna Pattern\".\nlegend::Bool: Whether to show the legend. Defaults to true.\nline_width::Float64: The width of the line. Defaults to 3.0.\ncolor::Symbol: The color of the line. Defaults to :red.\ntitle::String: The title of the plot. Defaults to \"Antenna Pattern\".\nmainlobe::Bool: Whether to show the main lobe. Defaults to true.\nmainlobe_color::Symbol: The color of the main lobe. Defaults to :blue.\nmainlobe_linewidth::Float64: The width of the main lobe line. Defaults to 1.5.\nmainlobe_label::String: The label of the main lobe. Defaults to \"Main lobe\".\nrotation::Float64: The rotation of the plot in degrees. Defaults to 0.0.\n\nReturns\n\np::Plot: The plot object.\n\n\n\n\n\n","category":"method"},{"location":"#AntennaPattern.preprocess_CST_3D_ASCII_file-Tuple{String, String}","page":"Home","title":"AntennaPattern.preprocess_CST_3D_ASCII_file","text":"Preprocessing of CST 3D ASCII file\n\nGenerates a CSV file from a CST 3D ASCII file. The CST 3D ASCII file is a text file with the following format:\n\n- [\"Theta[deg.]\", \"Phi[deg.]\", \"|Dir.|[dBi]\", \"|Theta|[dBi]\", \"∠Theta[deg.]\", \"|Phi|[dBi]\", \"∠Phi[deg.]\", \"AR[dB]\"]\n\nInputs:\n\n- input_filename: path to the input file\n- output_filename: path to the output file\n\nOutputs:\n\n- output_filename: processed file\n\n\n\n\n\n","category":"method"},{"location":"#AntennaPattern.setBackend1D-Tuple{Symbol}","page":"Home","title":"AntennaPattern.setBackend1D","text":"setBackend1D\n\nSets the plotting engine. Available engines are:\n\n:gr\n\n\n\n\n\n","category":"method"},{"location":"#AntennaPattern.setBackend3D-Tuple{Symbol}","page":"Home","title":"AntennaPattern.setBackend3D","text":"setBackend3D\n\nSets the plotting engine. Available engines are:\n\n:plotlyjs\n:pyplot\n\n\n\n\n\n","category":"method"},{"location":"#AntennaPattern.sph2cart-Tuple{Real, Real, Real}","page":"Home","title":"AntennaPattern.sph2cart","text":"sph2Cart\n\nTransforms spherical coordinates to carthesian coordinates\n\nINPUTS\n\nr: r coordinate in spherical coordinates, Real \nθ: theta coordinate in spherical coordinates, Real\nφ: phi coordinate in spherical coordinates, Real\n\nOUTPUTS\n\nx: x coordinate, Real\ny: y coordinate, Real\nz: z coordinate, Real\ntype: [x, y, z]\n\n\n\n\n\n","category":"method"},{"location":"#AntennaPattern.@STANDARD_CST_3D_PATTERN_COLUMNS-Tuple{}","page":"Home","title":"AntennaPattern.@STANDARD_CST_3D_PATTERN_COLUMNS","text":"Standard CST 3D ASCII file header\n\n\n\n\n\n","category":"macro"}]
}
