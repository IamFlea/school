#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Libs and modules.
import sys    # System module (standard input, output..)
import random # Pseudorandom generator.
import time   # Time() for seed.
import re     # Regular expressions. Might be usefull?
import array  # C like arrays 
import ctypes # memmove

class CgpCore:
    CIRCUIT = 1
    EQUATION = 2

    def printGeneration(self, gen):
        if gen % 1000 == 0:
            if gen == 0:
                print("Generation:", repr(gen).rjust(10),\
                      "Best fitness:", repr(self.bestFitness).rjust(10), "/", self.maxFitness)
            else:
                #print("Generation:", repr(gen).rjust(10), "Best fitness:", repr(self.popFitness[i]).rjust(10), "/", self.bestFitness)
                print("Generation:", repr(gen).rjust(10))

    
    ## Starts cartesian genetic programming.
    #  @param self    The object pointer.
    #  @param p_gen   How many generations.
    #  @param p_pop   Size of population. Default 5. Optional.
    #  @param p_mut   Max mutated gens during one mutation()
    def runAscending(self, generations, pop, mut, acc = None):
        self.mutations = mut
        # Check instance variables
        #self.checkInstanceVariables()
        # Shuffle cards
        #random.seed()
        random.seed(73541)
        # Setting instance variables.
        self._initCGPRun(pop)

        # INJEKCE  4x4 adder   
        #self.pop[0] = array.array('L', [2,6,7,7,3,5,9,8,6,5,1,3,2,6,7,2,8,1,13,4,0,0,4,7,8,9,3,11,5,2,4,4,7,15,17,7,10,13,6,2,14,1,15,3,3,3,7,3,13,14,1,2,4,2,25,16,3,5,26,1,11,20,5,28,19,7,0,4,1,23,2,0,25,2,7,20,11,7,30,27,0,18,29,1,35,0,4,10,0,0,18,16,1,30,10,6,28,37,2,32,31,1,31,29,5,28,19,7,18,33,1,29,15,6,45,34,2,18,46,1,47,35,44,38,23])

        # Evaluate first population 
        self.evaluatePop()
        # Select first parent
        for i in range(0, self.popsize):
            if self.popFitness[i] > self.bestFitness:
                self.parent = i
                self.bestFitness = self.popFitness[i]

        # Start the timer.
        start = time.time()

        # Run evolution.
        for gen in range(0, generations): 
            # Printing generation
            #self.printGeneration(gen)
            # Each person in population is mutated.
            for i in range(0, self.popsize):
                if self.parent == i: continue  # Skip parent
                #ctypes.memmove(self.ptrPop[i], self.ptrPop[self.parent], self.chromSize)
                self.pop[i] = array.array(self.arrayTypecode, self.pop[self.parent])
                self.__mutation(self.pop[i])
            # evaluate population
            self.evaluatePop()
            parentt = self.parent # Save parent position
            a = False
            for i in range(0, self.popsize):
                # Skip parent or worse finesses...
                if self.parent == i or self.popFitness[i] < self.bestFitness:
                    continue
                if self.popFitness[i] > self.bestFitness:
                    self.bestFitness = self.popFitness[i]
                    print("Generation: "+ repr(str(gen)).rjust(10) +" Fitness: "+ repr(str(self.bestFitness)).rjust(10) +" / "+ str(self.maxFitness))
                # Found better fitness?
                parentt = i # Use parent with same fitness
            self.parent = parentt # Actualize parent
            #for
        #for
        #print("Generation:", repr(generations).rjust(10))
        self.elapsed = time.time() - start
        self.evalspersec = round(generations/self.elapsed * (self.popsize-1))
        # Done
    #runAscending

    ## Starts cartesian genetic programming.
    #  @param self    The object pointer.
    #  @param p_gen   How many generations.
    #  @param p_pop   Size of population. Default 5. Optional.
    #  @param p_mut   Max mutated gens during one mutation()
    def runDescending(self, generations, pop, mut, acc=None):
        if acc is None: acc = 0.01
        self.mutations = mut
        # Check instance variables
        #self.checkInstanceVariables()
        # Shuffle cards
        random.seed(73541)
        #random.seed()
        # Setting instance variables.
        self._initCGPRun(pop)
        # Evaluate first population 
        self.evaluatePop()
        # Select first parent
        for i in range(0, self.popsize):
            if self.popFitness[i] < self.bestFitness:
                self.parent = i
                self.bestFitness = self.popFitness[i] - acc

        # Start the timer.
        start = time.time()

        # Run evolution.
        for gen in range(0, generations): 
            # Printing generation
            #self.printGeneration(gen)
            # Each person in population is mutated.
            for i in range(0, self.popsize):
                if self.parent == i: continue  # Skip parent
                #ctypes.memmove(self.ptrPop[i], self.ptrPop[self.parent], self.chromSize)
                self.pop[i] = array.array('L', self.pop[self.parent])
                self.__mutation(self.pop[i])
            # evaluate population
            self.evaluatePop()
            parentt = self.parent # Save parent position
            for i in range(0, self.popsize):
                # Skip parent or worse finesses...
                if self.parent == i or self.popFitness[i] > self.bestFitness:
                    continue
                if self.popFitness[i] < self.bestFitness:
                    self.bestFitness = self.popFitness[i] - acc
                    print("Generation: "+ repr(str(gen)).rjust(10) +" Fitness: "+ repr(str(self.bestFitness)).rjust(10))
                # Found better fitness?
                parentt = i # Use parent with same fitness
            self.parent = parentt # Actualize parent
            #for
        #for
        #print("Generation:", repr(generations).rjust(10))
        self.elapsed = time.time() - start
        self.evalspersec = round(generations/self.elapsed * (self.popsize-1))
    #runDescending

    ## Initiate variables.
    def _initCGPRun(self, pop):
        self.lastFuncIdx = self.area - 1          # -1 becouse of random.int(a,b) is in range <a, b>
        self.parent      = -1                     # Parent in population.
        self.lastGeneIdx = self.area * (self.nodeInputPorts + self.nodeOutputPorts) # Last gene index in chromosome
        self.popFitness  = array.array(self.arrayTypecode, [0] * pop)    # Init population fitnesses [0, 0, .. -0]
        self._initLevelBack()                       # Initiate level back lookup tables self.__lBack[] self.__lBackLen[]
        self._initPopulation(pop)                     # Initiate population. self.pop[]
        self.chromLength = len(self.pop[0]) - 1   # -1 because 0 start cnt
        self.functionIOports = self.nodeInputPorts + self.nodeOutputPorts


    ## Sets self.__lBack look up table for L param.
    #  @param self  The object pointer.
    def _initLevelBack(self):
        self.__lBack    = []# Array of correct values for each column 
                            # [[Col0 correct vals] [col1 correct vals] ..]
        self.__lBackLen = array.array('L') 
                            # Count of correct values for each column 
                            # [len(__lBack[0]), len(__lBack[1]) .. ]
        for i in range(0,self.cols):
            minIdx = self.rows*(i - self.levelBack)
            if minIdx < 0: 
                minIdx = 0
            minIdx = minIdx + self.graphInputCnt
            maxIdx = i * self.rows + self.graphInputCnt
            self.__lBackLen.append(self.graphInputCnt + maxIdx - minIdx -1)
            tmp = array.array('L')
            # Look-up table - select inputs
            for j in range(0, self.graphInputCnt):
                tmp.append(j)
            # Look-up table - select nodes
            for j in range(minIdx, maxIdx):
                tmp.append(j)
            self.__lBack.append(tmp)
    # __initLevelBack()

    ## Sets self.pop look up table for L param. 
    #  @param self
    #      The object pointer.
    def _initPopulation(self, pop):
        self.pop = []
        # For everyone in population create his chromosome
        for i in range(0, self.popsize):
            chromosome = array.array('L')
            # Creating genes
            for j in range(0, self.area):
                col = int(j/self.rows)
                # Select function inputs (gene inputs)
                for k in range(0, self.nodeInputPorts):
                    tmp = self.__lBack[col][random.randint(0,self.__lBackLen[col])]
                    chromosome.append(tmp)
                # Select function (gene operation)   #for k in range(0, self.functionOutputs):
                tmp = random.randint(0, self.functionCnt)
                chromosome.append(tmp)
            # Connecting primary outputs, creating last gene
            for j in range(0, self.graphOutputCnt):
                chromosome.append(random.randint(0, self.area + self.graphInputCnt - 1))
            self.pop.append(chromosome)
        self.ptrPop = array.array('L')
        for i in range(pop):
            a, tmp = self.pop[i].buffer_info()
            self.ptrPop.append(a)
        if sys.maxsize > 2**32:
            self.chromSize = len(self.pop[0]) * 8
        else:
            self.chromSize = len(self.pop[0]) * 4
    #__initLevelBack(self)


    ## Mutate chromosome
    #  @param self
    #      The object pointer.
    #  @param chromosome
    #      The mutated chromosome.
    def __mutation(self, chromosome):
        mutations = random.randint(1, self.mutations)
        # Max of mutations.
        for j in range(0, mutations):
            # Select mutated base. (The gene.)
            idx = random.randint(0, self.chromLength)
            col = int(int(idx/self.functionIOports) / self.rows)
            rnd = chromosome[idx]
            # Mutate NODE
            if idx < self.lastGeneIdx: # lastBaseIdx - 1
                # Mutate connection
                #if idx % self.node_IO_ports < self.nodeInputPorts:
                tmp = rnd
                if idx % self.functionIOports < self.nodeInputPorts:
                    # Same as: if (col_values[col]->items > 1){ while(1){..} }
                    while self.__lBackLen[col] > 1:
                        rnd = random.randint(0, self.__lBackLen[col])
                        rnd = self.__lBack[col][rnd]
                        if rnd != chromosome[idx]: break
                    chromosome[idx] = rnd
                    
                # Mutate function
                else:
                    # Same as: if (items > 1){ while(1){..} }
                    while self.functionCnt > 0:
                        rnd = random.randint(0, self.functionCnt)
                        if rnd != chromosome[idx]: break
                    chromosome[idx] = rnd
            # Mutate output last ,,gene''
            else:
                while 1:
                    rnd = random.randint(0, int(self.lastGeneIdx/self.functionIOports))
                    if rnd != chromosome[idx]: break
                chromosome[idx] = rnd


    def _initOutputBuff(self):
        if sys.maxsize > 2**32:
            bytes = 8
        else:                   
            bytes = 4
        
        self.outputBuff = array.array(self.arrayTypecode, [0] * (self.area + self.graphInputCnt))
        self.ptrOutputBuff, tmp = self.outputBuff.buffer_info()
        self.ptrDataInput,  tmp = self.dataInput.buffer_info() 
        self.buffOffsetSize     = bytes * self.graphInputCnt

    def _initUsedNodes(self, population):
        self.popUsedNodes = array.array('l', [0] * population)
        self.ptrUsedNodes = array.array('L', [0] * population)
        self.usedNodes = []
        for i in range(0, population):
            self.usedNodes.append(array.array('l', [0] * (self.rows * self.cols + self.graphInputCnt)))
            self.ptrUsedNodes[i], tmp = self.usedNodes[i].buffer_info()
        if sys.maxsize > 2**32:
            self.bufferUsedNodes = (self.rows * self.cols + self.graphInputCnt)*8
        else:
            self.bufferUsedNodes = (self.rows * self.cols + self.graphInputCnt)*4



    # Returns used nodes.
    def _usedNodes(self, chrom, usedNodes):
        cnt = 0
        idx = self.lastGeneIdx
        for i in range(0, self.graphOutputCnt): 
            usedNodes[chrom[idx]] += 1
            idx += 1
        idx = self.lastGeneIdx - 1 # Chromosome index
        uidx = len(usedNodes) - 1  # NODE index
        for i in range(0, self.area):
            if usedNodes[uidx] != 0:  # usedNodes[uidx] == 1
                f = chrom[idx]
                # Unary operation..
                idx -= 1                  # B idx
                if self.functionArity[f] == 0:
                    idx -= 1
                elif self.functionArity[f] == 1: # Using A port
                    idx -= 1                  # Get A idx. B is not used
                    usedNodes[chrom[idx]] += 1 # saving A
                #elif self.arity[f] == -1: # Using B port
                    #usedNodes[chrom[idx]] = 1 # saving B
                    #idx -= 1 # Prev node idx. A is not used
                # Binary operation..
                else:
                    usedNodes[chrom[idx]] += 1 # saving B
                    idx -= 1 # a
                    usedNodes[chrom[idx]] += 1 # saving A

                cnt += 1
                idx -= 1 # a
            else:
                idx -= 3
            uidx -= 1
        return cnt

    def resultChrom(self, p=None ):
        if p is None:
            p = self.parent
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
        for i in range(0, self.area):
            result += "("
            for i in range(0, self.nodeInputPorts + self.nodeOutputPorts):
                result += str(self.pop[p][idx])
                result += ","
                idx+=1
            result = result[:-1]
            result += ")"
        result += "("
        for i in range(0, self.graphOutputCnt):
            result += str(self.pop[p][idx])
            result += ","
            idx+=1
        result = result[:-1]
        result += ")"
        return result


    ## Prints chromosome in more readable format.
    #  @param self The object pointer.
    def showChrom(self, chrom=None):
        if chrom is None:
            chrom = self.pop[self.parent]
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
    # getChromosome()
from cgp_core import CgpCore
import dis

import ctypes
import sys
import array
import types 

class CgpCircuit(CgpCore):
    ARRAY_TYPECODE = 'L'

    ## The constructor.
    #  @param self The object pointer. 
    #  @param params Dictionary with CGP params. 
    #     (rows, cols, lback, functions, i/o node ports, i/o data)
    def __init__(self, params,  population):
        # Copy params.
        if params is not None:
            self.__dict__ = params.copy()

        # Set another params 
        self.area           = self.cols * self.rows
        self.popsize        = population
        self.functionCnt    = len(self.functionSet) - 1 # Last idx, because of rand_int(a,b)
        self.graphInputCnt  = len(self.dataInput)
        self.graphOutputCnt = len(self.dataOutput)
        self.maxFitness     = 2**self.graphInputCnt * self.graphOutputCnt
        self.bestFitness    = 42
        CgpCircuit.run      = CgpCore.runAscending  # Type of selecting parent. 
        
        
        self.arrayTypecode  = CgpCircuit.ARRAY_TYPECODE

        self.trainingVectors = 1
        if sys.maxsize > 2**32:
            if self.graphInputCnt > 6:
                self.trainingVectors = int((2**self.graphInputCnt)/64)
        else:                   
            if self.graphInputCnt > 5:
                self.trainingVectors = int((2**self.graphInputCnt)/32)
        self.__convertData()
        self._initOutputBuff()
        self._initUsedNodes(population)
        self.__initLookUp()
        self.__initByteCodes(population)
        if sys.maxsize > 2**32:
            CgpCircuit.bitMax = 2**64 
            self.mask = 2**64-1
        else:
            CgpCircuit.bitMax = 2**32
            self.mask = 2**32-1

    def myExec(self, i ):
        #exec (self.code[i],  None, {"outputBuff" : self.outputBuff})
        exec (self.code[i])

    # Calculate Fitness
    def evaluatePop(self):
        # Init values of evaluation
        for i in range(0, self.popsize):
            if i == self.parent: continue
            self.popFitness[i] = 0 
            ctypes.memset(self.ptrUsedNodes[i], 0, self.bufferUsedNodes)
            self.popUsedNodes[i] = self._usedNodes(self.pop[i], self.usedNodes[i])
            #self.code[i] = self._getByteCodePostfix(self.pop[i], self.usedNodes[i], self.arrByteCodes)
            # Using build-in function: compile()
            #self.code[i] = compile(self.__getCode(self.pop[i], self.usedNodes[i]), "", "exec")
            # Using byte code JIT compilation
            #self.code[i] = self.__getByteCode(self.pop[i], self.usedNodes[i], self.arrByteCodes)
        vektor = 0 
        ptr = self.ptrDataInput
        #for i in self.dataInput: print(hex(i))
        #print()
        for j in range(0, self.trainingVectors):
            ctypes.memmove(self.ptrOutputBuff, ptr, self.buffOffsetSize)
            ptr += self.buffOffsetSize
            for i in range(0, self.popsize):
                if i == self.parent: continue
                #self.myExec(i)

                self.evalFitness(self.pop[i], self.outputBuff, self.usedNodes[i])
                idx = self.lastGeneIdx
                for k in range(0, self.graphOutputCnt):
                    # Zero count
                    # Int -> string -> zero_cnt
                    #tmp = bin((self.outputBuff[self.pop[i][idx]] | self.bitMax)^ self.dataOutput[k+vektor])
                    #self.popFitness[i] += (tmp.count('0')) - 1 # becouse it is in format 0b0001 and i want to del first zero. 
                    # Look-up table
                    #self.popFitness[i] += CgpCircuit.zeroCount((self.outputBuff[self.pop[i][idx]] | self.bitMax)^ self.dataOutput[k+vektor])
                    idx += 1
            vektor += self.graphOutputCnt
        for i in range(0, self.popsize):
            if i == self.parent or self.popFitness[i] != self.maxFitness:
                continue
            #self.popFitness[i] += self.area - self.popUsedNodes[i]


    ## Converts data in more usefull format
    def __convertData(self):
        if sys.maxsize > 2**32:
            architecture = 64
            mask = 2**64 - 1
        else:
            architecture = 32
            mask = 2**32 - 1
        input  = list(self.dataInput)  # Temp variable
        output = list(self.dataOutput) # Temp variable

        # Init array
        size = self.trainingVectors * self.graphInputCnt
        self.dataInput =  array.array(self.arrayTypecode, [0]*size)
        size = self.trainingVectors * self.graphOutputCnt
        self.dataOutput = array.array(self.arrayTypecode, [0]*size)
        
        # Fill up input array
        idx = 0 
        for i in range(0, self.trainingVectors):
            for j in range(0, self.graphInputCnt):
                self.dataInput[idx] = input[j] & mask
                input[j] = input[j] >> architecture
                idx += 1 

        # Fill up output array
        idx = 0 # reset idx, using another array || list
        for i in range(0, self.trainingVectors):
            for j in range(0, self.graphOutputCnt):
                self.dataOutput[idx] = output[j] & mask
                output[j] = output[j] >> architecture
                idx += 1 

    ############################################################################
    # EVAL FITNESS
    ############################################################################
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


    def __initByteCodes(self, population):
        arr = []
        for i in range(0, self.graphInputCnt + self.cols * self.rows):
            arr.append(i)
        self.mask_idx = i + 1
        if sys.maxsize > 2*32:
            arr.append(2**64-1)
        else:
            arr.append(2**32-1)
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



        self.arrByteCodes = array.array('B', initCode + nodeCode*(self.cols*self.rows) + exitCode) 
        self.stacksize = self.area # EDIT IF NEED!!! 
        
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
            code[i+7 ] = chrom[a_idx]
            code[i+14] = chrom[b_idx]
            code[i+17] = self.functionBC1[chrom[f_idx]]
            code[i+18] = self.functionBC2[chrom[f_idx]]
            code[i+19] = self.functionBC3[chrom[f_idx]]
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




    def __initLookUp(self):
        global lookUpBitTable 
        lookUpBitTable = array.array(self.arrayTypecode, [0]*256)
        for i in range(0, 256):
            cnt = 0
            zi  = 0xffff - i
            for j in range(0, 8):
                cnt += zi & 1
                zi = zi >> 1
            lookUpBitTable[i] = cnt

        # Select zeroCount
        if sys.maxsize > 2**32:
            CgpCircuit.zeroCount = CgpCircuit.zeroCount64bit
        else:
            CgpCircuit.zeroCount = CgpCircuit.zeroCount32bit

    def zeroCount32bit(val):
        return lookUpBitTable[val & 0xff] + \
               lookUpBitTable[val >>  8 & 0xff] + \
               lookUpBitTable[val >> 16 & 0xff] + \
               lookUpBitTable[val >> 24 & 0xff]

    def zeroCount64bit(val):
        return lookUpBitTable[val & 0xff] + \
               lookUpBitTable[val >>  8 & 0xff] + \
               lookUpBitTable[val >> 16 & 0xff] + \
               lookUpBitTable[val >> 24 & 0xff] + \
               lookUpBitTable[val >> 32 & 0xff] + \
               lookUpBitTable[val >> 40 & 0xff] + \
               lookUpBitTable[val >> 48 & 0xff] + \
               lookUpBitTable[val >> 56 & 0xff]


    def __getBc(self, chrom, nodeidx, usedNodes, code):
        global code_idx
        idx = (nodeidx - self.graphInputCnt) * 3
        # Mame promennou ulozenu?        jedna se o vstup?
        if usedNodes[nodeidx] == -1 or nodeidx < self.graphInputCnt:
            code[code_idx] = 101
            code_idx += 1 
            code[code_idx] = 0
            code_idx += 1 
            code[code_idx] = 0
            code_idx += 1 
            code[code_idx] = 100
            code_idx += 1 
            code[code_idx] = nodeidx
            code_idx += 1 
            code[code_idx] = 0
            code_idx += 1 
            code[code_idx] = 25
            code_idx += 1 
            return
            #return [101, 0, 0, 100, nodeidx, 0, 25]  # Uloz hajzla
        function = chrom[idx + 2]
        arita = self.functionArity[function]
        if arita == 0:
            code[code_idx] = 100
            code_idx += 1 
            code[code_idx] = self.functionBC4[function]
            code_idx += 1 
            code[code_idx] = 0
            code_idx += 1 
            return
            #return [100, self.functionBC4[function], 0]  # ve 4ce je ulozena konstanta
        # zpracuj a uloz do pole.
        if usedNodes[nodeidx] == 1:
            # IDENTITA
            if function == 0: # Identity
                self.__getBc(chrom, chrom[idx], usedNodes, code)
                return
             
            # dve arity
            elif arita == 2:
                if self.functionBC2[function] == 24:
                    code[code_idx] = 100
                    code_idx += 1 
                    code[code_idx] = self.mask_idx
                    code_idx += 1 
                    code[code_idx] = 0
                    code_idx += 1 
                    self.__getBc(chrom, chrom[idx],   usedNodes, code)
                    self.__getBc(chrom, chrom[idx+1], usedNodes, code)
                    code[code_idx] = self.functionBC1[function]
                    code_idx += 1 
                    code[code_idx] = 24
                    code_idx += 1 
                    return

                self.__getBc(chrom, chrom[idx],   usedNodes, code)
                self.__getBc(chrom, chrom[idx+1], usedNodes, code)
                code[code_idx] = self.functionBC1[function]
                code_idx += 1 
                return

            elif arita == 1:
                code[code_idx] = 100
                code_idx += 1 
                code[code_idx] = self.mask_idx
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                self.__getBc(chrom, chrom[idx],   usedNodes, code)
                code[code_idx] = 24
                code_idx += 1 
                return 

        else: # usedNodes[idx] == 1
            usedNodes[nodeidx] = -1  # SAVE INDEX
            # Identity
            if function == 0:
                self.__getBc(chrom, chrom[idx], usedNodes, code) 
                code[code_idx] = 4
                code_idx += 1 
                code[code_idx] = 101
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 100
                code_idx += 1 
                code[code_idx] = nodeidx 
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 60
                code_idx += 1 
                return
            elif arita == 2:
                #return self.__getBc(chrom, chrom[idx], usedNodes) + self.__getBc(chrom, chrom[idx+1], usedNodes) + self.functionBC1[chrom[idx+2]] + [4, 101, 0, 0, 100, idx, 0, 60] 
                if self.functionBC2[function] == 24:
                    code[code_idx] = 100
                    code_idx += 1 
                    code[code_idx] = self.mask_idx
                    code_idx += 1 
                    code[code_idx] = 0
                    code_idx += 1 
                    self.__getBc(chrom, chrom[idx],   usedNodes, code)
                    self.__getBc(chrom, chrom[idx+1], usedNodes, code)
                    code[code_idx] = self.functionBC1[function]
                    code_idx += 1 
                    code[code_idx] = 24
                    code_idx += 1 
                else:
                    self.__getBc(chrom, chrom[idx],   usedNodes, code)
                    self.__getBc(chrom, chrom[idx+1], usedNodes, code)
                    code[code_idx] = self.functionBC1[function]
                    code_idx += 1 
                code[code_idx] = 4
                code_idx += 1 
                code[code_idx] = 101
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 100
                code_idx += 1 
                code[code_idx] = nodeidx 
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 60
                code_idx += 1 
                return
                #return self.__getBc(chrom, chrom[idx], usedNodes) + self.__getBc(chrom, chrom[idx+1], usedNodes) + [self.functionBC1[chrom[idx+2]]] + [4, 101, 0, 0, 100, nodeidx, 0, 60] 
            elif arita == 1:
                code[code_idx] = 100
                code_idx += 1 
                code[code_idx] = self.mask_idx
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                self.__getBc(chrom, chrom[idx],   usedNodes, code)
                code[code_idx] = 24
                code_idx += 1 
                code[code_idx] = 4
                code_idx += 1 
                code[code_idx] = 101
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 100
                code_idx += 1 
                code[code_idx] = nodeidx 
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 60
                code_idx += 1 
                return
                #      LOAD FUNCTION          CALCULATIONS      EXEC FUNCTION 1 param 0 (magic) keywords SAVE VARIABLE
                #return [100, sinidx, 0] + self.__getBc(chrom, chrom[idx_a], usedNodes) + [131, 1, 0,                              4, 101, 0, 0, 100, nodeidx, 0, 60] 
                                                                              
    ## Transfer chromosome into postfix notation! 
    #  Returns used nodes. 
    #  I somhow love this function 
    #  GENE LENGTH MUST BE 3 
    #  INPUT PORTS MUST BE 2
    #  OUTPUT PORTS MUST BE 1 
    #  IF NOT u have to replace numbers (CONSTANTS) in this piece of script.
    def _getByteCodePostfix(self, chrom, usedNodes, code):
        cnt = 0
        # Load last index
        global code_idx
        code_idx = 0
        idx = self.lastGeneIdx
        for i in range(self.graphOutputCnt):
            if usedNodes[chrom[idx]] == -1: 
                idx +=1
                continue
            self.__getBc(chrom, chrom[idx], usedNodes, code)
            # STACK = [result]                  LOAD ouputBuff
            code[code_idx] = 101
            code_idx+=1
            code[code_idx] = 0
            code_idx+=1
            code[code_idx] = 0
            code_idx+=1
            # STACK = [result, outputBuff]      LOAD const 
            code[code_idx] = 100
            code_idx+=1
            code[code_idx] = chrom[idx]
            code_idx+=1
            code[code_idx] = 0
            code_idx+=1
            #STACK = [result, outputBuff, const] STORE result in outputbuff[const]
            code[code_idx] = 60
            code_idx+=1
            idx+=1
        #STACK = []                          LOAD NONE
        code[code_idx] = 100
        code_idx +=1
        code[code_idx] = self.none_idx
        code_idx +=1
        code[code_idx] = 0
        code_idx +=1
        #STACK = [None]                      RETURN None
        code[code_idx] = 83
        code_idx +=1
        return  types.CodeType(0, 
                              0, # Py2  asi smazat..
                              0,  self.stacksize, 64,
                              code.tobytes(), self.co_consts, self.co_names, tuple(),
                              "", "<module>", 1, self.co_lnotab)
        #dis.dis(c)

    def resultEquation(self, chrom=None):
        if chrom is None: chrom = self.pop[self.parent]
        result = ""
        for i in range(self.graphOutputCnt):
            result += "out_"+ str(i) + "=" + self.__getEq(chrom, chrom[i + self.area * (self.nodeInputPorts + self.nodeOutputPorts)])+ "\n"
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
from cgp_core import CgpCore

from math import sin

import dis # debugging
import ctypes
import sys
import array
import types 

class CgpEquation(CgpCore):
    ARRAY_TYPECODE = 'f'

    ## The constructor.
    #  @param self The object pointer. 
    #  @param params Dictionary with CGP params. 
    #     (rows, cols, lback, functions, i/o node ports, i/o data)
    def __init__(self, params,  population):
        # Copy params.
        if params is not None:
            self.__dict__ = params.copy()

        # Set another params 
        self.area           = self.cols * self.rows
        self.popsize        = population
        self.functionCnt    = len(self.functionSet) - 1 # Last idx, because of rand_int(a,b)
        self.graphInputCnt  = len(self.dataInput)
        self.graphOutputCnt = len(self.dataOutput)
        self.maxFitness     = 0
        self.bestFitness    = 42 #float("inf")
        CgpEquation.run     = CgpCore.runDescending
        
        
        self.arrayTypecode  = CgpEquation.ARRAY_TYPECODE

        self.trainingVectors = len(self.dataInput[0])

        self.__convertData()
        self._initOutputBuff()
        self._initUsedNodes(population)
        self.__initByteCodes(population)
        # Becouse we are using float we need to divide it 2
        if sys.maxsize > 2**32:
            self.bufferUsedNodes = self.bufferUsedNodes >> 1 
            self.buffOffsetSize  = self.buffOffsetSize >> 1

    def __myExec(self, i ):
        #exec (self.code[i],  None, {"outputBuff" : self.outputBuff})
        exec (self.code[i])

    
    # Calculate Fitness
    def evaluatePop(self):
        # Init values of evaluation
        for i in range(0, self.popsize):
            if i == self.parent: continue
            self.popFitness[i] = 0.0
            ctypes.memset(self.ptrUsedNodes[i], 0, self.bufferUsedNodes*2) # Black magic
            self.popUsedNodes[i] = self._usedNodes(self.pop[i], self.usedNodes[i])
            # Using build-in function: compile()
            #self.code[i] = compile(self.__getCode(self.pop[i], self.usedNodes[i]), "", "exec")
            # Using byte code JIT compilation
            #self.code[i] = self.__getByteCode(self.pop[i], self.usedNodes[i], self.arrByteCodes)
            # Yet another JIT compilation
            #self.code[i] = self._getByteCodePostfix(self.pop[i], self.usedNodes[i], self.arrByteCodes)
        vektor = 0 
        ptr = self.ptrDataInput
        for j in range(0, self.trainingVectors):
            ctypes.memmove(self.ptrOutputBuff, ptr, self.buffOffsetSize)
            ptr += self.buffOffsetSize
            for i in range(0, self.popsize):
                if i == self.parent: continue

                try:
                    self.__evalFitness(self.pop[i], self.outputBuff, self.usedNodes[i])
                    #self.__myExec(i)
                except (ZeroDivisionError, ValueError):
                    self.popFitness[i] = 10.0**10.0
                    continue

                idx = self.lastGeneIdx
                for k in range(0, self.graphOutputCnt):
                    #if self.outputBuff[self.pop[i][idx]] >= self.dataOutput[k + vektor]:
                        #self.popFitness[i] += self.outputBuff[self.pop[i][idx]] - self.dataOutput[k + vektor]
                    #else:
                        #self.popFitness[i] += self.dataOutput[k+vektor] - self.outputBuff[self.pop[i][idx]] 
                    idx += 1
            vektor += self.graphOutputCnt
    
    def resultEquation(self, chrom=None):
        if chrom is None: chrom = self.pop[self.parent]
        for i in range(self.graphOutputCnt):
            result = "out_"+ str(i) + "=" + self.__getEq(chrom, chrom[i + self.area * (self.nodeInputPorts + self.nodeOutputPorts)])+ "\n"
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

    ## Converts data in more usefull format
    def __convertData(self):
        # Init array
        input = self.dataInput
        output = self.dataOutput
        size = self.trainingVectors * self.graphInputCnt
        self.dataInput =  array.array(self.arrayTypecode, [0]*size)
        size = self.trainingVectors * self.graphOutputCnt
        self.dataOutput = array.array(self.arrayTypecode, [0]*size)
        
        # Fill up input array
        idx = 0 
        for i in range(0, self.trainingVectors):
            for j in range(0, self.graphInputCnt):
                self.dataInput[idx] = input[j][i]
                idx += 1 

        # Fill up output array
        idx = 0 # reset idx, using another array || list
        for i in range(0, self.trainingVectors):
            for j in range(0, self.graphOutputCnt):
                self.dataOutput[idx] = output[j][i]
                idx += 1 

    ############################################################################
    # EVAL FITNESS
    ############################################################################
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


    ## 
    def __initByteCodes(self, population):
        arr = []
        for i in range(0, self.graphInputCnt + self.cols * self.rows):
            arr.append(i)
        self.mask_idx = i + 1
        if sys.maxsize > 2*32:
            arr.append(2**64-1)
        else:
            arr.append(2**32-1)
        self.none_idx = i + 2
        arr.append(None)
        arr.append(1.0)
        arr.append(0.50)
        arr.append(0.25)
        self.functionBC4[5] = i+5
        self.functionBC4[6] = i+4
        self.functionBC4[7] = i+3

        self.co_consts = tuple(arr)
        #print(self.co_consts)
        #print(self.co_constsk
        self.code = [0] * population
        self.arrByteCodes = [0] * population
        #self.co_names  = ('self', 'graphInputCnt', 'out_idx', 'outputBuff', 'a', 'b', 'bitOnes')
        self.co_names  = ('outputBuff','sin',) # U need to put variable names here. Or function names.. Madness right?
        sinus_idx = 1
        #initCode = [101, 0, 0, 
                    #106, 1, 0, 
                    #90, 2, 0]
        initCode = []
        #                               # PythonBytecode         STACK
        #             0 1 2
        nodeCode = [101, 0, 0,          # LOAD ATTR, outputbuff  [outputbuff]
        #             3 4 5
                    100, 0, 0,          # LOAD CONST, 0          [const, ouputbuff]
        #             6 
                    25,                 # BIN_SUBSCR             [a]
        #             7 8 9 
                    101, 0, 0,          # LOAD ATTR, outputbuff  [outputbuff, a]
        #             10 11 12
                    100, 0, 0,          # LOAD CONST, 0          [const, outputbuff, a]
        #             13
                    25,                 # BIN_SUBSCR             [b, a]
        #             14
                    9,                  # NOP                    [operation]
        #             15
                    9,                  # NOP                    [operation]
        #             16
                    9,                  # NOP                    [operation]
        #             17
                    9,                  # NOP                    [operation]
        #             18
                    9,                  # NOP                    [operation]
        #           19 20 21
                    101, 0, 0,          # LOAD ATTR, outputbuff  [outputbuff, self, result]
        #           22 23 24
                    100, 0, 0,          # LOAD CONST, index      [index, outputbuff, self, result]
        #           25
                    60                  # STORE_SUBCR, val       []
                   ]
        exitCode = [100, self.none_idx, 0,   # LOAD NONE
                    83]                 # Return shit
        #self.co_lnotab = bytes([9,0] + [35,0,10,0]*self.rows*self.cols)
        self.co_lnotab = bytes()

        self.arrByteCodes = array.array('B', initCode + nodeCode*(self.cols*self.rows) + exitCode) 
        #self.arrByteCodes = array.array('B', initCode + [0]*150 + exitCode) 

        self.stacksize = self.area # EDIT IF NEED!!! 


        # Please forgive me for this hack
        self.functionIdx = array.array('L', [0]*self.functionCnt)
        if self.functionCnt == 9: 
            self.functionIdx[8] = sinus_idx

         
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
            code[i   ] = 101
            code[i+1 ] = 0
            code[i+3 ] = 100
            code[i+4]  = chrom[a_idx]
            code[i+11] = chrom[b_idx]
            code[i+14] = self.functionBC1[chrom[f_idx]]
            code[i+15] = self.functionBC2[chrom[f_idx]]
            code[i+16] = self.functionBC3[chrom[f_idx]]
            code[i+17] = self.functionBC4[chrom[f_idx]]
            code[i+18] = self.functionBC5[chrom[f_idx]]
            code[i+23] = j 
            i += 26 
        code[i]   = 100             # RETURN VALUE
        code[i+1] = self.none_idx   # RETURN VALUE
        code[i+2] = 0               # RETURN VALUE
        code[i+3] = 83              # RETURN VALUE
        #exitCode = [100, self.none_idx, 0,   # LOAD NONE
        return types.CodeType(0, 
                              0, # Py2  asi smazat..
                              0,  20, 64,
                              code.tobytes(), self.co_consts, self.co_names, tuple(),
                              "", "<module>", 1, self.co_lnotab)
    

    def __getBc(self, chrom, nodeidx, usedNodes, code):
        global code_idx
        idx = (nodeidx - self.graphInputCnt) * 3
        # Mame promennou ulozenu?        jedna se o vstup?
        if usedNodes[nodeidx] == -1 or nodeidx < self.graphInputCnt:
            code[code_idx] = 101
            code_idx += 1 
            code[code_idx] = 0
            code_idx += 1 
            code[code_idx] = 0
            code_idx += 1 
            code[code_idx] = 100
            code_idx += 1 
            code[code_idx] = nodeidx
            code_idx += 1 
            code[code_idx] = 0
            code_idx += 1 
            code[code_idx] = 25
            code_idx += 1 
            return
            #return [101, 0, 0, 100, nodeidx, 0, 25]  # Uloz hajzla
        function = chrom[idx + 2]
        arita = self.functionArity[function]
        if arita == 0:
            code[code_idx] = 100
            code_idx += 1 
            code[code_idx] = self.functionBC4[function]
            code_idx += 1 
            code[code_idx] = 0
            code_idx += 1 
            return
            #return [100, self.functionBC4[function], 0]  # ve 4ce je ulozena konstanta
        # zpracuj a uloz do pole.
        if usedNodes[nodeidx] == 1:
            # IDENTITA
            if function == 0: # Identity
                self.__getBc(chrom, chrom[idx], usedNodes, code)
                return
             
            # dve arity
            elif arita == 2:
                self.__getBc(chrom, chrom[idx],   usedNodes, code)
                self.__getBc(chrom, chrom[idx+1], usedNodes, code)
                code[code_idx] = self.functionBC1[function]
                code_idx += 1 
                return

            # Jenda arita == jedna se o funkci
            elif arita == 1:
                code[code_idx] = 100
                code_idx += 1 
                code[code_idx] = self.functionIdx[function]
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                
                self.__getBc(chrom, chrom[idx], usedNodes, code)

                code[code_idx] = 131
                code_idx += 1 
                code[code_idx] = arita
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                return
                #raise #laziness at full power
                #return [100, self.sinidx, 0] + self.__getBc(chrom[idx]) + [131, 1, 0]

        else: # usedNodes[idx] == 1
            usedNodes[nodeidx] = -1  # SAVE INDEX
            # Identity
            if function == 0:
                self.__getBc(chrom, chrom[idx], usedNodes, code) 
                code[code_idx] = 4
                code_idx += 1 
                code[code_idx] = 101
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 100
                code_idx += 1 
                code[code_idx] = nodeidx 
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 60
                code_idx += 1 
                return
            elif arita == 2:
                #return self.__getBc(chrom, chrom[idx], usedNodes) + self.__getBc(chrom, chrom[idx+1], usedNodes) + self.functionBC1[chrom[idx+2]] + [4, 101, 0, 0, 100, idx, 0, 60] 
                self.__getBc(chrom, chrom[idx],   usedNodes, code)
                self.__getBc(chrom, chrom[idx+1], usedNodes, code)
                code[code_idx] = self.functionBC1[function]
                code_idx += 1 
                code[code_idx] = 4
                code_idx += 1 
                code[code_idx] = 101
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 100
                code_idx += 1 
                code[code_idx] = nodeidx 
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 60
                code_idx += 1 
                return
                #return self.__getBc(chrom, chrom[idx], usedNodes) + self.__getBc(chrom, chrom[idx+1], usedNodes) + [self.functionBC1[chrom[idx+2]]] + [4, 101, 0, 0, 100, nodeidx, 0, 60] 
            elif arita == 1:
                code[code_idx] = 100
                code_idx += 1 
                code[code_idx] = self.functionIdx[function]
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                
                self.__getBc(chrom, chrom[idx], usedNodes, code)

                code[code_idx] = 131
                code_idx += 1 
                code[code_idx] = arita
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 

                code[code_idx] = 4
                code_idx += 1 
                code[code_idx] = 101
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 100
                code_idx += 1 
                code[code_idx] = nodeidx 
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                code[code_idx] = 60
                code_idx += 1 
                return
                #return [100, sinidx, 0] + self.__getBc(chrom, chrom[idx_a], usedNodes) + [131, 1, 0,                              4, 101, 0, 0, 100, nodeidx, 0, 60] 
                #raise
                #      LOAD FUNCTION          CALCULATIONS      EXEC FUNCTION 1 param 0 (magic) keywords SAVE VARIABLE
                                                                              
    ## Transfer chromosome into postfix notation! 
    #  Returns used nodes. 
    #  I somhow love this function 
    #  GENE LENGTH MUST BE 3 
    #  INPUT PORTS MUST BE 2
    #  OUTPUT PORTS MUST BE 1 
    #  IF NOT u have to replace numbers (CONSTANTS) in this piece of script.
    def _getByteCodePostfix(self, chrom, usedNodes, code):
        #self.functionSet  = [Cgp.add, Cgp.sub, Cgp.mul, Cgp.div, Cgp.id, Cgp._0_25, Cgp._0_50, Cgp._1_00]
        #self.functionTable= [" ADD",   " SUB",   " MUL",   " DIV",   " ID ",  "0.25",     "0.50",     "1.00"]
        #puvodni_bc = self.__getByteCode(chrom, usedNodes, code)
        cnt = 0
        #print(usedNodes)
        #print(self.resultEquation(chrom))
        #print(self.showChrom(chrom))
        #print()
        #print("PREVOD CHROMOSOMU DO POSTFIXOVE NOTACE:")
        # Load last index
        global code_idx
        code_idx = 0
        #print(self.resultEquation())
        idx = self.lastGeneIdx
        for i in range(self.graphOutputCnt):
            if usedNodes[chrom[idx]] == -1: 
                idx +=1
                continue
            self.__getBc(chrom, chrom[idx], usedNodes, code)
            # STACK = [result]                  LOAD ouputBuff
            code[code_idx] = 101
            code_idx+=1
            code[code_idx] = 0
            code_idx+=1
            code[code_idx] = 0
            code_idx+=1
            # STACK = [result, outputBuff]      LOAD const 
            code[code_idx] = 100
            code_idx+=1
            code[code_idx] = chrom[idx]
            code_idx+=1
            code[code_idx] = 0
            code_idx+=1
            #STACK = [result, outputBuff, const] STORE result in outputbuff[const]
            code[code_idx] = 60
            code_idx+=1
            idx+=1
        #STACK = []                          LOAD NONE
        code[code_idx] = 100
        code_idx +=1
        code[code_idx] = self.none_idx
        code_idx +=1
        code[code_idx] = 0
        code_idx +=1
        #STACK = [None]                      RETURN None
        code[code_idx] = 83
        code_idx +=1
        return types.CodeType(0, 
                              0, # Py2  asi smazat..
                              0,  self.stacksize, 64,
                              code.tobytes(), self.co_consts, self.co_names, tuple(),
                              "", "<module>", 1, self.co_lnotab)


    # Simulate circuit
    def __evalFitness(self, chrom, out, usedNodes):
        idx = 0 # Index pointer in chromosome
        j = self.graphInputCnt
        # For each node set its output
        for i in range(self.graphInputCnt, self.area+self.graphInputCnt):
            if usedNodes[i] == 0: 
                idx += 3 
                continue
            a = out[chrom[idx]]
            idx += 1
            b = out[chrom[idx]]
            idx += 1
            out[i] = self.functionSet[chrom[idx]](a, b)
            idx += 1

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
