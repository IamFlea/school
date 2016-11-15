#!/usr/bin/env python2
import re
import sys
import string   # TODO import gravity  xkcd

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

# Refularni vyraz, jednak hledame ve smeru tak i v protismeru aka britian mode (podle smeru jizdy) :)
pattern = r"(.{14}A[AG].{1,3}G.{11,14}[ATC]T(...)[AG].{11,31}GTTC[AG]A.[TC]C.{12}CCA)"
pattern += "|"
pattern += "(TGG.{12}G[AG].T[TC]GAAC.{11,31}[TC](...)A[ATG].{11,14}C.{1,3}[TC]T.{14})|"
x = re.compile(pattern, re.M|re.I|re.L) # Kompilace regularniho vyrazu. Lienarni slozitost? meh. nevadi

f = open(filename, mode='r')    # Otevreni souboru read only mode.
f.readline()                    # Preskoceni hlavicky.    O(c) ?
file = ""
for l in f: 
    file += l[:-1]              # Odstrani posledni znak. O(n)
m = x.finditer(file)            # Parsrovani genomu.      O(n)
i = 1
for l in m:                     # Tisk nalezenych genu
    if l.group(1) is not None:  # Ve smeru
        print ">tRNA_"+ str(i) +"|"+ getAcid(l.group(2)) + l.group(2) + "|" + str(l.start(1)+1) + "|" + str(len(l.group(1))) +"|+"
        print str2fasta(l.group(1))
        i += 1
    elif l.group(3) is not None: # V protismeru (britian mode) 
        print ">tRNA_"+ str(i) +"|"+ getAcid(irt(l.group(4))) + irt(l.group(4)) + "|" + str(l.end(3)-1) + "|" + str(len(l.group(3))) +"|-"
        print str2fasta(irt(l.group(3)))
        i += 1
#"""
