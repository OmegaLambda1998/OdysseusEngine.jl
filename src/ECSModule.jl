# ECS Module
module ECSModule

# Internal Packages 

# External Packages 

# Exports

# ------------
# Component 
# ------------
export Component
"""
    abstract type Component

Component is an abstract type that represents components.
"""
abstract type Component end

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

export Rotation2D
"""
    mutable struct Rotation2D <: Component

Rotation2D is a component that represents the rotation of an entity in 2D space in radians.

# Fields
- `θ::Float64`: The angle of rotation in radians. Default is 0.
"""
@kwdef mutable struct Rotation2D <: Component
    θ::Float64=0.0
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
end

export Transform2D
"""
    mutable struct Transform2D <: Component

Transform2D is a component that represents the transformation of an entity in 2D space. The transformation is made up of [`Origin2D`](origin), [`Position2D`](position), [`Velocity2D`](velocity), [`Acceleration2D`](acceleration), [`Rotation2D`](rotation), [`AngularVelocity2D`](angular velocity), and [`Scale2D`](scale) components. 
"""
@kwdef mutable struct Transform2D <: Component
    origin::Origin2D=Origin2D()
    position::Position2D=Position2D()
    velocity::Velocity2D=Velocity2D()
    acceleration::Acceleration2D=Acceleration2D()
    rotation::Rotation2D=Rotation2D()
    angular_velocity::AngularVelocity2D=AngularVelocity2D()
    scale::Scale2D=Scale2D()
end

# ------------
# Entity
# ------------
export EntityType
"""
    abstract type EntityType

EntityType is an abstract type that represents entities.
"""
abstract type EntityType end

export Entity
"""
    struct Entity <: EntityType

Entity is a struct that represents an entity. An entity is a container for components.

# Fields
- `id::Int64`: The unique identifier of the entity.
- `name::String`: The name of the entity for logging purposes. Default is "".
"""
@kwdef struct Entity <: EntityType
    id::Int64
    name::String=""
end

# ------------
# Entity Manager
# ------------

export ECSManager
"""
    mutable struct ECSManager

ECSManager provides functionality to create and remove [`Entity`](entity) objects. It also keeps track of the maximum id and free ids for creating new entities.

# Fields
- `max_id::Int64`: The maximum id of the entities created so far.
- `free_ids::Vector{Int64}`: The ids of the entities that have been removed and can be reused.
- `entities::Vector{Entity}`: The entities that have been created.
- `components::Dict{DataType, Dict{Entity, Component}}`: A dictionary that maps component types to a vector of dictionaries that map entities to components of that type.
"""
@kwdef mutable struct ECSManager
    max_id::Int64=0
    free_ids::Vector{Int64}=Vector{Int64}([0])
    entities::Vector{Entity}=Vector{Entity}()
    components::Dict{DataType, Dict{Entity, Component}}=Dict{DataType, Dict{Entity, Component}}()
end

"""
    Entity(ecs_manager::ECSManager, name::String="")

Create an [`Entity`](entity) with the given name. The id of the entity is determined by the [`ECSManager`](ECS manager).

# Arguments
- `ecs_manager::ECSManager`: The [`ECSManager`](ECS manager) that keeps track of the entities.
- `name::String`: The name of the entity for logging purposes. Default is "".
"""
function Entity(ecs_manager::ECSManager; name::String="")
    if length(ecs_manager.free_ids) > 0
        id = pop!(ecs_manager.free_ids)
    else
        id = ecs_manager.max_id + 1
    end
    if id > ecs_manager.max_id
        ecs_manager.max_id = id
        push!(ecs_manager.free_ids, id + 1)
    end
    entity = Entity(id, name)
    push!(ecs_manager.entities, entity)
    return entity
end

export remove_entity!
"""
    remove_entity!(ecs_manager::ECSManager, entity::Entity)

Remove the given [`Entity`](entity) from the [`ECSManager`](ECS manager).

# Arguments
- `ecs_manager::ECSManager`: The [`ECSManager`](ECS manager) that keeps track of the entities.
- `entity::Entity`: The [`Entity`](entity) to remove.
"""
function remove_entity!(ecs_manager::ECSManager, entity::Entity)
    ecs_manager.entities = filter!(x -> x.id != entity.id, ecs_manager.entities)
    push!(ecs_manager.free_ids, entity.id)
end

export add_component!
"""
    add_component!(ecs_manager::ECSManager, entity::Entity, component::Component)

Add the given [`Component`](component) to the given [`Entity`](entity) in the [`ECSManager`](ECS manager).

# Arguments
- `ecs_manager::ECSManager`: The [`ECSManager`](ECS manager) that keeps track of the entities.
- `entity::Entity`: The [`Entity`](entity) to add the [`Component`](component) to.
- `component::Component`: The [`Component`](component) to add to the [`Entity`](entity).
"""
function add_component!(ecs_manager::ECSManager, entity::Entity, component::Component)
    component_type = typeof(component)
    if !haskey(ecs_manager.components, component_type)
        ecs_manager.components[component_type] = Dict{Entity, Component}()
    end
    component_dict = ecs_manager.components[component_type]
    component_dict[entity] = component
end

"""
    add_component(ecs_manager::ECSManager, entity::Entity, component::Transform2D)

Add all fields of the given [`Transform2D`](transform) to the given [`Entity`](entity) in the [`ECSManager`](ECS manager).

# Arguments
- `ecs_manager::ECSManager`: The [`ECSManager`](ECS manager) that keeps track of the entities.
- `entity::Entity`: The [`Entity`](entity) to add the [`Transform2D`](transform) to.
- `component::Transform2D`: The [`Transform2D`](transform) to add to the [`Entity`](entity).
"""
function add_component!(ecs_manager::ECSManager, entity::Entity, component::Transform2D)
    for comp in [getfield(component, field) for field in fieldnames(Transform2D)]
        add_component!(ecs_manager, entity, comp)
    end
end


# ------------
# System 
# ------------

function set_origin!(ecs_manager::ECSManager, entity::Entity, x::Float64, y::Float64)
    origin = Origin2D(x, y)
    add_component!(ecs_manager, entity, origin)
end



end
