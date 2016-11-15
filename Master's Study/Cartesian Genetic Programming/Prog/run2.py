#!/bin/env python3
# Autor: petr dvoracek
from cgp import Cgp
from datetime import datetime
import os
import sys



circuitInputs = 6
circuit = "mult"

row   = 1
col   = 35
lback = 35
pop   = 5

mut   = 2
runs  = 30
gen   = 15000000

result = []
runNaive = False

j = circuitInputs
if circuit == "mult":
    filename = "mult"+str(j//2)+"x"+str(j//2)+".txt"
    f = open("mult"+str(j//2)+"x"+str(j//2)+".txt", 'w+')
    for a in range(2**(j//2)):
        for b in range(2**(j//2)):
            f.write(bin(a)[2:].rjust(j//2, '0') + " " + bin(b)[2:].rjust(j//2, '0')+ ":" + bin(a*b)[2:].rjust(j, '0') + "\n")
    f.close()
elif circuit == "adder":
    # Vygenerovani souboru pro scitacku
    filename = "adder"+str(j//2)+"x"+str(j//2)+".txt"
    f = open(filename, 'w+')
    for a in range(2**(j//2)):
        for b in range(2**(j//2)):
            f.write(bin(a)[2:].rjust(j//2, '0') + " " + bin(b)[2:].rjust(j//2, '0')+ ":" + bin(a+b)[2:].rjust(j//2+1, '0') + "\n")
    f.close()

def tableToStr(table,j):
    i = [str(i).rjust(3) for i in range(j//2)]
    padding = "    "
    header = padding + "    | "
    string = ""
    i = 0
    for row in table:
        header +=str(i).rjust(3) +"  "
        string +=padding + str(i).rjust(3) +" | "
        for item in row:
            string += str(item).rjust(3) + "  "
        string += "\n"
        i+=1
    header += "\n"+padding+"----+-" + "-----"*(i)
    return header+"\n"+string
###############################################################################
#                                    SHD                                      #
###############################################################################
# 3+3

f = open("cgp"+datetime.now().isoformat(' ')+".log", "w+")
"""
f.write("----SHD----\n")
k = -1
cgp = Cgp(row, col, lback)
cgp.file(filename)
cgp.runSHD(gen, pop, mut, runs) 
#runes.append(sum(cgp.fit) / len(cgp.fit))
similar = 0
avgFit = 0; avgNodes = 0; avgError = 0; avgElapsed = 0; avgFound = 0;
worstfit = cgp.results[0][2]
for result in cgp.results: 
    chrom      = result[0]
    elapsed    = result[1]
    fitness    = result[2]
    foundInGen = result[3]
    usedNodes  = result[4]
    etable = cgp.createErrorTable(chrom, int(j/2), int(j/2))
    
    error = sum([abs(item) for row in etable for item in row])
    avgElapsed += elapsed
    if fitness == cgp.bestFitness:
        similar += 1
        avgFound += foundInGen
        avgError += (1-error/float((2**j)*((2**(j/2)-1)*2)))*100
        avgNodes += usedNodes
    avgFit  += fitness
    if fitness < worstfit:
        worstfit = fitness

try:
    avgFit/=len(cgp.results)
    avgFound/=similar
    avgError/=len(cgp.results)
    avgNodes/=len(cgp.results)
except: 
    pass #, you shall.
avgElapsed /= len(cgp.results)
    
etable = cgp.createErrorTable(cgp.chrom, int(j/2), int(j/2))
error = sum([abs(item) for row in etable for item in row])

f.write(filename)
f.write("  Max gates: "+str("inf")+"\n")
f.write("  Graph:     "+ str(row )+ "x" +str(col)+"    Lback: "+str(lback)+"\n")
f.write("  Function set: id, and, or, xor, not, nand, nor, nxor\n")
f.write("  Mutations: "+str(mut)+"   Gnerations:"+str(gen)+"   Population:"+str(pop)+"\n")
f.write("  Runs cnt:  "+str(runs)+"\n")
f.write("  Max fit:   "+str(cgp.maxFitness)+"\n")
f.write("Results\n")
f.write("  Best chromosome:  "+cgp.resultChrom()+"\n")
f.write("    Fitness:  "+str(cgp.bestFitness)+"\n")
f.write("    Used nodes: "+str(cgp.usedNodes)+"\n")
f.write("    Functionality: "+str((1-error/float((2**j)*((2**(j/2)-1)*2)))*100)+"%\n")
f.write(tableToStr(etable, j))
if similar > 1:
    f.write("  Average values of "+str(similar)+" similar solutions:\n")
    f.write("    Found in gen:  "+str(avgFound)+" generation\n")
f.write("  Used nodes:    "+str(avgNodes)+"\n")
f.write("  Functionality: "+str(avgError)+" %\n")
f.write("  Min best fitness:      "+str(worstfit)+"\n")
f.write("  Average fitness:       "+str(avgFit)+"\n")
f.write("  Average elapsed time:  "+str(avgElapsed)+" s \n")
f.write("\n\n")
k=cgp.usedNodes
for i in range(k, 0, -1):
    cgp = Cgp(row, col, lback)
    cgp.file(filename)
    cgp.runSHD(gen, pop, mut, runs, i-1) # V posledni iteraci pouze prirazujeme vstupy.
    #runes.append(sum(cgp.fit) / len(cgp.fit))
    similar = 0
    avgFit = 0; avgNodes = 0; avgError = 0; avgElapsed = 0; avgFound = 0;
    worstfit = cgp.results[0][2]
    for result in cgp.results: 
        chrom      = result[0]
        elapsed    = result[1]
        fitness    = result[2]
        foundInGen = result[3]
        usedNodes  = result[4]
        etable = cgp.createErrorTable(chrom, int(j/2), int(j/2))
        error = sum([abs(item) for row in etable for item in row])
        avgElapsed += elapsed
        if fitness == cgp.bestFitness:
            similar += 1
            avgFound += foundInGen
            avgError += (1-error/float((2**j)*((2**(j/2)-1)*2)))*100
            avgNodes += usedNodes
        avgFit  += fitness
        if fitness < worstfit:
            worstfit = fitness

    try:
        avgFit/=len(cgp.results)
        avgFound/=similar
        avgError/=len(cgp.results)
        avgNodes/=len(cgp.results)
    except: 
        pass #, you shall.
    avgElapsed /= len(cgp.results)
        
    etable = cgp.createErrorTable(cgp.chrom, int(j/2), int(j/2))
    error = sum([abs(item) for row in etable for item in row])
    
    f.write(filename)
    f.write("  Max gates: "+str(i-1)+"\n")
    f.write("  Graph:     "+ str(row )+ "x" +str(col)+"    Lback: "+str(lback)+"\n")
    f.write("  Function set: id, and, or, xor, not, nand, nor, nxor\n")
    f.write("  Mutations: "+str(mut)+"   Gnerations:"+str(gen)+"   Population:"+str(pop)+"\n")
    f.write("  Runs cnt:  "+str(runs)+"\n")
    f.write("  Max fit:   "+str(cgp.maxFitness)+"\n")
    f.write("Results\n")
    f.write("  Best chromosome:  "+cgp.resultChrom()+"\n")
    f.write("    Fitness:  "+str(cgp.bestFitness)+"\n")
    f.write("    Used nodes: "+str(cgp.usedNodes)+"\n")
    f.write("    Functionality: "+str((1-error/float((2**j)*((2**(j/2)-1)*2)))*100)+"%\n")
    f.write(tableToStr(etable, j))
    if similar > 1:
        f.write("  Average values of "+str(similar)+" similar solutions:\n")
        f.write("    Found in gen:  "+str(avgFound)+" generation\n")
    f.write("  Used nodes:    "+str(avgNodes)+"\n")
    f.write("  Functionality: "+str(avgError)+" %\n")
    f.write("  Min best fitness:      "+str(worstfit)+"\n")
    f.write("  Average fitness:       "+str(avgFit)+"\n")
    f.write("  Average elapsed time:  "+str(avgElapsed)+" s \n")
    f.write("\n\n")

"""

###############################################################################
#                                    SAD                                      #
###############################################################################
# 3+3
f.write("----SAD----\n")

print("SAD "+ filename)
k = -1
cgp = Cgp(row, col, lback)
cgp.file(filename)
cgp.runSAD(gen, pop, mut, runs) 
#runes.append(sum(cgp.fit) / len(cgp.fit))
similar = 0
avgFit = 0; avgNodes = 0; avgError = 0; avgElapsed = 0; avgFound = 0;
worstfit = cgp.results[0][2]
for result in cgp.results: 
    chrom      = result[0]
    elapsed    = result[1]
    fitness    = result[2]
    foundInGen = result[3]
    usedNodes  = result[4]
    etable = cgp.createErrorTable(chrom, int(j/2), int(j/2))
    error = sum([abs(item) for row in etable for item in row])
    avgElapsed += elapsed
    if fitness == cgp.bestFitness:
        similar += 1
        avgFound += foundInGen
        avgError += (1-error/float((2**j)*((2**(j/2)-1)*2)))*100
        avgNodes += usedNodes
    avgFit  += fitness
    if fitness < worstfit:
        worstfit = fitness

try:
    avgFit/=len(cgp.results)
    avgFound/=similar
    avgError/=len(cgp.results)
    avgNodes/=len(cgp.results)
except: 
    pass #, you shall.
avgElapsed /= len(cgp.results)
    
etable = cgp.createErrorTable(cgp.chrom, int(j/2), int(j/2))
error = sum([abs(item) for row in etable for item in row])

f.write(filename)
f.write("  Max gates: "+str("inf")+"\n")
f.write("  Graph:     "+ str(row )+ "x" +str(col)+"    Lback: "+str(lback)+"\n")
f.write("  Function set: id, and, or, xor, not, nand, nor, nxor\n")
f.write("  Mutations: "+str(mut)+"   Gnerations:"+str(gen)+"   Population:"+str(pop)+"\n")
f.write("  Runs cnt:  "+str(runs)+"\n")
f.write("  Max fit:   "+str(cgp.maxFitness)+"\n")
f.write("Results\n")
f.write("  Best chromosome:  "+cgp.resultChrom()+"\n")
f.write("    Fitness:  "+str(cgp.bestFitness)+"\n")
f.write("    Used nodes: "+str(cgp.usedNodes)+"\n")
f.write("    Functionality: "+str((1-error/float((2**j)*((2**(j/2)-1)*2)))*100)+"%\n")
f.write(tableToStr(etable, j))
if similar > 1:
    f.write("  Average values of "+str(similar)+" similar solutions:\n")
    f.write("    Found in gen:  "+str(avgFound)+" generation\n")
f.write("  Used nodes:    "+str(avgNodes)+"\n")
f.write("  Functionality: "+str(avgError)+" %\n")
f.write("  Min best fitness:      "+str(worstfit)+"\n")
f.write("  Average fitness:       "+str(avgFit)+"\n")
f.write("  Average elapsed time:  "+str(avgElapsed)+" s \n")
f.write("\n\n")
k=cgp.usedNodes
for i in range(k, 0, -1):
    cgp = Cgp(row, col, lback)
    cgp.file(filename)
    cgp.runSAD(gen, pop, mut, runs, i-1) # V posledni iteraci pouze prirazujeme vstupy.
    #runes.append(sum(cgp.fit) / len(cgp.fit))
    similar = 0
    avgFit = 0; avgNodes = 0; avgError = 0; avgElapsed = 0; avgFound = 0;
    worstfit = cgp.results[0][2]
    for result in cgp.results: 
        chrom      = result[0]
        elapsed    = result[1]
        fitness    = result[2]
        foundInGen = result[3]
        usedNodes  = result[4]
        etable = cgp.createErrorTable(chrom, int(j/2), int(j/2))
        error = sum([abs(item) for row in etable for item in row])
        avgElapsed += elapsed
        if fitness == cgp.bestFitness:
            similar += 1
            avgFound += foundInGen
            avgError += (1-error/float((2**j)*((2**(j/2)-1)*2)))*100
            avgNodes += usedNodes
        avgFit  += fitness
        if fitness < worstfit:
            worstfit = fitness

    try:
        avgFit/=len(cgp.results)
        avgFound/=similar
        avgError/=len(cgp.results)
        avgNodes/=len(cgp.results)
    except: 
        pass #, you shall.
    avgElapsed /= len(cgp.results)
        
    etable = cgp.createErrorTable(cgp.chrom, int(j/2), int(j/2))
    error = sum([abs(item) for row in etable for item in row])
    
    f.write(filename)
    f.write("  Max gates: "+str(i-1)+"\n")
    f.write("  Graph:     "+ str(row )+ "x" +str(col)+"    Lback: "+str(lback)+"\n")
    f.write("  Function set: id, and, or, xor, not, nand, nor, nxor\n")
    f.write("  Mutations: "+str(mut)+"   Gnerations:"+str(gen)+"   Population:"+str(pop)+"\n")
    f.write("  Runs cnt:  "+str(runs)+"\n")
    f.write("  Max fit:   "+str(cgp.maxFitness)+"\n")
    f.write("Results\n")
    f.write("  Best chromosome:  "+cgp.resultChrom()+"\n")
    f.write("    Fitness:  "+str(cgp.bestFitness)+"\n")
    f.write("    Used nodes: "+str(cgp.usedNodes)+"\n")
    f.write("    Functionality: "+str((1-error/float((2**j)*((2**(j/2)-1)*2)))*100)+"%\n")
    f.write(tableToStr(etable, j))
    if similar > 1:
        f.write("  Average values of "+str(similar)+" similar solutions:\n")
        f.write("    Found in gen:  "+str(avgFound)+" generation\n")
    f.write("  Used nodes:    "+str(avgNodes)+"\n")
    f.write("  Functionality: "+str(avgError)+" %\n")
    f.write("  Min best fitness:      "+str(worstfit)+"\n")
    f.write("  Average fitness:       "+str(avgFit)+"\n")
    f.write("  Average elapsed time:  "+str(avgElapsed)+" s \n")
    f.write("\n\n")

f.close()
