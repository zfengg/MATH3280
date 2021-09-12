using Combinatorics

# Example 3 formula values
# (a) = 1//158753389900 = 6.299078089796431e-12
pA = 4 // binomial(52, 13) |> Float64

# (b) = 2197//20825 = 0.10549819927971188
pB = (factorial(4) * multinomial(BigInt(12), BigInt(12), BigInt(12), BigInt(12))) // multinomial(BigInt(13), BigInt(13), BigInt(13), BigInt(13))
pB = Float64(pB)

# (c) = 316451606//333515525 = 0.9488362078496946..
probUnionC = binomial(4, 1) * binomial(39, 13) // binomial(52, 13)
			- binomial(4, 2) * binomial(39, 26) // binomial(52, 26)
			+ binomial(4, 3) * binomial(39, 39) // binomial(52, 39)
pC = 1 - probUnionC |> Float64


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
