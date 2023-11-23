using OdysseusEngine
using Test

@testset "OdysseusEngine.jl" begin
    # Write your tests here.
    @testset "Component Bounds" begin
        @test_throws ArgumentError Origin2D(-1.0, 0.0)
        @test_throws ArgumentError Origin2D(0.0, -1.0)
        r1 = Rotation2D(0.5π)
        r2 = Rotation2D(2.5π)
        r3 = Rotation2D(-1.5π)
        r4 = Rotation2D(-3.5π)
        @test r1.θ ≈ r2.θ ≈ r3.θ ≈ r4.θ
        @test_throws ArgumentError Scale2D(-1.0, 1.0)
        @test_throws ArgumentError Scale2D(0.0, 1.0)
        @test_throws ArgumentError Scale2D(1.0, -1.0)
        @test_throws ArgumentError Scale2D(1.0, 0.0)
    end
    @testset "ECS Manager" begin
        em = ECSManager()
        e1 = Entity(em)
        @test e1.id == 0
        @test em.max_id == 0
        @test em.entities[1] == e1
        e2 = Entity(em)
        @test e2.id == 1
        @test em.max_id == 1
        @test em.entities[2] == e2
        @test em.free_ids == Vector{Int64}([2])
        remove_entity!(em, e1)
        e3 = Entity(em)
        @test e3.id == 0
        @test em.max_id == 1
        @test em.entities == Vector{Entity}([e2, e3])
        @test em.free_ids == Vector{Int64}([2])
        add_component!(em, e2, Transform2D())
        add_component!(em, e3, Origin2D())
        @test haskey(em.components, Origin2D)
        @test haskey(em.components, Position2D)
        @test length(em.components[Origin2D]) == 2
        @test length(em.components[Position2D]) == 1

        @testset "Basic Systems" begin
            set_component!(em, e2, Origin2D; x=0.0, y=0.0)
            origin = get_component(em, e2, Origin2D)
            @test origin.x == 0.0
            @test origin.y == 0.0
            shift_component!(em, e2, Origin2D; x=1.0, y=1.0)
            @test origin.x == 1.0
            @test origin.y == 1.0
        end

        remove_component!(em, e2, Origin2D)
        @test length(em.components[Origin2D]) == 1

        remove_component!(em, e3, Origin2D)
        @test !haskey(em.components, Origin2D)
    end
end
