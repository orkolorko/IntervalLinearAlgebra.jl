@testset "Real Interval Matrix type" begin

    A = [0..1 -0.5..0.5;
    -1..0.0 0.0]

    B = IntervalMatrix(A)
    mB, rB = midpoint_radius(B)

    @test all(mB .== [0.5 0.0; -0.5 0.0])
    @test all(rB .== [0.5 0.5; 0.5 0.0])

end