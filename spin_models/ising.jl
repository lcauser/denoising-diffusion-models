"""
    metropolis(σ, β)

Perform a metropolis update on an Ising spin configuration σ at temperature β.
"""
function metropolis!(σ, β)
    # Find the dimensions & randomly select spin to update
    dims = size(σ)
    indexs = collect(rand(1:dims[i]) for i in eachindex(dims))

    # Find the difference in energy 
    ΔE = 0
    for i in eachindex(dims)
        ΔE -= 2 * σ[indexs...] * σ[collect((i == j ? ((indexs[j]) % dims[j] + 1) : indexs[j] for j in eachindex(dims)))...]
        ΔE -= 2 * σ[indexs...] * σ[collect((i == j ? (indexs[j] - 1 == 0 ? dims[j] : indexs[j] - 1) : indexs[j] for j in eachindex(dims)))...]
    end
    #println(σ)
    #println(indexs)
    #println(ΔE)
    #println(exp(β*ΔE))

    # Randomly choose to flip spin 
    σ[indexs...] = exp(β*ΔE) > rand() ? -σ[indexs...] : σ[indexs...]
end


σ = rand([1, -1], (100, 100))
for i = 1:10000000
    metropolis!(σ, 1.0 * log(1 + sqrt(2)) / 2)
end
println(sum(σ) / 400)