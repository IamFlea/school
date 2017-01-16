#!/usr/bin/env python3
from cgp_algorithm import Cgp_algorithm 
import dis
import random

import types
import py_compile
import array    # C like arrays 
import inspect  # Function arguments count. 
import sys      # System.
import ctypes   # memmove
#from io import StringIO  # Streams

class Error(Exception):
    pass

class Cgp(Cgp_algorithm):
    # cgp states
    INIT = 1 # Just inited.
    DATA = 2 # Have some data.

    # Types of CGP.
    CIRCUIT = 1
    EQUATION = 2
    OTHER = 3

    DEFAULT_ROWS = 1
    DEFAULT_COLS = 40
    #DEFAULT_LBACK = self.cols #is maximum value. (self.cols)
    #DEFAULT_FUNCTION_SET = self.allLogicalOperations()

    ## The constructor of CGP.
    #  Fills up the most important CGP variables.
    def __init__(self, rows=None, cols=None, lBack=None, input=None, output=None, functions=None):
        # Check validity of params
        if rows is not None and cols is None:
            raise Error("Expecting 2nd parameter - cols - in __init__()")
        if input is not None and output is None:
            raise Error("Expecting 5th parameter - output data - in __init__()")
        # Set instance values.
        self.rows        = rows
        self.cols        = cols
        self.levelBack    = lBack
        self.initDataInput = input
        self.initDataOutput  = output
        self.functionSet = functions

        # Default vars
        if self.rows           is None: self.DEFAULT_ROWS
        if self.cols           is None: self.DEFAULT_COLS
        if self.levelBack      is None: self.cols

   
    ## Setting graph options.
    def graph(self, p_row, p_col, p_l=None):
        self.rows      = p_row
        self.cols      = p_col
        self.levelBack = p_l
        if self.levelBack is None: self.cols
    
    ############################################################################
    # DATA
    ############################################################################
    ## Parsing data file
    def fileCirucit(self, filename):
        f = open(filename, 'r')
        input = 0
        output = 0
        tmp = 1
        init = 1
        for line in f:
            str = line.split("#")[0].split(":")
            if len(str) == 1:
                continue
            str[0] = str[0].replace(" ", "")
            str[1] = str[1].replace(" ", "")
            if init == 1:
                input  = [0] * len(str[0])
                output = [0] * len(str[1])
                init = 0
            for i in range(0, len(str[0])):
                if str[0][i] == '1':
                    input[i] = input[i] | tmp
            for i in range(0, len(str[1])):
                if str[1][i] == '1':
                    output[i] = output[i] | tmp
            tmp = tmp << 1
        self.initDataInput = input
        self.initDataOutput = output
        f.close()


    def file(self, filename):
        self.fileCirucit(filename)

    ## Setting data.
    def data(self, input, output):
        self.initDataInput  = input
        self.initDataOutput = output

    ## Checking IO data
    def checkData(self):
        # Checking data types
        typ = type(self.initDataInput[0])
        if typ is int or typ is long:
            for dato in self.initDataInput:
                if not (isinstance(dato, int) or isinstance(dato, long)):
                    raise InitData("Data are bad formated")
            for dato in self.initDataOutput:
                if not (isinstance(dato, int) or isinstance(dato, long)):
                    raise InitData("Data are bad formated")
        else:
            for dato in self.initDataInput:
                if type(dato) is not typ:
                    raise InitData("Data are bad formated")
            for dato in self.initDataOutput:
                if type(dato) is not typ:
                    raise InitData("Data are bad formated")

        # Select Type
        if typ is float:
            self.type = self.EQUATION
            self.maxFitness = self.graphInputCnt
        elif typ is int or typ is long: 
            self.type = self.CIRCUIT
            self.maxFitness = ( 1 << self.graphInputCnt ) * self.graphOutputCnt
        else:
            #self.type = self.OTHER
            raise Error("Data are in variable format...")


    ## Converts python's long to integer array.
    #  In one evaluation should be used variables from one part becouse of effecient.
    #  This parts are called training vectors. 
    #
    #                                 .---training vecotr 1---. .---training vector 2---.       .---training vector m---.
    #  [long_a, long_b .. long_n] => [int_a1, int_b1 .. int_n1, int_a2, int_b2 .. int_n2, ... , int_m1, int_m2 .. int_mn]
    def __convertData(self):
        self.architecture  = self.getArchitecture()
        self.arrayTypecode = self.getTypecode()
        self.trainingVectors = self.getTrainingVectors(1 << self.graphInputCnt)

        input = list(self.initDataInput)   # Temp variable
        output = list(self.initDataOutput) # Temp variable
        
        mask = self.getMask() 

        # Init array
        size = self.trainingVectors * self.graphInputCnt
        self.dataInput = array.array(self.arrayTypecode, [0]*size)
        size = self.trainingVectors * self.graphOutputCnt
        self.dataOutput = array.array(self.arrayTypecode, [0]*size)
        
        # Fill up input array
        idx = 0 
        lastbit = 1<<(self.architecture -1)
        for i in range(0, self.trainingVectors):
            for j in range(0, self.graphInputCnt):
                self.dataInput[idx] = input[j] & mask
                input[j] = input[j] >> self.architecture
                idx += 1 
        # Fill up output array
        idx = 0 # reset idx, using another array || list
        for i in range(0, self.trainingVectors):
            for j in range(0, self.graphOutputCnt):
                self.dataOutput[idx] = output[j] & mask
                output[j] = output[j] >> self.architecture
                idx += 1 

    ## Prints I/O data of CGP
    def printBinData(self):
        print("INPUT")
        for dato in self.dataInput:
            print(bin(dato))
        print("OUTPUT")
        for dato in self.dataOutput:
            print(bin(dato))

    ## Prints I/O data of CGP
    def printHexData(self):
        print("INPUT")
        for dato in self.dataInput:
            print(hex(dato))
        print("OUTPUT")
        for dato in self.dataOutput:
            print(hex(dato))


    ## Check variables before cgp_algorithm will run.
    def run(self, generation, population, mutation):
        if self.initDataInput  is None: raise Error("Instance variable dataInput wasn't initiated!")
        if self.initDataOutput is None: raise Error("Instance variable dataOutput wasn't initiated!")
        if self.functionSet    is None: self.allLogicalOperations()

        # Initiate inputs and ouptuts of graph
        self.graphInputCnt  = len(self.initDataInput)
        self.graphOutputCnt = len(self.initDataOutput)

        # Init data
        self.checkData()
        self.__convertData() 

        # Init Functions
        self.functionCnt = len(self.functionSet) - 1 # Last index
        self.maxArity    = self.getMaxArity()
        self.bitOnes = self.getMask()
        self.bitMax = self.bitOnes + 1
        self.initLookUp()

        self.outputBuff = array.array(self.arrayTypecode, [0] * (self.rows * self.cols + self.graphInputCnt))
        self.ptrOutputBuff, tmp = self.outputBuff.buffer_info()
        self.ptrDataInput = array.array(self.arrayTypecode)
        self.architectureBytes = self.getArchitectureBytes()

        ptr, tmp = self.dataInput.buffer_info()
        size = self.architectureBytes * self.graphInputCnt
        offset = 0
        for j in range(0, self.trainingVectors):
            self.ptrDataInput.append(ptr+offset)
            offset+=size

        #self.ptrDataInput = self.ptrDataInput[0]

        self.bytescnt   = (self.architecture >> 3 ) * self.graphInputCnt

        self.usedNodes = []
        self.used = array.array(self.arrayTypecode, [0] * population)
        for i in range(0, population):
            self.usedNodes.append(array.array(self.arrayTypecode, [0] * (self.rows * self.cols + self.graphInputCnt)))

        self.initCompile(population)
       
        ## NAIVNI
        self.bitMax  = 1 << 2**self.graphInputCnt
        self.bitOnes = self.bitMax - 1
        self.outputBuff = list(self.initDataInput + ([0] * self.rows * self.cols)) #array.array(self.arrayTypecode, [0] * (self.rows * self.cols + self.graphInputCnt))

        Cgp_algorithm.run(self, generation, population, mutation)





    ############################################################################
    # FINTESS
    ############################################################################
    def ___________(): pass
    def __FINTESS__(): pass
    
    # gief asm
    #def __getCode(self, chrom):#, usedNodes):
    def __getCode(self, chrom, usedNodes):
        a_idx = -3   # Index prvniho operandu
        b_idx = -2   # Index druheho operandu
        f_idx = -1   # Index Operace
        # Strings solution 
        result = ""
        for j in range(self.graphInputCnt, self.area+self.graphInputCnt):
            a_idx += 3
            b_idx += 3
            f_idx += 3
            if usedNodes[j] == 0: 
                continue
            result += "a=self.outputBuff["+str(chrom[a_idx])+"]\n"
            result += "b=self.outputBuff["+str(chrom[b_idx])+"]\n"
            result += "self.outputBuff["+str(j)+"]="+ self.functionSetStr[chrom[f_idx]] +"\n"
        return result


    def initCompile(self, population):
        arr = []
        for i in range(0, self.graphInputCnt + self.cols * self.rows):
            arr.append(i)
        self.mask_idx = i + 1
        arr.append(self.getMask())
        self.none_idx = i + 2
        arr.append(None)

        self.co_consts = tuple(arr)
        #print(self.co_consts)
        #print(self.co_constsk
        self.code = [0] * population
        self.arrByteCodes = [0] * population
        #self.co_names  = ('self', 'graphInputCnt', 'out_idx', 'outputBuff', 'a', 'b', 'bitOnes')
        self.co_names  = ('outputBuff',)
        #initCode = [101, 0, 0, 
                    #106, 1, 0, 
                    #90, 2, 0]
        initCode = []
        #                               # PythonBytecode         STACK
        nodeCode = [100, self.mask_idx, 0,   # LOAD CONST
                    101, 0, 0,          # LOAD ATTR, outputbuff  [outputbuff]
                    100, 0, 0,          # LOAD CONST, 0          [const, ouputbuff]
                    25,                 # BIN_SUBSCR             [a]
                    101, 0, 0,          # LOAD ATTR, outputbuff  [outputbuff, a]
                    100, 0, 0,          # LOAD CONST, 0          [const, outputbuff, a]
                    25,                 # BIN_SUBSCR             [b, a]
                    9,                  # NOP                    [operation]
                    9,                  # NOP                    [operation]
                    9,                  # NOP                    [operation]
                    101, 0, 0,          # LOAD ATTR, outputbuff  [outputbuff, self, result]
                    100, 0, 0,          # LOAD CONST, index      [index, outputbuff, self, result]
                    60                  # STORE_SUBCR, val       []
                   ]
        exitCode = [100, self.none_idx, 0,   # LOAD NONE
                    83]                 # Return shit
        #self.co_lnotab = bytes([9,0] + [35,0,10,0]*self.rows*self.cols)
        self.co_lnotab = bytes()



        for i in range(0, population):
            self.arrByteCodes[i] = array.array('B', initCode + nodeCode*(self.cols*self.rows) + exitCode) 
        
        #print(self.co_consts)

    def __getByteCode(self, chrom, used, code):
        # zkopirovat prvnich osm bajtu ty zustanou nemenne 
        # Checknout dokumentaci jestli existuje neco jako NO operation!
        i = 0    # Index zactku bytekodu
        a_idx = -3   # Index prvniho operandu
        b_idx = -2   # Index druheho operandu
        f_idx = -1   # Index Operace
        idx = 0  # Index chromozomu 
        for j in range(self.graphInputCnt, self.area+self.graphInputCnt):
            a_idx += 3
            b_idx += 3
            f_idx += 3
            idx += 1
            if 0 == used[j]: # Byl tento uzel pouzitej? 
                continue 
            code[i   ] = 100
            code[i+1 ] = self.mask_idx
            code[i+3 ] = 101
            code[i+7] = chrom[a_idx]
            code[i+14] = chrom[b_idx]
            code[i+17] = self.fun1[chrom[f_idx]]
            code[i+18] = self.fun2[chrom[f_idx]]
            code[i+19] = self.fun3[chrom[f_idx]]
            code[i+24] = j 
            i += 27
        code[i] = 100               # RETURN VALUE
        code[i+1] = self.none_idx   # RETURN VALUE
        code[i+2] = 0               # RETURN VALUE
        code[i+3] = 83              # RETURN VALUE
        #exitCode = [100, self.none_idx, 0,   # LOAD NONE
        return types.CodeType(0, 
                              0, # Py2  asi smazat..
                              0,  20, 64,
                              code.tobytes(), self.co_consts, self.co_names, tuple(),
                              "", "<module>", 1, self.co_lnotab)




    # Simulate circuit
    def evalFitness(self, chrom, out, usedNodes):
        idx = 0 # Index pointer in chromosome
        j = self.graphInputCnt
        # For each node set its output
        for i in range(self.graphInputCnt, self.area+self.graphInputCnt):
            if usedNodes[i] == 0: 
                idx += 3 
                j += 1
                continue
            a = out[chrom[idx]]
            idx += 1
            b = out[chrom[idx]]
            idx += 1
            out[j] = self.functionSet[chrom[idx]](a, b)
            j   += 1
            idx += 1



    # Calculate Fitness
    def evaluatePop(self):
        # Init values of evaluation
        for i in range(0, self.popsize):
            if i == self.parent: continue
            self.popFitness[i] = 0 
            self.used[i] = self.__usedNodes(self.pop[i], self.usedNodes[i])
            # Using build-in function: compile()
            #self.code[i] = compile(self.__getCode(self.pop[i], self.usedNodes[i]), "", "exec")
            # Using byte code JIT compilation
            #self.code[i] = self.__getByteCode(self.pop[i], self.usedNodes[i], self.arrByteCodes[i])
        #vektor = 0 
        #for j in range(0, self.trainingVectors):
            #ctypes.memmove(self.ptrOutputBuff, self.ptrDataInput[j], self.bytescnt) 
        for i in range(0, self.popsize):
            if i == self.parent: continue
            #exec (self.code[i])
            #exec (self.code[i],  None, {"outputBuff" : self.outputBuff})
            self.evalFitness(self.pop[i], self.outputBuff, self.usedNodes[i])
            idx = self.lastGeneIdx
            for k in range(0, self.graphOutputCnt):
                # Zero count
                # Int -> string -> zero_cnt
                tmp = bin((self.outputBuff[self.pop[i][idx]] | self.bitMax)^ self.initDataOutput[k])
                self.popFitness[i] += (tmp.count('0')) - 1 # becouse it is in format 0b0001 and i want to del first zero. 
                # Look-up table DONT WORK IN THIS IMPLEMENTATION 
                #self.popFitness[i] +=  self.zeroCount((self.outputBuff[self.pop[i][idx]] | self.bitMax)^ self.dataOutput[k+vektor])
                idx += 1
            #vektor += self.graphOutputCnt
        for i in  range(0, self.popsize):
            if i == self.parent or self.popFitness[i] != self.maxFitness:
                continue
            self.popFitness[i] += self.area - self.used[i]

    # Returns used nodes.
    def __usedNodes(self, chrom, usedNodes):
        cnt = 0
        idx = self.lastGeneIdx
        for i in range(0, self.graphOutputCnt): 
            usedNodes[chrom[idx]] = 1
            idx += 1
        idx = self.lastGeneIdx - 1 # Chromosome index
        uidx = len(usedNodes) - 1  # NODE index
        for i in range(0, self.area):
            if usedNodes[uidx] == 1:  # usedNodes[uidx] == 1
                f = chrom[idx]
                # Unary operation..
                idx -= 1                  # B idx
                if self.arity[f] == 1: # Using A port
                    idx -= 1                  # Get A idx. B is not used
                    usedNodes[chrom[idx]] = 1 # saving A
                #elif self.arity[f] == -1: # Using B port
                    #usedNodes[chrom[idx]] = 1 # saving B
                    #idx -= 1 # Prev node idx. A is not used
                # Binary operation..
                else:
                    usedNodes[chrom[idx]] = 1 # saving B
                    idx -= 1 # a
                    usedNodes[chrom[idx]] = 1 # saving A
                cnt += 1
                idx -= 1 # a
            else:
                idx -= 3
            uidx -= 1
        return cnt

    ############################################################################
    # LOOKUP Zero count
    ############################################################################
    def initLookUp(self):
        global lookUpBitTable 
        lookUpBitTable = array.array(self.arrayTypecode, [0]*256)
        for i in range(0, 256):
            cnt = 0
            zi  = 0xffff - i
            for j in range(0, 8):
                cnt += zi & 1
                zi = zi >> 1
            lookUpBitTable[i] = cnt


    def zeroCount(self, val):
        # 
        return lookUpBitTable[val & 0xff] + lookUpBitTable[val >>  8 & 0xff] + lookUpBitTable[val >> 16 & 0xff] + lookUpBitTable[val >> 24 & 0xff] + lookUpBitTable[val >> 32 & 0xff] + lookUpBitTable[val >> 40 & 0xff] + lookUpBitTable[val >> 48 & 0xff] + lookUpBitTable[val >> 56 & 0xff]

        #return lookUpBitTable[val & 0xff] + lookUpBitTable[val >>  8 & 0xff] + lookUpBitTable[val >> 16 & 0xff] + lookUpBitTable[val >> 24 & 0xff] 



    
    def _____________(self): pass
    def __FUNCTIONS__(self): pass

    ############################################################################
    # FUNCTIONS
    ############################################################################
    def wire_a(self, a, b=None):
        return a
    def wire_b(self, a, b):
        return b
    def and_(self, a, b):
        return a & b
    def or_(self, a, b):
        return a | b
    def xor(self, a, b):
        return a ^ b
    def not_a(self, a, b=None):
        return self.bitOnes-a
    def not_b(self, a, b):
        return self.bitOnes-b
    def nand(self, a, b):
        return self.bitOnes-(a & b)
    def nor(self, a, b):
        return self.bitOnes-(a | b)
    def nxor(self, a, b):
        return self.bitOnes-(a ^ b)

    # Stack:        [b, a, self.bitOnes]
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
        self.functionSet = [self.wire_a, self.and_, self.or_, self.xor, self.not_a, self.nand, self.nor, self.nxor]
        self.functionTab = ["BUFa",      "AND ",    "OR  ",   "XOR ",   "NOTa",     "NAND",    "NOR ",   "NXOR"]
        self.arity       = [1,           2,         2,        2,        1,          2,         2,        2]
        self.fun1        = [1,           64,        66,       65,       1,          64,        66,       65]
        self.fun2        = [2,           2,         2,        2,        24,         24,        24,       24]
        self.fun3        = [1,           1,         1,        1,        9,          9,         9,        9]
        self.functionSetStr = ["a", "a & b", "a | b", "a ^ b", "self.bitOnes-a", "self.bitOnes-(a & b)", "self.bitOnes-(a | b)", "self.bitOnes-(a ^ b)"]



    def booleanAlgebra(self):
        self.functionSet = [self.wire_a, self.and_, self.or_, self.not_a]
        self.functionTab = ["BUFa",      "AND ",    "OR  ",   "NOTa"]
        self.arity       = [1,           2,         2,        1]
        self.fun1        = [1,           64,        66,       1]
        self.fun2        = [2,           2,         2,        24]
        self.fun3        = [1,           1,         1,        9]
        self.functionSetStr = ["a",      "a & b",   "a | b",  "self.bitOnes-a"]

    def reedMuller(self):
        self.functionSet = [self.wire_a, self.xor, self.or_, self.not_a]
        self.functionTab = ["BUFa",      "XOR ",   "OR  ",   "NOTa"]
        self.arity       = [1,           2,        2,        1]
        self.fun1        = [1,           66,       65,       1]
        self.fun2        = [2,           2,        2,        24]
        self.fun3        = [1,           1,        1,        9]
        self.functionSetStr = ["a", "a | b", "a ^ b", "self.bitOnes-a"]

    def moje(self):
        self.functionSet = [self.wire_a, self.and_, self.or_, self.xor]
        self.functionTab = ["BUFa",      "AND ",   "OR  ",   "XOR "]
        self.arity       = [1,           2,         2,        2]
        self.fun1        = [1,           64,        66,       65]
        self.fun2        = [2,           2,         2,        2]
        self.fun3        = [1,           1,         1,        1]
        self.functionSetStr = ["a", "a & b", "a | b", "a ^ b"]


    def nandOnly(self):
        self.functionSet = [self.nand]
        self.functionTab = ["NAND"]
        self.arity       = [2]
        self.fun1        = [64]
        self.fun2        = [24]
        self.fun2        = [9]
        self.functionSetStr = ["self.bitOnes - (a & b)"]


    def symbolicRegression(self):
        self.functionSet = [self.krat, self.plus, self.minus, self.deleno]
        self.functionTab = [" ?? "]
        self.arity       = [42]
        self.fun1        = [9]
        self.fun2        = [9]
        self.fun2        = [9]
        self.functionSetStr = [""]


    ############################################################################
    # CONSTS
    ############################################################################
    def __________(self): pass
    def __CONSTS__(self): pass
    def getMaxArity(self):

        return 2 # Trust me ..
   
    def __functionGetLen(self):
        return len(self.functionSet) - 1

    ## Getting bit mask  0xfffffff..f
    def getMask(self):
        if sys.maxsize > 2**32:
            ## FIXME if dataLen < 64: ..
            return (1 << 64) - 1 # 64 bit
        else:
            ## FIXME if dataLen < 32: ..
            return (1 << 32) - 1 # 32 bit

    ## Count of training vectors
    def getTrainingVectors(self, dataLen):
        if sys.maxsize > 2**32:
            if dataLen < 64:
                #return dataLen >> 6 # 64 bit    dataLen/64
                return 1
            else:
                return dataLen >> 6 # 64 bit    dataLen/64
        else:
            if dataLen < 32:
                #return dataLen >> 5 # 32 bit    dataLen/32
                return 1
            else:
                return dataLen >> 5 # 32 bit    dataLen/32

    ## Returns
    def getArchitecture(self):
        if sys.maxsize > 2**32:
            return 64
        else:
            return 32

    def getArchitectureBytes(self):
        if sys.maxsize > 2**32:
            return 8
        else:
            return 4
    
    ## array.typecode 
    def getTypecode(self):
        return 'L' 
# EOF 
