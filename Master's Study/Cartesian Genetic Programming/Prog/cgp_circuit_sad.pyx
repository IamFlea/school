DEF SYS_ARCHITECTURE = 64

IF SYS_ARCHITECTURE == 32:
    DEF SYS_BYTES = 4
    DEF SYS_MASK  = 2**32 - 1 
ELIF SYS_ARCHITECTURE == 64:
    DEF SYS_BYTES = 8
    DEF SYS_MASK  = 2**64 - 1
DEF DEBUG = 0
DEF DEBUG_INJECTION  = 0
DEF DEBUG_SEED = 0
#DEF DEBUG_SEED = 73541

cdef extern from "string.h":
    void* memcpy(void* a, void* b, int c)
    void* memset(void* a, int b, int c)
cdef extern from "stdlib.h":
    void * malloc(int a)
    void free(void* a)
    int rand()
    void srand(int a)
#include <stddef.h>
# Libs and modules.
import sys    # System module (standard input, output..)
import random # Pseudorandom generator.
import time   # Time() for seed.
import re     # Regular expressions. Might be usefull?
import array  # C like arrays 
import ctypes # memmove

# Shuffle cards
IF DEBUG_SEED > 0:
    srand(DEBUG_SEED)
ELSE:
    srand(time.time())


## aaa hezky odznova
cdef class CgpCircuitSAD:
    cdef int maxGates

    cdef unsigned char ** code
    # INPUT VARIABLES
    cdef int cols
    cdef int rows
    cdef int levelBack
    cdef int graphInputCnt
    cdef int graphOutputCnt

    # FUNCTIONS
    cdef int functionCnt
    cdef object functionSet
    cdef int * functionArity
    cdef int nodeInputPorts 
    cdef int nodeOutputPorts
    cdef int nodeIOPorts 
        
    # CGP VARS
    cdef int area
    cdef int trainVectors
    cdef void* dataTrain
     
    cdef int ** pop 
    cdef int popsize
    cdef int lastGeneIdx
    cdef int chromLength
    cdef int chromSize

    
    cdef int ** __lBack 
    cdef int *  __lBackLen
    

    # OUTPUT DATA
    cdef readonly unsigned long elapsed 
    cdef readonly unsigned long evalspersec
    cdef int parent

    cdef int * popFitness
    cdef int * popFitnessNodes
    cdef int ** usedNodes
    cdef int usedNodesLen
    cdef int usedNodesSize
    cdef int * lookUpBitTable
    cdef readonly long   bestFitness
    cdef readonly long   maxFitness

    cdef long * outputBuff
    cdef int outputBuffSize

    cdef public   object result 

    cdef int bestResultGeneration
    cdef int resultUsedNodes


    cdef int evalFitness(self, int* chrom, long* out, int* usedNodes):
        cdef int  j, i, o
        cdef int * idx = chrom 
        cdef long a, b
        j = self.graphInputCnt
        # For each node set its output
        for i in range(self.graphInputCnt, self.area+self.graphInputCnt):
            if usedNodes[i] == 0: 
                idx += 3 
                j += 1
                continue
            a = out[idx[0]]
            idx += 1
            b = out[idx[0]]
            idx += 1
            o = idx[0]
            if   o == 0: out[j] = a
            elif o == 1: out[j] = a & b
            elif o == 2: out[j] = a | b
            elif o == 3: out[j] = a ^ b
            elif o == 4: out[j] = ~a 
            elif o == 5: out[j] = ~(a & b)
            elif o == 6: out[j] = ~(a | b)
            elif o == 7: out[j] = ~(a ^ b)

            #out[j] = self.functionSet[idx[0]](a, b)
            j   += 1
            idx += 1

    def setMaxGates(self, pmg):
        self.maxGates = pmg 

    def __init__(self, cols, rows, levelBack, dataInput, dataOutput, functions):
        self.maxGates = -1
        cdef int i 
        IF DEBUG == 1 and 0:
            print
            print "Hello, Forest!"
            print "I am CGP. I have just spawned here!"
            print 
            print "Graph: " + str(cols) + " x " + str(rows) + " (" + str(levelBack) + ")"
            print "Data Input: "
            for dato in dataInput:
                print(hex(dato))
            print "Data Output: "
            for dato in dataOutput:
                print(hex(dato))
            print
        ELSE:
            pass
        self.cols = cols
        self.rows = rows
        self.area = cols * rows
        self.levelBack = levelBack
        
        self.__convertData(dataInput, dataOutput)

        IF DEBUG == 1 and 0:
            cdef unsigned long * ptr = <unsigned long *> self.dataTrain
            for i in range(0, self.trainVectors *(self.graphInputCnt + self.graphOutputCnt)):
                print(hex(ptr[0]))
                ptr += 1
        ELSE:
            pass

        self.functionCnt     = len(functions.set)
        self.functionSet     = functions.set
        self.functionArity   = <int *> malloc(sizeof(int) * self.functionCnt) 
        cdef int idx = 0
        for i in functions.arity:
            self.functionArity[idx] = i
            idx += 1

        self.nodeInputPorts  = functions.inputs
        self.nodeOutputPorts = functions.outputs
        self.nodeIOPorts     = functions.outputs + functions.inputs

        IF DEBUG == 1 and 0:
            print "Node info: "
            print("Cnt:         ", self.functionCnt)
            print("Set:         ", self.functionSet)
            arita = "["
            for i in range(self.functionCnt):
                arita += str(self.functionArity[i]) + " "
            arita = arita[:-1]
            arita += "]"
            print("Arita:       ", arita)
            print("Max inputs:  ", self.nodeInputPorts)
            print("Max outputs: ", self.nodeOutputPorts)
        ELSE:
            pass

    cdef void __convertData(self, input, output):
        cdef int i, j, size
        cdef unsigned long * idx
        
        self.graphInputCnt  = len(input)
        self.graphOutputCnt = len(output)

        IF SYS_ARCHITECTURE == 32: 
            self.trainVectors = 1
            if self.graphInputCnt > 5:
                self.trainVectors = int((2**self.graphInputCnt)/32)
        ELIF SYS_ARCHITECTURE == 64: 
            self.trainVectors = 1
            if self.graphInputCnt > 6:
                self.trainVectors = int((2**self.graphInputCnt)/64)

        # Init array
        size = self.trainVectors * (self.graphInputCnt  + self.graphOutputCnt)
        self.dataTrain = <unsigned long *> malloc(8 * size)

        # Fill up input array
        idx = <unsigned long *> self.dataTrain
        for i in range(0, self.trainVectors):
            for j in range(0, self.graphInputCnt):
                idx[0] = input[j] & SYS_MASK
                input[j] = input[j] >> SYS_ARCHITECTURE
                idx += 1
            for j in range(0, self.graphOutputCnt):
                idx[0] = output[j] & SYS_MASK
                output[j] = output[j] >> SYS_ARCHITECTURE
                idx += 1

    ## Inits population, lback arryas need ot be defined. 
    cdef void _initPopulation(self, int pop):
        cdef int i, j, k, col, idx
        cdef int * chromosome 
        cdef int * usedNodes
        idx = 0
        self.pop = <int **> malloc(sizeof(int *) * pop)
        self.popsize = pop
        self.chromLength = -1  

        self.popFitness      = <int *> malloc(sizeof(int) * pop) 
        self.popFitnessNodes = <int *> malloc(sizeof(int) * pop) 
        self.usedNodes       = <int **> malloc(sizeof(int *) * pop) 
        self.usedNodesLen    = self.area + self.graphInputCnt
        self.usedNodesSize   = sizeof(int)*self.usedNodesLen

        self.outputBuff      = <long *> malloc(sizeof(long) * (self.area + self.graphInputCnt))
        self.outputBuffSize  = sizeof(long)*(self.area + self.graphInputCnt)
        
        # For everyone in population create his chromosome
        for i in range(0, pop):
            usedNodes = <int *>  malloc(sizeof(int) * (self.area + self.graphInputCnt))
            self.usedNodes[i] = usedNodes
            chromosome = <int *> malloc(sizeof(int) * (self.area *(self.nodeInputPorts + self.nodeOutputPorts) + self.graphOutputCnt))
            idx = 0
            # Creating genes
            for j in range(0, self.area):
                col = (j/self.rows)
                # Select function inputs (gene inputs)
                for k in range(0, self.nodeInputPorts):
                    #tmp = self.__lBack[col][rand()%self.__lBackLen[col]]
                    chromosome[idx] = self.__lBack[col][rand()%self.__lBackLen[col]]
                    idx += 1
                # Select function (gene operation)   #for k in range(0, self.functionOutputs):
                chromosome[idx] = rand() % self.functionCnt
                idx += 1
            # Connecting primary outputs, creating last gene
            if self.maxGates != -1 and i == (pop-1): # alespon jedno reseni v populaci je normalni
                for j in range(0, self.graphOutputCnt):
                    chromosome[idx] = rand() % self.graphInputCnt
                    idx += 1 
            else:
                for j in range(0, self.graphOutputCnt):
                    chromosome[idx] = rand() %(self.area + self.graphInputCnt)
                    idx += 1 

            self.pop[i] = chromosome
            self.popFitness[i] = 0
            self.popFitnessNodes[i] = 0
        self.__initLookUp()
        self.chromLength = idx 
        self.chromSize = idx * sizeof(int)
        self.lastGeneIdx = idx - self.graphOutputCnt

    cdef void _initLBack(self):
        cdef int i, minIdx, maxIdx, j, idx
        cdef int * lBack
        self.__lBack    = <int **> malloc(sizeof(int *) * self.cols) # Array of crrect values for each column
        self.__lBackLen = <int *>  malloc(sizeof(int)   * self.cols) # Count of correct values for each column
        for i in range(0, self.cols):
            minIdx = self.rows*(i - self.levelBack)
            if minIdx < 0: 
                minIdx = 0
            minIdx = minIdx + self.graphInputCnt 
            maxIdx = i * self.rows + self.graphInputCnt
            self.__lBackLen[i] = self.graphInputCnt + maxIdx - minIdx
            lBack  = <int *> malloc(sizeof(int) * self.__lBackLen[i])
            idx = 0
            # Look-up table - select inputs
            for j in range(0, self.graphInputCnt):
                lBack[idx] = j
                idx+=1
            # Look-up table - select nodes
            for j in range(minIdx, maxIdx):
                lBack[idx] = j
                idx+=1
            self.__lBack[i] = lBack
        IF DEBUG == 1 and 0: 
            print "LBACK INITED"
            for i in range(0, self.cols): 
                print("i = " + str(i) + ";  LEN: " + str(self.__lBackLen[i]) )
                foiaejfoihearoi = ""
                for j in range(self.__lBackLen[i]):
                    foiaejfoihearoi += str(self.__lBack[i][j]) + " "
                print(foiaejfoihearoi[:-1])
        ELSE:
            pass
    # __initLevelBack()
    
    cdef void injection(self, int p, list):
        idx = 0
        for item in list: 
            self.pop[p][idx] = <int> item
            idx += 1 

    cdef void __initLookUp(self):
        cdef int i,cnt,zi,j
        self.lookUpBitTable = <int *> malloc(sizeof(int)*256)
        for i in range(0, 256):
            cnt = 0
            zi  = 0xffff - i
            for j in range(0, 8):
                cnt += zi & 1
                zi = zi >> 1
            self.lookUpBitTable[i] = cnt

    cdef int zeroCount(self, long val):
        IF SYS_ARCHITECTURE == 32:
                return self.lookUpBitTable[val & 0xff] + \
                       self.lookUpBitTable[val >>  8 & 0xff] + \
                       self.lookUpBitTable[val >> 16 & 0xff] + \
                       self.lookUpBitTable[val >> 24 & 0xff]
        ELIF SYS_ARCHITECTURE == 64:
                return self.lookUpBitTable[val & 0xff] + \
                       self.lookUpBitTable[val >>  8 & 0xff] + \
                       self.lookUpBitTable[val >> 16 & 0xff] + \
                       self.lookUpBitTable[val >> 24 & 0xff] + \
                       self.lookUpBitTable[val >> 32 & 0xff] + \
                       self.lookUpBitTable[val >> 40 & 0xff] + \
                       self.lookUpBitTable[val >> 48 & 0xff] + \
                       self.lookUpBitTable[val >> 56 & 0xff]


    cdef int _usedNodes(self, int * chrom, int * usedNodes):
        cdef int i, f, uidx
        cdef cnt = 0
        cdef int idx = self.lastGeneIdx
        for i in range(0, self.graphOutputCnt): 
            usedNodes[chrom[idx]] += 1
            idx += 1
        idx = self.lastGeneIdx - 1 # Chromosome index
        uidx = self.usedNodesLen  - 1  # NODE index
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
                idx -= self.nodeIOPorts
            uidx -= 1
        return cnt

    #__initLevelBack(self)
    cdef void evaluatePop(self, int popsize):
        cdef int i, j, k, idx, a
        cdef unsigned long * ptr 
        cdef unsigned char * ptri
        # Init values of evaluation
        for i in range(popsize):
            if i == self.parent: continue
            self.popFitness[i] = 0 
            memset(self.usedNodes[i], 0, self.usedNodesSize)
            self.popFitnessNodes[i] = self._usedNodes(self.pop[i], self.usedNodes[i])
            #ptri = self.code[i]
            #str = ""
            #while (ptri[0] != 0xff):
                #str += hex(ptri[0])[2:]
                #ptri +=1 
            #print str
            #return
            #self.code[i][0] = 0xc3

        ptr = <unsigned long *> self.dataTrain
        for j in range(self.trainVectors):
            memcpy(<void *> self.outputBuff, ptr, self.graphInputCnt*sizeof(long))
            for i in range(self.graphInputCnt):
                #print hex(ptr[0])
                ptr += 1
            #ptr += self.outputBuffSize + self.graphOutputCnt * 8   
            for i in range(0, popsize):
                if i == self.parent: continue
                #(<execute *> (self.code[i]))()
                self.evalFitness(self.pop[i], self.outputBuff, self.usedNodes[i])
                idx = self.lastGeneIdx
                for k in range(0, self.graphOutputCnt):
                    # Zero count
                    self.popFitness[i] += (SYS_ARCHITECTURE - self.zeroCount(self.outputBuff[self.pop[i][idx]] ^ ptr[k])) << (self.graphOutputCnt -1 - k)
                    idx += 1
            ptr += self.graphOutputCnt
        for i in range(0, popsize):
            if i == self.parent: continue
            if self.maxGates != -1 and self.popFitnessNodes[i] > self.maxGates:
                self.popFitness[i] = 0x7fffffff
            if self.popFitness[i] != 0:
                continue
            self.popFitness[i] -= self.area - self.popFitnessNodes[i]

    cdef void _initCode(self, popsize):
        self.code = <unsigned char **> malloc(sizeof(unsigned char *) * self.popsize) 
        cdef unsigned char * ptr 
        for i in range(popsize):
            ptr = <unsigned char *> malloc(sizeof(unsigned char) * (42 + 24*self.area))
            self.code[i] = ptr 

    cdef void run(self, int generations, int popsize, int mut):
        self.popsize = popsize
        cdef unsigned long start
        cdef unsigned int i 
        cdef unsigned long j
        cdef int gen, newparent
        # Setting instance variables.
        self.parent      = -1                     # Parent in population.
        self.maxFitness  = 2**self.graphInputCnt * self.graphOutputCnt
        self.bestFitness = 0x7fffffff #ffffffff

        self._initLBack()
        self._initPopulation(popsize)                     # Initiate population. self.pop[]
        self._initCode(popsize)
        IF DEBUG == 1 and 0:
            strs = "" 
            for j in range(self.chromLength):
                strs += str(self.pop[0][j]) + " "
            print strs
            print "POP INITED"
        # 3x4 adder injekce spravneho reseni
        #self.injection(0, [2,5,1,6,4,6,4,6,3,0,3,3,8,1,3,8,10,1,7,11,7,9,12,3,9,0,6,8,13,7,13,9,5,2,5,3,16,14,3,2,7,0,11,14,4,12,7,7,13,2,3,7,19,2,0,10,2,2,21,2,18,13,10,17])
        # INJEKCE  4x4 adder   
        IF DEBUG_INJECTION == 1 :
            self.injection(0, [2,6,7,7,3,5,9,8,6,5,1,3,2,6,7,2,8,1,13,4,0,0,4,7,8,9,3,11,5,2,4,4,7,15,17,7,10,13,6,2,14,1,15,3,3,3,7,3,13,14,1,2,4,2,25,16,3,5,26,1,11,20,5,28,19,7,0,4,1,23,2,0,25,2,7,20,11,7,30,27,0,18,29,1,35,0,4,10,0,0,18,16,1,30,10,6,28,37,2,32,31,1,31,29,5,28,19,7,18,33,1,29,15,6,45,34,2,18,46,1,47,35,44,38,23])

        # Evaluate first population 
        self.evaluatePop(popsize)
        # Select first parent
        for i in range(0, popsize):
            if self.popFitness[i] < self.bestFitness:
                self.parent = i
                self.bestFitness = self.popFitness[i]
        print "Init fitness " + str(self.bestFitness)
        IF DEBUG == 1 and 0:
            print "1st EVAL DONE "
            print str(self.parent) + " is now parent with " + str(self.bestFitness) + " fitness value."
        ELSE: pass
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
                if self.parent == i or self.popFitness[i] > self.bestFitness:
                    continue
                if self.popFitness[i] < self.bestFitness:
                    self.bestResultGeneration = gen
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
        if self.elapsed == 0.0: 
            self.evalspersec = 0
        try:
            self.evalspersec = round(generations/self.elapsed * (popsize-1))
        except: 
            self.evalspersec = sys.maxsize

        self.result = []
        for i in range(self.chromLength):
            self.result.append(self.pop[self.parent][i])

        self.resultUsedNodes = self.popFitnessNodes[self.parent] 


        ## SAVE CHROM FOR PYTHON CODE 
        # Done
    #runAscending

    cdef void __mutation(self, int * chromosome, int mut):
        cdef int j, idx, col, rnd
        # Max of mutations.
        for j in range(rand() % mut + 1):
            # Select mutated base. (The gene.)
            idx = rand() % self.chromLength
            col = ((idx/self.nodeIOPorts) / self.rows)
            rnd = chromosome[idx]
            # Mutate NODE
            if idx < self.lastGeneIdx: 
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

    cdef void __del__(self):
        free(<void *> self.functionArity)
        free(<void *> self.dataTrain)
        free(<void *> self.__lBackLen)
        free(<void *> self.lookUpBitTable)
        free(<void *> self.outputBuff)
        for i in range(self.popsize):
            free(<void *>  self.pop[i])
        free(<void *> self.pop)
        for i in range(self.popsize):
            free(<void *>  self.usedNodes[i])
        free(<void *> self.usedNodes)
        for i in range(self.cols):
            free(<void *> self.__lBack[i])
        free(<void *> self.__lBack)
# EOF
