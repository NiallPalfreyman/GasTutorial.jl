using GasTutorial
using Test

@testset "GasTutorial.jl" begin
    @test 0.49 < GasTutorial.niall() < 0.51
end
