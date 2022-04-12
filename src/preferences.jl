const BACKEND_KEY = "context_backend"
const VALID_BACKENDS = (:contextvariablesx, :atomics)

function safe_load_context_backend_preference()
    try
        load_context_backend_preference()
    catch err
        @error(
            "Error while loading context backend preference",
            exception = (err, catch_backtrace())
        )
        :atomics
    end::Symbol
end

function load_context_backend_preference()
    return validate_context_backend_preference(
        @load_preference(BACKEND_KEY, "atomics")
    )::Symbol
end

function validate_context_backend_preference(str::AbstractString)
    backend = Symbol(lowercase(str))
    if backend ∉ VALID_BACKENDS
        error("invalid backend: ", str)
    end
    backend
end

function Experimental.set_context_backend(backend::Symbol)
    backend = validate_context_backend_preference(string(backend))
    if CONTEXT_BACKEND == backend
        @info("Context backend was already set to $backend")
        return
    end
    @set_preferences!(BACKEND_KEY => string(backend))
    @info("New backend set; restart your Julia session for this change to take effect!")
end
