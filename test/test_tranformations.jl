using Test
using AntennaPattern

println("Testing transformations.jl...")
r = [5.002139542235902, 5.00009999900002, 3.004546554806565]
θ = [1.0006336156360904, 2.9999128950530918, 0.0984421247294862]
φ = [1.999389226196129, 1.2983331773911049, 0.4939413689195813]

x = [-1.75, 0.19, 0.26]
y = [3.83, 0.68, 0.14]
z = [2.70, -4.95, 2.99]


@testset "cart2sph" begin
    rθφ = cart2sph.(x, y, z)
    @test getindex.(rθφ, 1) ≈ r
    @test getindex.(rθφ, 2) ≈ θ
    @test getindex.(rθφ, 3) ≈ φ
end

@testset "sph2cart" begin
    xyz = sph2cart.(r, θ, φ)
    @test getindex.(xyz, 1) ≈ x
    @test getindex.(xyz, 2) ≈ y
    @test getindex.(xyz, 3) ≈ z
end