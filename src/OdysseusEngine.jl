module OdysseusEngine

# External packages
using TOML
using BetterInputFiles 
using ArgParse
using StatProfilerHTML
using Reexport

# Internal Packages
include("RunModule.jl")
@reexport using .RunModule

# Exports
export main 

"""
    get_args()

Helper function to get the ARGS passed to julia.
"""
function get_args()
    s = ArgParseSettings()
    @add_arg_table! s begin
        "--verbose", "-v"
            help = "Increase level of logging verbosity"
            action = :store_true
        "--profile", "-p"
            help = "Run profiler"
            action = :store_true
        "input"
            help = "Path to .toml file"
            required = true
    end
    return parse_args(s)
end

"""
    main()

Read the args, prepare the input TOML and run the actual package functionality.
"""
function main()
    args = get_args()
    verbose = args["verbose"]
    toml_path = args["input"]
    profile = args["profile"]
    main(toml_path, verbose, profile)
end

function main(toml_path::AbstractString, verbose::Bool, profile::Bool)
    toml = setup_input(toml_path, verbose)
    if profile 
        @profilehtml run_OdysseusEngine(toml)
    else
        run_OdysseusEngine(toml)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

end
