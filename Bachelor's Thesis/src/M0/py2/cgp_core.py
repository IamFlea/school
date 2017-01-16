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
        for i in xrange(0, self.popsize):
            if self.popFitness[i] > self.bestFitness:
                self.parent = i
                self.bestFitness = self.popFitness[i]

        # Start the timer.
        start = time.time()

        # Run evolution.
        for gen in xrange(0, generations): 
            # Printing generation
            #self.printGeneration(gen)
            # Each person in population is mutated.
            for i in xrange(0, self.popsize):
                if self.parent == i: continue  # Skip parent
                #ctypes.memmove(self.ptrPop[i], self.ptrPop[self.parent], self.chromSize)
                self.pop[i] = array.array(self.arrayTypecode, self.pop[self.parent])
                self.__mutation(self.pop[i])
            # evaluate population
            self.evaluatePop()
            parentt = self.parent # Save parent position
            a = False
            for i in xrange(0, self.popsize):
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
        # INJEKCE logx
        #self.pop[0] = array.array('L', [0,0,7,1,0,4,1,0,8,2,0,7,4,3,5,5,5,4,2,3,8,6,2,8,8,4,7,2,4,5,7,9,0,9,8,6,12,10,6,13,13,4,10,0,2,13])
        # Evaluate first population 
        self.evaluatePop()
        # Select first parent
        for i in xrange(0, self.popsize):
            if self.popFitness[i] < self.bestFitness:
                self.parent = i
                self.bestFitness = self.popFitness[i] - acc

        # Start the timer.
        start = time.time()

        # Run evolution.
        for gen in xrange(0, generations): 
            # Printing generation
            #self.printGeneration(gen)
            # Each person in population is mutated.
            for i in xrange(0, self.popsize):
                if self.parent == i: continue  # Skip parent
                #ctypes.memmove(self.ptrPop[i], self.ptrPop[self.parent], self.chromSize)
                self.pop[i] = array.array('L', self.pop[self.parent])
                self.__mutation(self.pop[i])
            # evaluate population
            self.evaluatePop()
            parentt = self.parent # Save parent position
            for i in xrange(0, self.popsize):
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
        self.lastFuncIdx = self.area - 1          # -1 becouse of random.int(a,b) is in xrange <a, b>
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
        for i in xrange(0,self.cols):
            minIdx = self.rows*(i - self.levelBack)
            if minIdx < 0: 
                minIdx = 0
            minIdx = minIdx + self.graphInputCnt
            maxIdx = i * self.rows + self.graphInputCnt
            self.__lBackLen.append(self.graphInputCnt + maxIdx - minIdx -1)
            tmp = array.array('L')
            # Look-up table - select inputs
            for j in xrange(0, self.graphInputCnt):
                tmp.append(j)
            # Look-up table - select nodes
            for j in xrange(minIdx, maxIdx):
                tmp.append(j)
            self.__lBack.append(tmp)
    # __initLevelBack()

    ## Sets self.pop look up table for L param. 
    #  @param self
    #      The object pointer.
    def _initPopulation(self, pop):
        self.pop = []
        # For everyone in population create his chromosome
        for i in xrange(0, self.popsize):
            chromosome = array.array('L')
            # Creating genes
            for j in xrange(0, self.area):
                col = int(j/self.rows)
                # Select function inputs (gene inputs)
                for k in xrange(0, self.nodeInputPorts):
                    tmp = self.__lBack[col][random.randint(0,self.__lBackLen[col])]
                    chromosome.append(tmp)
                # Select function (gene operation)   #for k in xrange(0, self.functionOutputs):
                tmp = random.randint(0, self.functionCnt)
                chromosome.append(tmp)
            # Connecting primary outputs, creating last gene
            for j in xrange(0, self.graphOutputCnt):
                chromosome.append(random.randint(0, self.area + self.graphInputCnt - 1))
            self.pop.append(chromosome)
        self.ptrPop = array.array('L')
        for i in xrange(pop):
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
        for j in xrange(0, mutations):
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
        self.ptrDataInput,  tmp = self.dataTrain.buffer_info() 
        self.buffOffsetSize     = bytes * self.graphInputCnt

    def _initUsedNodes(self, population):
        self.popUsedNodes = array.array('l', [0] * population)
        self.ptrUsedNodes = array.array('L', [0] * population)
        self.usedNodes = []
        for i in xrange(0, population):
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
        for i in xrange(0, self.graphOutputCnt): 
            usedNodes[chrom[idx]] += 1
            idx += 1
        idx = self.lastGeneIdx - 1 # Chromosome index
        uidx = len(usedNodes) - 1  # NODE index
        for i in xrange(0, self.area):
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

    # getChromosome()
