include("../src/pagerank.jl")

using .PageRank

exampleNetwork = float([
    0 0 1 0;
    1 0 0 0;
    1 1 0 1; 
    0 0 0 0;

])

println(page_rank_vector(exampleNetwork, 0.85))