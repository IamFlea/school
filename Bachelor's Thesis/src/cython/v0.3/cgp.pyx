#!/usr/bin/env python3

DEF CIRCUIT = 1
DEF EQUATION = 2

#from cgp_equation import CgpEquation
#from cgp_circuit  import CgpCircuit
import sys 
#from math import sin

#  TODO bestfitness se bude mazat jen pri zmene i/o dat!!!

## This class serves for setting CGP params. 
#  It is selected concrete behavior of CGP (circuit or equation).
class Cgp:
    NODE_INPUT  = 2 # This Implementation works with maximal 2 node inputs.
    NODE_OUTPUT = 1 # This implementation works with maximal 1 node output

    DEFAULT_ROWS = 1
    DEFAULT_COLS = 40

    ## The constructor of CGP.
    #  @param self The object pointer.
    #  @param rows Rows of CGP graph.
    #  @param cols Columns of CGP graph.
    #  @param lBack Level back parameter represents connection between columns.
    #  @param input Input data.
    #  @param output Output data.
    def __init__(self, rows=None, cols=None, lBack=None, input=None, output=None):
        # Check validity of params
        if rows is not None and cols is None:
            raise Exception("Expecting parameter - cols - in __init__()")
        if input is not None and output is None:
            raise Exception("Expecting parameter - output data - in __init__()")
        # Set CGP values.
        self.rows        = rows
        self.cols        = cols
        self.levelBack   = lBack
        self.dataInput   = input
        self.dataOutput  = output
        self.nodeInputPorts  = Cgp.NODE_INPUT
        self.nodeOutputPorts = Cgp.NODE_OUTPUT
        self.function = CgpFunctions()

        # Default vars.
        if self.rows      is None: self.rows = self.DEFAULT_ROWS
        if self.cols      is None: self.cols = self.DEFAULT_COLS
        if self.levelBack is None: self.levelBack = self.cols    # Set max connection

        self.maxFitness  = None
        self.bestFitness = None
        self.elapsed     = None
        self.evalspersec = None
        self.chrom       = None


    #__init__()

    ## Setting graph options.
    #  @param self The object pointer.
    #  @param rows Rows of CGP graph.
    #  @param cols Columns of CGP graph.
    def graph(self, rows, cols, levelBack=None):
        self.rows      = rows
        self.cols      = cols
        self.levelBack = levelBack
        # Default vars.
        if self.levelBack is None: self.levelBack = cols    # Set max connection.
    #graph(row, col, l)

    ## Sets data from file.
    #  @param self The object pointer.
    #  @param filename Filename.
    def file(self, filename):
        # Check file
        f = open(filename, 'r')
        state = "INIT"
        type = CIRCUIT
        tmp = 1
        for line in f:
            str = line.split("#")[0].split(":") # Delete comments.
            if len(str) != 2: continue          # Skip if it is not in format: "input : output"
            
            # INIT phase
            if state == "INIT":
                # Check string.
                for char in str[0]:
                    if char != '0' and char != '1' and char != ' ':
                        type = EQUATION
                # Select CGP and init i/o variables
                if type == CIRCUIT:
                    str[0] = str[0].replace(" ", "")
                    str[1] = str[1].replace(" ", "")
                    str[0] = str[0].replace("\t", "")
                    str[1] = str[1].replace("\t", "")
                    str[0] = str[0].replace("\n", "")
                    str[1] = str[1].replace("\n", "")
                    str[0] = str[0].replace("\r", "")
                    str[1] = str[1].replace("\r", "")
                    input  = [0] * len(str[0])
                    output = [0] * len(str[1])
                    state = "SAVE_DATA"
                else:
                    inLen = 0
                    for i in str[0].split(" "):
                        if len(i) > 0:
                            inLen+=1 
                    outLen = 0
                    for i in str[1].split(" "):
                        if len(i) > 0:
                            outLen +=1 
                    input  = []
                    output = []
                    # init 
                    input_str  = str[0].split(" ")
                    output_str = str[1].split(" ")
                    idx = 0
                    for i in input_str:
                        if len(i) >= 1:
                            input.append([float(i)])
                            idx+=1
                    idx = 0
                    for i in output_str:
                        if len(i) >= 1:
                            output.append([float(i)])
                            idx+=1
                    state = "SAVE_DATA"
                    continue # sorry for hack

            #INIT phase end
            
            # SAVE_DATA phase.
            if type == CIRCUIT:                     # CIRCUIT
                str[0] = str[0].replace(" ", "")
                str[1] = str[1].replace(" ", "")
                str[0] = str[0].replace("\t", "")
                str[1] = str[1].replace("\t", "")
                str[0] = str[0].replace("\n", "")
                str[1] = str[1].replace("\n", "")
                str[0] = str[0].replace("\r", "")
                str[1] = str[1].replace("\r", "")
                input_str  = str[0]
                output_str = str[1]
                idx = 0
                for i in range(0, len(str[0])):
                    if str[0][idx] == '1':
                        input[idx] = input[i] | tmp
                    elif str[0][idx] == '0':
                        pass
                    else:
                        raise Exception("File format is wrong!")
                    idx+=1
                idx = 0
                for i in range(0, len(str[1])):
                    if str[1][idx] == '1':
                        output[idx] = output[i] | tmp
                    elif str[1][idx] == '0':
                        pass
                    else:
                        raise Exception("File format is wrong!")
                    idx+=1
                tmp = tmp << 1
            else:                                       # EQUATION
                input_str  = str[0].split(" ")
                output_str = str[1].split(" ")
                idx = 0
                for i in input_str:
                    if len(i) >= 1:
                        input[idx].append(float(i))
                        idx+=1
                idx = 0
                for i in output_str:
                    if len(i) >= 1:
                        output[idx].append(float(i))
                        idx+=1
        f.close()
        self.dataInput  = input
        self.dataOutput = output
    #self.file(filename)

    ## Setting data.
    #  @param self The object pointer.
    #  @param input Input data.
    #  @param output Output data.
    def data(self, input, output):
        self.dataInput  = input
        self.dataOutput = output

    ## Selects type of CGP. 
    #  @param self The object pointer.
    #  @return CGP type.
    def __getCGPtype(self):
        if type(self.dataInput[0]) is int:
            return CIRCUIT
        # Python2 only.
        try:
            if type(self.dataInput[0]) is long:
                return CIRCUIT
        except: 
            pass
        return EQUATION
    

    ## Runs the CGP algorithm.
    #  @param self The object pointer.
    #  @param generation Count of CGP iterations.
    #  @param population Population of CGP. Includes parent.
    #  @param mutation Count of maximum gene mutations that can occurs in one chromosome mutation.
    def run(self, generation, population, mutation, runs=None, acc=None):
        self.graphInputCnt  = len(self.dataInput)
        self.graphOutputCnt = len(self.dataOutput)
        # Check params overloading
        if runs is None: runs = 1
        elif type(runs) is float: acc  = runs; runs = 1
        # Check data if exists
        if self.dataInput is None or self.dataOutput is None:
            raise Exception("CGP Data was not initiated!")
        type_ = self.__getCGPtype()
        # Select type of CGP
        if self.function.set is None or self.function.type != type_:
            if self.function.set is not None: 
                raise Exception("Bad function set!")
            if type_ == CIRCUIT:
                self.function.allLogicalOperations()
            else:
                self.function.symbolicRegressionWithSin()

        # Init object with params of this object.
        if type_ == CIRCUIT:
            self.function.allLogicalOperations()
            input = list(self.dataInput)
            output = list(self.dataOutput)
            cgp_cir = CgpCircuit(self.cols, self.rows, self.levelBack, input, output, self.function)
            #Cgp.mask = len(bin(self.dataInput[0]))-2
            self.bestFitness = 0
        else:
            self.function.symbolicRegressionWithSin()
            input = list(self.dataInput)
            output = list(self.dataOutput)
            cgp_eq = CgpEquation(self.cols, self.rows, self.levelBack, input, output, self.function)
            self.bestFitness = float("inf")


        # Run, Forest, run!
        for i in range(runs):
            if runs != 1:
                print "STARTING RUN " + str(i)
            # Save results.
            if type_ == CIRCUIT:
                cgp_cir.run(generation, population, mutation)
                if self.bestFitness < cgp_cir.bestFitness:
                    self.maxFitness  = cgp_cir.maxFitness
                    self.bestFitness = cgp_cir.bestFitness
                    self.elapsed     = cgp_cir.elapsed
                    self.evalspersec = cgp_cir.evalspersec
                    self.chrom       = cgp_cir.result
                if runs != 1:
                    if cgp_cir.bestFitness == self.bestFitness:
                        print "Run " + str(i) + " ended with " + str(cgp_cir.bestFitness) + " This is the best fitness."
                    else:
                        print "Run " + str(i) + " ended with " + str(cgp_cir.bestFitness) + " / " + str(self.bestFitness)
            else:
                cgp_eq.run_desc(generation, population, mutation, acc)
                if self.bestFitness > cgp_eq.bestFitness:
                    self.maxFitness  = cgp_eq.maxFitness
                    self.bestFitness = cgp_eq.bestFitness
                    self.elapsed     = cgp_eq.elapsed
                    self.evalspersec = cgp_eq.evalspersec
                    self.chrom       = cgp_eq.result
                if runs != 1:
                    if cgp_eq.bestFitness == self.bestFitness:
                        print "Run " + str(i) + " ended with " + str(cgp_eq.bestFitness) + " This is the best fitness."
                    else:
                        print "Run " + str(i) + " ended with " + str(cgp_eq.bestFitness) + " / " + str(self.bestFitness)


    ######
    # TOOL FUNCTIONS
    def resultEquation(self, chrom=None):
        if chrom is None: chrom = self.chrom
        if self.chrom is None: raise
        result = ""
        for i in range(self.graphOutputCnt):
            result += "out_"+ str(i) + "=" + self.__getEq(chrom, chrom[i + self.rows * self.cols * (self.function.inputs + self.function.outputs)])+ "\n"
        return result
    
    def __getEq(self, chrom, nodeidx):
        geneLen = self.nodeInputPorts + self.nodeOutputPorts
        if nodeidx < self.graphInputCnt:
            return "in_" + str(nodeidx)
        else:
            nodeidx -= self.graphInputCnt
            node_in1 = chrom[nodeidx*geneLen]
            node_in2 = chrom[nodeidx*geneLen +1]
            function = chrom[nodeidx * geneLen + 2]
            if self.function.arity[function] == 0:
                return self.function.op[function]
            elif self.function.arity[function] == 1:
                return self.function.op[function] + "("+ self.__getEq(chrom, node_in1)+")"
            elif self.function.arity[function] == 2:
                return "("+ self.__getEq(chrom, node_in1) +self.function.op[function] + self.__getEq(chrom, node_in2)+")"

    
    def resultChrom(self, chrom=None ):
        if chrom is None: chrom = self.chrom
        if self.chrom is None: raise
        result  = "{"
        result += str(self.graphInputCnt) 
        result += ","
        result += str(self.graphOutputCnt) 
        result += ","
        result += str(self.rows) 
        result += ","
        result += str(self.cols) 
        result += ","
        result += str(self.nodeInputPorts) 
        result += ","
        result += "1" # DEFAULT
        result += ","
        result += str(self.levelBack)
        result += "}"
        start = 1
        idx = 0
        for i in range(0, self.rows * self.cols):
            result += "("
            for i in range(0, self.nodeInputPorts + self.nodeOutputPorts):
                result += str(chrom[idx])
                result += ","
                idx+=1
            result = result[:-1]
            result += ")"
        result += "("
        for i in range(0, self.graphOutputCnt):
            result += str(chrom[idx])
            result += ","
            idx+=1
        result = result[:-1]
        result += ")"
        return result


    ## Prints chromosome in more readable format.
    #  @param self The object pointer.
    def showChrom(self, chrom=None):
        if chrom is None: chrom = self.chrom
        if self.chrom is None: raise
        table = self.function.table
        i = self.graphInputCnt
        result = "Inputs: 0 -" + str(i-1) + '\n'
        for j in range(0, self.rows):
            for k in range(0, self.cols):
                a = chrom[(i-self.graphInputCnt)*3]
                b = chrom[(i-self.graphInputCnt)*3 + 1]
                f = chrom[(i-self.graphInputCnt)*3 + 2]
                result += repr(i).rjust(3)
                result += ":["
                result += repr(a).rjust(3)
                result += " "
                result += repr(b).rjust(3)
                result += " "
                try:
                    result += table[f]
                except:
                    try:
                        stra = str(f)
                        result += stra
                    except:
                        result += "XXXX"
                result += "] "
                i += self.rows
            result += '\n'
            i = self.graphInputCnt + j +1

        result += "Output connected on: "
        first = 0
        for i in range(len(chrom)-self.graphOutputCnt, len(chrom)):
            if first: result += ","
            first = 1
            result += repr(chrom[i])
        result += '\n'
        return result

