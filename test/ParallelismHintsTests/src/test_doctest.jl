module TestDoctest

using ParallelismHints
using Documenter

test() = doctest(ParallelismHints; manual = false)

end  # module
