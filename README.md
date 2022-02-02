# PageRank

This is my implementation of PageRank for my algorithms class. I am attempting to implement the algorithm that is vaguely described in this [wikipedia article](https://en.wikipedia.org/wiki/Google_matrix). Instead of using the more typical power convergence method, I will be using the Linear Algebra approach, utlizing the eigenvector coorisponding to the highest eigenvalue (equal to 1 with the matrices being used) as a probability distrubition for the sites in a network. 

## What is page rank? 

PageRank is an algorithm which is used to determine the "legitimacy" of a given site based on the amount of links that go to the site. This is scaled by the importance of the site which links to said site. Basically, the more links a certain site has to it (and the more important the sites linking are), the higher the PankRange score will be. Of course, the complexity of the algorithm is more in what is the chance that a random user, performing a random walk on the network, ends up on a given site. The more likely this is, the "better" the given site is. 

## My Implementation

In the introductory section I talked a bit about my implementation, but I will go into a bit more detail here (this is mostly outlined in the wikipedia article linked above). I start by taking the adjacency matrix formed by the network and constructing a new matrix, S, from it. For each row in S, it is the value it was for the adjacency matrix (so either 1 or 0), however divided by the total number of connections in that column. This process is the process of taking each connection from each node and dividing my the total number of connections from that node. When dividing, I temporarily ignore dangling nodes, nodes with no connections which would mean a divide by 0 error, and then subsitute all the column's values in S with 1/N (where N is the number of nodes). 

Once computing S, I then compute a new matrix G, which is calculated by: G_ij = d*S_ij + (1-d)/N. Here d is a dampening factor which is intended to be between 0 and 1. I believe the value 1-d represents the chance that someone will jump off a given page. From here, I simply compute the eigenvalues and eigenvectors of G, find the eigenvector coorisponding to a eigenvalue of 1, and return that value. In this process I have to do a bit of processing for complex numbers, however this is largely unimportant. Each entry in the returned eigenvector can be seen as proportional to the chance that some user ends up on that site. This means it can be used to rank sites based on importance. 

## Testing 

In ```test/``` there is a ```test_network.jl``` script which is my example network for the functionality of my implementation. This network was used as an example in my class lecture and I have computed values, however using the power convergence method, for the given sites. Therefore, I should get the same results if my implementation is correct. This was the network in picture form: 

![Alt text](/assets/exampleNetwork.png?raw=true "Example Network")

The lecture contained the following values from the PageRank algorithm for the different sites: A -> 1.49, B -> 0.78, C -> 1.57, D -> 0.15. This is compared to the values I got from my algorithm: A -> 0.64, B -> 0.34, C -> 0.68, D -> 0.06. While these values aren't the same, you will notice that my algorithm has simply returned values that are scaled down by about 2.3 times, which means it has given the same relative results (just at a different scale). While by no means conclusive, this would indicate that my implementation works. 