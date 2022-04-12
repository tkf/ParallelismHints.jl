module TestCore

using ParallelismHints
using Test

exec_tests_path() = joinpath(@__DIR__, "exec_tests.jl")

test_exec() = Core.include(Module(), exec_tests_path())

function check_backend(backend)
    mktempdir(; prefix = "jl_ParallelismHintsTests_") do dir
        write(
            joinpath(dir, "Project.toml"),
            """
            [deps]
            ParallelismHints = "46c41b0e-a2c8-4d01-b46f-57b962fbffd7"
            Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
            """
        )

        write(
            joinpath(dir, "LocalPreferences.toml"),
            """
            [ParallelismHints]
            context_backend = "$backend"
            """
        )

        cmd = Base.julia_cmd()
        @info "Running tests with backend `$backend`"
        exec_tests = """
        $(Base.load_path_setup_code())
        pushfirst!(LOAD_PATH, $(repr(dir)))

        include($(repr(exec_tests_path())))

        using Test, ParallelismHints
        @test ParallelismHints.Internal.CONTEXT_BACKEND === :$backend
        """
        run(`$cmd --startup-file=no -e $exec_tests`)
    end
end

test_backend_atomics() = check_backend(:atomics)
test_backend_contextvariablesx() = check_backend(:contextvariablesx)

end  # module
