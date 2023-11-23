export Origin2D
"""
    mutable struct Origin2D <: Component

Origin2D is a component that represents the origin of an entity in 2D space. The origin is the point about which the entity rotates and scales. The origin is specified as a fraction of the entity's width and height, with 0 being the left or top of the entity and 1 being the right or bottom of the entity. The default is 0.5, which is the center of the entities bounding box.

# Fields
- `x::Float64`: The x-coordinate of the origin. Between 0 and 1, with 0 being the left and 1 being the right of the entity. Default is 0.5.
- `y::Float64`: The y-coordinate of the origin. Between 0 and 1, with 0 being the top and 1 being the bottom of the entity. Default is 0.5.
"""
@kwdef mutable struct Origin2D <: Component
    x::Float64=0.5
    y::Float64=0.5
    function Origin2D(x::Float64, y::Float64)
        if x < 0 || x > 1
            throw(ArgumentError("x must be between 0 and 1"))
        end
        if y < 0 || y > 1
            throw(ArgumentError("y must be between 0 and 1"))
        end
        new(x, y)
    end
end

export Position2D
"""
    mutable struct Position2D <: Component

Position2D is a component that represents the position of an entity in 2D space. Sets the [`Origin2D`](origin) to this point. The position is specified as a fraction of the screen width and height, with 0 being the left or top of the screen and 1 being the right or bottom of the screen. The default is 0.5, which is the center of the screen.

# Fields
- `x::Float64`: The x-coordinate of the position. Between 0 and 1, with 0 being the left and 1 being the right of the screen. Default is 0.5.
- `y::Float64`: The y-coordinate of the position. Between 0 and 1, with 0 being the top and 1 being the bottom of the screen. Default is 0.5.
"""
@kwdef mutable struct Position2D <: Component
    x::Float64=0.5
    y::Float64=0.5
end

export Rotation2D
"""
    mutable struct Rotation2D <: Component

Rotation2D is a component that represents the rotation of an entity in 2D space in radians.

# Fields
- `θ::Float64`: The angle of rotation in radians. Default is 0.
"""
@kwdef mutable struct Rotation2D <: Component
    θ::Float64=0.0
    function Rotation2D(θ::Float64)
        if θ < 0.0 || θ > 2π
            θ = mod(θ, 2π)
        end
        new(θ)
    end
end

export Scale2D
"""
    mutable struct Scale2D <: Component

Scale2D is a component that represents the scale of an entity in 2D space.

# Fields
- `Δx::Float64`: The x-component of the scale. Default is 1.
- `Δy::Float64`: The y-component of the scale. Default is 1. 
"""
@kwdef mutable struct Scale2D <: Component
    Δx::Float64=1.0
    Δy::Float64=1.0
    function Scale2D(Δx::Float64, Δy::Float64)
        if Δx <= 0.0
            throw(ArgumentError("Δx must be greater than 0"))
        end
        if Δy <= 0.0
            throw(ArgumentError("Δy must be greater than 0"))
        end
        new(Δx, Δy)
    end
end

export Transform2D
"""
    mutable struct Transform2D <: Component

Transform2D is a component that represents the transformation of an entity in 2D space. The transformation is made up of [`Origin2D`](origin), [`Position2D`](position), [`Velocity2D`](velocity), [`Acceleration2D`](acceleration), [`Rotation2D`](rotation), [`AngularVelocity2D`](angular velocity), and [`Scale2D`](scale) components. 
"""
@kwdef mutable struct Transform2D <: CompositeComponent
    origin::Origin2D=Origin2D()
    position::Position2D=Position2D()
    rotation::Rotation2D=Rotation2D()
    scale::Scale2D=Scale2D()
end
