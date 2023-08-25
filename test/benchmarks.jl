using BenchmarkTools
using AntennaPattern

x = rand(500);
y = rand(500);
z = rand(500);

r = rand(500);
theta = rand(500);
phi = rand(500);

_ = @btime cart2sph.($x, $y, $z) evals=3 samples=20 seconds=3600;
_ = @btime sph2cart.($r, $theta, $phi) evals=3 samples=20 seconds=3600;