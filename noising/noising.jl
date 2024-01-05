using Distributions

function noise(x, β)
    # Calculate mean and variance 
    μ = sqrt(1 - β)*x
    σ = sqrt(β)

    # Sample 
    return rand(Normal(μ, σ))
end

function linear_variance_scheduele(β_start, β_end, steps)
    β_increment = (β_end - β_start) / (steps-1)
    βs = collect(β_start:β_increment:β_end)
    αs = cumprod(1 .- βs)
    return βs, 1 .- αs
end

function noise_trajectory(x, βs)
    x_traj = zeros(length(βs)+1, size(x)...)
    x_traj[begin, repeat([:], length(size(x)))...] = x
    for i in eachindex(βs)
        x_traj[i+1, repeat([:], length(size(x)))...] = noise.(x_traj[i, repeat([:], length(size(x)))...], βs[i])
    end
    return x_traj
end