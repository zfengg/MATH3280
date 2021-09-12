using Combinatorics

# check the formula in Example 3(c)
numCardPerColor = 4
numColors = 2

function count_partition(numCardPerColor, numColors)
    numTotalCards = numCardPerColor * numColors
    container = []
    for perm in permutations(1:numTotalCards)
		tmpPartition = []
		for j in 1:numColors
			push!(tmpPartition, perm[(j - 1) * numCardPerColor + 1:j * (numCardPerColor)])
		end
		flag = true
		for j in 1:numColors
			if sum(tmpPartition[j] .<= numCardPerColor) == 0
				flag = false
			end	
		end
		if flag
			push!(container, Set.(tmpPartition))
			unique!(container)
		end
    end
    return length(container), container
end

countTargets, allTargets = count_partition(numCardPerColor, numColors)

# formula results in Example 3(c)
probUnionC = binomial(4, 1) * binomial(39, 13) // binomial(52, 13) 
			- binomial(4, 2) * binomial(39, 26) // binomial(52, 26) 
			+ binomial(4, 3) * binomial(39, 39) // binomial(52, 39) 
probAsLeast1Heart = 1 - probUnionC # 316451606//333515525 = 0.9488362078496946..