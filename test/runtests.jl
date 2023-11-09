using OdysseusEngine
using Test

@testset "OdysseusEngine.jl" begin
    # Write your tests here.
    @testset "Component Bounds" begin
        @test_throws ArgumentError OdysseusEngine.RunModule.ECSModule.Origin2D(-1.0, 0.0)
        @test_throws ArgumentError OdysseusEngine.RunModule.ECSModule.Origin2D(0.0, -1.0)
    end
    @testset "ECS Manager" begin
        em = OdysseusEngine.RunModule.ECSModule.ECSManager()
        e1 = OdysseusEngine.RunModule.ECSModule.Entity(em)
        @test e1.id == 0
        @test em.max_id == 0
        @test em.entities[1] == e1
        e2 = OdysseusEngine.RunModule.ECSModule.Entity(em)
        @test e2.id == 1
        @test em.max_id == 1
        @test em.entities[2] == e2
        @test em.free_ids == Vector{Int64}([2])
        OdysseusEngine.RunModule.ECSModule.remove_entity!(em, e1)
        e3 = OdysseusEngine.RunModule.ECSModule.Entity(em)
        @test e3.id == 0
        @test em.max_id == 1
        @test em.entities == Vector{OdysseusEngine.RunModule.ECSModule.Entity}([e2, e3])
        @test em.free_ids == Vector{Int64}([2])
        OdysseusEngine.RunModule.ECSModule.add_component!(em, e2, OdysseusEngine.RunModule.ECSModule.Transform2D())
        OdysseusEngine.RunModule.ECSModule.add_component!(em, e3, OdysseusEngine.RunModule.ECSModule.Origin2D())
        @show em
        @test haskey(em.components, OdysseusEngine.RunModule.ECSModule.Origin2D)
        @test haskey(em.components, OdysseusEngine.RunModule.ECSModule.Position2D)
        @test length(em.components[OdysseusEngine.RunModule.ECSModule.Origin2D]) == 2
        @test length(em.components[OdysseusEngine.RunModule.ECSModule.Position2D]) == 1
    end
end
