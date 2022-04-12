using ContextVariablesX: @contextvar, with_context

@contextvar IS_PARALLELIZED::Bool = false

ParallelismHints.is_parallelized() = IS_PARALLELIZED[]
ParallelismHints.within_parallel(f::F) where {F} = with_context(f, IS_PARALLELIZED => true)
