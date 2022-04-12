const PARALLEL_REGION_DEPTH = Threads.Atomic{Int}(0)

ParallelismHints.is_parallelized() = PARALLEL_REGION_DEPTH[] != 0

function ParallelismHints.within_parallel(f)
    Threads.atomic_add!(PARALLEL_REGION_DEPTH, 1)
    try
        return f()
    finally
        Threads.atomic_sub!(PARALLEL_REGION_DEPTH, 1)
    end
end
