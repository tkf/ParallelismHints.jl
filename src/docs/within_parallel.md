    ParallelismHints.within_parallel(f) -> y

Evaluate `y = f()` in a context in which [`is_parallelized`](@ref) returns `true` and return
the value `y` returned from `f`.

This function is mainly intended to be used by the library authors for marking the code
region that uses parallelism (but not distributed or GPU-based ones that use "remote"
resources).  It can also be used by application programmers for composing libraries that do
not use ParallelismHints.jl with the ones that use.

# Examples

```JULIA
using ParallelismHints

ParallelismHints.within_parallel() do
    @sync begin
        Threads.@spawn f1()
        Threads.@spawn f2()
        f3()
    end
end
```

Note that it is not accurate to use

```JULIA
@sync begin
    ParallelismHints.within_parallel() do
        Threads.@spawn f1()
        Threads.@spawn f2()
        f3()
    end
end
```

because the tasks executing `f1` and `f2` may still be running in parallel after
`within_parallel` returns.

# Extended help

`within_parallel(f)` requires that parallel resources acquired during the execution of `f`
are all released before `f` returns.  For example,
[fork-join](https://en.wikipedia.org/wiki/Fork%E2%80%93join_model) (series-parallel)
parallelism or more in general [structured
concurrency](https://en.wikipedia.org/wiki/Structured_concurrency) is compatible with
`within_parallel(f)`.

However, "unstructured" concurrent code such as

```JULIA
ParallelismHints.within_parallel() do
    Threads.@spawn f1()
    f2()
end
```

is not compatible with `within_parallel`.
