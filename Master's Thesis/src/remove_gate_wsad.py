#!/bin/python2
import sys, copy, os,re
from circuit import circuit

def get_chrom(chrom):
    global inputs,outputs,cols,rows,node_inputs,node_outputs,lback
    metadata = "{"+str(inputs)+"," +str(outputs)+","+str(cols)+"," +str(rows)+"," +str(node_inputs)+"," +str(node_outputs)+","+str(lback)+"}"
    result = ""
    idx = inputs
    for gene in chrom[:-1]:
        result+="(["+str(idx)+"]"+str(gene[0])+","+str(gene[1])+","+str(gene[2])+")"
        idx+=1
    result += "(" + reduce(lambda x,y: str(x)+","+str(y), chrom[-1]) + ")"
    return metadata+ result
try:
    #INPUT FNAME
    chrom_str = open(sys.argv[1]).readline()[:-1]
    #OUTPUT FNAME
    filename = sys.argv[2]
    #REFERENCE FNAME
    data_fname = sys.argv[3]
except:
    print "python2 remove_gate_wsad.py INPUT OUTPUT REFERENCE"
    exit(1)

lambda_toint = lambda x: int(x)
splitted = chrom_str.split("(") # Chromozom je ve tvaru "{int, int, int, int, int, int}([cislouzlu]int_a,int_b,int_f)([cislouzlu]int_a,int_b,int_f)...(int,int...int_outs)"
# Ziskam metadata z prvniho zaznamu `splitted[0]`, ktery je ve tvaru "{int, int, int, int, int, int}". 
# Z toho ziskam seznam sesti cisel, ktere je potreba pretypovat na int! 
inputs, outputs, cols, rows, node_inputs, node_outputs, lback = map(lambda_toint, splitted[0][1:-1].split(","))
# Parsrovani retezce + jeho pretypovani na list integeru
chrom = map(lambda x: x[x.index(']')+1:-1], splitted[1:-1]) + [splitted[-1][:-1]]
chrom[:] = map(lambda x: map(lambda_toint, x.split(',')), chrom)
# Dame pryc nepouzite uzly
used_nodes = [True] * inputs + [False] * len(chrom)
for gene in chrom[-1]:
    used_nodes[gene] = True
# Backtracking of used nodes
for i, gene in reversed(list(enumerate(chrom[:-1]))):
    if used_nodes[i + inputs]:
        used_nodes[gene[0]] = True
        if gene[2] > 1: 
            used_nodes[gene[1]] = True
                
fitness = 0
best_chrom = None
best_fitness = 18446744073709486080
best_fitness2 = 18446744073709486080
used_blocks  = sum(used_nodes[inputs:])
#print used_blocks
matrix =  " -r " + str(rows) + " -c " + str(cols) + " -l " + str(lback) + " -n " + str(used_blocks - 1)
data_chrom_prefix = "./tmp/bad_chrom_mult_"
cgp_test_log_dir  = "./tmp/remove_gate_v2.log"
#print matrix
for idx, gene in enumerate(chrom):
    if gene[2] == 0 or not used_nodes[idx+inputs]: continue
    tmp = copy.deepcopy(chrom)
    tmp[idx] = [gene[0], gene[1], 0]
    new_chrom = get_chrom(tmp)
    f = open(filename, 'w')
    f.write(new_chrom)
    f.close()
    os.system("./cgp_wsad/cgp_native -g 1 -p 1 "+matrix+" -x "+filename+" "+data_fname +" >"+cgp_test_log_dir)
    for line in open(cgp_test_log_dir):
        match = re.match(r"(Best fitness:\s+(.*))", line)
        try: fitness = int(match.group(2).split("/")[0])
        except ValueError: fitness = float(match.group(2).split("/")[0])
        except AttributeError: pass
        match = re.match(r"(Suma zbytku fitness:\s+(.*))", line)
    if fitness < best_fitness:
        best_fitness, best_chrom = fitness, new_chrom

    #print idx, fitness
    #break
for idx, gene in enumerate(chrom):
    if gene[2] == 0 or not used_nodes[idx+inputs]: continue
    tmp = copy.deepcopy(chrom)
    tmp[idx] = [gene[1], gene[0], 0]
    new_chrom = get_chrom(tmp)
    f = open(filename, 'w')
    f.write(new_chrom)
    f.close()
    os.system("./cgp_wsad/cgp_native -g 1 -p 1 "+matrix+" -x "+filename+" "+data_fname +" >"+cgp_test_log_dir)
    for line in open(cgp_test_log_dir):
        match = re.match(r"(Best fitness:\s+(.*))", line)
        try: fitness = int(match.group(2).split("/")[0])
        except ValueError: fitness = float(match.group(2).split("/")[0])
        except AttributeError: pass
        match = re.match(r"(Suma zbytku fitness:\s+(.*))", line)
    if fitness < best_fitness:
        best_fitness, best_chrom = fitness, new_chrom
    #print idx, fitness
    #break
print "  Initing it with fitness:", best_fitness
f = open(filename, 'w')
f.write(best_chrom + "\n")
f.close()

