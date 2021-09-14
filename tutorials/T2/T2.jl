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

