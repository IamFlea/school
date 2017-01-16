#!/bin/python2
import sys
from circuit import circuit
#INPUT FNAME
f = open(sys.argv[1])
chromosome_string = f.readline()
f.close()
#REFERENCE FNAME
remove_nodes = int(sys.argv[2])
#OUTPUT FNAME
#filename = sys.argv[3]
f = open(sys.argv[3], 'w')

c = circuit(chromosome_string[:-1])
c.cols -= remove_nodes
def get_chrom(circuit):
    global remove_nodes
    chrom = circuit.circuit
    metadata = "{"+str(circuit.inputs)+"," +str(circuit.outputs)+","+str(circuit.cols)+"," +str(circuit.rows)+"," +str(circuit.node_inputs)+"," +str(circuit.node_outputs)+",333}"
    result = ""
    idx = circuit.inputs
    for gene in chrom[:-1]:
        result+="(["+str(idx)+"]"+str(gene[0])+","+str(gene[1])+","+str(circuit.GENE_TRANSLATION.index(gene[2]))+")"
        idx+=1
    for _ in xrange(idx - circuit.inputs, circuit.cols):
        result+="(["+str(idx)+"]0,0,0)"
        idx+=1
    result += "(" + reduce(lambda x,y: str(x)+","+str(y), chrom[-1]) + ")"
    return metadata+ result

chrom = get_chrom(c)
f.write(chrom+"\n")
f.close()