#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from cgp import Cgp
row    = 1
col    = 40
lback  = 40
input = [[-1,  0, 1,  2,   3]]
output  = [[0.1, 1, 10, 100, 1000]]
gen = 10000000
gen = 10
pop = 5
mut = 3
#print(gen)
cgp = Cgp(row, col, lback)#, input, output)
#cgp.file("/home/flea/bakalarka/src/data/adder6_6.txt")
#cgp = cgp(1, 40, 40, input, output)
#cgp = cgp()
cgp.file("../../data/xxyz.txt")
cgp.run(gen, pop, mut, 10, 0.01)
cgp.symbolicRegressionWithSin()
print(cgp.bestFitness, cgp.result["popFitness"])
print("Time:",cgp.result["elapsed"])
print("Elapsed:",cgp.result["evalspersec"])
print(cgp.showChromosome)
print()
print()
print("maxfitness", cgp.result["bestFitness"])
for key, value in cgp.result.items():
    print(key)
#print(cgp.pop[cgp.parent])
