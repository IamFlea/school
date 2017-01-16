import os
import re
import sys
import copy

class circuit(object):
    GENE_TRANSLATION      = ["BUF", "NOT", "AND", "OR", "XOR", "NAND", "NOR", "XNOR"]
    NAND_GATES_USED       = {"BUF":0,    "NOT":1,    "NAND":1,    "NOR":4,    "AND":2,    "OR":3,    "XOR":4,    "XNOR":5}
    NAND_GATES_LATENCY    = {"BUF":0,    "NOT":1,    "NAND":1,    "NOR":3,    "AND":2,    "OR":2,    "XOR":3,    "XNOR":4}
    CMOS_TRANSISTORS_USED = {"BUF":0,    "NOT":2,    "NAND":4,    "NOR":4,    "AND":6,    "OR":6,    "XOR":10,   "XNOR":12}
    CMOS_VLSI_WIDTH       = {"BUF":0,    "NOT":24,   "NAND":32,   "NOR":32,   "AND":40,   "OR":40,   "XOR":72,   "XNOR":72}
    CMOS_LOGICAL_EFFORT   = {"BUF":0,    "NOT":1.00, "NAND":1.32, "NOR":1.65, "AND":1.76, "OR":2.04, "XOR":1.55, "XNOR":2.77}
    INTERPRETATION   = {"BUF":  lambda a, b: a,
                        "NOT":  lambda a, b: ~a, 
                        "NAND": lambda a, b: ~(a & b),
                        "NOR":  lambda a, b: ~(a | b), 
                        "AND":  lambda a, b: a & b, 
                        "OR":   lambda a, b: a | b,
                        "XOR":  lambda a, b: a ^ b, 
                        "XNOR": lambda a, b: ~(a ^ b)}

    VHDL_HEADER = "-- Generated VHDL source code\nlibrary IEEE;\nuse IEEE.STD_LOGIC_1164.ALL;"

    def __init__(self, chromosome_string, data_fname, outputs_are_downto=True):
        super(circuit, self).__init__()
        
        bufffunction = lambda x : x&1
        # Part one: obtain chromosome
        state = 0
        splitted = chromosome_string.split("(")
        metadata = splitted[0].split(",")
        self.inputs  = int(metadata[0][1:])
        self.outputs = int(metadata[1])
        self.cols    = int(metadata[2])
        self.rows    = int(metadata[3])
        self.lback   = int(metadata[6][:-1])
        self.chromosome = chromosome_string
        idx = self.inputs
        chrom = [[0]]*idx
        gene = [0]
        num_str = ""
        for gene_string in splitted[1:-1]:
            for char in gene_string:
                if state == 0:
                    if char == '[': # Start info part
                        state = 1
                    elif char == ')': # End loading gene -- save 
                        gene.append(circuit.GENE_TRANSLATION[int(num_str)])
                        num_str = ""
                        gene.append(idx)
                        chrom.append(gene)
                        idx += 1
                        gene = [0]
                        state = 0
                    elif char == ' ' or char == '\t' or char == '\n':
                        pass
                    elif char == ',':
                        gene.append(int(num_str))
                        num_str = ""
                    else: 
                        num_str += char
                elif state == 1 and char == ']':
                    state = 0
        to_int = lambda x : int(x)
        chrom.append(map(to_int, splitted[-1][:-1].split(',')))
        tmp = copy.deepcopy(chrom)
        
        # Part two: remove unused nodes
        for output in chrom[-1]:
            chrom[output][0] += 1
        # Backtracking of unused nodes
        for gene in chrom[-2:self.inputs:-1]:
            if gene[0] > 0: # used nodes.
                a = gene[1]
                b = gene[2]
                chrom[a][0] += 1
                if not (gene[3] == "BUF" or gene[3] == "NOT"):
                    chrom[b][0] += 1
        chrom = chrom[self.inputs:]
        fenotype = []
        removed_genes = 0
        for gene in chrom[:-1]:
            if gene[0] > 0:
                fenotype.append(gene[1:])
        fenotype.append(chrom[-1])
        
        # Part three: update fenotype
        result = []
        translate = {}
        for idx in range(self.inputs):
            translate[idx]=idx
        idx+=1
        for gene in fenotype[:-1]:
            translate[gene[-1]]=idx
            idx += 1
            try: # if not (gene[3] == "BUF" or gene[3] == "NOT"):
                result.append([translate[gene[0]],translate[gene[1]],gene[2]])
            except:
                result.append([translate[gene[0]],0,gene[2]])
        last_gene = []
        for output in fenotype[-1]:
            last_gene.append(translate[output])
        result.append(last_gene)
        self.circuit = result

        # Part four: get usefull data
        self.logic_gates = len(self.circuit) -1 
        nand_gates = 0
        transistors = 0
        vlsi_width = 0
        for gate in self.circuit[:-1]:
            nand_gates += circuit.NAND_GATES_USED[gate[-1]]
            transistors += circuit.CMOS_TRANSISTORS_USED[gate[-1]]
            vlsi_width += circuit.CMOS_VLSI_WIDTH[gate[-1]]
        self.nand_gates = nand_gates
        self.transistors = transistors
        self.vlsi_width = vlsi_width

        self.circuit = [[0 for i in xrange(0, 6)]]*self.inputs + self.circuit
        # Part five -- Pruchod od zadu
        for gene in self.circuit[-2:self.inputs:-1]: 
            try:
                latency = 1 + gene[3]
                nandLatency = circuit.NAND_GATES_LATENCY[gene[2]] + gene[4]
                logicalEffort = circuit.CMOS_LOGICAL_EFFORT[gene[2]] + gene[5]
            except:
                latency = 1
                nandLatency = circuit.NAND_GATES_LATENCY[gene[2]]
                logicalEffort = circuit.CMOS_LOGICAL_EFFORT[gene[2]]
            
            # Koukni na prvni vstup
            a_gene = self.circuit[gene[0]]
            try:
                if latency > a_gene[3]:
                    a_gene[3] = latency
                if nandLatency > a_gene[4]:
                    a_gene[4] = nandLatency
                if logicalEffort > a_gene[5]:
                    a_gene[5] = logicalEffort
            except:
                a_gene.append(latency)
                a_gene.append(nandLatency)
                a_gene.append(logicalEffort)

            # To same pro druhy 
            if gene[2] == "BUF" or gene[2] == "NOT":
                continue
            b_gene = self.circuit[gene[1]]

            try:
                if latency > b_gene[3]:
                    b_gene[3] = latency
                if nandLatency > b_gene[4]:
                    b_gene[4] = nandLatency
                if logicalEffort > b_gene[5]:
                    b_gene[5] = logicalEffort
            except:
                b_gene.append(latency)
                b_gene.append(nandLatency)
                b_gene.append(logicalEffort)
        self.latency = self.circuit[0][3]
        self.nandLatency = self.circuit[0][4]
        self.logicalEffort = self.circuit[0][5]
        for gene in self.circuit[1:self.inputs]: # For sure..
            if gene[3] > self.latency:
                self.latency = gene[3]
            if gene[4] > self.nandLatency:
                self.nandLatency = gene[4]
            if gene[5] > self.logicalEffort:
                self.logicalEffort = gene[5]
        # Odstranime bordel
        self.circuit = self.circuit[self.inputs:]
        f = lambda x : x[:3]
        self.circuit = map(f, self.circuit[:-1]) + [self.circuit[-1]]


        # FILL BUFFER
        input_ref = [0 for i in xrange(self.inputs)]
        output_ref = [0 for i in xrange(self.outputs)]
        shift = 0
        f = lambda listek, string: listek | (int(string) << shift)
        # Load the file
        chrom_buffer = [0 for i in xrange(len(self.circuit[:-1]))]
        self.errors = []
        self.functionality = []
        for line in open(data_fname):
            line = line.replace(" ", "")
            line = line[:line.find("#")]
            val = line.split(":")
            try:
                val[1]
            except:
                continue
            input_ref = map(f, input_ref, val[0])
            output_ref = map(f, output_ref, val[1])
            shift += 1
            buff = map(to_int, list(val[0])) + chrom_buffer
            idx = self.inputs
            for gene in self.circuit[:-1]:
                buff[idx] = circuit.INTERPRETATION[gene[2]](buff[gene[0]], buff[gene[1]])
                idx += 1
            #buff = map( lambda x : ~x&1, buff)
            buff = map( bufffunction, buff)

            # print buff, self.circuit[-1][::-1]
            # print reduce(lambda x, y : str(x) + str(y), map(lambda x : buff[x], self.circuit[-1][::-1]))
            output_obt = int(reduce(lambda x, y : str(x) + str(y), map(lambda x : buff[x], self.circuit[-1][::-1])), 2)
            a = val[0][ : self.inputs/2]
            b = val[0][self.inputs/2 : ]
            self.functionality.append((int(a,2), int(b, 2), int(val[1],2), output_obt))
            self.errors.append(abs(output_obt - int(val[1],2)))
            #print abs(output_obt - int(val[1],2))
        # Interpret chromosome for SHD
        chrom_buffer = input_ref + [0 for i in xrange(len(self.circuit[:-1]))]
        idx = self.inputs
        for gene in self.circuit[:-1]:
            chrom_buffer[idx] = circuit.INTERPRETATION[gene[2]](chrom_buffer[gene[0]], chrom_buffer[gene[1]])
            idx += 1
        output_obt = map(lambda x : chrom_buffer[x], self.circuit[-1][::-1])

        self.error_bits = sum(map(lambda x, y : bin(x ^ y).count("1"), output_obt, output_ref))
        self.correct_bits = self.outputs * 2**self.inputs - self.error_bits
        self.error_bits_rate = self.error_bits / float(self.outputs * 2**self.inputs)
        self.error_bits_rate_percent = self.error_bits_rate * 100

        self.errors = filter(lambda a: a != 0, self.errors)
        self.error_sum = len(self.errors)
        self.error_sum_rate = len(self.errors)/float(2**self.inputs)
        try:
            self.error_sad = sum(self.errors)
            self.error_max = max(self.errors)
            self.error_min = min(self.errors)
            self.error_avg = self.error_sad / float(2**self.inputs)
            self.error_dev = reduce(lambda a, x: a+(x-self.error_avg)**2, self.errors)/ float(2**self.inputs)
            self.error2_avg = self.error_sad / float(self.error_sum)
            self.error2_dev = reduce(lambda a, x: a+(x-self.error_avg)**2, self.errors)/ float(self.error_sum)
    
            errors_sort = sorted(self.errors)
            self.error_qu1 = errors_sort[self.error_sum*1/4]
            self.error_qu2 = errors_sort[self.error_sum*2/4]
            self.error_qu3 = errors_sort[self.error_sum*3/4]
            self.error_med = self.error_qu2
            self.error_mod = max(set(errors_sort), key=errors_sort.count)
        except:
            self.error_sad = 0
            self.error_max = 0
            self.error_min = 0
            self.error_avg = 0
            self.error_dev = 0
            self.error2_avg = 0
            self.error2_dev = 0
            
            self.error_qu1 = 0
            self.error_qu2 = 0
            self.error_qu3 = 0
            self.error_med = 0
            self.error_mod = 0
        

        """

            lastnodeidx--; 
            k--;
            fit += onescount(carry);
            for (; k >= 0; k--, lastnodeidx--){
                vysl = zeroscount(carry ^ nodeoutput[lastnodeidx]) << k;
                fit += vysl;
            }
            fitvalues[i] += fit;
        """


        

    def print_chrom(self):
        chrom = "{"+str(self.inputs)+","+str(self.outputs)+","+ str(len(self.circuit[:-1]))+",1,2,1,"+str(len(self.circuit[:-1]))+"}"
        idx = self.inputs
        for gene in self.circuit[:-1]:
            chrom += "(["+str(idx)+"]"+str(gene[0])+","+str(gene[1])+","+str(circuit.GENE_TRANSLATION.index(gene[2]))+")"
            idx+=1
        chrom += "("
        for i in self.circuit[-1]:
            chrom += str(i) + ","
        chrom = chrom[:-1] + ")"
        return chrom

        """
        idx = 0
        for out in self.circuit[-1]:
            print bin( out ^ output_val[idx])
            idx+=1
        print self.error_bits
        #for o in :
        """

    def info(self, data_fname):    
        print "===CIRCUIT INFO==="
        print "Data filename:", data_fname
        print "Inputs:", self.inputs, "\t\tOutputs:", self.outputs
        print "Gates:", self.logic_gates, "\t\tLatency:", self.latency
        print "NAND gates:", self.nand_gates, "\t\tNAND latency:", self.nandLatency
        print "Transistors:", self.transistors, "\tVLSI width:", self.vlsi_width, "\tLogicalEffort:", self.logicalEffort, "\t"
        print
        if self.error_bits != 0:
            print "Wrong combinations:", self.error_sum, "\tRate: %.4f" %self.error_sum_rate
            print "Error bits:", self.error_bits, "\tCorrect bits:", self.correct_bits, "\tBit error ratio: %.4f" % self.error_bits_rate
            print "Error sum:",self.error_sad
            print "Avg error: %.4f" % self.error2_avg,"\tStd deviation: %.4f" % self.error2_dev
            print "Avg error: %.4f" % self.error_avg, "\tStd deviation: %.4f" % self.error_dev, "\tContain correct combinatinos."
            print "Min:",self.error_min, "\tQ1:", self.error_qu1, "\tMed:", self.error_qu2, "\tQ3:", self.error_qu3, "\tMax:", self.error_max
            print "Most freq. error:", self.error_mod
            print
        print "Circuit:", self.circuit
        print
        print "Circuit chromosome:", self.print_chrom()

        



def main():
    try:
        filename = sys.argv[1]
    except:
        print "python2 ./getdata.py filename.log [-t]"
        exit(1)

    try:
        downto = False if sys.argv[2] == "-t" else True
    except:
        downto = True


    for line in open(filename):
        match = re.match(r"(Best individual:\s+(.*))", line)
        try: 
            chromosome_string = match.group(2)
        except:
            pass    
        match = re.match(r"\s*file:(.*), items.*", line)
        try: 
            data_fname = match.group(1)
        except:
            pass
    circ = circuit(chromosome_string, data_fname, outputs_are_downto=downto)
    circ.info(data_fname)
    string = ""


        
if __name__ == '__main__':
    main()
    sys.exit(0)

dirname = "./full_adder_3_3/"
time_sum = 0
med_sum = 0
avg_sum = 0
avg_time = 0
max_time = 0

for dirname in sorted(filter(os.path.isdir, os.listdir("."))):
    print dirname
    runs = []
    successfull_runs = [] # This shouldnt be used for approximate circuits. 
    if dirname.find("weighted") == -1 :
        continue
    dirname = "./"+dirname+"/"
    for filename in os.listdir(dirname):
        #print filename
        #print
        generations_find_st = -1
        for line in open(dirname+filename):
            match = re.match(r"(Best individual:\s+(.*))", line)
            try: 
                chromosome_string = match.group(2)
            except:
                pass
            match = re.match(r"\s*file:(.*), items.*", line)
            try: 
                data_fname = match.group(1)
            except:
                pass
            match = re.match(r"Duration:\s*([0-9]+\.?[0-9]*)\s+Evaluations per sec:\s+([0-9]+\.?[0-9]*)",line)
            try: 
                duration = int(float(match.group(1)))
                eps = match.group(2)
            except:
                pass
            match = re.match(r"Generation: ([0-9]+)\s+Fitness:\s*[^\s]+\s*Nodes:\s*([0-9]+).*", line) 
            try:
                generations_find_nd = match.group(1)
                nodes = match.group(2)
                if generations_find_st == -1:
                    generations_find_st =  match.group(1)
            except:
                pass
        circ = circuit(chromosome_string, data_fname)
        #circ = None
        if generations_find_st != -1:
            #print "Found at generation:",generations_find_st
            #print "Optimized at generation:",generations_find_nd
            successfull_runs.append([circ, duration, generations_find_st, generations_find_nd])
        
        runs.append([circ, duration])
    
        #circ.info(data_fname)
        #print circ.errors
        time_sum += duration
    tmp = map(lambda x : int(x[2]), successfull_runs)
    try:
        avg = sum(tmp)/len(tmp)
        med = sorted(tmp)[len(tmp)/2]
    except: 
        avg = -1
        med = -1
        tmp = [-1]
    time = map(lambda x : int(x[1]), runs)
    #print "Successfull runs: "+str(len(successfull_runs))+"/"+str(len(runs))
    #print "Avg found:",avg
    #print "Min:", min(tmp), "\tMed found:",med, "\tMax:", max(tmp)
    #print "TIME :: avg", sum(time)/len(time), "med",sorted(time)[len(time)/2], "max",max(time)
    #print
    avg_sum += avg
    med_sum += med
    avg_time += sum(time)/len(time)
    max_time += max(time)

    t = []
    for run in runs:
        c = run[0]
        t.append(c.error_sad)
    print "SAD MIN found: " +str( sorted(t)[0])
    print "SAD MED found: " +str( sorted(t)[len(t)/2])
    print "SAD MAX found: " +str( sorted(t)[-1])
    print
    
print 
print "Avg time sum: ", avg_time
print "Max time sum: ", max_time
    
print 
print "Total run time: "+str(time_sum) +" seconds"