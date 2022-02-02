module PageRank

using LinearAlgebra

export page_rank_vector

""" 

Function which generates a matrix S coorisponding to a specific adjacency
matrix A for a given network.

# Parameters

    A::Matrix{Float64}
        Adjacency matrix of the network. A_{i,j} is 1 if an edge exists from 
        j to i, otherwise it is 0. Must be square.

# Returns 
    
        S::Matrix{Float64}
            Matrix S corresponding to the adjacency matrix A. An intermidiate 
            step in creating the PageRank matrix.

"""
function S_matrix(A::Matrix{Float64})
    # Check for square matrix
    if size(A)[1] != size(A)[2]
        throw(DomainError(A, "A must be a square matrix.")) # throw error on non-square matrix
    end # if square matrix

    # get row vector with each column being the sum of the coorisponding column in A
    columnSums = ones(1, size(A)[1])*A 
    
    # get all the columns with no entries (this coorisponds to the nodes with no outward connections)
    noOutwardConnections = findall(x->x==0, columnSums)
    danglingNodeColumns = [x[2] for x in noOutwardConnections] # strip just the column indicies from above vector

    # if dangling nodes exist, replace scaler in scaling column with 1 temporarily to avoid divide by 0
    if length(danglingNodeColumns) > 0
        for i in danglingNodeColumns
            columnSums[i] = 1
        end # for
    end # if dangling nodes exist

    # divide all elements in each column by sum of column 
    S = A./columnSums 

    # if dangling nodes exist, replace column in S with 1/N 
    if length(danglingNodeColumns) > 0
        for j in danglingNodeColumns # loop through all column indicies coorisponding to dangling nodes
            for i in 1:size(A)[1] #loop through all row indicies
                S[i, j] = 1/size(A)[1] # replace dangling node column with 1/N
            end # for i
        end # for j
    end # if dangling nodes exist

    S 

end # function S_matrix

""" 
Contructs the "Google Matrix" from the S matrix which is just a few changes
from S. 

# Parameters

    S::Matrix{Float64}
        Matrix S corresponding to the adjacency matrix A. An intermidiate 
        step in creating the PageRank matrix.

    d::Float64
        The damping factor.

# Returns 
    
        G::Matrix{Float64}
            Matrix G, the Google matrix.

"""
function G_matrix(S::Matrix{Float64}, d::Float64)
    G = d.*S .+ (1-d)/size(S)[1] # multiply S by d and add 1-d/N to each element

end # function G_matrix

""" 
Computes the PageRank vector for a given network. Uses the eigenvector method
as opposed to the power convergence method.

# Parameters

    A::Matrix{Float64}
        Adjacency matrix of the network. A_{i,j} is 1 if an edge exists from 
        j to i, otherwise it is 0. Must be square.

    d::Float64
        The damping factor.

"""
function page_rank_vector(A::Matrix{Float64}, d::Float64)
    # computes the S matrix 
    S = S_matrix(A) 

    # computes the G matrix
    G = G_matrix(S, d)

    # computes the eigenvector corresponding to the largest eigenvalue
    gEigenvalues = eigvals(G)
    gEigenvectors = eigvecs(G)

    # find differences in eigenvalues and 1 (need the eigenvalue equal to 1, but Julia isn't 100% accurate)
    eigenvalueDiff = [] # empty vector
    for evalue in gEigenvalues 
        if typeof(evalue) <: ComplexF64 # if the eigenvalue is a float, give difference of 1 if significant complex part 
            if imag(evalue) > 1e-8
                push!(eigenvalueDiff, 1.0) # push difference of 1 if imaginary part is significant 
            else
                push!(eigenvalueDiff, abs(1.0-real(evalue))) # push difference of 1 in real part
            end # if imag
        
        else # if just a float, then get difference from 1 
            push!(eigenvalueDiff, abs(1.0-evalue))
        end # if complex 
    end # for evalue

    # find index of eigenvalue closest to 1 
    index = findmin(eigenvalueDiff)

    # find the eigenvector corresponding to the maximum eigenvalue
    maxEigenvector = gEigenvectors[:, index[2]]

    real.(maxEigenvector) # get the real part of the eigenvector

end # function PageRank

end # module PageRank