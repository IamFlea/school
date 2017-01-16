DEF DEBUG = 0
DEF DEBUG_SEED = 0
#DEF DEBUG_SEED = 73541
DEF DEBUG_INJECTION  = 0
DEF SYS_ARCHITECTURE = 64
DEF INFINITY = float("inf")

IF SYS_ARCHITECTURE == 32:
    DEF SYS_BYTES = 4
    DEF SYS_MASK  = 2**32 - 1 
ELIF SYS_ARCHITECTURE == 64:
    DEF SYS_BYTES = 8
    DEF SYS_MASK  = 2**64 - 1
ELSE:
    pass

cdef extern from "string.h":
    void* memcpy(void* a, void* b, int c)
    void* memset(void* a, int b, int c)
cdef extern from "stdlib.h":
    void * malloc(int a)
    int rand()
    void srand(int a)

cdef extern from "math.h":
    float sin(float a)

# Libs and modules.
import sys    # System module (standard input, output..)
import random # Pseudorandom generator.
import time   # Time() for seed.
import re     # Regular expressions. Might be usefull?
import array  # C like arrays 
import ctypes # memmove

cdef class CgpEquation:
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
    cdef float* dataTrain
     
    cdef int ** pop 
    cdef int lastGeneIdx
    cdef int chromLength
    cdef int chromSize

    
    cdef int ** __lBack 
    cdef int *  __lBackLen
    

    # OUTPUT DATA
    cdef readonly unsigned long elapsed 
    cdef readonly unsigned long evalspersec
    cdef int parent

    cdef float * popFitness
    cdef int * popFitnessNodes
    cdef int ** usedNodes
    cdef int usedNodesLen
    cdef int usedNodesSize
    cdef int * lookUpBitTable
    cdef readonly float   bestFitness
    cdef readonly float   maxFitness

    cdef float * outputBuff
    cdef int outputBuffSize

    cdef public   object result 



    def __init__(self, cols, rows, levelBack, dataInput, dataOutput, functions):
        cdef int i 
        IF DEBUG == 1 and 0 :
            print
            print "Hello, Forest!"
            print "I am CGP. I have just spawned here!"
            print 
            print "Graph: " + str(cols) + " x " + str(rows) + " (" + str(levelBack) + ")"
            print "Data Input: "
            for dato in dataInput:
                print(dato)
            print "Data Output: "
            for dato in dataOutput:
                print(dato)
            print
        ELSE:
            pass
        self.cols = cols
        self.rows = rows
        self.area = cols * rows
        self.levelBack = levelBack
        
        self.__convertData(dataInput, dataOutput)

        IF DEBUG == 1 and 0:
            cdef float * ptr = <float *> self.dataTrain
            for i in range(0, self.trainVectors *(self.graphInputCnt + self.graphOutputCnt)):
                print(ptr[0])
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
        cdef float * idx
        
        self.graphInputCnt  = len(input)
        self.graphOutputCnt = len(output)
        self.trainVectors = len(input[0])

        # Init array
        size = self.trainVectors * (self.graphInputCnt  + self.graphOutputCnt)
        self.dataTrain = <float *> malloc(sizeof(float) * size)

        # Fill up input array
        idx = <float *> self.dataTrain
        for i in range(0, self.trainVectors):
            for j in range(0, self.graphInputCnt):
                idx[0] = input[j][i]
                idx += 1
            for j in range(0, self.graphOutputCnt):
                idx[0] = output[j][i]
                idx += 1

    ## Inits population, lback arryas need ot be defined. 
    cdef void _initPopulation(self, int pop):
        cdef int i, j, k, col, idx
        cdef int * chromosome 
        cdef int * usedNodes
        idx = 0
        self.pop = <int **> malloc(sizeof(int *) * pop)
        self.chromLength = -1  

        self.popFitness      = <float *> malloc(sizeof(int) * pop) 
        self.popFitnessNodes = <int *> malloc(sizeof(int) * pop) 
        self.usedNodes       = <int **> malloc(sizeof(int *) * pop) 
        self.usedNodesLen    = self.area + self.graphInputCnt
        self.usedNodesSize   = sizeof(int)*self.usedNodesLen

        self.outputBuff      = <float *> malloc(sizeof(float) * (self.area + self.graphInputCnt))
        self.outputBuffSize  = sizeof(float)*(self.area + self.graphInputCnt)
        
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
            for j in range(0, self.graphOutputCnt):
                chromosome[idx] = rand() %(self.area + self.graphInputCnt)
                idx += 1 
            self.pop[i] = chromosome
            self.popFitness[i] = 0
            self.popFitnessNodes[i] = 0
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


    cdef void evalFitness(self, int* chrom, float* out, int* usedNodes):
        cdef int   j, i
        cdef int * idx = chrom
        cdef float a, b
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
            if   o == 0: out[j] = 0.25
            elif o == 1: out[j] = 0.5
            elif o == 2: out[j] = 1.0
            elif o == 3: out[j] = a 
            elif o == 4: out[j] = a + b
            elif o == 5: out[j] = a - b
            elif o == 6: out[j] = a * b
            elif o == 7: 
                if b == 0.0: out[j] = 1e10; 
                else:        out[j] = a / b
            elif o == 8: out[j] = sin(a)
            #out[j] = self.functionSet[idx[0]](a, b)
            j   += 1
            idx += 1

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
                idx -= 3
            uidx -= 1
        return cnt
        
    #__initLevelBack(self)
    cdef void evaluatePop(self, int popsize):
        cdef int i, j, k, idx
        cdef float * ptr 
        cdef float mame, chceme
        # Init values of evaluation
        for i in range(popsize):
            if i == self.parent: continue
            self.popFitness[i] = 0 
            memset(self.usedNodes[i], 0, self.usedNodesSize)
            self.popFitnessNodes[i] = self._usedNodes(self.pop[i], self.usedNodes[i])
        
        ptr = <float *> self.dataTrain
        for j in range(self.trainVectors):
            memcpy(<void *> self.outputBuff, ptr, self.graphInputCnt*sizeof(float))
            for i in range(self.graphInputCnt):
                #print hex(ptr[0])
                ptr += 1
            #ptr += self.outputBuffSize + self.graphOutputCnt * 8   
            for i in range(0, popsize):
                if i == self.parent: continue
                #self.myExec(i)
                self.evalFitness(self.pop[i], self.outputBuff, self.usedNodes[i])
                idx = self.lastGeneIdx
                for k in range(0, self.graphOutputCnt):
                    mame = self.outputBuff[self.pop[i][idx]]
                    chceme = ptr[k]
                    if mame >= chceme:
                        self.popFitness[i] += mame - chceme
                    else:
                        self.popFitness[i] += chceme - mame
                    idx += 1
            ptr += self.graphOutputCnt
        for i in range(0, popsize):
            if i == self.parent or self.popFitness[i] != self.maxFitness:
                continue
            self.popFitness[i] += self.area - self.popFitnessNodes[i]


    cdef void run_desc(self, int generations, int popsize, int mut, float acc):
        cdef unsigned long start
        cdef unsigned int i 
        cdef unsigned long j
        cdef int gen, newparent
        # Shuffle cards
        IF DEBUG_SEED > 0:
            srand(DEBUG_SEED)
        ELSE:
            srand(time.time())
        # Setting instance variables.
        self.parent      = -1                     # Parent in population.
        self.bestFitness = float("inf")
        self.maxFitness  = 0
        self._initLBack()
        self._initPopulation(popsize)                     # Initiate population. self.pop[]
        IF DEBUG == 1 and 0:
            strs = "" 
            for j in range(self.chromLength):
                strs += str(self.pop[0][j]) + " "
            print strs
            print "POP INITED"
        ELSE:
            pass
        # INJEKCE  4x4 adder   
        IF DEBUG_INJECTION == 1 :
            self.injection(0, [0,0,7,1,0,4,1,0,8,2,0,7,4,3,5,5,5,4,2,3,8,6,2,8,8,4,7,2,4,5,7,9,0,9,8,6,12,10,6,13,13,4,10,0,2,13])

        # Evaluate first population 
        self.evaluatePop(popsize)
        IF DEBUG == 1:
            print self.bestFitness
        ELSE:
            pass
        # Select first parent
        for i in range(0, popsize):
            if self.popFitness[i] < self.bestFitness:
                self.parent = i
                self.bestFitness = self.popFitness[i] - acc
                if self.bestFitness < 0.0: self.bestFitness = 0.0
        #print "1st EVAL DONE " + str(self.parent) + " is now parent with " + str(self.bestFitness) + " fitness value."
        print "Init fitness " + str(self.bestFitness)
        # Start the timer.
        start = time.time()
        # Run evolution.
        a =0
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
                    self.bestFitness = self.popFitness[i] - acc 
                    if self.bestFitness < 0.0: self.bestFitness = 0.0
                    # TODO IFDEF
                    print("Generation: "+ repr(str(gen)).rjust(10) +" Fitness: "+ repr(str(self.bestFitness)).rjust(10) +" / "+ str(self.maxFitness))
                # Found better fitness?
                newparent = i # Use parent with same fitness
            self.parent = newparent # Actualize parent
            a +=1
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
        pass
# EOF
