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
        self.bestFitness    = float("inf")
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
        exec (self.code[i],  None, {"outputBuff" : self.outputBuff})
        #exec (self.code[i])

    
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
            self.code[i] = self._getByteCodePostfix(self.pop[i], self.usedNodes[i], self.arrByteCodes)
        vektor = self.graphInputCnt
        ptr = self.ptrDataInput
        for j in range(0, self.trainingVectors):
            ctypes.memmove(self.ptrOutputBuff, ptr, self.buffOffsetSize)
            ptr += self.buffOffsetSize + self.graphOutputCnt * 4
            for i in range(0, self.popsize):
                if i == self.parent: continue

                try:
                    #self.__evalFitness(self.pop[i], self.outputBuff, self.usedNodes[i])
                    self.__myExec(i)
                except (ZeroDivisionError, ValueError):
                    self.popFitness[i] = 10.0**10.0
                    continue

                idx = self.lastGeneIdx
                for k in range(0, self.graphOutputCnt):
                    if self.outputBuff[self.pop[i][idx]] >= self.dataTrain[k + vektor]:
                        self.popFitness[i] += self.outputBuff[self.pop[i][idx]] - self.dataTrain[k + vektor]
                    else:
                        self.popFitness[i] += self.dataTrain[k+vektor] - self.outputBuff[self.pop[i][idx]] 
                    idx += 1
            vektor += self.graphOutputCnt + self.graphInputCnt
    

    ## Converts data in more usefull format
    def __convertData(self):
        # Init array
        input = self.dataInput
        output = self.dataOutput
        size = self.trainingVectors * (self.graphInputCnt + self.graphOutputCnt)
        self.dataTrain =  array.array(self.arrayTypecode, [0]*size)
        
        # Fill up input array
        idx = 0 
        for i in range(0, self.trainingVectors):
            for j in range(0, self.graphInputCnt):
                self.dataTrain[idx] = input[j][i]
                idx += 1 

            for j in range(0, self.graphOutputCnt):
                self.dataTrain[idx] = output[j][i]
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
        self.functionBC4[0] = i+5
        self.functionBC4[1] = i+4
        self.functionBC4[2] = i+3

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
        self.functionIdx = array.array('L', [0]*(self.functionCnt+1))
        if self.functionCnt == 8: 
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
            if function == 3: # Identity
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
                code[code_idx] = 101
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
            if function == 3:
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
                code[code_idx] = 101
                code_idx += 1 
                code[code_idx] = self.functionIdx[function]
                code_idx += 1 
                code[code_idx] = 0
                code_idx += 1 
                
                self.__getBc(chrom, chrom[idx], usedNodes, code)

                code[code_idx] = 131
                code_idx += 1 
                code[code_idx] = 1
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
        #print(self.showChrom(chrom))
        #print()
        #print("PREVOD CHROMOSOMU DO POSTFIXOVE NOTACE:")
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

