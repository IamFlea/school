#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from cgp import Cgp
row    = 5
col    = 5
lback  = 1
input  = [0xffff0000, 0xff00ff00, 0xf0f0f0f0, 0xcccccccc, 0xaaaaaaaa]
output = [0xfee8e880]
gen = 50000
pop = 5
mut = 5

cgp = Cgp(row, col, lback, input, output)
#cgp = cgp(1, 40, 40, input, output)
#cgp = cgp()
cgp.moje()
cgp.run(gen, pop, mut)
cgp.printResults()


# Median 5 bit 
