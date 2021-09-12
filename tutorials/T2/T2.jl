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