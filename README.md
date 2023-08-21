![RFspin_logo](https://github.com/RFspin/APattern.jl/assets/128054331/1a4c7715-ad1f-4b28-8d8d-0cea6c955dac)

## Overview [![CI](https://github.com/RFspin/APattern.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/RFspin/APattern.jl/actions/workflows/CI.yml) [![codecov](https://codecov.io/gh/RFspin/APattern.jl/graph/badge.svg?token=MapVB9qg1G)](https://codecov.io/gh/RFspin/APattern.jl)

> "3D antenna pattern processing done easy."

> **Warning**
>There is no 3D plotting yet, this package is a WIP. Processing data from CST is available.

Simple open source solution to antenna 3D data processing. Why?
- Processing data from measurements is a constant and never-ending struggle.
- There is very little tools that allow you to easily do this.

## Installation
 - TODO - when published, in the meantime feel free to clone the repository

## Using the package
See tests to use the package.

Minimal example:
```julia
using APattern
using CSV
using DataFrames

# File paths
filename = joinpath(dirname(pwd()), "data", "pattern_CP_2.92GHz.txt")
outputfilename = joinpath(dirname(pwd()), "data", "pattern_CP_2.92GHz_processed.csv")

# preprocess data
preprocess_CST_3D_ASCII_file(filename, outputfilename)

# import data
df = CSV.read(outputfilename, DataFrame, header=@STANDARD_CST_3D_PATTERN_COLUMNS, skipto=3)
```
