module RunModule

# External Packages
using Reexport

# Internal Packages
include("ECSModule.jl")
@reexport using .ECSModule
include("PhysicsModule.jl")
@reexport using .PhysicsModule

# Exports
export run_OdysseusEngine

"""
    run_OdysseusEngine(toml::Dict{String, Any})

Main entrance function for the package

# Arguments
- `toml::Dict{String, Any}`: Input toml file containing all options for the package
"""
function run_OdysseusEngine(toml::Dict{String, Any})
end

end
