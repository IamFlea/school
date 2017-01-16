# Heuristic circuit approximation
# ===============================
#
# File: heuristic_gate_approx.py
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Date: 13th Februrary 2015
# Description: The script generate a chromosome for larger circuit.
#              The input is directory with run report of CGP.
#              The script finds best chromosome and uses it as a new chromosome.
#              Three new columns of genes are added in new chromosome.
#              
import os
import sys
import re

try:
    _, source_dir, output_filename, new_cols, new_lback, pop_size = sys.argv
    new_cols = int(new_cols)
    new_lback = int(new_lback)
    pop_size = int(pop_size)
except:
    sys.stderr.write("python2 ./heuristic_gate_approx.py ./input_dir/ ./output.chrom new_cols new_lback pop_size\n")
    sys.stderr.write("cols and rows must be integers")
    exit(1)


# Part 1: prohledej vsechny soubory v dane slozce
# .. vyhledavas v logu nejlepsi fitness a nejmensi pocet uzlu 
bestFitness = 0xffffffff # Fitness zmensujeme
bestNodes = 0xffffff # Uzly snizujeme
bestChrom = None
for filename in os.listdir(source_dir):
    f = open(source_dir+"/"+filename)
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
    if fitness < bestFitness:
        bestFitness = fitness
        bestChrom = chromosome
    if nodes < bestNodes and bestFitness == fitness:
        bestNodes = nodes
        bestChrom = chromosome
    f.close()
    #print filename, bestNodes, bestFitness

# Part 2: pridej pocet uzlu
result = bestChrom

match = re.match("\{([^\}]*)\}(.*)", bestChrom)
metadata = match.group(1)
chromosome = match.group(2)
info = metadata.split(",")
inputs = info[0]
outputs = info[1]
cols = int(info[2])
rows = info[3]
node_inputs = info[4]
node_outputs = info[5]
lback = int(info[6])



match = re.match("(.*)(\([^\)]*\))", chromosome)
chrom = "{"+inputs+"," + outputs+"," 
chrom+= str(new_cols) +"," + rows +","+node_inputs+","+node_outputs+","+str(new_lback)+"}"
chrom+= match.group(1)
for i in xrange(new_cols - cols):
    chrom += "(0,0,0)"
chrom += match.group(2)


# Part 3: Tiskni novou heuristickou populaci
for i in xrange(pop_size):
    print chrom
print "Generations: 0"
