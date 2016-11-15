#!/usr/bin/env python2
import re
import sys
import string

if len(sys.argv) < 3:
    print "Chybi argument programu, tudiz potrebujete vice argumentu."
    exit(1)
filename_result = sys.argv[1]
filename_reference = sys.argv[2]

def parseHeader(header):
    pass

def makeGenes(filename):
    result = []
    f = open(filename, mode='r')
    for line in f: 
        if line[:5] == ">tRNA":
            sense = True if line.split("|")[4][0] == "+" else False
            bases_cnt = int(line.split("|")[3])
            if sense:
                start = int(line.split("|")[2]) 
                end   = int(line.split("|")[2])+bases_cnt 
            else:
                end   = int(line.split("|")[2])
                start = int(line.split("|")[2])-bases_cnt

            line = line[1:]
            succ_rate = None
        elif line[:5] == ">Esch":
            start, end = line.split(" ")[1][1:-1].split("-")
            start, end = int(start), int(end)
            sense = True if start < end else False
            start, end = (start, end) if start < end else (end, start)
            bases_cnt = line.split(" ")[5]
            succ_rate = float(line.split(" ")[9])
        else:
            continue
        gene = {}
        gene["start"] = start
        gene["end"] = end
        gene["bases_cnt"] = bases_cnt
        gene["sense"] = sense
        gene["succ_rate"] = succ_rate
        gene["line"] = line[:-1]
        gene["okay"] = False
        gene["found"] = ""
        result.append(gene)
    return result

resultGenes = makeGenes(filename_result)
referenceGenes = makeGenes(filename_reference)

for res in resultGenes:
    for ref in referenceGenes:
        if res["sense"] != ref["sense"]: 
            continue
        # <DARK MAGIC> 
        # Tato temna magie neni zminena v dokumentaci. V podstate slo o to, ze mi to hodne blblo s ohledem na vypocet prekryvu. 
        # Fasta format ma pocitani pozice od jednicky ve Pythonu se pocita od nuly... To je duvod temne magie dvojek a jednicek.
        if res["sense"]:
            start_diff = abs(ref["start"] - res["start"])
            end_diff = abs(ref["end"] - res["end"] +1)
        else: 
            start_diff = abs(ref["start"] - res["start"]-2)
            end_diff = abs(ref["end"] - (res["end"]+1 ))
        # </DARK MAGIC>
        error = (start_diff + end_diff)/float(ref["bases_cnt"])
        if error <= 0.25:
            #print ref["end"]
            res["succ_rate"] = error
            res["okay"] = True
            ref["okay"] = True

for res in resultGenes:
    if not res["okay"]: 
        print res["line"]
print
for ref in referenceGenes:
    if not ref["okay"]:
        print ref["line"]
"""
print ""
for res in resultGenes:
    print res["line"] + "|" + str(res["succ_rate"])
#"""
