#!/usr/bin/env python3
include "cgp_circuit.pyx"
include "cgp_equation.pyx"
include "cgp_functions.pyx"
include "cgp_classification.pyx"


DEF CIRCUIT = 1
DEF EQUATION = 2

#from cgp_equation import CgpEquation
#from cgp_circuit  import CgpCircuit
import sys 
#from math import sin

#  TODO bestfitness se bude mazat jen pri zmene i/o dat!!!

## This class serves for setting CGP params and binds python with C module.
#  It is selected concrete behavior of CGP (circuit or equation).
class Cgp:
    """Cartesian genetic programming is a form of genetic programming that encodes a graph representation. 
It was implemented by Julian Miller and Peter Thomson. 
This module can be used for symbolic regression, electronic circuit design or classification. 

It is selected specific behavior of CGP from i/o data!
Floats are used for symbolic regression and classifications.
Integers are used for electronic circuit design.

Object methods:
    __init__(rows, cols, levelBack, inputData, outputData) 
        The constructor. Params are not required. 
    graph(rows, cols, levelBack)
        Graph constructor.
        If levelBack isn't set, it is used maximal value.
    file(filename)
        Parse data from file. 
    data(inputData, outputData)
        Get data from the file.
    run(generations, populations, mutations, accuracy, numberOfRuns)
        Run the simulation of circuit. 
    resultEquation()
        Gets result equation. 
    resultChrom()
        Gets result chromosome for cgpviewer.
    showChrom()
        Shows chromosome in more readable form. Maybe."""
    NODE_INPUT  = 2 # This Implementation works with maximal 2 node inputs.
    NODE_OUTPUT = 1 # This implementation works with maximal 1 node output

    DEFAULT_ROWS = 1
    DEFAULT_COLS = 40

    def __init__(self, rows=None, cols=None, levelBack=None, input=None, output=None):
        """The constructor initiate the world of CGP!
__init__(rows=None, cols=None, levelBack=None, input=None, output=None)
    @param rows      Graph rows.
    @param cols      Graph columns.
    @param levelBack Level-back defines maximal connection between columns.
    @param input     Input data.
    @param output    Data output.
        """
        # Check validity of params
        if rows is not None and cols is None:
            raise Exception("Expecting parameter - cols - in __init__()")
        if input is not None and output is None:
            raise Exception("Expecting parameter - output data - in __init__()")
        # Set CGP values.
        self.rows        = rows
        self.cols        = cols
        self.levelBack   = levelBack
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
        """Setting graph options.

graph(rows, cols, levelBack=None)
    @param rows      Graph rows.
    @param cols      Graph columns.
    @param levelBack Level-back defines maximal connection between columns.
        """
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
        """Setting data from file.
file(filename)
    @param filename Filename.

Format of file:
    Input and output data are separated by colon.
    If it used float format each data should be seperated by space.
    Example for symbolic regresion
        # This is comment
            42.0 1.5 6.66 : 12.1 13.2   # Another comment
            42.0 1.5 6.66 : 12.1 13.1
    Example for classification
        # Output values represents the class. 
        # This is comment
            42.0 1.5 6.66 : 1.0  -1.0   # Another comment
            45.0 1.3 6.26 : 1.0  -1.0
            14.0 6.3 0.26 : -1.0  1.0
            14.4 6.4 0.46 : -1.0  1.0
    Example for circuit design
        # This is comment
            0000 0000 : 00000000 # 0*0 = 0
            0010 0010 : 00000100 # 2*2 = 4
        """
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
        """Setting data.
List of lists for symbolic regression or classification.
List for circuits.

data(input, output)
    @param input Input data. 
    @param output Ouput data.
        """
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
        """Runs CGP algorithm.

For CIRCUITS:
run(generation, population, mutation, runs=None)
    @param generation Count of CGP iterations.
    @param population Population of CGP includes parent individual. 
    @param mutation   Count of maximum gene mutations that can occurs in one chromosme.
    @param runs       Number of runs of CGP.

For SYMBOLIC REGRESSION or CLASSIFICATION
run(generation, population, mutation, acc, runs=None)
    @param generation Count of CGP iterations.
    @param population Population of CGP includes parent individual. 
    @param mutation   Count of maximum gene mutations that can occurs in one chromosme.
    @param acc        Accuracy of new fitness. 
    @param runs       Number of runs of CGP.
        """

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


    def run_classification(self, generation, population, mutation, runs=None, acc=None):
        """Runs CGP algorithm. For classificiation problems. 

run(generation, population, mutation, acc, runs=None)
    @param generation Count of CGP iterations.
    @param population Population of CGP includes parent individual. 
    @param mutation   Count of maximum gene mutations that can occurs in one chromosme.
    @param acc        Accuracy of new fitness. 
    @param runs       Number of runs of CGP.
        """

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
                raise Exception("Classification is not supported for this data set! Use float representations.")
            else:
                self.function.classification()

        input = list(self.dataInput)
        output = list(self.dataOutput)
        cgp_eq = CgpClassification(self.cols, self.rows, self.levelBack, input, output, self.function)
        self.bestFitness = float("inf")


        # Run, Forest, run!
        for i in range(runs):
            if runs != 1:
                print "STARTING RUN " + str(i)
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
        """Print equation from result chromomse."""
        if chrom is None: chrom = self.chrom
        if self.chrom is None: raise
        result = ""
        for i in range(self.graphOutputCnt):
            result += "out_"+ str(i) + "=" + self.__getEq(chrom, chrom[i + self.rows * self.cols * (self.function.inputs + self.function.outputs)])+ "\n"
        return result
    
    def __getEq(self, chrom, nodeidx):
        geneLen = self.function.inputs + self.function.outputs
        #geneLen = self.nodeInputPorts + self.nodeOutputPorts
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

    def resultEquationPostFix(self, chrom=None):
        """Print equation from result chromomse."""
        if chrom is None: chrom = self.chrom
        if self.chrom is None: raise
        result = ""
        for i in range(self.graphOutputCnt):
            result += "out_"+ str(i) + "=" + self.__getEqPf(chrom, chrom[i + self.rows * self.cols * (self.function.inputs + self.function.outputs)])+ "\n"
        return result
    
    def __getEqPf(self, chrom, nodeidx):
        geneLen = self.function.inputs + self.function.outputs
        if nodeidx < self.graphInputCnt:
            return "in_" + str(nodeidx)
        else:
            nodeidx -= self.graphInputCnt
            node_in1 = chrom[nodeidx*geneLen]
            node_in2 = chrom[nodeidx*geneLen + 1]
            node_in3 = chrom[nodeidx*geneLen + 2]
            function = chrom[nodeidx*geneLen + 3]
            if self.function.arity[function] == 0:
                return self.function.op[function]
            elif self.function.arity[function] == 1:
                return "("+self.function.op[function] +" "+ self.__getEqPf(chrom, node_in1)+")"
            elif self.function.arity[function] == 2:
                return "("+self.function.op[function] +" "+ self.__getEqPf(chrom, node_in1)+ " "+ self.__getEqPf(chrom, node_in2)+")"
            elif self.function.arity[function] == 3:
                return "("+self.function.op[function] +" "+ self.__getEqPf(chrom, node_in1)+ " "+ self.__getEqPf(chrom, node_in2) +" "+ self.__getEqPf(chrom, node_in3) + ")"

    def eq(self, chrom=None):
        """Print equation from result chromomse."""
        if chrom is None: chrom = self.chrom
        if self.chrom is None: raise
        result = ""
        result += "f2b = lambda x: 1 if x >= 0 else 0\n"
        result += "b2f = lambda x: 1.0 if x == 1 else -1.0\n"
        sinputs = ""
        for i in range(self.graphInputCnt):
            sinputs += "in_" +str(i) + ", "
        for i in range(self.graphOutputCnt):
            result += "out_" + str(i) + " = lambda "+ sinputs + " : 1.0 if " + self.__eq(chrom, chrom[i + self.rows * self.cols * (self.function.inputs + self.function.outputs)])+ " >= 0 else -1.0\n"
        return result
    
    def __eq(self, chrom, nodeidx):
        geneLen = self.function.inputs + self.function.outputs
        if nodeidx < self.graphInputCnt:
            return "in_" + str(nodeidx)
        else:
            nodeidx -= self.graphInputCnt
            node_in1 = chrom[nodeidx*geneLen]
            node_in2 = chrom[nodeidx*geneLen + 1]
            node_in3 = chrom[nodeidx*geneLen + 2]
            function = chrom[nodeidx*geneLen + 3]
            op = self.function.table[function]
            ar = self.function.arity[function]
            """
#self.set   = [C_1_24, C_2_71, C_3_14, C_add, C_sub, C_mul, C_div, C_neg, C_if, C_iflez, C_lt, C_lte, C_gt, C_gte, C_eq, C_and, C_or, C_not, C_nand, C_nor]
#self.table = ["1_24", "2_71", "3_14", "add", "sub", "mul", "div", "neg", "if", "iflez", "lt", "lte", "gt", "gte", "eq", "and", "or", "not", "nand", "nor"]
            """
            
            if op == "1_24":
                return "1.24"
            elif op == "2_71":
                return "2.71"
            elif op == "3_14":
                return "3.14"
            elif op == "add":
                return "("+ self.__eq(chrom, node_in1)+ "+" + self.__eq(chrom, node_in2)+")"
            elif op == "sub":
                return "("+ self.__eq(chrom, node_in1)+ "-" + self.__eq(chrom, node_in2)+")"
            elif op == "mul":
                return "("+ self.__eq(chrom, node_in1)+ "*" + self.__eq(chrom, node_in2)+")"
            elif op == "div":
                a = self.__eq(chrom, node_in1)
                b = self.__eq(chrom, node_in2)
                return "(("+ a +"/" + b +") if "+b+" != 0.0 else 1e10)"
            elif op == "neg":
                return "("+ "-" + self.__eq(chrom, node_in1)+")"
            elif op == "if":
                return "("+  self.__eq(chrom, node_in2) + " if " + self.__eq(chrom, node_in1) +" else "+ self.__eq(chrom, node_in3)+")"
            elif op == "iflez":
                return "("+  self.__eq(chrom, node_in2)  +" if " + self.__eq(chrom, node_in1) +" <= 0 else "+ self.__eq(chrom, node_in3)+")"
            elif op == "lt":
                return "b2f("+ self.__eq(chrom, node_in1)+ "<" + self.__eq(chrom, node_in2)+")"
            elif op == "lte":
                return "b2f("+ self.__eq(chrom, node_in1)+ "<=" + self.__eq(chrom, node_in2)+")"
            elif op == "gt":
                return "b2f("+ self.__eq(chrom, node_in1)+ ">" + self.__eq(chrom, node_in2)+")"
            elif op == "gte":
                return "b2f("+ self.__eq(chrom, node_in1)+ ">=" + self.__eq(chrom, node_in2)+")"
            elif op == "eq":
                return "b2f("+ self.__eq(chrom, node_in1)+ "==" + self.__eq(chrom, node_in2)+")"
            elif op == "and":
                return "(b2f( f2b("+ self.__eq(chrom, node_in1)+ ") and f2b(" + self.__eq(chrom, node_in2)+")))"
                #return "("+ self.__eq(chrom, node_in1)+ " and " + self.__eq(chrom, node_in2)+")"
            elif op == "or":
                return "(b2f( f2b("+ self.__eq(chrom, node_in1)+ ") or f2b(" + self.__eq(chrom, node_in2)+")))"
                #return "("+ self.__eq(chrom, node_in1)+ " or " + self.__eq(chrom, node_in2)+")"
            elif op == "nor":
                return "(b2f(not( f2b("+ self.__eq(chrom, node_in1)+ ") or f2b(" + self.__eq(chrom, node_in2)+"))))"
                #return "(not("+ self.__eq(chrom, node_in1)+ " or " + self.__eq(chrom, node_in2)+"))"
            elif op == "nand":
                return "(b2f(not( f2b("+ self.__eq(chrom, node_in1)+ ") and f2b(" + self.__eq(chrom, node_in2)+"))))"
                #return "(not("+ self.__eq(chrom, node_in1)+ " or " + self.__eq(chrom, node_in2)+"))"
            elif op == "not":
                return "(b2f(not (f2b(" + self.__eq(chrom, node_in1)+"))))"
            else :
                print op
                raise  

            
    
    def resultChrom(self, chrom=None):
        """Print result chromomse. Compactibile with CGPview.exe"""
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
        """Shows chromse in more readable form."""
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

