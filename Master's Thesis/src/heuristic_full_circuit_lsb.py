# Heuristic full circuit chromomse generator
# ==========================================
#
# File: heuristic_full_adder_lsb.py
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Date: 11th November 2014
# Description: The script generate a chromosome for larger circuit.
#              The input is directory with run report of CGP.
#              The script finds best chromosome and uses it as a new chromosome.
#              Two new columns of genes must be added in new chromosome.
#              
import os
import sys
import re


try:
    path = sys.argv[1]
    new_cols = int(sys.argv[2])
    if new_cols < 2:
        raise
    new_primary_inputs = int(sys.argv[3])
    new_primary_outputs = int(sys.argv[4])
except:
    sys.stderr.write("SYNOPSIS\n    python2 heuristic_full_circuit.py ./path/ added_cols inputs outputs [lback]\nOPTIONS\n    The directory must contain run report of cgp.\n    added_cols is a number of added cols. Must be larger than two.\n    inputs and outputs are new primary I/O.\n        If they are equal the circuit is multiplier; otherwise it is an adder.\n    lback is just for feshion of outputfile.\nDESCRIPTION\n    Creates an arithmetic circuit chromosome from smaller circuit\n")
    exit(1)
try:
    new_lback = int(sys.argv[5])
except:
    new_lback = None


if path[-1] != '/' or path[-1] != '\\':
    path = path + '/'


# Firstly we need to find best chromosome from tests.
bestFitness = 0 # Fitness zvetsujeme
bestNodes = 0xffffff # Uzly snizujeme
bestChrom = None
for filename in os.listdir(path): # Every file
    f = open(path+filename)
    fitness = 0
    nodes = 0xffffff
    for line in f: # Every line
        # Get fitness
        match = re.match(r".*Fitness:\s*([0-9]*)[^:]*(: ([0-9]*))?", line)
        if match:
            try:
                fitness = int(match.group(1))
            except:
                pass
            try:
                nodes =  int(match.group(3))
            except:
                pass
        match = re.match(r".*Best fitness:\s*([0-9]*)/.*", line)
        # Get chromosome
        match = re.match(r"^\s*Best individual:\s*(.*)", line)
        if match:
            chromosome = match.group(1)
    # Get best chromosome through all files.
    if fitness > bestFitness:
        bestFitness = fitness
        bestChrom = chromosome
    if nodes < bestNodes and bestFitness == fitness:
        bestNodes = nodes
        bestChrom = chromosome
#print chromosome
if bestNodes == 0xffffff:
    exit(1)

# Secondly we need to parse chromosome and obtain an encoding in list form.
match = re.match("\{([^\}]*)\}(.*)", bestChrom)
metadata = match.group(1)
chromosome = match.group(2)
info = metadata.split(",")
inputs = int(info[0])
outputs = int(info[1])
cols = int(info[2])
rows = int(info[3])
node_inputs = int(info[4])
node_outputs = int(info[5])
lback = int(info[6])
if new_lback is not None:
    lback = new_lback
new_metadata = (new_primary_inputs, new_primary_outputs, cols+new_cols, rows, node_inputs, node_outputs, lback)

result = [] 
LAST_GENE = -1
for gene in re.split("\(([^\)]*)\)", chromosome): # Parsing gene
    if len(gene) < 1:
        continue
    match = re.match("(\[([0-9]+)\])*(.*)", gene)
    # Get index of gene
    try:
        idx = int(match.group(2))
    except:
        idx = LAST_GENE 


    geneList = []
    for val in match.group(3).split(','):
        geneList.append(int(val))
    result.append((idx, geneList))
last_gene =  result[-1][1]
last_matrix_gene_idx = result[-2][0]
chromosome = result[:-1]



# THIRDLY CREATE GENE CONTRADICTION
last_matrix_gene_idx += 1
new_gene = (last_matrix_gene_idx, [0, 0, 1]) # 5 - NOT GATE
not_gene = last_matrix_gene_idx
chromosome.append(new_gene)
# ADD ANOTHER NEW ROW GENES (we used one)
for row in range(1,rows):
    last_matrix_gene_idx += 1
    chromosome.append(last_matrix_gene_idx, [0,0,0]) 

# NEW COLUMN
last_matrix_gene_idx += 1
chromosome.append((last_matrix_gene_idx, [not_gene, 0, 2])) # 6 AND GATE 
nor_gene = last_matrix_gene_idx
# ADD ANOTHER NEW ROW GENES (we used one)
for row in range(1,rows):
    last_matrix_gene_idx += 1
    chromosome.append((last_matrix_gene_idx, [0,0,0]))
#print last_gene

# ADD ANOTHER COLUMN OF GENES
for col in range(2, new_cols):
    for row in range(0,rows):
        last_matrix_gene_idx += 1
        chromosome.append((last_matrix_gene_idx, [0,0,0]))

# Fourthly edit last gene
# Add new outputs
#     in out
# 3x3  6   6
# 3x4  7   7
# 4x4  8   8
#    
# 3+3  6   4   
# 3+4  7   4
# 5+4  8   5   // IT DOES NEED TO ADD NEW PRIMARY OUTPUT!!!
last_gene.reverse()
if new_primary_inputs == new_primary_outputs: # For multiplier
    last_gene.append(nor_gene)
elif (new_primary_inputs % 2) == 1: # For adder
    last_gene.append(nor_gene)
last_gene.reverse()
#last_gene.chromosome()
reverse.append((-1, last_gene))

#print chromosome




result = "{"
for dato in new_metadata:
    result += str(dato)+","
result = result[:-1] 
result += "}"

# Fifthly modify whole chromosome connection
if (new_primary_inputs % 2) == 0: # Added input has index 0
    added_input_index = 0
else:
    added_input_index = new_primary_inputs/2

#print added_input_index
for gene in chromosome:
    if gene[0] == LAST_GENE:
        result += "("
        for val in gene[1]:
            val += 1 if val >= added_input_index else 0
            result += str(val)+","
        result = result[:-1] + ")"
    else: 
        input_a = gene[1][0]
        input_b = gene[1][1]
        input_a += 1 if input_a >= added_input_index else 0
        input_b += 1 if input_b >= added_input_index else 0
        result += "([" + str(gene[0] + 1)+"]"+str(input_a)+","+str(input_b)+","+str(gene[1][2])+")"
#print result
#print bestChrom
#"""
print result
print result
print result
print result
print result
print "Generations: 0"

exit(0)

#{7,5,43,1,2,1,40}  ([7]0,1,5)([8]4,0,4)([9]0,5,1)([10]2,6,5)([11]1,10,7)([12]8,9,3)([13]7,5,7)([14]11,8,4)([15]8,12,1)([16]8,10,4)([17]2,6,4)([18]9,9,6)([19]5,1,7)([20]4,12,6)([21]16,10,0)([22]17,21,0)([23]0,4,3)([24]19,11,2)([25]13,20,0)([26]9,15,4)([27]11,2,6)([28]22,18,7)([29]13,10,5)([30]16,24,7)([31]1,1,3)([32]10,2,4)([33]17,24,3)([34]20,2,5)([35]11,5,4)([36]30,8,5)([37]36,36,3)([38]28,15,6)([39]18,6,0)([40]36,16,7)([41]1,37,5)([42]25,5,0)([43]27,6,5)([44]2,37,5)([45]36,24,7)([46]36,23,2)([47]0,0,5)([48]0,0,2)([49]48,47,6)(49,17,35,30,46)
#{6,4, 40,1, 2,1,40}([6]0,1,5)([7]3,0,4)([8]0,4,1) ([9]2,5,5)([10]1, 9,7)([11]7,8,3)([12]6,4,7)([13]10,7,4)([14]7,11,1)([15]7, 9,4)([16]2,5,4)([17]8,8,6)([18]4,1,7)([19]3,11,6)([20]15,9,0)([21]16,20,0)([22]0,3,3)([23]18,10,2)([24]12,19,0)([25]8,14,4)([26]10,2,6)([27]21,17,7)([28]12,9,5)([29]15,23,7)([30]1,1,3)([31]9,2,4)([32]16,23,3)([33]19,2,5)([34]10,4,4)([35]29,7,5)([36]35,35,3)([37]27,14,6)([38]17,5,0)([39]35,15,7)([40]1,36,5)([41]24,4,0)([42]26,5,5)([43]2,36,5)([44]35,23,7)([45]35,22,2)(16,34,29,45)


# """
