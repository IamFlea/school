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

cdef class CgpClassification (CgpEquation):
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
                idx -= 1                  # idx is on C
                if self.functionArity[f] == 0:
                    idx -= 1  # idx is on B 
                    idx -= 1  # idx is on A
                elif self.functionArity[f] == 1: # Using A port
                    idx -= 1  # idx is on B
                    idx -= 1  # idx is on A
                    usedNodes[chrom[idx]] += 1 # saving A
                elif self.functionArity[f] == 2:
                    idx -= 1  # idx is on B
                    usedNodes[chrom[idx]] += 1 # saving B
                    idx -= 1  # idx is on A
                    usedNodes[chrom[idx]] += 1 # saving A
                elif self.functionArity[f] == 3:
                    usedNodes[chrom[idx]] += 1 # saving C
                    idx -= 1 # idx is on B
                    usedNodes[chrom[idx]] += 1 # saving B
                    idx -= 1 # idx is on A
                    usedNodes[chrom[idx]] += 1 # saving A

                cnt += 1
                idx -= 1 # a
            else:
                idx -= self.nodeIOPorts
            uidx -= 1
        return cnt

    cdef void evalFitness(self, int* chrom, float* out, int* usedNodes):
        cdef int   j, i
        cdef int * idx = chrom
        cdef float a, b, c
        j = self.graphInputCnt
        # For each node set its output
        for i in range(self.graphInputCnt, self.area+self.graphInputCnt):
            if usedNodes[i] == 0: 
                idx += self.nodeIOPorts
                j += 1
                continue
            a = out[idx[0]]
            idx += 1
            b = out[idx[0]]
            idx += 1
            c = out[idx[0]]
            idx += 1
            """
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
            """
            out[j] = self.functionSet[idx[0]](a, b, c)
            j   += 1
            idx += 1

    cdef void printme(self, int* chrom):
        a = []
        j = 0
        k = 0
        for i in range(self.chromLength):
            if j == 0:
                gen = []
            gen.append(chrom[i])
            j += 1
            if j == self.nodeIOPorts and k < self.area:
                a.append(gen)
                j = 0
                k+=1
        a.append(gen)
        print a
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
                    mame = 1.0 if self.outputBuff[self.pop[i][idx]] >= 0.0 else -1.0
                    chceme = ptr[k]
                    #print str(mame) + "/" + str(chceme)
                    if mame >= chceme:
                        self.popFitness[i] += mame - chceme
                    else:
                        #print str(chceme-mame)
                        self.popFitness[i] += chceme - mame
                    idx += 1
            ptr += self.graphOutputCnt
        for i in range(0, popsize):
            if i == self.parent or self.popFitness[i] != self.maxFitness:
                continue
            self.popFitness[i] += self.area - self.popFitnessNodes[i]

