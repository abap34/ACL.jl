using Test
using ACL

tests = ["floorsum"]

@testset "ACL" begin

for testname in tests
    @testset "$testname" begin
        include("$testname.jl")
    end
end

end

