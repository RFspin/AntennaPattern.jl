![RFspin_logo](https://github.com/RFspin/APattern.jl/assets/128054331/1a4c7715-ad1f-4b28-8d8d-0cea6c955dac)

## Overview [![CI](https://github.com/RFspin/APattern.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/RFspin/APattern.jl/actions/workflows/CI.yml) [![codecov](https://codecov.io/gh/RFspin/AntennaPattern.jl/graph/badge.svg?token=MapVB9qg1G)](https://codecov.io/gh/RFspin/AntennaPattern.jl)

> "3D antenna pattern processing done easy."

A simple open-source solution to antenna 3D data processing. Why?
- Processing data from measurements is a constant and never-ending struggle.
- There are very few tools that allow you to do this easily.

## Installation
```julia
import Pkg
Pkg.add("AntennaPattern")
```

## Using the package
See the [example_3D_plots](example_3D_plots.jl) for instructions and an explanation of using the package for 3D graphics. For 1D graphics, see [example_1D_plots](example_1D_plots.jl).

## Road map
### PlotlyJS
For the upcoming changes, see [#9](https://github.com/RFspin/APattern.jl/issues/9).
### PyPlot
For the upcoming changes, see [#10](https://github.com/RFspin/APattern.jl/issues/10).
### 1D Graphics
For the upcoming changes, see [#23](https://github.com/RFspin/AntennaPattern.jl/issues/23).

The future work includes:
- Parsing data from vector network analysers spectrum analysers (specifically ms464x Anritsu series);
- Data exporting to HTML, PDF, and SVG.

## Visual outputs 
### 3D Results
 PlotlyJS            |  PyPlot
:-------------------------:|:-------------------------:
<img width="587" alt="plotly" src="https://github.com/RFspin/APattern.jl/assets/128054331/2ee48938-e0ae-4adb-9f80-2e04af6ea75b">  |  ![pyplot](https://github.com/RFspin/APattern.jl/assets/128054331/85d9244a-0908-41d2-8130-44e530fecb9c)

### 1D Results
![CP](https://github.com/RFspin/AntennaPattern.jl/assets/128054331/0bfc0ac7-2574-4e28-ac4d-b16f9ca5f837)
