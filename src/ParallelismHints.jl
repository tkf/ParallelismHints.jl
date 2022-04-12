baremodule ParallelismHints

function is_parallelized end
function within_parallel end

baremodule Experimental
function set_context_backend end
end  # baremodule Experimental

module Internal

using ExternalDocstrings: @define_docstrings
using Preferences: @load_preference, @set_preferences!

using ..ParallelismHints: Experimental, ParallelismHints

include("preferences.jl")

const CONTEXT_BACKEND = safe_load_context_backend_preference()

if CONTEXT_BACKEND === :contextvariablesx
    include("backend_contextvariablesx.jl")
else
    include("backend_atomics.jl")
end

end  # module Internal

Internal.@define_docstrings

end  # baremodule ParallelismHints
