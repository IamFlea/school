#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 4x4 adder

from cgp import Cgp
row    = 1
col    = 40
lback  = 40
input  = [
    0xffffffffffffffffffffffffffffffff00000000000000000000000000000000,
    0xffffffffffffffff0000000000000000ffffffffffffffff0000000000000000,
    0xffffffff00000000ffffffff00000000ffffffff00000000ffffffff00000000,
    0xffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000,
    0xff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00,
    0xf0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0,
    0xcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc,
    0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa]
output = [
    0xfffefffcfff8fff0ffe0ffc0ff80ff00fe00fc00f800f000e000c00080000000,
    0xfe01fc03f807f00fe01fc03f807f00ff01fe03fc07f80ff01fe03fc07f80ff00,
    0xe1e1c3c387870f0f1e1e3c3c7878f0f0e1e1c3c387870f0f1e1e3c3c7878f0f0,
    0x999933336666cccc999933336666cccc999933336666cccc999933336666cccc,
    0x5555aaaa5555aaaa5555aaaa5555aaaa5555aaaa5555aaaa5555aaaa5555aaaa]
gen = 10000000
gen = 50000
pop = 5
mut = 1

cgp = Cgp(row, col, lback, input, output)
cgp.file("/home/flea/bakalarka/src/data/parity9.txt")
#cgp = cgp(1, 40, 40, input, output)
#cgp = cgp()
cgp.run(gen, pop, mut)
print(cgp.bestFitness, cgp.result["popFitness"])
print("Time:",cgp.result["elapsed"], "Elapsed:",cgp.result["evalspersec"])
print(cgp.showChromosome)
#print(cgp.pop[cgp.parent])
