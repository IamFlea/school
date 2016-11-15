#!/usr/bin/env python2
import re
import sys
import string
MAX_ERROR = 2 # maximalni pocet chybnych bazi v genomu -- spatna kompelementarita etc..
if len(sys.argv) < 2:
    print "Chybi parametr programu."
    exit(1)
filename = sys.argv[1]

codon_table = {}  
codon_table['UUU'] = "Phe"; codon_table['UUC'] = "Phe"; codon_table['UUA'] = "Leu";  codon_table['UUG'] = "Leu";
codon_table['UCU'] = "Ser"; codon_table['UCC'] = "Ser"; codon_table['UCA'] = "Ser";  codon_table['UCG'] = "Ser";
codon_table['UAU'] = "Tyr"; codon_table['UAC'] = "Tyr"; codon_table['UAA'] = "Stop"; codon_table['UAG'] = "Stop";
codon_table['UGU'] = "Cys"; codon_table['UGC'] = "Cys"; codon_table['UGA'] = "Stop"; codon_table['UGG'] = "Trp";

codon_table['CUU'] = "Leu"; codon_table['CUC'] = "Leu"; codon_table['CUA'] = "Leu";  codon_table['CUG'] = "Leu";
codon_table['CCU'] = "Pro"; codon_table['CCC'] = "Pro"; codon_table['CCA'] = "Pro";  codon_table['CCG'] = "Pro";
codon_table['CAU'] = "His"; codon_table['CAC'] = "His"; codon_table['CAA'] = "Gln";  codon_table['CAG'] = "Gln";
codon_table['CGU'] = "Arg"; codon_table['CGC'] = "Arg"; codon_table['CGA'] = "Arg";  codon_table['CGG'] = "Arg";

codon_table['AUU'] = "Ile"; codon_table['AUC'] = "Ile"; codon_table['AUA'] = "Ile";  codon_table['AUG'] = "Met";
codon_table['ACU'] = "Thr"; codon_table['ACC'] = "Thr"; codon_table['ACA'] = "Thr";  codon_table['ACG'] = "Thr";
codon_table['AAU'] = "Asn"; codon_table['AAC'] = "Asn"; codon_table['AAA'] = "Lys";  codon_table['AAG'] = "Lys";
codon_table['AGU'] = "Ser"; codon_table['AGC'] = "Ser"; codon_table['AGA'] = "Arg";  codon_table['AGG'] = "Arg";

codon_table['GUU'] = "Val"; codon_table['GUC'] = "Val"; codon_table['GUA'] = "Val";  codon_table['GUG'] = "Val";
codon_table['GCU'] = "Ala"; codon_table['GCC'] = "Ala"; codon_table['GCA'] = "Ala";  codon_table['GCG'] = "Ala";
codon_table['GAU'] = "Asp"; codon_table['GAC'] = "Asp"; codon_table['GAA'] = "Glu";  codon_table['GAG'] = "Glu";
codon_table['GGU'] = "Gly"; codon_table['GGC'] = "Gly"; codon_table['GGA'] = "Gly";  codon_table['GGG'] = "Gly";

# Pomocne funkcicky, aby poslednich par radku nebylo dlouhych.
invert = lambda seq : seq.translate(string.maketrans("ATGC","TACG"))
reverse = lambda seq : seq[::-1]
irt = lambda seq : invert(reverse(seq))
transcribe = lambda seq : seq.replace("T","U")
getAcid = lambda codon : codon_table[reverse(transcribe(invert(codon)))]
str2fasta = lambda s : '\n'.join(s[i:i+60] for i in range(0, len(s), 60))


def pairing(a, b):
    result = 0
    b = invert(b)
    for i in xrange(len(a)):
        if a[i] == b[i]:
            continue
        elif (a[i] == 'G' and b[i] == 'A') or (a[i] == 'T' and b[i] == 'C'):
            continue
        else:
            result += 1 
    return result

def check_astem(gene):
    maxoffset = len(gene)-69 # magic
    for i in xrange(minoffset, maxoffset):
        if paruje(prvni, reverse(gene[i:i+7])):
            return i
    return None


def parse(gene):
    global MAX_ERROR
    # co vime
    seq = gene["seq"]
    tail = seq[-4:]
    astem_comp = seq[-11:-4]
    tstem_comp = seq[-16:-11]
    tloop = seq[-23:-16]
    tstem = seq[-28:-23]

    # check tstem
    error = pairing(tstem_comp, reverse(tstem))
    if error > MAX_ERROR: return None

    found = False 
    # check astem
    maxoffset = len(seq)-69 # magic
    for i in xrange(maxoffset):
        error2 = pairing(astem_comp, reverse(seq[i:i+7]))
        if (error2 + error) > MAX_ERROR:
            continue
        # check dstem and cstem
        dstem = seq[9+i:13+i]
        for j in xrange(5):
            dloop = seq[13+i:13+6+i+j]
            dstem_comp = seq[13+6+i+j:13+6+i+j+4]
            error3 = pairing(dstem, reverse(dstem_comp))
            cstem = seq[13+6+i+j+5:13+6+i+j+5+5] # lazy
            cloop = seq[13+6+i+j+5+5:13+6+i+j+5+5+7] # lazy
            cstem_comp = seq[13+6+i+j+5+5+7:13+6+i+j+5+5+7+5] # lazy
            vloop = seq[13+6+i+j+5+5+7+5:-28] # lazy
            error4 = pairing(cstem, reverse(cstem_comp))
            if (error4 + error3 + error2 + error) > MAX_ERROR:
                continue
            else:
                found = True
                break
        if found:
            break
    if found:
        anticodon = cloop[2:5]
        if gene["sense"]: 
            gene["start"] += i
        else:
            gene["end"] -= i
        gene["bases_cnt"] = len(seq[i:])
        gene["succ_rate"] = (error+error2+error3+error4)/float(gene["bases_cnt"])
        gene["anticodon"] = anticodon
        gene["seq"] = seq[i:]
        return gene
    else:
        return None


def makeGenes(filename):
    result = []
    f = open(filename, mode='r')
    virgin = True
    for line in f:
        if line[:5] == ">tRNA":
            virgin = False
            sense = True if line.split("|")[4][0] == "+" else False
            bases_cnt = int(line.split("|")[3])
            if sense:
                start = int(line.split("|")[2]) 
                end   = int(line.split("|")[2])+bases_cnt 
            else:
                end   = int(line.split("|")[2])
                start = int(line.split("|")[2])-bases_cnt
            line = line[1:]
            seq = ""
            succ_rate = None
        else:
            result[-1]["seq"] += line[:-1]
            continue
        gene = {}
        gene["start"] = start
        gene["end"] = end
        gene["bases_cnt"] = bases_cnt
        gene["sense"] = sense
        gene["succ_rate"] = succ_rate
        gene["okay"] = False
        gene["anticodon"] = ""
        gene["seq"] = "" # promenna seq se naplni v dalsi iteraci
        result.append(gene)
    return result

genes = makeGenes(filename)
parsed_genes = []
for gene in genes:
    if parse(gene) is not None: 
        parsed_genes.append(gene)
i = 0
for gene in parsed_genes:
    i+=1
    if gene["sense"]:
        print ">tRNA_"+ str(i) +"|"+ getAcid(gene["anticodon"]) + gene["anticodon"] + "|" + str(gene["start"]) + "|" + str(gene["bases_cnt"]) +"|"+ "+"
    else:
        print ">tRNA_"+ str(i) +"|"+ getAcid(gene["anticodon"]) + gene["anticodon"] + "|" + str(gene["end"]) + "|" + str(gene["bases_cnt"]) +"|"+ "-"
    print str2fasta(gene["seq"])
#print parse(genes[3]["seq"])
#"""
