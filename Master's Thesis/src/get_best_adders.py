#!/bin/python2

import sys, os, re
from circuit import circuit 

data_fname = "data/adder8_8.txt"
def get_best_run(dirname):
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
            fit = float(fit.split("/")[0])
            if fit < best_fit:
                best_fit, best_chrom = fit, chrom
        f.close()
    return best_fit, best_chrom

def create_specification(chrom, out_fname, data_fname):
    circ = circuit(chrom)
    circ.get_usefull_data()
    circ.check_errors(data_fname)
    circ.get_more_errors()

    ptr = 0
    f = open(out_fname, 'w')
    metadata = "# 8+8 Kogge Stone adder\n"
    metadata += "# Inputs:      " + str(circ.inputs).rjust(6)      + " Outputs:      " + str(circ.outputs).rjust(6) + "\n"
    metadata += "# Gates:       " + str(circ.logic_gates).rjust(6) + " Latency:      " + str(circ.latency_nodes).rjust(6) + "\n"
    metadata += "# NAND gates:  " + str(circ.nand_gates).rjust(6)  + " NAND latency: " + str(circ.latency_nand_logic).rjust(6) + "\n"
    metadata += "# Transistors: " + str(circ.transistors).rjust(6) + " VLSI width:   " + str(circ.relative_area).rjust(6) + "LogicalEffort:" + str(circ.logical_effort).rjust(6) + "\n"
    metadata += "# \n"
    metadata += "# SHD:  "+ str(circ.error_shd).rjust(12)  + "\n"
    metadata += "# WSHD: "+ str(circ.error_wshd).rjust(12) + "\n"
    metadata += "# SAD:  "+ str(circ.error_sad).rjust(12)  + "\n"
    metadata += "# \n"
    try:
        metadata += "# Wrong combos:"+ str(circ.incorrect_combinations).rjust(6)+" Correct comb: " + str(circ.correct_combinations).rjust(6)+"\n"
        metadata += "# Avg err: " +       ("%.3f" % circ.error_avg2).rjust(10) +      " Std dev: %.4f" % circ.error_dev2 + "\n"
        metadata += "# Avg err: " +       ("%.3f" % circ.error_avg ).rjust(10) +      " Std dev: %.4f" % circ.error_dev  + "\tContain correct combinatinos.\n"
        metadata += "# Min: " + str(circ.error_min) + " Q1: " + str(circ.error_qu1) + \
                      " Q2: " + str(circ.error_med) + " Q3: " + str(circ.error_qu3) + " Max: " + str(circ.error_max)+"\n"
        metadata += "# Most freq. error:" + str(circ.error_modus) +"\n"
        metadata += "# \n"
    except:
        pass
    try:
        circ.error_differences
    except:
        circ.error_differences = [0]*(2**circ.inputs)
    metadata += "# Circuit: " + str(circ.circuit)
    metadata += "#\n"
    metadata += "# a    b    vysled [chyba]\n"
    f.write(metadata)
    for i in xrange(2**8):
        for j in xrange(2**8):
            f.write(str(i).rjust(3)+ " + "+ str(j).rjust(3)+" = "+str(i+j - circ.error_differences[ptr]).rjust(5)+" [" +str(circ.error_differences[ptr]) +"]\n")
            ptr += 1
    f.close()
    

if __name__ == '__main__':
    
    print ("python2 get_best_circuit.py RUNS_DIR REFERENCE_FILE OUT_DIR")
    import time
    for l in map(lambda x: sys.argv[1] + x , os.listdir(sys.argv[1])):
        gates = l.split("/")[-1]
        print "Analyzing", gates, "gated solution"
        tik = time.time()
        _, chrom = get_best_run(l + "/")
        create_specification(chrom, sys.argv[3]+"/"+gates+".log", sys.argv[2])
        print "Done in", time.time()-tik
