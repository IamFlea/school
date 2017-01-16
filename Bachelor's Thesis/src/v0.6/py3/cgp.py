#!/usr/bin/env python3
from cgp_equation import CgpEquation
from cgp_circuit  import CgpCircuit
import sys 
from math import sin

#  TODO bestfitness se bude mazat jen pri zmene i/o dat!!!

## This class serves for setting CGP params. 
#  It is selected concrete behavior of CGP (circuit or equation).
class Cgp:
    NODE_INPUT  = 2 # This Implementation works with maximal 2 node inputs.
    NODE_OUTPUT = 1 # This implementation works with maximal 1 node output

    DEFAULT_ROWS = 1
    DEFAULT_COLS = 40

    CIRCUIT = 1
    EQUATION = 2

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
            raise Error("Expecting parameter - cols - in __init__()")
        if input is not None and output is None:
            raise Error("Expecting parameter - output data - in __init__()")
        # Set CGP values.
        self.rows        = rows
        self.cols        = cols
        self.levelBack   = lBack
        self.dataInput   = input
        self.dataOutput  = output
        self.nodeInputPorts  = Cgp.NODE_INPUT
        self.nodeOutputPorts = Cgp.NODE_OUTPUT

        # Default vars.
        if self.rows      is None: self.DEFAULT_ROWS
        if self.cols      is None: self.DEFAULT_COLS
        if self.levelBack is None: self.cols    # Set max connection
        self.functionSet = None
        self.functionType = None


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
        if self.levelBack is None: self.cols    # Set max connection.
    #graph(row, col, l)

    ## Sets data from file.
    #  @param self The object pointer.
    #  @param filename Filename.
    def file(self, filename):
        # Check file
        f = open(filename, 'r')
        state = "INIT"
        type = Cgp.CIRCUIT
        tmp = 1
        for line in f:
            str = line.split("#")[0].split(":") # Delete comments.
            if len(str) != 2: continue          # Skip if it is not in format: "input : output"
            
            # INIT phase
            if state == "INIT":
                # Check string.
                for char in str[0]:
                    if char != '0' and char != '1' and char != ' ':
                        type = Cgp.EQUATION
                # Select CGP and init i/o variables
                if type == Cgp.CIRCUIT:
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
            if type == Cgp.CIRCUIT:                     # CIRCUIT
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
            return Cgp.CIRCUIT
        # Python2 only.
        try:
            if type(self.dataInput[0]) is long:
                return Cgp.CIRCUIT
        except: 
            pass
        return Cgp.EQUATION
    

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
        if self.functionSet is None or self.functionType != type_:
            if self.functionSet is not None: 
                print("Warning: changed functions set!")
            if type_ == Cgp.CIRCUIT:
                self.allLogicalOperations()
            else:
                self.symbolicRegressionWithSin()

        # Init object with params of this object.
        if type_ == Cgp.CIRCUIT:
            cgp = CgpCircuit(self.__dict__, population)
            #Cgp.mask = len(bin(self.dataInput[0]))-2
            self.bestFitness = 0
        else:
            cgp = CgpEquation(self.__dict__, population)
            self.bestFitness = float("inf")

        # Run, Forest, run!
        for i in range(runs):
            cgp.run(generation, population, mutation, acc)
            # Save results.
            if type_ == cgp.CIRCUIT:
                if self.bestFitness < cgp.popFitness[cgp.parent]:
                    self.bestfitness     = cgp.popFitness[cgp.parent]
                    self.chromosome = cgp.pop[cgp.parent]
                    self.result     = cgp.__dict__.copy()
            else:
                if self.bestFitness > cgp.popFitness[cgp.parent]:
                    self.bestFitness     = cgp.popFitness[cgp.parent]
                    self.chromosome = cgp.pop[cgp.parent]
                    self.result     = cgp.__dict__.copy()


    ######
    # TOOL FUNCTIONS
    def resultEquation(self, chrom=None):
        if chrom is None: chrom = self.chromosome
        result = ""
        for i in range(self.graphOutputCnt):
            result += "out_"+ str(i) + "=" + self.__getEq(chrom, chrom[i + self.rows * self.cols * (self.nodeInputPorts + self.nodeOutputPorts)])+ "\n"
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
            if self.functionArity[function] == 0:
                return self.functionTableOp[function]
            elif self.functionArity[function] == 1:
                return self.functionTableOp[function] + "("+ self.__getEq(chrom, node_in1)+")"
            elif self.functionArity[function] == 2:
                return "("+ self.__getEq(chrom, node_in1) +self.functionTableOp[function] + self.__getEq(chrom, node_in2)+")"

    
    def resultChrom(self, chrom=None ):
        if chrom is None: chrom = self.chromosome
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
        if chrom is None: chrom = self.chromosome
        table = self.functionTable
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

    ############################################################################
    #  Functions of CGP
    ############################################################################
    id   = lambda a, b: a
    and_ = lambda a, b: a & b
    or_  = lambda a, b: a | b
    xor  = lambda a, b: a ^ b
    not_ = lambda a, b: ~a
    nand = lambda a, b: ~(a & b)
    nor  = lambda a, b: ~(a | b)
    nxor = lambda a, b: ~(a ^ b)

    add  = lambda a, b: a + b
    sub  = lambda a, b: a - b
    mul  = lambda a, b: a * b
    div  = lambda a, b: a / b # if b != 0.0 else 10.0**10.0
    sin  = lambda a, b: sin(a) # if a != float("inf") else float("inf")
    _0_25= lambda a, b: 0.25
    _0_50= lambda a, b: 0.50
    _1_00= lambda a, b: 1.00

    # Stack:        [b, a, self.mask]
    # Top of stack: b 
    # Byte codes: 
    # 1  POP TOS 
    # 2  SWAP TOS TOS1
    # 9  NOP
    # 24 SUB  (TOS = TOS1 - TOS)
    # 64 AND
    # 65 XOR
    # 66 OR
    def allLogicalOperations(self):
        self.functionType  = Cgp.CIRCUIT
        self.functionSet   = [Cgp.id, Cgp.and_, Cgp.or_, Cgp.xor, Cgp.not_,  Cgp.nand, Cgp.nor, Cgp.nxor]
        self.functionTable = ["BUFa",  "AND ",    "OR  ",   "XOR ",   "NOTa",     "NAND",    "NOR ",   "NXOR"]
        self.functionTableOp=["BUFa",  "AND ",    "OR  ",   "XOR ",   "NOTa",     "NAND",    "NOR ",   "NXOR"]
        self.functionArity = [1,       2,         2,        2,        1,          2,         2,        2]
        self.functionBC1   = [1,       64,        66,       65,       15,         64,        66,       65]
        self.functionBC2   = [9,       9,         9,        9,        9,          15,        15,       15]
        self.functionSetStr = ["a", "a & b", "a | b", "a ^ b", "~a", "~(a & b)", "~(a | b)", "~(a ^ b)"]

    def booleanAlgebra(self):
        self.functionType  = Cgp.CIRCUIT
        self.functionSet   = [self.id,     self.and_, self.or_, self.not_]
        self.functionTable = ["BUFa",      "AND ",    "OR  ",   "NOTa"]
        self.functionArity = [1,           2,         2,        1]
        self.functionBC1   = [1,           64,        66,       15]
        self.functionBC2   = [9,           9,         9,        9]
        self.functionSetStr = ["a",      "a & b",   "a | b",  "~a"]

    def reedMuller(self):
        self.functionType  = Cgp.CIRCUIT
        self.functionSet   = [self.id,     self.xor, self.or_, self.not_]
        self.functionTable = ["BUFa",      "XOR ",   "OR  ",   "NOTa"]
        self.functionArity = [1,           2,         2,        1]
        self.functionBC1   = [1,           66,        65,       15]
        self.functionBC2   = [9,           9,         9,        9]
        self.functionSetStr = ["a", "a | b", "a ^ b", "~a"]

    def moje(self):
        self.functionType  = Cgp.CIRCUIT
        self.functionSet   = [self.id,     self.and_, self.or_, self.xor]
        self.functionTable = ["BUFa",      "AND ",   "OR  ",   "XOR "]
        self.functionArity = [1,           2,         2,        2]
        self.functionBC1   = [1,           64,        66,       65]
        self.functionBC2   = [9,           9,         9,        9]
        self.functionSetStr = ["a", "a & b", "a | b", "a ^ b"]


    def nandOnly(self):
        self.functionType  = Cgp.CIRCUIT
        self.functionSet = [self.id, self.nand]
        self.functionTable = ["BUFa", "NAND"]
        self.functionArity = [1, 2]
        self.functionBC1   = [1, 64]
        self.functionBC2   = [9, 15]
        self.functionSetStr = ["~(a & b)"]



    def symbolicRegression(self):
        self.functionType = Cgp.EQUATION
        self.functionSet  = [Cgp._0_25, Cgp._0_50,  Cgp._1_00, Cgp.id,    Cgp.add,  Cgp.sub,  Cgp.mul,  Cgp.div]
        self.functionTable= ["0.25",    "0.50",     "1.00",    " ID ",    " ADD",   " SUB",   " MUL",   " DIV"]
        self.functionTableOp=["0.25",   "0.50",     "1.00",    "",        "+",      "-",      "*",      "/"]
        self.functionArity= [0,         0,          0,         1,         2,        2,        2,        2]
        self.functionBC1  = [1,         1,          1,         1,         23,       24,       20,       27]
        self.functionBC2  = [1,         1,          1,         9,         9,        9,        9,        9] 
        self.functionBC3  = [100,       100,        100,       9,         9,        9,        9,        9]
        self.functionBC4  = [0,         0,          0,         9,         9,        9,        9,        9]
        self.functionBC5  = [0,         0,          0,         9,         9,        9,        9,        9]
        self.functionSetStr=["0.25",    "0.50",   "1.00",   "a",      "a+b",   "a-b",     "a*b",     "a/b"]
    
    def symbolicRegressionWithSin(self):
        self.functionType = Cgp.EQUATION
        self.functionSet  = [Cgp._0_25, Cgp._0_50,  Cgp._1_00, Cgp.id,    Cgp.add,  Cgp.sub,  Cgp.mul,  Cgp.div, Cgp.sin]
        self.functionTable= ["0.25",    "0.50",     "1.00",    " ID ",    " ADD",   " SUB",   " MUL",   " DIV",  "SIN "]
        self.functionTableOp=["0.25",   "0.50",     "1.00",    "",        "+",      "-",      "*",      "/",     "sin"]
        self.functionArity= [0,         0,          0,         1,         2,        2,        2,        2,       1]
        self.functionBC1  = [1,         1,          1,         1,         23,       24,       20,       27,      1]
        self.functionBC2  = [1,         1,          1,         9,         9,        9,        9,        9,       9] 
        self.functionBC3  = [100,       100,        100,       9,         9,        9,        9,        9,       9]
        self.functionBC4  = [0,         0,          0,         9,         9,        9,        9,        9,       9]
        self.functionBC5  = [0,         0,          0,         9,         9,        9,        9,        9,       9]
        self.functionSetStr=["0.25",    "0.50",   "1.00",   "a",      "a+b",   "a-b",     "a*b",     "a/b",      "sin(a)"]
