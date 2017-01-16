DEF PRINT_GENERATION = 0
DEF SYS_ARCHITECTURE = 32

IF SYS_ARCHITECTURE == 32:
    DEF SYS_BYTES = 4
ELIF SYS_ARCHITECTURE == 64:
    DEF SYS_BYTES = 8

cdef extern from "string.h":
    void memcpy(void* a, void* b, int c)
cdef extern from "stdlib.h":
    int rand()
    void srand(int a)
# Libs and modules.
import sys    # System module (standard input, output..)
import random # Pseudorandom generator.
import time   # Time() for seed.
import re     # Regular expressions. Might be usefull?
import array  # C like arrays 
import ctypes # memmove

cdef class CgpCore:
    cdef int cols
    cdef int rows
    cdef int area
    cdef int levelBack
    cdef int graphInputCnt
    cdef int graphOutputCnt
    cdef int nodeInputPorts
    cdef int nodeOutputPorts
    cdef int nodeIOPorts
    cdef int [:] functionArity

    cdef int popsize
    cdef int parent
    cdef int chromSize
    cdef int chromLength
    cdef int lastGeneIdx
    cdef int bufferUsedNodes
    cdef object pop
    cdef int [:] popUsedNodes
    cdef object usedNodes
    cdef int lenUsedNodes
    cdef object __lBack
    cdef int [:] __lBackLen
    cdef unsigned int elapsed
    cdef unsigned int evalspersec

    # Podedit 
    cdef long  maxFitness
    cdef long  bestFitness
    cdef long [:] outputbuff
    # popFitness  = array.array(self.arrayTypecode, [0] * pop)    # Init population fitnesses [0, 0, .. -0]
    # bestFitness
    # outputbuffer
    
    ## Starts cartesian genetic programming.
    #  @param self    The object pointer.
    #  @param p_gen   How many generations.
    #  @param p_pop   Size of population. Default 5. Optional.
    #  @param p_mut   Max mutated gens during one mutation()
    cdef void runAscending(self, \
                           int generations, \
                           int popsize, \
                           int mut, \
                           float acc = 0.01):
        cdef int i, gen, newparent
        cdef unsigned int start
        # Shuffle cards
        #random.seed()
        #srand(time.time()) 
        srand(73541)
        # Setting instance variables.
        self._initCGPRun(popsize)

        # INJEKCE  4x4 adder   
        self.pop[0] = array.array('L', [2,6,7,7,3,5,9,8,6,5,1,3,2,6,7,2,8,1,13,4,0,0,4,7,8,9,3,11,5,2,4,4,7,15,17,7,10,13,6,2,14,1,15,3,3,3,7,3,13,14,1,2,4,2,25,16,3,5,26,1,11,20,5,28,19,7,0,4,1,23,2,0,25,2,7,20,11,7,30,27,0,18,29,1,35,0,4,10,0,0,18,16,1,30,10,6,28,37,2,32,31,1,31,29,5,28,19,7,18,33,1,29,15,6,45,34,2,18,46,1,47,35,44,38,23])

        # Evaluate first population 
        self.evaluatePop(popsize)
        # Select first parent
        for i in range(0, popsize):
            if self.popFitness[i] > self.bestFitness:
                self.parent = i
                self.bestFitness = self.popFitness[i]

        # Start the timer.
        start = time.time()

        # Run evolution.
        for gen in range(0, generations): 
            # Each person in population is mutated.
            for i in range(0, popsize):
                if self.parent == i: continue  # Skip parent
                memcpy(<void *> self.pop[i], <void *>self.pop[self.parent], self.chromSize) 
                self.__mutation(self.pop[i], mut)
            # evaluate population
            self.evaluatePop(popsize)
            newparent = self.parent # Save parent position
            for i in range(0, popsize):
                # Skip parent or worse finesses...
                if self.parent == i or self.popFitness[i] < self.bestFitness:
                    continue
                if self.popFitness[i] > self.bestFitness:
                    self.bestFitness = self.popFitness[i]
                    # TODO IFDEF
                    print("Generation: "+ repr(str(gen)).rjust(10) +" Fitness: "+ repr(str(self.bestFitness)).rjust(10) +" / "+ str(self.maxFitness))
                # Found better fitness?
                newparent = i # Use parent with same fitness
            self.parent = newparent # Actualize parent
            #for
        #for
        #print("Generation:", repr(generations).rjust(10))
        self.elapsed = time.time() - start
        self.evalspersec = round(generations/self.elapsed * (popsize-1))
        # Done
    #runAscending

    ## Starts cartesian genetic programming.
    #  @param self    The object pointer.
    #  @param p_gen   How many generations.
    #  @param p_pop   Size of population. Default 5. Optional.
    #  @param p_mut   Max mutated gens during one mutation()
    cdef void runDescending(self, \
                            int generations, \
                            int popsize, \
                            int mut, \
                            float acc = 0.01):
        cdef int i, gen, newparent
        cdef unsigned int start
        # Shuffle cards
        srand(73541)
        #srand(time.time())
        #random.seed()
        # Setting instance variables.
        self._initCGPRun(popsize)
        # INJEKCE logx
        self.pop[0] = array.array('L', [0,0,7,1,0,4,1,0,8,2,0,7,4,3,5,5,5,4,2,3,8,6,2,8,8,4,7,2,4,5,7,9,0,9,8,6,12,10,6,13,13,4,10,0,2,13])
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
            # Each person in population is mutated.
            for i in range(0, self.popsize):
                if self.parent == i: continue  # Skip parent
                memcpy(<void *>self.pop[i], <void *> self.pop[self.parent], self.chromSize) 
                self.__mutation(self.pop[i], mut)
            # evaluate population
            self.evaluatePop(popsize)
            newparent = self.parent # Save parent position
            for i in range(0, self.popsize):
                # Skip parent or worse finesses...
                if self.parent == i or self.popFitness[i] > self.bestFitness:
                    continue
                if self.popFitness[i] < self.bestFitness:
                    self.bestFitness = self.popFitness[i] - acc
                    print("Generation: "+ repr(str(gen)).rjust(10) +" Fitness: "+ repr(str(self.bestFitness)).rjust(10))
                # Found better fitness?
                newparent = i # Use parent with same fitness
            self.parent = newparent # Actualize parent
            #for
        #for
        #print("Generation:", repr(generations).rjust(10))
        self.elapsed = time.time() - start
        self.evalspersec = round(generations/self.elapsed * (self.popsize-1))
    #runDescending

    ## Initiate variables.
    cdef void _initCGPRun(self, int pop):
        self.parent      = -1                     # Parent in population.
        self.lastGeneIdx = self.area * (self.nodeInputPorts + self.nodeOutputPorts) # Last gene index in chromosome
        self._initLevelBack()                       # Initiate level back lookup tables self.__lBack[] self.__lBackLen[]
        self._initPopulation(pop)                     # Initiate population. self.pop[]
        self.chromLength = len(self.pop[0])
        self.chromSize   = self.chromLength * SYS_BYTES
        self.nodeIOPorts = self.nodeInputPorts + self.nodeOutputPorts


    ## Sets self.__lBack look up table for L param.
    #  @param self  The object pointer.
    cdef void _initLevelBack(self):
        cdef int i, minIdx, maxIdx
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
            self.__lBackLen.append(self.graphInputCnt + maxIdx - minIdx )
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
    cdef void _initPopulation(self, int pop):
        cdef int i, j, k, col, tmp
        self.pop = []
        # For everyone in population create his chromosome
        for i in range(0, self.popsize):
            chromosome = array.array('L')
            # Creating genes
            for j in range(0, self.area):
                col = (j/self.rows)
                # Select function inputs (gene inputs)
                for k in range(0, self.nodeInputPorts):
                    tmp = self.__lBack[col][rand()%self.__lBackLen[col]]
                    chromosome.append(tmp)
                # Select function (gene operation)   #for k in range(0, self.functionOutputs):
                tmp = rand() % self.functionCnt
                chromosome.append(tmp)
            # Connecting primary outputs, creating last gene
            for j in range(0, self.graphOutputCnt):
                chromosome.append(rand() %(self.area + self.graphInputCnt))
            self.pop.append(chromosome)
    #__initLevelBack(self)


    ## Mutate chromosome
    #  @param self
    #      The object pointer.
    #  @param chromosome
    #      The mutated chromosome.
    cdef void __mutation(self, int [:] chromosome, int mut):
        cdef int mutations = rand() % mut + 1
        cdef int j, idx, col, rnd
        # Max of mutations.
        for j in range(0, mutations):
            # Select mutated base. (The gene.)
            idx = rand() % self.chromLength
            col = ((idx/self.nodeIOPorts) / self.rows)
            #rnd = chromosome[idx]
            # Mutate NODE
            if idx < self.lastGeneIdx: # lastBaseIdx - 1
                # Mutate connection
                #if idx % self.node_IO_ports < self.nodeInputPorts:
                if idx % self.nodeIOPorts < self.nodeInputPorts:
                    # Same as: if (col_values[col]->items > 1){ while(1){..} }
                    if self.__lBackLen[col] > 1:
                        while 1:
                            rnd = self.__lBack[col][rand()%self.__lBackLen[col]]
                            if rnd != chromosome[idx]: break
                    chromosome[idx] = rnd
                    
                # Mutate function
                else:
                    # Same as: if (items > 1){ while(1){..} }
                    if self.functionCnt > 1:
                        while 1:
                            rnd = rand() % self.functionCnt 
                            if rnd != chromosome[idx]: break
                    chromosome[idx] = rnd
            # Mutate output last ,,gene''
            else:
                while 1:
                    rnd = rand() % self.lastGeneIdx / self.nodeIOPorts
                    if rnd != chromosome[idx]: break
                chromosome[idx] = rnd


    cdef void _initOutputBuff(self):
        self.outputBuff = array.array(self.arrayTypecode, [0] * (self.area + self.graphInputCnt))
        #self.ptrOutputBuff, tmp = self.outputBuff.buffer_info()
        self.ptrDataInput,  tmp = self.dataTrain.buffer_info() 
        self.buffOffsetSize     = SYS_BYTES * self.graphInputCnt

    cdef void _initUsedNodes(self, int population):
        cdef int i
        self.popUsedNodes = array.array('l', [0] * population)
        self.usedNodes = []
        for i in range(0, population):
            self.usedNodes.append(array.array('l', [0] * (self.rows * self.cols + self.graphInputCnt)))
        self.bufferUsedNodes = (self.rows * self.cols + self.graphInputCnt)*SYS_BYTES
        self.lenUsedNodes = len(self.usedNodes[0])



    # Returns used nodes.
    cdef int _usedNodes(self, int [:] chrom, int [:] usedNodes):
        cdef int uidx, f 
        cdef int cnt = 0
        cdef int idx = self.lastGeneIdx
        cdef int i = 0
        for i in range(0, self.graphOutputCnt): 
            usedNodes[chrom[idx]] += 1
            idx += 1
        idx = self.lastGeneIdx - 1 # Chromosome index
        uidx = self.lenUsedNodes  - 1  # NODE index
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

    # getChromosome()
