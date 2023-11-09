module RunModule

# External Packages

# Internal Packages
include("ECSModule.jl")
using .ECSModule

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
