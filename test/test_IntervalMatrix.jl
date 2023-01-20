@testset "Real Interval Matrix type" begin
    A = [Interval(0, 1) Interval(-0.5, 0.5);
    @interval(0.1) Interval(0.0)]

    B = IntervalMatrix(A)
    mB, rB = midpoint_radius(B)

    @test all(mB .== [0.5 0.0; mid(@interval(0.1)) 0.0])
    @test all(rB .== [0.5 0.5; radius(@interval(0.1)) 0.0])

end