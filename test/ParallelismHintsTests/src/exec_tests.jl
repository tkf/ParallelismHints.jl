using ParallelismHints
using Test

@testset begin
    @test !ParallelismHints.is_parallelized()
    @test ParallelismHints.within_parallel(ParallelismHints.is_parallelized)
end
