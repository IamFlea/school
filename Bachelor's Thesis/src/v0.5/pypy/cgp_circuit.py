from cgp_core import CgpCore
import cgp # F!@#$%^ hack
import dis

import ctypes
import sys
import array
import types 

class CgpCircuit(CgpCore):
    ARRAY_TYPECODE = 'l'

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
        self.bestFitness    = 0
        CgpCircuit.run      = CgpCore.runAscending  # Type of selecting parent. 
       
        self.c = cgp.Cgp() #$%^& hack
        
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
        exec (self.code[i],  None, {"outputBuff" : self.outputBuff})
        #exec (self.code[i])

    # Calculate Fitness
    def evaluatePop(self):
        # Init values of evaluation
        for i in xrange(0, self.popsize):
            if i == self.parent: continue
            self.popFitness[i] = 0 
            ctypes.memset(self.ptrUsedNodes[i], 0, self.bufferUsedNodes)
            self.popUsedNodes[i] = self._usedNodes(self.pop[i], self.usedNodes[i])
            #self.code[i] = self._getByteCodePostfix(self.pop[i], self.usedNodes[i], self.arrByteCodes)
            # Using build-in function: compile()
            #self.code[i] = compile(self.__getCode(self.pop[i], self.usedNodes[i]), "", "exec")
            # Using byte code JIT compilation
            self.code[i] = self.__getByteCode(self.pop[i], self.usedNodes[i], self.arrByteCodes)
        """
        for i in self.dataInput: 
            print(hex(i))
        print()
        for i in self.dataOutput: print(hex(i))
        print()
        for i in self.dataTrain: 
            if i < 0:
                print(hex( 2**63 | (i & (2**63-1))))
            else:
                print(hex((i)))

        print()

        vektor = 0 
        print(self.graphInputCnt)
        print(self.buffOffsetSize)
        #print()
        """
        vektor = self.graphInputCnt
        ptr = self.ptrDataInput
        for j in xrange(0, self.trainingVectors):
            ctypes.memmove(self.ptrOutputBuff, ptr, self.buffOffsetSize)
            ptr += self.buffOffsetSize + self.graphOutputCnt * 8   
            for i in xrange(0, self.popsize):
                if i == self.parent: continue
                self.myExec(i)
                #self.evalFitness(self.pop[i], self.outputBuff, self.usedNodes[i])
                idx = self.lastGeneIdx
                for k in xrange(0, self.graphOutputCnt):
                    # Zero count
                    self.popFitness[i] += self.zeroCount((self.outputBuff[self.pop[i][idx]] | self.bitMax)^ self.dataTrain[k+vektor])
                    idx += 1
            vektor += self.graphOutputCnt + self.graphInputCnt
        for i in xrange(0, self.popsize):
            if i == self.parent or self.popFitness[i] != self.maxFitness:
                continue
            self.popFitness[i] += self.area - self.popUsedNodes[i]


    ## Converts data in more usefull format
    def __convertData(self):
        if sys.maxsize > 2**32:
            architecture = 64
            mask = 2**63 - 1
            bneg = 2**64 >> 1
            tmp =  -2**63
        else:
            architecture = 32
            mask = 2**31 - 1
            bneg = 2**32 >> 1
            tmp =  -2**31
        input  = list(self.dataInput)  # Temp variable
        output = list(self.dataOutput) # Temp variable

        # Init array
        size = self.trainingVectors * (self.graphInputCnt  + self.graphOutputCnt)
        self.dataTrain =  array.array(self.arrayTypecode, [0]*size)

        # Fill up input array
        idx = 0 
        for i in xrange(0, self.trainingVectors):
            for j in xrange(0, self.graphInputCnt):
                if input[j] & bneg: 
                    self.dataTrain[idx] = tmp | ( input[j] & mask )
                else:
                    self.dataTrain[idx] = input[j] & mask
                input[j] = input[j] >> architecture
                idx += 1 

            for j in xrange(0, self.graphOutputCnt):
                if output[j] & bneg: 
                    self.dataTrain[idx] = tmp | ( output[j] & mask )
                else:
                    self.dataTrain[idx] = output[j] & mask
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
        for j in xrange(self.graphInputCnt, self.area+self.graphInputCnt):
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
        # init code consts()
        arr = []
        for i in xrange(0, self.graphInputCnt + self.cols * self.rows):
            arr.append(i)
        self.mask_idx = i + 1
        if sys.maxsize > 2*32:
            arr.append(2**64-1)
        else:
            arr.append(2**32-1)
        self.none_idx = i + 2
        arr.append(None)
        self.co_consts = tuple(arr)
        self.code = [0] * population
        self.arrByteCodes = [0] * population
        # init code names
        self.co_names  = ('outputBuff',)
        # init code ... CODE
        initCode = []
        #                               # PythonBytecode         STACK
        nodeCode = [101, 0, 0,          # LOAD ATTR, outputbuff  [outputbuff]
                    100, 0, 0,          # LOAD CONST, 0          [const, ouputbuff]
                    25,                 # BIN_SUBSCR             [a]
                    101, 0, 0,          # LOAD ATTR, outputbuff  [outputbuff, a]
                    100, 0, 0,          # LOAD CONST, 0          [const, outputbuff, a]
                    25,                 # BIN_SUBSCR             [b, a]
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
        for j in xrange(self.graphInputCnt, self.area+self.graphInputCnt):
            a_idx += 3
            b_idx += 3
            f_idx += 3
            idx += 1
            if 0 == used[j]: # Byl tento uzel pouzitej? 
                continue 
            code[i   ] = 101    # becouse of overwrite
            code[i+1 ] = 0      # becouse of overwrite
            code[i+3 ] = 100    # becouse of overwrite
            code[i+4 ] = chrom[a_idx]
            code[i+11] = chrom[b_idx]
            code[i+14] = self.functionBC1[chrom[f_idx]]
            code[i+15] = self.functionBC2[chrom[f_idx]]
            code[i+20] = j 
            i += 23
        code[i] = 100               # RETURN VALUE
        code[i+1] = self.none_idx   # RETURN VALUE
        code[i+3] = 83              # RETURN VALUE
        #exitCode = [100, self.none_idx, 0,   # LOAD NONE
        return types.CodeType(0, 
                              #0, # Py2  asi smazat..
                              0,  20, 64,
                              code.tostring(), self.co_consts, self.co_names, tuple(),
                              "", "<module>", 1, self.co_lnotab)




    # Simulate circuit
    def evalFitness(self, chrom, out, usedNodes):
        idx = 0 # Index pointer in chromosome
        j = self.graphInputCnt
        # For each node set its output
        for i in xrange(self.graphInputCnt, self.area+self.graphInputCnt):
            if usedNodes[i] == 0: 
                idx += 3 
                j += 1
                continue
            a = out[chrom[idx]]
            idx += 1
            b = out[chrom[idx]]
            idx += 1
            out[j] = self.functionSet[chrom[idx]](self.c, a, b)
            j   += 1
            idx += 1




    def __initLookUp(self):
        global lookUpBitTable 
        lookUpBitTable = array.array(self.arrayTypecode, [0]*256)
        for i in xrange(0, 256):
            cnt = 0
            zi  = 0xffff - i
            for j in xrange(0, 8):
                cnt += zi & 1
                zi = zi >> 1
            lookUpBitTable[i] = cnt

        # Select zeroCount
        if sys.maxsize > 2**32:
            CgpCircuit.zeroCount = CgpCircuit.zeroCount64bit
        else:
            CgpCircuit.zeroCount = CgpCircuit.zeroCount32bit

    def zeroCount32bit(self, val):
        return lookUpBitTable[val & 0xff] + \
               lookUpBitTable[val >>  8 & 0xff] + \
               lookUpBitTable[val >> 16 & 0xff] + \
               lookUpBitTable[val >> 24 & 0xff]

    def zeroCount64bit(self, val):
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
            # LOAD var usedNodes(0)
            code[code_idx] = 101;       code_idx += 1 
            code[code_idx] = 0;         code_idx += 1 
            code[code_idx] = 0;         code_idx += 1 
            # LOAD const nodeidx
            code[code_idx] = 100;       code_idx += 1 
            code[code_idx] = nodeidx;   code_idx += 1 
            code[code_idx] = 0;         code_idx += 1 
            # from usedNodes[nodeIdx] gets result on  TOS
            code[code_idx] = 25;        code_idx += 1 
            return
            #return [101, 0, 0, 100, nodeidx, 0, 25]  # Uloz hajzla
        function = chrom[idx + 2]
        arita = self.functionArity[function]
        # zpracuj a uloz do pole.
        if usedNodes[nodeidx] == 1:
            # IDENTITA load next.
            if function == 0: 
                self.__getBc(chrom, chrom[idx], usedNodes, code)
             
            # dve arity
            elif arita == 2:
                self.__getBc(chrom, chrom[idx],   usedNodes, code)
                self.__getBc(chrom, chrom[idx+1], usedNodes, code)
                code[code_idx] = self.functionBC1[function]; code_idx += 1 
                code[code_idx] = self.functionBC2[function]; code_idx += 1 
            
            elif arita == 1:
                self.__getBc(chrom, chrom[idx],   usedNodes, code)
                code[code_idx] = self.functionBC1[function]; code_idx += 1 

        else: # usedNodes[idx] == 1
            usedNodes[nodeidx] = -1  # SAVE INDEX
            # Identity
            if function == 0:
                self.__getBc(chrom, chrom[idx], usedNodes, code) 
                # DUPLICATE Top of STACK
                code[code_idx] = 4;         code_idx += 1 
                # LOAD usednodes (0)
                code[code_idx] = 101;       code_idx += 1 
                code[code_idx] = 0;         code_idx += 1 
                code[code_idx] = 0;         code_idx += 1 
                # LOAD const (nodeidx)
                code[code_idx] = 100;       code_idx += 1 
                code[code_idx] = nodeidx;   code_idx += 1 
                code[code_idx] = 0;         code_idx += 1 
                # into usednodes[nodeidx] save dup
                code[code_idx] = 60;        code_idx += 1 
            elif arita == 2:
                self.__getBc(chrom, chrom[idx],   usedNodes, code)
                self.__getBc(chrom, chrom[idx+1], usedNodes, code)
                code[code_idx] = self.functionBC1[function]; code_idx += 1 
                code[code_idx] = self.functionBC2[function]; code_idx += 1 
                # DUPLICATE Top of STACK
                code[code_idx] = 4;         code_idx += 1 
                # LOAD usednodes (0)
                code[code_idx] = 101;       code_idx += 1 
                code[code_idx] = 0;         code_idx += 1 
                code[code_idx] = 0;         code_idx += 1 
                # LOAD const (nodeidx)
                code[code_idx] = 100;       code_idx += 1 
                code[code_idx] = nodeidx;   code_idx += 1 
                code[code_idx] = 0;         code_idx += 1 
                # into usednodes[nodeidx] save dup
                code[code_idx] = 60;        code_idx += 1 
            elif arita == 1:
                self.__getBc(chrom, chrom[idx],   usedNodes, code)
                code[code_idx] = self.functionBC1[function]; code_idx += 1 
                # DUPLICATE Top of STACK
                code[code_idx] = 4;         code_idx += 1 
                # LOAD usednodes (0)
                code[code_idx] = 101;       code_idx += 1 
                code[code_idx] = 0;         code_idx += 1 
                code[code_idx] = 0;         code_idx += 1 
                # LOAD const (nodeidx)
                code[code_idx] = 100;       code_idx += 1 
                code[code_idx] = nodeidx;   code_idx += 1 
                code[code_idx] = 0;         code_idx += 1 
                # into usednodes[nodeidx] save dup
                code[code_idx] = 60;        code_idx += 1 
                                                                              
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
        for i in xrange(self.graphOutputCnt):
            if usedNodes[chrom[idx]] == -1: 
                idx +=1
                continue
            self.__getBc(chrom, chrom[idx], usedNodes, code)
            # STACK = [result]                  LOAD ouputBuff
            code[code_idx] = 101; code_idx+=1
            code[code_idx] = 0;   code_idx+=1
            code[code_idx] = 0;   code_idx+=1
            # STACK = [result, outputBuff]      LOAD const 
            code[code_idx] = 100; code_idx+=1
            code[code_idx] = chrom[idx]; code_idx+=1
            code[code_idx] = 0;   code_idx+=1
            #STACK = [result, outputBuff, const] STORE result in outputbuff[const]
            code[code_idx] = 60;  code_idx+=1
            idx+=1
        ### 
        # RETURN of exec
        # Load None
        code[code_idx] = 100; code_idx +=1
        code[code_idx] = self.none_idx; code_idx +=1
        code[code_idx] = 0;   code_idx +=1
        #STACK = [None]                      RETURN None
        code[code_idx] = 83;  code_idx +=1
        return  types.CodeType(0, 
                              #0, # Py2  asi smazat..
                              0,  self.stacksize, 64,
                              code.tostring(), self.co_consts, self.co_names, tuple(),
                              "", "<module>", 1, self.co_lnotab)
        #dis.dis(c)

# My represenattion of integer ... it rocks
"""
print("BUFF")
c = 0
for i in self.outputBuff: 
    if i < 0:
        print(hex( 2**63 | (i & (2**63-1))))
    else:
        print(hex((i)))
    c+=1
    if c == self.graphInputCnt: break
c = 0
print("NEED")
for iojkakavfaf  in xrange(self.graphOutputCnt):
    i = self.dataTrain[c+vektor]
    if i < 0:
        print(hex( 2**63 | (i & (2**63-1))))
    else:
        print(hex((i)))
    c += 1
    if c == self.graphOutputCnt: break
print()
"""
