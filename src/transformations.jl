"""
# cart2sph
Transforms carthesian coordinates to spherical coordinates

## INPUTS:
- x: x coordinate, `Real`
- y: y coordinate, `Real`
- z: z coordinate, `Real`
## OUTPUTS
- r: r coordinate in spherical coordinates, `Real`
- θ: theta coordinate in spherical coordinates, `Real`
- φ: phi coordinate in spherical coordinates, `Real`
- type: [x, y, z]
"""
function cart2sph(x::Real, y::Real, z::Real)
    r = sqrt(x ^ 2 + y ^ 2 + z ^ 2);
    θ = acos(z / r)
    φ = atan(y, x)
    return [r, θ, φ]
end

"""
# sph2Cart 
Transforms spherical coordinates to carthesian coordinates
 
## INPUTS
- r: r coordinate in spherical coordinates, `Real` 
- θ: theta coordinate in spherical coordinates, `Real`
- φ: phi coordinate in spherical coordinates, `Real`

## OUTPUTS
- x: x coordinate, `Real`
- y: y coordinate, `Real`
- z: z coordinate, `Real`
- type: [x, y, z]
"""
function sph2cart(r::Real, θ::Real, φ::Real)
    x = r * sin(θ) * cos(φ)
    y = r * sin(θ) * sin(φ)
    z = r * cos(θ)
    return [x, y, z]
end