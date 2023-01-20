export IntervalMatrix

# we define a Real IntervalMatrix

struct IntervalMatrix{T<:Real}
    mA::Matrix{T}
    rA::Matrix{T}
end

"""
    Return the midpoint and radius matrices of A
"""
midpoint_radius(A::IntervalMatrix) = (A.mA, A.rA)


function IntervalMatrix(A::AbstractMatrix{Interval{T}}) where {T<:Real}
    Ainf = inf.(A)
    Asup = sup.(A)

    mA, rA = setrounding(T, RoundUp) do
        mA = Ainf + 0.5 * (Asup - Ainf)
        rA = mA - Ainf
        return mA, rA
    end
    return IntervalMatrix(mA, rA)
end

function *(::MultiplicationType{:fast},
            A::IntervalMatrix{T},
            B::IntervalMatrix{T}) where {T<:Real}
    
    mA, rA = midpoint_radius(A)
    mB, rB = midpoint_radius(B)
    
    R, Csup = setrounding(T, RoundUp) do
        R = abs.(mA) * rB + rA * (abs.(mB) + rB)
        Csup = mA * mB + R
        return R, Csup
    end

    Cinf = setrounding(T, RoundDown) do
        mA * mB - R
    end
    
    # this is ugly
    return IntervalMatrix(Interval.(Cinf, Csup))
end

function *(::MultiplicationType{:fast},
    A::AbstractMatrix{T},
    B::IntervalMatrix{T}) where {T<:Real}

    mB, rB = midpoint_radius(B)

    R, Csup = setrounding(T, RoundUp) do
        R = abs.(A) * rB
        Csup = A * mB + R
        return R, Csup
    end

    Cinf = setrounding(T, RoundDown) do
        A * mB - R
    end

    # this is ugly
    return IntervalMatrix(Interval.(Cinf, Csup))
end

function *(::MultiplicationType{:fast},
    A::IntervalMatrix{T},
    B::AbstractMatrix{T}) where {T<:Real}

    mA, rA = midpoint_radius(A)

    R, Csup = setrounding(T, RoundUp) do
        R = rA * abs.(B)
        Csup = mA * B + R
        return R, Csup
    end

    Cinf = setrounding(T, RoundDown) do
       mA * B - R
    end

    # this is ugly
    return IntervalMatrix(Interval.(Cinf, Csup))
end