# ECS Module
module ECSModule

# Internal Packages 

# External Packages 
using InteractiveUtils

# ------------
# Entities
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
# Components
# ------------
export Component
"""
    abstract type Component

Component is an abstract type that represents components.
"""
abstract type Component end

"""
    abstract type CompositeComponent <: Component

CompositeComponent is an abstract type that represents components that are made up of other components.
"""
abstract type CompositeComponent end

"""
    mutable struct Relative <: Component

Relative is a struct that represents a component that is relative to another component.

# Fields
- `main_component::Component`: The component that this component is relative to.
- `relative_component::Component`: The component that is relative to the main component.
- `offsets::Base.Pairs`: The offsets of the relative component from the main component.
"""
@kwdef mutable struct Relative <: Component
    main_component::Component
    relative_component::Component
    offsets::Base.Pairs
end

"""
    Relative(main_component::Component; offsets...)

Create a [`Relative`](relative) component that is relative to the given component.

# Arguments
- `main_component::Component`: The component that this component is relative to.
- `offsets...`: The offsets of the relative component from the main component.
"""
function Relative(main_component::Component; offsets...)
    relative_component = deepcopy(main_component)
    for (key, value) in offsets 
        setfield!(relative_component, key, getfield(relative_component, key) + value)
    end
    return Relative(main_component, relative_component, offsets)
end

# ------------
# ECS Manager
# ------------

export ECSManager
"""
    mutable struct ECSManager

ECSManager provides functionality to create and remove [`Entity`](entity) objects. It also keeps track of the maximum id and free ids for creating new entities.

# Fields
- `max_id::Int64`: The maximum id of the entities created so far.
- `free_ids::Vector{Int64}`: The ids of the entities that have been removed and can be reused.
- `entities::Vector{Entity}`: The entities that have been created.
- `components::Dict{DataType, Dict{Entity, Component}}`: A dictionary that maps component types to a dictionary that map entities to components of that type.
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
    add_component(ecs_manager::ECSManager, entity::Entity, component::CompositeComponent)

Add all fields of the given [`CompositeComponent`](composite component) to the given [`Entity`](entity) in the [`ECSManager`](ECS manager).

# Arguments
- `ecs_manager::ECSManager`: The [`ECSManager`](ECS manager) that keeps track of the entities.
- `entity::Entity`: The [`Entity`](entity) to add the [`CompositeComponent`](composite component) to.
- `component::CompositeComponent`: The [`CompositeComponent`](composite component) to add to the [`Entity`](entity).
"""
function add_component!(ecs_manager::ECSManager, entity::Entity, component::CompositeComponent)
    for comp in [getfield(component, field) for field in fieldnames(typeof(component))]
        add_component!(ecs_manager, entity, comp)
    end
end

export get_component
"""
    get_component(ecs_manager::ECSManager, entity::Entity, component_type::DataType)

Get the [`Component`](component) of the given type from the given [`Entity`](entity) in the [`ECSManager`](ECS manager).

# Arguments
- `ecs_manager::ECSManager`: The [`ECSManager`](ECS manager) that keeps track of the entities.
- `entity::Entity`: The [`Entity`](entity) to get the [`Component`](component) from.
- `component_type::DataType`: The type of the [`Component`](component) to get from the [`Entity`](entity).
"""
function get_component(ecs_manager::ECSManager, entity::Entity, component_type::DataType)
    if !haskey(ecs_manager.components, component_type)
        throw(ArgumentError("Entity does not have component of type $component_type"))
    end
    component_dict = ecs_manager.components[component_type]
    if !haskey(component_dict, entity)
        throw(ArgumentError("Entity does not have component of type $component_type"))
    end
    return component_dict[entity]
end

export set_component!
"""
    set_component!(ecs_manager::ECSManager, entity::Entity, component_type::DataType; kwargs...)

Set the [`Component`](component) of the given type to the given [`Entity`](entity) in the [`ECSManager`](ECS manager).

# Arguments
- `ecs_manager::ECSManager`: The [`ECSManager`](ECS manager) that keeps track of the entities.
- `entity::Entity`: The [`Entity`](entity) to set the [`Component`](component) to.
- `component_type::DataType`: The type of the [`Component`](component) to set to the [`Entity`](entity).
- `kwargs...`: The keyword arguments to pass to the constructor of the [`Component`](component). 
"""
function set_component!(ecs_manager::ECSManager, entity::Entity, component_type::DataType; kwargs...)
    component = component_type(;kwargs...)
    add_component!(ecs_manager, entity, component)
end

export shift_component!
"""
    shift_component!(ecs_manager::ECSManager, entity::Entity, component_type::DataType; kwargs...)

Shift the values of the fields of the [`Component`](component) of the given type in the given [`Entity`](entity) in the [`ECSManager`](ECS manager).

# Arguments
- `ecs_manager::ECSManager`: The [`ECSManager`](ECS manager) that keeps track of the entities.
- `entity::Entity`: The [`Entity`](entity) to shift the [`Component`](component) of.
- `component_type::DataType`: The type of the [`Component`](component) to shift in the [`Entity`](entity).
- `kwargs...`: The keyword arguments to pass to the constructor of the [`Component`](component).
"""
function shift_component!(ecs_manager::ECSManager, entity::Entity, component_type::DataType; kwargs...)
    component = get_component(ecs_manager, entity, component_type)
    for (key, value) in kwargs
        setfield!(component, key, getfield(component, key) + value)
    end
end

export remove_component!
"""
    remove_component!(ecs_manager::ECSManager, entity::Entity, component_type::DataType)

Remove the [`Component`](component) of the given type from the given [`Entity`](entity) in the [`ECSManager`](ECS manager).

# Arguments
- `ecs_manager::ECSManager`: The [`ECSManager`](ECS manager) that keeps track of the entities.
- `entity::Entity`: The [`Entity`](entity) to remove the [`Component`](component) from.
- `component_type::DataType`: The type of the [`Component`](component) to remove from the [`Entity`](entity).
"""
function remove_component!(ecs_manager::ECSManager, entity::Entity, component_type::DataType)
    if !haskey(ecs_manager.components, component_type)
        throw(ArgumentError("Entity does not have component of type $component_type"))
    end
    component_dict = ecs_manager.components[component_type]
    if !haskey(component_dict, entity)
        throw(ArgumentError("Entity does not have component of type $component_type"))
    end
    delete!(component_dict, entity)
    if length(component_dict) == 0
        delete!(ecs_manager.components, component_type)
    end
end

"""
    has_component(ecs_manager::ECSManager, entity::Entity, component_type::DataType)

Check if the given [`Entity`](entity) in the [`ECSManager`](ECS manager) has a [`Component`](component) of the given type.

# Arguments
- `ecs_manager::ECSManager`: The [`ECSManager`](ECS manager) that keeps track of the entities.
- `entity::Entity`: The [`Entity`](entity) to check for the [`Component`](component).
- `component_type::DataType`: The type of the [`Component`](component) to check for.
"""
function has_component(ecs_manager::ECSManager, entity::Entity, component_type::DataType)
    if !haskey(ecs_manager.components, component_type)
        return false
    end
    component_dict = ecs_manager.components[component_type]
    if !haskey(component_dict, entity)
        return false
    end
    return true
end

function shared_component!(ecs_manager::ECSManager, entity_1::Entity, entity_2::Entity, component_type::DataType)
    if !has_component(ecs_manager, entity_1, component_type)
        throw(ArgumentError("Entity 1 does not have component of type $component_type"))
    end
    component_dict = ecs_manager.components[component_type]
    component = component_dict[entity_1]
    add_component!(ecs_manager, entity_2, component)
end

# ------------
# Prebuilt Components
# ------------

for f in readdir(joinpath(@__DIR__, "Components"), join=true)
    if endswith(f, ".jl")
        println("Including $f")
        include(f)
    end
end

# ------------
# Prebuilt Systems
# ------------

for f in readdir(joinpath(@__DIR__, "Systems"), join=true)
    if endswith(f, ".jl")
        println("Including $f")
        include(f)
    end
end



end
