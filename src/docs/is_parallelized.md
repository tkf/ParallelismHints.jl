    ParallelismHints.is_parallelized() -> ans::Bool

Return `true` if the caller (a function providing parallelized implementation) is _advised_
to be parsimonious for using parallel computing resources.

The context in which `is_parallelized` returns `true` can be opened using
[`within_parallel`](@ref).

# Examples

```julia
julia> using ParallelismHints

julia> ParallelismHints.is_parallelized()
false

julia> ParallelismHints.within_parallel() do
           ParallelismHints.is_parallelized()
       end
true
```

# Extended help

This function returns `true` if it is called within a call stack/task context that is
parallelized.  For example, `is_parallelized()` called in a function `f` that is passed to
parallel `map(f, xs)` may return `true`.

The easiest strategy for a library is to switch to a serial implementation.  This may be the
best strategy where parallel algorithm is known to have a larger amount of _work_ compared
to the serial algorithm in order to have a short _span_ (see: [Analysis of parallel
algorithms - Wikipedia](https://en.wikipedia.org/wiki/Analysis_of_parallel_algorithms)).
For example, parallel prefix sum is a good example.

A more nuanced approach may be to use this value for reducing the amount of exposed
parallelisms (e.g., the number of tasks spawned).  A good way to implement this is to
implement a library API that takes an execution parameter (say) `basesize` that sets the
minimum amount of work to be done for each task and use the default `basesize =
is_parallelized() ? 1_000_000 : cld(total_work, nthreads())` where `1_000_000` is a
conservative guess of the work to be done in a single task such that the task overheads is
relatively negligible.

For libraries that tune the performance with cache locality consideration, it may be a good
idea to simply ignore this function and parallelize at the inner most level.
