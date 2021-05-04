import numpy as np
import matplotlib.pyplot as plt
import networkx as nx
import pylab as plt
#%matplotlib inline
import numpy as np
from time import clock
import pickle
import seaborn as sns
import csv 
from networkx.algorithms.community import greedy_modularity_communities
import community as community_louvain
def _find_between_community_edges(g, partition):

    edges = dict()

    for (ni, nj) in g.edges():
        ci = partition[ni]
        cj = partition[nj]

        if ci != cj:
            try:
                edges[(ci, cj)] += [(ni, nj)]
            except KeyError:
                edges[(ci, cj)] = [(ni, nj)]

    return edges
def communities_graph(g, partition, **kwargs):

    # create a weighted graph, in which each node corresponds to a community,
    # and each edge weight to the number of edges between communities
    between_community_edges = _find_between_community_edges(g, partition)

    communities = set(partition.values())
    hypergraph = nx.Graph()
    hypergraph.add_nodes_from(communities)
    for (ci, cj), edges in between_community_edges.items():
        hypergraph.add_edge(ci, cj, weight=len(edges))
    return hypergraph
G= nx.read_edgelist('/home/bm7mp/git/oss-2020/Pydata/edgelist_0819.txt', nodetype=str, data=(('weight',float),))

with open('/sfs/qumulo/qhome/bm7mp/OS/rnbrw/gitt_luvain_rnbrw.pickle', 'rb') as handle:
    #This one is obtained Des2020
    git_luvain_rnbrw = pickle.load(handle) # LRN is the membership dictionary
    #each value is an array of nodes on r
#with open('/sfs/qumulo/qhome/bm7mp/OS/rnbrw/git_luvain.pickle', 'rb') as handle:
    #this one is only louvain Dec2020
    #git_louvain = pickle.load(handle) # LRN is the membership dictionary
    #each value is an array of nodes on r
par = git_luvain_rnbrw
partition = {}
for k,v in par.items():
    for x in v:
        partition.setdefault(x,[]).append(k)
for k,v in partition.items():
    strings = [str(integer) for integer in v]
    a_string = "".join(strings)
    partition[k] = int(a_string)
            
#partition = community_louvain.best_partition(G)
G_com = communities_graph(G, partition)
in_degrees = dict(G_com.degree(weight='weight')) # dictionary node:degree
in_values = sorted(in_degrees.values())

s=0
si=list(in_degrees.values())
for i in si:
    s=s+i
in_hist = [list(in_degrees.values()).count(x)/int(s) for x in in_values]
with open('/sfs/qumulo/qhome/bm7mp/OS/rnbrw/indegree_rnbrw_louvain.pickle', 'wb') as handle:
    pickle.dump(in_degrees, handle, protocol=pickle.HIGHEST_PROTOCOL)
    
plt.figure() # you need to first do 'import pylab as plt'
plt.grid(True)
plt.loglog(in_values, in_hist, 'ro-') # in-degree
# plt.legend(['degree'])
#plt.xlabel('Degree')
#plt.ylabel('Number of nodes')
# plt.title('network of places in Cambridge')
plt.xlim([0, 2*10**6])
plt.savefig('/home/bm7mp/OS/rnbrw/output/compunity_net_degree_distribution_rnbrw_louv.pdf')
plt.show()
plt.close()