#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Libs and modules.
import sys    # System module (standard input, output..)
import random # Pseudorandom generator.
import time   # Time() for seed.
import re     # Regular expressions. Might be usefull?
import array  # C like arrays 

# Spawning errors
class Cgp_error(Exception):
    pass

class Cgp_algorithm:
    ## This function checks if instance variables were set correctly.
    #  If they weren't initiated error will occurs.
    def checkInstanceVariables (self):
        if self.rows            is None: raise Cgp_error("Instance variable rows wasn't initiated!")
        if self.cols            is None: raise Cgp_error("Instance variable cols wasn't initiated!")
        if self.levelBack        is None: raise Cgp_error("Instance variable levelBack wasn't initiated!")
        if self.dataInput       is None: raise Cgp_error("Instance variable dataInput wasn't initiated!")
        if self.dataOutput      is None: raise Cgp_error("Instance variable dataOutput wasn't initiated!")
        if self.graphInputCnt   is None: raise Cgp_error("Instance variable graphInputCnt wasn't initiated!")
        if self.graphOutputCnt  is None: raise Cgp_error("Instance variable graphOutputCnt wasn't initiated!")
        if self.functionSet     is None: raise Cgp_error("Instance variable functionSet wasn't initiated!")
        if self.trainingVectors is None: raise Cgp_error("Instance variable trainingVectors wasn't initiated!")  # Choo Choo
        if self.maxArity        is None: raise Cgp_error("Instance variable maxArity wasn't initiated!")
        if self.functionCnt     is None: raise Cgp_error("Instance variable functionCnt wasn't initiated!")
        if self.maxFitness      is None: raise Cgp_error("Instance variable maxFitness wasn't initiated!")
        if self.dataOutput      is None: raise Cgp_error("Instance variable dataOutput wasn't initiated!")
        if self.arrayTypecode   is None: raise Cgp_error("Instance variable arrayTypecode wasn't initiated!")

    ## Effect. 
    def evolution(self):
        str = ""
        x = self.pop[self.parent]
        for i in xrange( self.__chromLength):
            str += repr(x[i]).rjust(2)
            str += ", "
        print(str)

    ## Printing.
    def printGeneration(self, gen):
        if gen % 1000 == 0:
            if gen == 0:
                print("Generation:", repr(gen).rjust(10),\
                      "Best fitness:", repr(self.bestFitness).rjust(10), "/", self.maxFitness)
            else:
                #print("Generation:", repr(gen).rjust(10), "Best fitness:", repr(self.popFitness[i]).rjust(10), "/", self.maxFitness)
                print("Generation:", repr(gen).rjust(10))
    
    ## Initiate variables.
    def initCGPRun(self):
        self.area        = self.rows * self.cols  # Used nodes in graph
        self.lastFuncIdx = self.area - 1          # -1 becouse of random.int(a,b) is in range <a, b>
        self.parent      = -1                     # Parent in population.
        self.bestFitness = -1                     # Best fitness value
        self.lastGeneIdx = self.area * (self.maxArity + 1) # Last gene index in chromosome
        self.popFitness  = array.array(self.arrayTypecode, [0] * self.popsize)    # Init population fitnesses [0, 0, .. -0]
        self.initLevelBack()                       # Initiate level back lookup tables self.__lBack[] self.__lBackLen[]
        self.initPopulation()                     # Initiate population. self.pop[]
        self.chromLength = len(self.pop[0]) - 1   # -1 because 0 start cnt
        self.functionIOports = self.maxArity + 1


    ## Sets self.__lBack look up table for L param.
    #  @param self  The object pointer.
    def initLevelBack(self):
        self.__lBack    = []# Array of correct values for each column 
                            # [[Col0 correct vals] [col1 correct vals] ..]
        self.__lBackLen = array.array(self.arrayTypecode) 
                            # Count of correct values for each column 
                            # [len(__lBack[0]), len(__lBack[1]) .. ]
        for i in xrange(self.cols):
            minIdx = self.rows*(i - self.levelBack)
            if minIdx < 0: 
                minIdx = 0
            minIdx = minIdx + self.graphInputCnt
            maxIdx = i * self.rows + self.graphInputCnt
            self.__lBackLen.append(self.graphInputCnt + maxIdx - minIdx -1)
            tmp = array.array(self.arrayTypecode)
            # Look-up table - select inputs
            for j in xrange( self.graphInputCnt):
                tmp.append(j)
            # Look-up table - select nodes
            for j in xrange(minIdx, maxIdx):
                tmp.append(j)
            self.__lBack.append(tmp)
        return
    # __initLevelBack()
    
    def __printPop(self):
        for i in xrange( self.popsize):
            print("CHROMOSOME ", i )
            print(self.getChromosome(self.pop[i]))

    ## Sets self.pop look up table for L param. 
    #  @param self
    #      The object pointer.
    def initPopulation(self):
        self.pop = []
        # For everyone in population create his chromosome
        for i in xrange( self.popsize):
            chromosome = array.array(self.arrayTypecode)
            # Creating genes
            for j in xrange( self.area):
                col = int(j/self.rows)
                # Select function inputs (gene inputs)
                for k in xrange( self.maxArity):
                    tmp = self.__lBack[col][random.randint(0,self.__lBackLen[col])]
                    chromosome.append(tmp)
                # Select function (gene operation)   #for k in xrange( self.functionOutputs):
                tmp = random.randint(0, self.functionCnt)
                chromosome.append(tmp)
            # Connecting primary outputs, creating last gene
            for j in xrange( self.graphOutputCnt):
                chromosome.append(random.randint(0, self.area + self.graphInputCnt - 1))
            self.pop.append(chromosome)
    #__initLevelBack(self)


    ## Starts cartesian genetic programming.
    #  @param self    The object pointer.
    #  @param p_gen   How many generations.
    #  @param p_pop   Size of population. Default 5. Optional.
    #  @param p_mut   Max mutated gens during one mutation()
    def run(self, gen, pop, mut):
        # Check instance variables
        self.checkInstanceVariables()
        # Set params of evolution.
        self.generations = gen
        self.popsize     = pop
        self.mutations   = mut
        # Shuffle cards
        random.seed(73541)
        # Setting instance variables.
        self.initCGPRun()
        # injekce... 
        # 3x3 adder

        # 4x4 adder
        #self.dataOutput.reverse()
        #self.pop[0] = array.array(self.arrayTypecode, [2,6,7,7,3,5,9,8,6,5,1,3,2,6,7,2,8,1,13,4,0,0,4,7,8,9,3,11,5,2,4,4,7,15,17,7,10,13,6,2,14,1,15,3,3,3,7,3,13,14,1,2,4,2,25,16,3,5,26,1,11,20,5,28,19,7,0,4,1,23,2,0,25,2,7,20,11,7,30,27,0,18,29,1,35,0,4,10,0,0,18,16,1,30,10,6,28,37,2,32,31,1,31,29,5,28,19,7,18,33,1,29,15,6,45,34,2,18,46,1,47,35,44,38,23])
        #self.pop[0] = array.array(self.arrayTypecode, [6,2,7,5,1,7,1,5,2,3,7,1,6,2,1,9,12,2,6,8,5,10,13,1,0,4,5,11,1,3,8,11,7,5,5,3,11,0,2,8,4,0,0,4,3,22,10,5,15,0,7,9,13,3,18,8,2,4,20,4,24,4,7,16,5,6,11,19,7,4,8,6,28,26,5,9,26,3,26,9,6,32,15,6,8,13,0,23,16,1,34,32,0,35,37,6,3,7,3,28,34,3,28,24,0,7,23,3,33,14,7,17,17,7,30,1,5,31,46,4,39,41,44,18,40])

        # slef.__debugInjection()
        #self.aprintData()
        # Evaluate first population 
        self.evaluatePop()
        # Select first parent
        for i in xrange( self.popsize):
            if self.popFitness[i] > self.bestFitness:
                self.parent = i
                self.bestFitness = self.popFitness[i]
        #print("fitness:", self.popFitness[0])
        #print("parent:", self.parent)
        #exit(1)

        # Start the timer.
        start = time.time()

        # Run evolution.
        for gen in xrange( self.generations): 
            # Nice effect.
            #self.evolution()
            # Printing generation
            #self.printGeneration(gen)

            # Each person in population is mutated.
            for i in xrange( self.popsize):
                if self.parent == i: continue  # Skip parent
                #self.pop[i] = list(self.pop[self.parent])
                self.pop[i] = array.array(self.arrayTypecode, self.pop[self.parent])
                self.__mutation(self.pop[i])
            #self.__printpop()
            # evaluate population
            self.evaluatePop()
            parentt = self.parent # Save parent position
            a = False
            for i in xrange( self.popsize):
                # Skip parent or worse finesses...
                if self.parent == i or self.popFitness[i] < self.bestFitness:
                    continue
                # Found better fitness?
                if self.bestFitness != self.popFitness[i]:
                    #print("Generation:", repr(gen).rjust(10), "Best fitness:", repr(self.popFitness[i]).rjust(10), "/", self.maxFitness)
                    self.bestFitness = self.popFitness[i]
                parentt = i # Use parent with same fitness
            self.parent = parentt # Actualize parent
            #for
        #for
        #print("Generation:", repr(self.generations).rjust(10))
        self.elapsed = time.time() - start
        self.evalspersec = round(self.generations/self.elapsed * (self.popsize-1))
        # Done
    #__run
   





    ## Mutate chromosome
    #  @param self
    #      The object pointer.
    #  @param chromosome
    #      The mutated chromosome.
    """
    def __mutation(self, chromosome):
        mutations = random.randint(1, self.mutations)
        # Max of mutations.
        for j in xrange( mutations):
            # Select mutated base. (The gene.)
            idx = random.randint(0, self.chromLength)
            col = int(int(idx/self.functionIOports) / self.rows)
            rnd = chromosome[idx]
            # Mutate NODE
            if idx < self.lastGeneIdx: # lastBaseIdx - 1
                # Mutate connection
                #if idx % self.node_IO_ports < self.nodeInputPorts:
                tmp = rnd
                a= 0
                if idx % self.functionIOports < self.maxArity:
                    a =1
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
    # __mutation(self, chrom)
    """
    # Should be faster...
    def __mutation(self, chromosome):
        mutations = random.randint(1, self.mutations)
        # Max of mutations.
        for j in xrange( mutations):
            # Select mutated base. (The gene.)
            idx = random.randint(0, self.chromLength)
            col = int(int(idx/self.functionIOports) / self.rows)
            rnd = chromosome[idx]
            # Mutate NODE
            if idx < self.lastGeneIdx: # lastBaseIdx - 1
                # Mutate connection
                #if idx % self.node_IO_ports < self.nodeInputPorts:
                tmp = rnd
                if idx % self.functionIOports < self.maxArity:
                    # Same as: if (col_values[col]->items > 1){ while(1){..} }
                    if self.__lBackLen[col] > 1:
                        rnd = random.randint(0, self.__lBackLen[col])
                        rnd = self.__lBack[col][rnd]
                        #if rnd != chromosome[idx]: break
                    chromosome[idx] = rnd
                    
                # Mutate function
                else:
                    # Same as: if (items > 1){ while(1){..} }
                    if self.functionCnt > 0:
                        rnd = random.randint(0, self.functionCnt)
                        #if rnd != chromosome[idx]: break
                    chromosome[idx] = rnd
            # Mutate output last ,,gene''
            else:
                #while 1:
                rnd = random.randint(0, int(self.lastGeneIdx/self.functionIOports))
                    #if rnd != chromosome[idx]: break
                chromosome[idx] = rnd

    # Not used yet
    def __usedNodes(self, chrom):
        # Init look-up table of 
        cnt = 0
        usedNodes = []
        idx = self.__lastBaseIdx
        for i in xrange( self.inputPorts): usedNodes.append(0)
        for i in xrange( self.area): usedNodes.append(0)
        for i in xrange( self.outputPorts): 
            usedNodes[chrom[idx]] = 1
            idx += 1
        idx = self.__lastBaseIdx - 1
        uidx = len(usedNodes) - 1
        for i in xrange(self.column, 0, -1):
            for j in xrange(self.row, 0, -1):
                if usedNodes[uidx]:
                    f = chrom[idx]
                    idx -= 1 # B idx
                    # Unary operation..
                    if f == 0 or f == 4:   # Using A string.
                        idx -= 1 # A idx. B is not used
                        usedNodes[chrom[idx]] = 1 # saving A
                        cnt += 1 
                    elif f == 8 or f == 9: # Using B
                        usedNodes[chrom[idx]] = 1 # saving B
                        idx -= 1 # Prev node idx. A is not used
                        cnt += 1 
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

    ## Prints chromosome in more readable format.
    #  @param self The object pointer.
    #  @param chrom Chromosome for printing 
    def getChromosome(self, chrom):
        table = self.functionTab
        i = self.graphInputCnt
        result = "Inputs: 0 -" + str(i-1) + '\n'
        for j in xrange( self.rows):
            for k in xrange( self.cols):
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
        for i in xrange(len(chrom)-self.graphOutputCnt, len(chrom)):
            if first: result += ","
            first = 1
            result += repr(chrom[i])
        result += '\n'
        return result
    # getChromosome()
    
    ## Prints fenotype in more readable format.
    #  @param self The object pointer.
    #  @param chrom Chromosome for printing 
    def getFenotype(self, chrom, unused):
        table = self.functionTab
        i = self.graphInputCnt
        idx = self.graphInputCnt
        result = "Inputs: 0 -" + str(i-1) + '\n'
        for j in xrange( self.rows):
            for k in xrange( self.cols):
                if unused[idx] == 1:
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
                        result += "XXXX"
                    result += "] "
                idx += 1 
                i += self.rows
            result+="\n"
            i = self.graphInputCnt + j +1

        result += "Output connected on: "
        first = 0
        for i in xrange(len(chrom)-self.graphOutputCnt, len(chrom)):
            if first: result += ","
            first = 1
            result += repr(chrom[i])
        result += '\n'
        return result

    ## Prints results of genetic programming
    #  @param self
    #      The object pointer.
    def printResults(self):
        print ()
        print ("CGP PARAMS")
        print ("Rows:       ", self.rows)
        print ("Columns:    ", self.cols)
        print ("Inputs:     ", self.graphInputCnt)
        print ("Outputs:    ", self.graphOutputCnt)
        print ("Level back: ", self.levelBack)
        print ("Node inputs: ", self.maxArity)
        print ("Node outputs: 1 DEFAULT") #, self.nodeOutputPorts)
        print ()
        print ("CGP RUN PARAMS")
        print ("Generations: ", self.generations)
        print ("Pop. size:   ", self.popsize)
        print ("Max mutation:", self.mutations)
        print ()
        print ("CGP RESULTS")
        print ("Time elapsed:", self.elapsed, "(" + str(round(self.evalspersec)) + " evals/sec)")
        print ("Best fitness:", self.bestFitness)
        try:
            print ("Used nodes:  ", self.used[self.parent])
        except: 
            pass
        #if self.bestFitness >= self.maxFitness:
            #print ("Used nodes:  ", self.bestNodes)
        print()
        #if self.bestFitness >= self.maxFitness:
        print ("BEST CHROMOSOME:")
        print(self.printBestChromosome())

    def results(self):
        string = "CGP PARAM\n"
        string+="Inputs:       " + str(self.graphInputCnt) + "\n"
        string+="Outputs:      " + str(self.graphOutputCnt) + "\n"
        string+="Rows:         " + str(self.rows) + "\n"
        string+="Columns:      " + str(self.cols) + "\n"
        string+="Node inputs:  " + str(self.maxArity) + "\n"
        string+="Node outputs: 1 (default)\n"
        string+="Level back:   " + str(self.levelBack) + "\n\n"
        string+="CGP RUN PARAMS\n"
        string+="Generations:  " + str(self.generations) + "\n"
        string+="Pop. size:    " + str(self.popsize) + "\n"
        string+="Max mutation: " + str(self.mutations) + "\n\n"
        string+="CGP RESULTS\n"
        string+="Time elapsed: " + str(self.elapsed) + "\n"
        string+="Best fitness: " + str(self.bestFitness) +"/"+str(self.maxFitness) + "\n"
        try:
            if self.maxFitness >= self.bestFitness: 
                string+="Used nodes:   " + str(self.used[self.parent]) + "\n"
        except: 
            pass
        string+="\n"
        string+="BEST CHROMOSOME"
        string+="\n"

        #if self.bestFitness >= self.maxFitness:
        string += self.printBestChromosome()
        return string

    def resultChrom(self):
        result  = "{"
        result += str(self.graphInputCnt) 
        result += ","
        result += str(self.graphOutputCnt) 
        result += ","
        result += str(self.rows) 
        result += ","
        result += str(self.cols) 
        result += ","
        result += str(self.maxArity) 
        result += ","
        result += "1" # DEFAULT
        result += "}"
        start = 1
        idx = 0
        for i in xrange( self.area):
            result += "("
            for i in xrange( self.maxArity + 1):
                result += str(self.pop[self.parent][idx])
                result += ","
                idx+=1
            result = result[:-1]
            result += ")"
        result += "("
        for i in xrange( self.graphOutputCnt):
            result += str(self.pop[self.parent][idx])
            result += ","
            idx+=1
        result = result[:-1]
        result += ")"
        return result

    def printBestChromosome(self):
        return self.getChromosome(self.pop[self.parent])

    ## 5 bit median. 5x5
    def __debug(self):
        f_a = lambda a, b: a
        f_b = lambda a, b: a & b
        f_c = lambda a, b: a | b
        f_d = lambda a, b: a ^ b
        f_e = lambda a, b: 2**5 - a
        self.functionSet = [f_a, f_b, f_c, f_d, f_e]
        self.functionCnt = len(self.functionSet) - 1 
        # Correct solution of 5x5 bit median
        self.rows = 5
        self.cols = 5
        self.levelBack = 1 
        self.dataInput = [0xffff0000, 0xff00ff00, 0xf0f0f0f0, 0xcccccccc, 0xaaaaaaaa]
        self.dataOutput= [0xfee8e880]
        self.graphInputCnt = len(self.dataInput)
        self.graphOutputCnt = len(self.dataOutput)
        self.trainingVectors = 1
        self.maxFitness = ( 1 << self.graphInputCnt ) * self.graphOutputCnt
        self.initCGPRun()
        self.pop[0] = [2,4,1,1,2,2,2,1,1,1,0,1,1,0,2,5,9,1,9,5,2,8,3,2,8,3,1,4,4,1,11,12,0,0,0,3,10,12,2,13,4,2,13,1,2,17,3,1,17,15,1,16,2,1,18,2,2,3,19,0,3,2,1,23,21,1,2,4,3,23,0,1,1,23,3,26]
# end class cgp
# End of file: cgp.py
