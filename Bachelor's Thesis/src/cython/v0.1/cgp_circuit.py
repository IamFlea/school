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
