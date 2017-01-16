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

        # Default vars.
        if self.rows      is None: self.DEFAULT_ROWS
        if self.cols      is None: self.DEFAULT_COLS
        if self.levelBack is None: self.cols    # Set max connection
        self.functionSet = None
        self.functionType = None

        if sys.maxsize > 2**32:
            Cgp.mask = 2**64 - 1 # 0xffffffffff lazy to count
        else: 
            Cgp.mask = 2**32 - 1 # 0xffffffffff lazy to count

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
        if runs is None: runs = 1
        elif type(runs) is float: acc  = runs; runs = 1
        if self.dataInput is None or self.dataOutput is None:
            raise Exception("CGP Data was not initiated!")
        type_ = self.__getCGPtype()
        # Select function.
        if self.functionSet is None or self.functionType != type_:
            if self.functionSet is not None: 
                print("Warning: changed functions set!")
            if type_ == Cgp.CIRCUIT:
                self.allLogicalOperations()
            else:
                self.symbolicRegression()

        # Init object with params of this object.
        if type_ == Cgp.CIRCUIT:
            cgp = CgpCircuit(self.__dict__, population)
            #Cgp.mask = len(bin(self.dataInput[0]))-2
            self.bestFitness = 0
        else:
            cgp = CgpEquation(self.__dict__, population)
            self.bestFitness = float("inf")

        # Run Forest run!
        for i in range(runs):
            cgp.run(generation, population, mutation, acc)
            # Save results.
            if type_ == cgp.CIRCUIT:
                if self.bestFitness < cgp.popFitness[cgp.parent]:
                    self.bestfitness     = cgp.popFitness[cgp.parent]
                    self.chromosome = cgp.resultChrom()
                    self.showChromosome = cgp.showChrom()
                self.result     = cgp.__dict__.copy()
            else:
                if self.bestFitness > cgp.popFitness[cgp.parent]:
                    self.bestFitness     = cgp.popFitness[cgp.parent]
                    self.chromosome = cgp.resultChrom()
                    self.showChromosome = cgp.showChrom()
                self.result     = cgp.__dict__.copy()

    ############################################################################
    #  Functions of CGP
    ############################################################################
    id   = lambda a, b: a
    and_ = lambda a, b: a & b
    or_  = lambda a, b: a | b
    xor  = lambda a, b: a ^ b
    not_ = lambda a, b: Cgp.mask - a
    nand = lambda a, b: Cgp.mask - (a & b)
    nor  = lambda a, b: Cgp.mask - (a | b)
    nxor = lambda a, b: Cgp.mask - (a ^ b)

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
        self.functionBC1   = [1,       64,        66,       65,       1,          64,        66,       65]
        self.functionBC2   = [2,       2,         2,        2,        24,         24,        24,       24]
        self.functionBC3   = [1,       1,         1,        1,        9,          9,         9,        9]
        self.functionSetStr = ["a", "a & b", "a | b", "a ^ b", "self.mask-a", "self.mask-(a & b)", "self.mask-(a | b)", "self.mask-(a ^ b)"]

    def booleanAlgebra(self):
        self.functionType  = Cgp.CIRCUIT
        self.functionSet   = [self.id,     self.and_, self.or_, self.not_]
        self.functionTable = ["BUFa",      "AND ",    "OR  ",   "NOTa"]
        self.functionArity = [1,           2,         2,        1]
        self.functionBC1   = [1,           64,        66,       1]
        self.functionBC2   = [2,           2,         2,        24]
        self.functionBC3   = [1,           1,         1,        9]
        self.functionSetStr = ["a",      "a & b",   "a | b",  "self.mask-a"]

    def reedMuller(self):
        self.functionType  = Cgp.CIRCUIT
        self.functionSet   = [self.id,     self.xor, self.or_, self.not_]
        self.functionTable = ["BUFa",      "XOR ",   "OR  ",   "NOTa"]
        self.functionArity = [1,           2,         2,        1]
        self.functionBC1   = [1,           66,        65,       1]
        self.functionBC2   = [2,           2,         2,        24]
        self.functionBC3   = [1,           1,         1,        9]
        self.functionSetStr = ["a", "a | b", "a ^ b", "self.mask-a"]

    def moje(self):
        self.functionType  = Cgp.CIRCUIT
        self.functionSet   = [self.id,     self.and_, self.or_, self.xor]
        self.functionTable = ["BUFa",      "AND ",   "OR  ",   "XOR "]
        self.functionArity = [1,           2,         2,        2]
        self.functionBC1   = [1,           64,        66,       65]
        self.functionBC2   = [2,           2,         2,        2]
        self.functionBC3   = [1,           1,         1,        1]
        self.functionSetStr = ["a", "a & b", "a | b", "a ^ b"]


    def nandOnly(self):
        self.functionType  = Cgp.CIRCUIT
        self.functionSet = [self.id, self.nand]
        self.functionTable = ["BUFa", "NAND"]
        self.functionArity = [1, 2]
        self.functionBC1   = [1, 64]
        self.functionBC2   = [2, 24]
        self.functionBC3   = [1, 9]
        self.functionSetStr = ["self.mask - (a & b)"]



    def symbolicRegression(self):
        self.functionType = Cgp.EQUATION
        self.functionSet  = [Cgp.id,    Cgp.add,  Cgp.sub,  Cgp.mul,  Cgp.div, Cgp._0_25, Cgp._0_50,  Cgp._1_00]
        self.functionTable= [" ID ",    " ADD",   " SUB",   " MUL",   " DIV",  "0.25",    "0.50",     "1.00"]
        self.functionTableOp=["",       "+",      "-",      "*",      "/",     "0.25",    "0.50",     "1.00"]
        self.functionArity= [1,         2,        2,        2,        2,       0,         0,          0]
        self.functionBC1  = [1,         23,       24,       20,       27,      1,         1,          1]
        self.functionBC2  = [9,         9,        9,        9,        9,       1,         1,          1]
        self.functionBC3  = [9,         9,        9,        9,        9,       100,       100,        100]
        self.functionBC4  = [9,         9,        9,        9,        9,       0,         0,          0]
        self.functionBC5  = [9,         9,        9,        9,        9,       0,         0,          0]
        self.functionSetStr = ["a+b",  "a-b",    "a*b",    "a/b",    "a",     "0.25",     "0.50",     "1.00"]

    def symbolicRegressionWithSin(self):
        self.functionType = Cgp.EQUATION
        self.functionSet  = [Cgp.id,    Cgp.add,  Cgp.sub,  Cgp.mul,  Cgp.div, Cgp._0_25, Cgp._0_50,  Cgp._1_00, sin]
        self.functionTable= [" ID ",    " ADD",   " SUB",   " MUL",   " DIV",  "0.25",    "0.50",     "1.00",    "SIN "]
        self.functionTableOp=["",       "+",      "-",      "*",      "/",     "0.25",    "0.50",     "1.00",    "sin"]
        self.functionArity= [1,         2,        2,        2,        2,       0,         0,          0,         1]
        self.functionBC1  = [1,         23,       24,       20,       27,      1,         1,          1,         9]
        self.functionBC2  = [9,         9,        9,        9,        9,       1,         1,          1,         9]
        self.functionBC3  = [9,         9,        9,        9,        9,       100,       100,        100,       9]
        self.functionBC4  = [9,         9,        9,        9,        9,       0,         0,          0,         9]
        self.functionBC5  = [9,         9,        9,        9,        9,       0,         0,          0,         9]
        self.functionSetStr = ["a+b",  "a-b",    "a*b",    "a/b",    "a",     "0.25",     "0.50",     "1.00",    "sin(a)"]
