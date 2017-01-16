#!/bin/python2
# This piece of code analyses chromosome of CGP representing circuit. 
# It analyzes its errors, area, delay and used components.
#
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# 
import os, re, sys, copy

# Usefull functions
def wshd(result):
    global weight
    result = result << weight
    weight -= 1
    return result
def dilemma(di, lemma):
    try: return di[lemma]
    except: return lemma

lambda_toint = lambda x: int(x)
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

    def __get_chromomsome(self, chrom_str):
        splitted = chrom_str.split("(") # Chromozom je ve tvaru "{int, int, int, int, int, int}([cislouzlu]int_a,int_b,int_f)([cislouzlu]int_a,int_b,int_f)...(int,int...int_outs)"
        # Ziskam metadata z prvniho zaznamu `splitted[0]`, ktery je ve tvaru "{int, int, int, int, int, int}". 
        # Z toho ziskam seznam sesti cisel, ktere je potreba pretypovat na int! 
        self.inputs, self.outputs, self.cols, self.rows, self.node_inputs, self.node_outputs, self.lback = map(lambda_toint, splitted[0][1:-1].split(","))
        # Parsrovani retezce + jeho pretypovani na list integeru
        chrom = map(lambda x: x[x.index(']')+1:-1], splitted[1:-1]) + [splitted[-1][:-1]]
        chrom[:] = map(lambda x: map(lambda_toint, x.split(',')), chrom)
        # Odstran draty bo se pocitaji jako uzly
        d = filter(lambda x: x[1][2] == 0, enumerate(chrom,self.inputs))
        d = dict(map(lambda x: (x[0],x[1][0]), d))
        for gene in chrom[:-1]:
            gene[0] = dilemma(d, gene[0])
            gene[1] = dilemma(d, gene[1])
        chrom[-1] = map(lambda x : dilemma(d, x), chrom[-1])
        # Dame pryc nepouzite uzly
        used_nodes = [True] * self.inputs + [False] * len(chrom)
        for gene in chrom[-1]:
            used_nodes[gene] = True
        # Backtracking of used nodes
        for i, gene in reversed(list(enumerate(chrom[:-1]))):
            if used_nodes[i + self.inputs]:
                used_nodes[gene[0]] = True
                if gene[2] > 1: 
                    used_nodes[gene[1]] = True
        # Create translation
        translate = range(len(used_nodes) + 2)
        skip = 0
        for val, used in zip(translate, used_nodes):
            translate[val] = val-skip
            if not used: skip += 1
        translate[-1] = -1; translate[-2] = -2
        # Create phenotype
        phenotype = map(lambda gene : [translate[gene[0][0]], translate[gene[0][1]], circuit.GENE_TRANSLATION[gene[0][2]]], 
                            filter(lambda x: x[1], 
                                zip(chrom[:-1], used_nodes[self.inputs:]))) + [map(lambda x : translate[x], chrom[-1])]
        self.circuit = phenotype

    def get_usefull_data(self):
        phenotype = self.circuit
        # Get usefull data from nodes
        self.nand_gates    = sum(map(lambda x : circuit.NAND_GATES_USED[x[2]],       phenotype[:-1]))
        self.transistors   = sum(map(lambda x : circuit.CMOS_TRANSISTORS_USED[x[2]], phenotype[:-1]))
        self.relative_area = sum(map(lambda x : circuit.CMOS_VLSI_WIDTH[x[2]],       phenotype[:-1]))
        self.logic_gates = len(filter(lambda x: x[2] != "BUF",  phenotype[:-1])) # vyfiltrujeme BUFFER -> JE TO DRAT
        # Get usefull data from critical path
        critical_path_nodes = [0]*(len(phenotype)- 1) + [0]*self.inputs 
        nand_latency = list(critical_path_nodes)
        logical_effort = list(critical_path_nodes)
        for i, gene in reversed(list(enumerate(phenotype[:-1]))):
            nand_latency[i+self.inputs] += circuit.NAND_GATES_LATENCY[gene[2]]
            logical_effort[i+self.inputs] += circuit.CMOS_LOGICAL_EFFORT[gene[2]]
            if gene[2] != "BUF":
                critical_path_nodes[i+self.inputs] += 1
            if critical_path_nodes[i+self.inputs] > critical_path_nodes[gene[0]]:
                critical_path_nodes[gene[0]] = critical_path_nodes[i+self.inputs]
            if nand_latency[i+self.inputs] > nand_latency[gene[0]]:
                nand_latency[gene[0]] = nand_latency[i+self.inputs]
            if logical_effort[i+self.inputs] > logical_effort[gene[0]]:
                logical_effort[gene[0]] = logical_effort[i+self.inputs]
            if gene[2] != "NOT" or gene[2] != "BUF":
                if critical_path_nodes[i+self.inputs] > critical_path_nodes[gene[1]]:
                    critical_path_nodes[gene[1]] = critical_path_nodes[i+self.inputs]
                if nand_latency[i+self.inputs] > nand_latency[gene[1]]:
                    nand_latency[gene[1]] = nand_latency[i+self.inputs]
                if logical_effort[i+self.inputs] > logical_effort[gene[1]]:
                    logical_effort[gene[1]] = logical_effort[i+self.inputs]
        self.logical_effort = max(logical_effort)
        self.latency_nodes = max(critical_path_nodes)
        self.latency_nand_logic = max(nand_latency)

    def check_errors(self, data_fname):
        self.data_fname = data_fname
        # Load input data from file `data_fname`
        input_ref = [0] * self.inputs
        output_ref = [0] * self.outputs
        shift = 0
        shift_load = lambda listek, string: listek | (int(string) << shift)
        for line in open(data_fname):   
            line = line.replace(" ", "") # Spaces can be removed
            line = line[:line.find("#")] # Sharp means comment
            if len(line) == 0: continue  # Are there some usefull data?
            in_val, out_val = line.split(":") # Input and output data are separated by colon
            input_ref = map(shift_load, input_ref, in_val)
            output_ref = map(shift_load, output_ref, out_val)
            shift += 1
        # Interpret circuit
        buff = input_ref +  [0] * (len(self.circuit) - 1) + [-1, 0]
        for i, gene in enumerate(self.circuit[:-1]):
            buff[i + self.inputs] = circuit.INTERPRETATION[gene[2]](buff[gene[0]], buff[gene[1]])
        # Get SHD
        self.error_shd = sum(map(lambda x, y : bin(buff[x] ^ y if buff[x] > 0 else (buff[x] ^ y) & ((1 << (1<<self.inputs))-1)).count("1"), 
                                 self.circuit[-1], output_ref))
        # Get WSHD
        global weight
        weight = self.outputs-1
        self.error_wshd = sum(map(wshd, map(lambda x, y : bin(buff[x] ^ y if buff[x] > 0 else (buff[x] ^ y) & ((1 << (1<<self.inputs))-1)).count("1"), 
                                 self.circuit[-1], output_ref)))
        # Get Errors
        self.error_differences = [0] * 2**self.inputs
        for i in xrange(2**self.inputs):
            shift, obt_val, ref_val = 0, 0, 0
            for ref, gene in zip(output_ref[::-1], self.circuit[-1][::-1]):
                if ref & 1 << i:
                    ref_val |= 1 <<shift
                if buff[gene] & 1 << i:
                    obt_val |= 1 <<shift
                shift = shift+1
            self.error_differences[i] = ref_val - obt_val
        # Error sum
        self.error_sad = sum(map(abs, self.error_differences))
    
    def get_more_errors(self):
        self.correct_combinations = len(filter(lambda x : x == 0, self.error_differences))
        self.incorrect_combinations = 2**self.inputs - self.correct_combinations
        self.correct_bits = 2**self.inputs * self.outputs - self.error_shd
        self.error_max = max(map(abs, self.error_differences))
        self.error_avg = self.error_sad/float((2**self.inputs))
        self.error_dev = reduce(lambda a, x: a+(x-self.error_avg)**2, self.error_differences)/ float(2**self.inputs)
    
        errors_only = map(abs, filter(lambda x: x != 0, self.error_differences))
        if len(errors_only) > 0:
            self.error_min = min(map(abs, errors_only))
            self.error_avg2 = self.error_sad/float(len(errors_only))
            self.error_dev2 = reduce(lambda a, x: a+(x-self.error_avg2)**2, errors_only)/ float(len(errors_only))
            errors_sort = sorted(errors_only)
            self.error_qu1 = errors_sort[len(errors_sort)*1/4]
            self.error_med = errors_sort[len(errors_sort)*2/4]
            self.error_qu3 = errors_sort[len(errors_sort)*3/4]
            self.error_modus = max(set(errors_sort), key=errors_sort.count)        


    def info(self):
        print "===CIRCUIT INFO==="
        try:    print "Data filename:", data_fname
        except: pass
        print "Inputs:", self.inputs, "\t\tOutputs:", self.outputs
        print "Gates:", self.logic_gates, "\t\tLatency:", self.latency_nodes
        print "NAND gates:", self.nand_gates, "\t\tNAND latency:", self.latency_nand_logic
        print "Transistors:", self.transistors, "\tVLSI width:", self.relative_area, "\tLogicalEffort:", self.logical_effort, "\t"
        print
        print "SHD:  ", self.error_shd
        print "WSHD: ", self.error_wshd
        print "SAD:  ", self.error_sad
        print 
        try:
            self.error_avg2
            print "Wrong combinations:", self.incorrect_combinations, "\tCorrect combinations: ", self.correct_combinations
            print "Error bits:", self.error_shd, "\tOK bits:", self.correct_bits
            print "Error sum:",self.error_sad
            print "Avg error: %.4f" % self.error_avg2,"\tStd deviation: %.4f" % self.error_dev2
            print "Avg error: %.4f" % self.error_avg, "\tStd deviation: %.4f" % self.error_dev, "\tContain correct combinatinos."
            print "Min:",self.error_min, "\tQ1:", self.error_qu1, "\tMed:", self.error_med, "\tQ3:", self.error_qu3, "\tMax:", self.error_max
            print "Most freq. error:", self.error_modus
            print
        except AttributeError: 
            pass
        print "Circuit:", self.circuit
        print

    def optimise(self, method=None):
        asap = [0]*self.inputs + [0]*len(self.circuit[:-1])
        for i, gene in enumerate(self.circuit[:-1], self.inputs):
            asap[i] = asap[gene[0]] if gene[2] == "BUF" or asap[gene[1]] < asap[gene[0]] else asap[gene[1]]
            asap[i] += 1
        alap = [0]*self.inputs + [0]*len(self.circuit[:-1])
        for i, gene in reversed(list(enumerate(self.circuit[:-1], self.inputs))):
            alap[i] += 1
            alap[gene[0]] = alap[i] if alap[i] > alap[gene[0]] else alap[gene[0]]
            alap[gene[1]] = alap[i] if alap[i] > alap[gene[1]] and gene[2] != "BUF" else alap[gene[1]]
        alap = map(lambda x: self.latency_nodes - x+1, alap)   
        asap = asap[self.inputs:]; alap = alap[self.inputs:]
        if method == None:
            for i in xrange(1,self.latency_nodes+1):
                print "Count of", i, "ASAP", asap.count(i), "ALAP", alap.count(i)
        # ALAP optimise
        elif method == "alap":
            cols, rows = self.latency_nodes, 0;
            for i in xrange(1,self.latency_nodes+1):
                rows = alap.count(i) if alap.count(i) > rows else rows
            translate = range(self.inputs+len(self.circuit[:-1]))
            chrom = ""
            op_circuit = zip(range(self.inputs, self.inputs+len(self.circuit[:-1])), alap, self.circuit[:-1])
            idx = self.inputs
            for i in xrange(1, self.latency_nodes+1):
                c = 0
                for node in filter(lambda x : x[1] == i, op_circuit):
                    translate[node[0]] = idx
                    chrom += "(["+str(idx)+"]"+str(translate[node[2][0]]) +","+str(translate[node[2][1]])+","+str(circuit.GENE_TRANSLATION.index(str(node[2][2])))+")"
                    idx += 1
                    c += 1                    
                for _ in xrange(c, rows):
                    chrom += "(["+str(idx)+"]0,0,0)"
                    idx += 1
                    c += 1

            s = "("
            for i in self.circuit[-1]:
                s += str(translate[i]) + ","
            s = s[:-1]+")"
            return "{"+str(self.inputs)+", "+str(self.outputs)+", "+str(cols)+", "+str(rows)+", 2, 1, "+str(cols)+"}" +chrom + s 
        elif method == "asap":
            print "<Code me>"

    def __init__(self, chromosome_string):
        super(circuit, self).__init__()
        self.__get_chromomsome(chromosome_string)
        
if __name__ == '__main__':
    try:
        filename = sys.argv[1]
        f = open(filename)
    except:
        print "Expected inputfile as argument"
        exit(1)
    retry = False
    try:
        for line in f:
            match = re.match(r"(Best individual:\s+(.*))", line)
            try: chromosome_string = match.group(2)
            except AttributeError: pass    
            match = re.match(r"\s*file:(.*), items.*", line)
            try: data_fname = match.group(1)
            except AttributeError: pass 
    except:
        retry = True
    try:
        chromosome_string = open(filename).readline()[:-1]
        data_fname = sys.argv[2]
    except:
        print "Fail during obtaining chromosome"
        exit(1)

    #if __debug__: 
    #    chromosome_string = "{6, 4, 6, 1, 2, 1, 6}([6]2,5,3)([7]0,3,4)([8]0,3,2)([9]1,4,2)([10]6,9,3)([11]1,4,3)(8,7,11,10)"
    #    print "Testing circuit:", chromosome_string
    #    print "It's SAD fitness is 44. Max error: 3"
    c = circuit(chromosome_string)
    c.get_usefull_data()
    c.check_errors(data_fname)
    c.get_more_errors()
    c.info()
    exit(1)
    chrom = c.optimise("alap")

    print chrom
    exit(1)
    c = circuit(chrom)
    c.get_usefull_data()
    c.check_errors(data_fname)
    c.get_more_errors()
    c.info()
    exit(1)
    
    
    
