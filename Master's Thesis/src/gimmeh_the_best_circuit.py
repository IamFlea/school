#!/bin/python2

import sys, os, re

dirname = sys.argv[1]
listdir = map(lambda x: dirname + x , os.listdir(dirname))
best_fit =  0xffffffffffffffff
best_chrom = None
for f in map(open, listdir):
    chrom, fit = None, None
    for line in f:
        match = re.match(r"(Best individual:\s+(.*))", line)
        try: chrom = match.group(2)
        except AttributeError: pass    
        match = re.match(r"(Best fitness:(.*))", line)
        try: fit = match.group(2)
        except AttributeError: pass 
    if fit is not None and chrom is not None:
        try:fit = int(fit.split("/")[0])
        except ValueError: fit = float(fit.split("/")[0])
        if fit < best_fit:
            best_fit, best_chrom = fit, chrom
    f.close()

print best_chrom
