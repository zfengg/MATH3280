### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 70629276-0e5a-11ec-06c2-2367d5e312ea
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["PlutoUI", "Plots"])
	
	using PlutoUI
	using LinearAlgebra: dot
	using Plots: plot
end

# ╔═╡ 7e0a15c4-f1ad-4ec5-a982-dccf833d1af8
md"""
# MATH3280A Tutorial 1
"""

# ╔═╡ 50bcfd4a-50f7-4aec-a6cc-d01e7eb8d4c3
TableOfContents()

# ╔═╡ 165bb169-1f08-4f53-a9c1-bf46c3935aab
md"""
## A counting example
Let `` k \geq 2 `` a integer and ``t = (t_1, \ldots, t_k) `` be a vector of non-negative integers.

For each ``0 \leq s \leq (t_1 + \cdots + t_k)``, how many vectors ``(n_1, \ldots, n_k)`` are there such that
```math
\begin{cases}
n_1 + \cdots + n_k = s \\
0 \leq n_i \leq t_i \,\quad, \forall\, 1 \leq i \leq k
\end{cases} \qquad ? 
```
We denote the total number of such vectors by ``N_{t}(s)`` as a function depending on the treshold ``t`` and the target sum ``s``.
"""

# ╔═╡ 346f3ffb-03dc-46db-8ea6-376eea27d8ed
md"""
**A theoretical formula:**
For ``0 \leq i \leq k``, define
```math
	T_i := \Big \{ t\cdot b\, \colon b\in \{0,1\}^{k} \mbox{ and } \|b \|_1 = i \Big\},
```
then
```math
 N_{t}(s) = \sum_{i=0}^{k} (-1)^{i} \sum_{x\in T_i} 
\begin{pmatrix}
	s - (x+i) + k - 1 \\
	k - 1
\end{pmatrix} \chi_{[x+i, +\infty)}(s) \quad .
```


"""

# ╔═╡ 7f6ee905-17c3-4bf9-b28b-e3ecd3cd66a0
md"""
### Specific setup
"""

# ╔═╡ 3195a541-0762-412a-8cc2-e6ffbfb6e717
t = [12, 10, 25] .|> Int

# ╔═╡ 530489b7-9332-43d8-b35a-38eb0470803b
md"""
``s = ``$(@bind targetSum Slider(0:sum(t); show_value=true))
"""

# ╔═╡ 777f2f48-bc0e-4de6-9bc2-6b79a6eda746
md"""
### Plot the outcomes
"""

# ╔═╡ eff0da72-e09c-4e2e-ae41-7e325c58cd0d
md"""
## Appendix
"""

# ╔═╡ 848d91a9-668d-4939-8c55-4592aabecd19
# brute force
function count_outcome(thresholds, targetSum)
    lenStack = length(thresholds)
    stack = zeros(Int, lenStack)

    container = []
    while stack[1] <= thresholds[1]
		if sum(stack) == targetSum
			push!(container, copy(stack))
		end

		stack[end] += 1
		for i = lenStack:-1:2
			if stack[i] > min(thresholds[i], targetSum)
				stack[i] = zero(Int)
				stack[i - 1] += 1
    		else
				break
			end
		end
    end
    unique!(container)
    numOutcome = length(container)
    return numOutcome, container
end

# ╔═╡ db25df5f-3777-4a9d-889d-439fd6cb79f6
function count_outcomes(thresholds)
	targetSums = collect(0:sum(thresholds))
	numOutcomes = zeros(Int, length(targetSums))
	for i in 1:length(targetSums)
		numOutcomes[i] = count_outcome(thresholds, targetSums[i])[1]
	end
	return numOutcomes
end

# ╔═╡ 23dd6a72-ab38-4e43-9419-526e309a564f
countOutcomes = count_outcomes(t)

# ╔═╡ d90734d1-df13-4b27-8c48-bb04eaeb46aa
plot(0:sum(t), countOutcomes;
	legend=false,
	title="Count by enumeration")

# ╔═╡ 39b7056a-b923-41d4-ab13-9c3a3e4d1e7e
# formula outcomes
function formula_outcome(t, s)
	k = length(t)
	binaryIndex = zeros(Bool, k)
	outcome = zero(Int)
	while true
		x = dot(t, binaryIndex)
		i = sum(binaryIndex)
		if s >= x + i
			outcome += (-1)^(i) * binomial(s - (x + i) + k - 1, k - 1)
		end
		# update binaryIndex
		indexFirstFalse = findfirst(!, binaryIndex)
		if indexFirstFalse === nothing
			break
		end
		binaryIndex[indexFirstFalse] = true
		if indexFirstFalse > 1
			binaryIndex[1:indexFirstFalse - 1] .= false
		end
	end
	return outcome
end

# ╔═╡ 1911a59d-79c5-4c49-ba28-8b0042cbc210
md"""
Count by enumeration: ``C_{t}(s) = `` $(count_outcome(t, targetSum)[1]).

Output by formula: ``N_{t}(s) = `` $(formula_outcome(t, targetSum)[1]).

All outcomes:
"""

# ╔═╡ d4d6483d-ca93-401b-a1dd-ba309d6b448f
function formula_outcomes(t)
	targetSums = collect(0:sum(t))
	formulaOutcomes = zeros(Int, length(targetSums))
	for i in 1:length(targetSums)
		formulaOutcomes[i] = formula_outcome(t, targetSums[i])
	end
	return formulaOutcomes
end

# ╔═╡ 9a438266-21df-48f5-a2a9-1cdb0d6130a2
formulaOutcomes= formula_outcomes(t)

# ╔═╡ 6f25fc96-ae56-4236-86ff-c5ad6a5385bb
plot(0:sum(t), formulaOutcomes;
	color=:red,
	legend=false,
	title="Output by formula")

# ╔═╡ Cell order:
# ╟─70629276-0e5a-11ec-06c2-2367d5e312ea
# ╟─7e0a15c4-f1ad-4ec5-a982-dccf833d1af8
# ╟─50bcfd4a-50f7-4aec-a6cc-d01e7eb8d4c3
# ╟─165bb169-1f08-4f53-a9c1-bf46c3935aab
# ╟─346f3ffb-03dc-46db-8ea6-376eea27d8ed
# ╟─7f6ee905-17c3-4bf9-b28b-e3ecd3cd66a0
# ╠═3195a541-0762-412a-8cc2-e6ffbfb6e717
# ╟─530489b7-9332-43d8-b35a-38eb0470803b
# ╟─1911a59d-79c5-4c49-ba28-8b0042cbc210
# ╟─23dd6a72-ab38-4e43-9419-526e309a564f
# ╟─9a438266-21df-48f5-a2a9-1cdb0d6130a2
# ╟─777f2f48-bc0e-4de6-9bc2-6b79a6eda746
# ╟─d90734d1-df13-4b27-8c48-bb04eaeb46aa
# ╟─6f25fc96-ae56-4236-86ff-c5ad6a5385bb
# ╟─eff0da72-e09c-4e2e-ae41-7e325c58cd0d
# ╟─848d91a9-668d-4939-8c55-4592aabecd19
# ╟─db25df5f-3777-4a9d-889d-439fd6cb79f6
# ╟─39b7056a-b923-41d4-ab13-9c3a3e4d1e7e
# ╟─d4d6483d-ca93-401b-a1dd-ba309d6b448f
