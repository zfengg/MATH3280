### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ f170ec96-5009-11ec-1ba2-7341c7165ed1
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["PlutoUI", "Plots", "Distributions", "LaTeXStrings"])
	
	using PlutoUI
	using LaTeXStrings
	using Distributions
	using LinearAlgebra: dot
	using Plots
end

# ╔═╡ c5b93aff-2406-43d4-8d1b-4e1e02c6e4b6
# meta-settings
begin
	## slider
	nMax = 10^6
	nMin = 10
	nStep = 100

	## canvas
	dWidth = 750
	dHeight = 500
	println("")
end

# ╔═╡ b8f72b0c-4e18-4d11-9ddf-67fec171cc87
md"""
# MATH3280 Tutorial 13
"""

# ╔═╡ c18d5418-fa40-49ad-81b1-32d46732ff48
TableOfContents()

# ╔═╡ 58630a30-f6be-44d4-b733-40ebcd88cb71
md"""
## Strong Law of Large number
"""

# ╔═╡ 2e5a1d06-1f94-4b82-b7c6-aaddccde3963
p = [0.1, 0.2, 0.3, 0.35, 0.05]; # make sure p is a probability vector

# ╔═╡ fcfe51e7-4f90-489a-aaf6-d0527ecdfd71
md"""
``n = `` $(@bind n Slider(nMin:nStep:nMax; default=1000, show_value=true)) ``\quad``
$(@bind go Button("Run! 🚀"))
"""

# ╔═╡ 327f1b7e-055d-42d8-9480-fbe1c1ee14d6
d = Categorical(p);

# ╔═╡ e546ded3-9fa9-4e71-9aca-0c0754dcef92
begin
	go
	samples = rand(d, n) .- 1
	
	v = collect(0:length(p)-1)
	countings = [count(samples .== i) for i in v]
	SMean = dot(v, countings) / n
	TMean = dot(v, p)
	annLLN = zip(v, countings .+ 0.02 * maximum(countings), zip(countings, fill(:auto, n))) |> collect
	
	histogram(samples;
		title="Theoretical Mean = $(TMean)\nSample Mean = $(SMean)\n",
		xlims=(-1, length(p)),
		label="count",
		bar_width=0.9,
		# bar_edges=true,
		size=(dWidth, dHeight),
		annotations = annLLN
	)
end

# ╔═╡ f597f24e-cfbf-4f35-9597-0a1b7a9617a3
if ! isprobvec(p)
	md"""
	!!! danger "Error"
		Please make sure `p` is a probability vector 🍺!
	"""
end

# ╔═╡ 5ce391ee-687f-457f-bf54-215c4133f34b
md"""
## Central Limit Theorem
"""

# ╔═╡ 0fba82bf-2cc4-4634-84b9-3e65270417ba
md"""
``Bin(n,p)`` with
``n = `` $(@bind bn Slider(1:1:nMax; default = 200000, show_value=true))
``\quad``
``p = `` $(@bind bp Slider(0.01:0.01:1; show_value=true))

"""

# ╔═╡ 2329019d-9e86-412e-b5d6-18b1535afccb
md"""
Sample size = $(@bind nBin NumberField(1000:100000; default=10000))
``\qquad``
$(@bind go2 Button("Run! 🚀"))
"""

# ╔═╡ 4b4e1d42-b700-4793-9f7c-8b73efc40b2f
bd = Binomial(bn, bp);

# ╔═╡ acd21c2a-0fb6-4c7a-9b93-aeb882230b0c
begin
	go2
	sampleBin = (rand(bd, nBin) .- mean(bd)) ./ std(bd)
	
	histogram(sampleBin;
			alpha=0.3,
			norm=true,
			bins=min(bn, 100),
			leg=false, 
			title="Sample from Bin($(bn), $(bp))",
			size=(680, 500),
			xlims=(-6, 6),
			ylims=(0, 0.5)
	)
	
	plot!(-6:0.01:6, x -> pdf(Normal(), x), lw=2)

end

# ╔═╡ dfa89323-f047-4010-98a0-84a56ef8c550
md"""
## Normal Distributions
"""

# ╔═╡ a7f9de36-3d60-4e71-8f93-4deb6b413407
md"
``μ =`` $(@bind μ Slider(-4:0.01:4, show_value=true, default=0.0)) ``\quad`` 
``σ =`` $(@bind σ Slider(0.01:0.01:3, show_value=true, default=1.0))
"

# ╔═╡ fcc70e81-da9e-4dd7-a145-eac6180037f8
begin
	xLim = 6
	
	plot(-6:0.01:6, x -> pdf(Normal(μ, σ), x);
		title="N($(μ), $(σ))",
		lw=2,
		leg=false,
		size=(680, 500),
		xlims=(-xLim, xLim),
		ylims=(0, 1),
		framestyle=:axes,
		xguideposition=:top,
		yguideposition=:left
	)
	
	plot!((μ - σ):0.01:(μ + σ), x -> pdf(Normal(μ, σ), x);
		fill=true,
		alpha=0.2,
		c=:purple
	)
	
	plot!([μ, μ], [0.05, pdf(Normal(μ, σ), μ)];
		ls=:dash, lw=1, c=:blue)
	annotate!(μ, 0.03, text(L"$\mu$", :blue))
	
	plot!([μ + σ, μ + σ], [0.01, pdf(Normal(μ, σ), μ + σ)];
		ls=:dash, lw=1, c=:green)
	annotate!(μ + σ, 0.03, text(L"$ \mu + \sigma$", :green, :left))
	plot!([μ - σ, μ - σ], [0.01, pdf(Normal(μ, σ), μ - σ)];
		ls=:dash, lw=1, c=:green)
	annotate!(μ - σ, 0.03, text(L"$ \mu - \sigma$", :green, :right))
	
	plot!([-xLim, μ], [pdf(Normal(μ, σ), μ), pdf(Normal(μ, σ), μ)];
		ls=:dash, lw=1, c=:red)
	annotate!(-xLim+.6, pdf(Normal(μ, σ), μ)+0.08,
		text(L"$\frac{1}{\sqrt{2\pi}\sigma}$", :red), :right)
	
end

# ╔═╡ Cell order:
# ╟─f170ec96-5009-11ec-1ba2-7341c7165ed1
# ╟─c5b93aff-2406-43d4-8d1b-4e1e02c6e4b6
# ╟─b8f72b0c-4e18-4d11-9ddf-67fec171cc87
# ╟─c18d5418-fa40-49ad-81b1-32d46732ff48
# ╟─58630a30-f6be-44d4-b733-40ebcd88cb71
# ╠═2e5a1d06-1f94-4b82-b7c6-aaddccde3963
# ╟─fcfe51e7-4f90-489a-aaf6-d0527ecdfd71
# ╟─e546ded3-9fa9-4e71-9aca-0c0754dcef92
# ╟─327f1b7e-055d-42d8-9480-fbe1c1ee14d6
# ╟─f597f24e-cfbf-4f35-9597-0a1b7a9617a3
# ╟─5ce391ee-687f-457f-bf54-215c4133f34b
# ╟─0fba82bf-2cc4-4634-84b9-3e65270417ba
# ╟─2329019d-9e86-412e-b5d6-18b1535afccb
# ╟─acd21c2a-0fb6-4c7a-9b93-aeb882230b0c
# ╟─4b4e1d42-b700-4793-9f7c-8b73efc40b2f
# ╟─dfa89323-f047-4010-98a0-84a56ef8c550
# ╟─a7f9de36-3d60-4e71-8f93-4deb6b413407
# ╟─fcc70e81-da9e-4dd7-a145-eac6180037f8
