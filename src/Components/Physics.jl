export Velocity2D
"""
    mutable struct Velocity2D <: Component

Velocity2D is a component that represents the velocity of an entity in 2D space in units of 1/10 screen space per second, so that an entity with a velocity of 1 would cross the screen in 10 seconds.

# Fields
- `dx::Float64`: The x-component of the velocity. In units of 1/10 horizontal screen space per second. Default is 0.
- `dy::Float64`: The y-component of the velocity. In units of 1/10 vertical screen space per second. Default is 0.
"""
@kwdef mutable struct Velocity2D <: Component
    dx::Float64=0.0
    dy::Float64=0.0
end

export Acceleration2D
"""
    mutable struct Acceleration2D <: Component

Acceleration2D is a component that represents the acceleration of an entity in 2D space in units of 1/10 screen space per second per second, so that an entity with an acceleration of 1 would have a velocity of 1 screen space per second in 10 seconds. 

# Fields
- `ddx::Float64`: The x-component of the acceleration. In units of 1/10 horizontal screen space per second per second. Default is 0.
- `ddy::Float64`: The y-component of the acceleration. In units of 1/10 vertical screen space per second per second. Default is 0.
"""
@kwdef mutable struct Acceleration2D <: Component
    ddx::Float64=0.0
    ddy::Float64=0.0
end

export AngularVelocity2D
"""
    mutable struct AngularVelocity2D <: Component

AngularVelocity2D is a component that represents the angular velocity of an entity in 2D space in radians per second.

# Fields
- `ω::Float64`: The angular velocity in radians per second. Default is 0.
"""
@kwdef mutable struct AngularVelocity2D <: Component
    ω::Float64=0.0
end

export AngularAcceleration2D
"""
    mutable struct AngularAcceleration2D <: Component

AngularAcceleration2D is a component that represents the angular acceleration of an entity in 2D space in radians per second per second. Default is 0.

# Fields
- `α::Float64`: The angular acceleration in radians per second per second. Default is 0.
"""
@kwdef mutable struct AngularAcceleration2D <: Component
    α::Float64=0.0
end


