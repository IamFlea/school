DEF CIRCUIT  = 1
DEF EQUATION = 2


cdef extern from "math.h":
    float sin(float a)

cpdef long id (long a, long b):
    return a
cpdef long and_ (long a, long b):
    return a & b
cpdef long or_ (long a, long b):
    return a | b
cpdef long xor (long a, long b):
    return a ^ b
cpdef long not_ (long a, long b):
    return ~a
cpdef long nand (long a, long b):
    return ~(a & b)
cpdef long nor (long a, long b):
    return ~(a | b)
cpdef long nxor (long a, long b):
    return ~(a ^ b)

cpdef float id_ (float a, float b):
    return a 
cpdef float add (float a, float b):
    return a + b
cpdef float sub (float a, float b):
    return a - b
cpdef float mul (float a, float b):
    return a * b
cpdef float div (float a, float b):
    if b == 0.0: return  1e10
    else: return a / b
cpdef float sin_(float a, float b):
    #if a == float("inf") or a == float("-inf"): return 1e10
    return sin(a)
cpdef float _0_25 (float a, float b):
    return 0.25
cpdef float _0_50 (float a, float b):
    return 0.50
cpdef float _1_00 (float a, float b):
    return 1.00



class CgpFunctions:
    def __init__(self):
        self.inputs  = 2
        self.outputs = 1
        self.type  = None
        self.set   = None
        self.table = None
        self.op    = None
        self.arity = None
        self.str   = None

    def allLogicalOperations(self):
        self.type  = CIRCUIT
        self.set   = [id,      and_,    or_,     xor,      not_,    nand,       nor,        nxor]
        self.table = ["BUFa",  "AND ",  "OR  ",  "XOR ",   "NOTa",  "NAND",     "NOR ",     " NXOR"]
        self.arity = [1,       2,       2,       2,        1,       2,          2,          2]
        self.str   = ["a",     "a & b", "a | b", "a ^ b",  "~a",    "~(a & b)", "~(a | b)", "~(a ^ b)"]
        self.op    = self.table

    def booleanAlgebra(self):
        self.type  = CIRCUIT
        self.set   = [id,      and_,    or_,     not_]
        self.table = ["BUFa",  "AND ",  "OR  ",  "NOTa"]
        self.arity = [1,       2,       2,       1]
        self.str   = ["a",     "a & b", "a | b", "~a"]
        self.op    = self.table

    def reedMuller(self):
        self.type  = CIRCUIT
        self.set   = [id,      or_,     xor,      not_]
        self.table = ["BUFa",  "OR  ",  "XOR ",   "NOTa"]
        self.arity = [1,       2,       2,        1]
        self.str   = ["a",     "a | b", "a ^ b",  "~a"]
        self.op    = self.table

    def moje(self):
        self.type  = CIRCUIT
        self.set   = [id,      or_,     xor,      and_]
        self.table = ["BUFa",  "OR  ",  "XOR ",   "AND "]
        self.arity = [1,       2,       2,        2]
        self.str   = ["a",     "a | b", "a ^ b",  "a & b"]
        self.op    = self.table


    def nandOnly(self):
        self.table = CIRCUIT
        self.set   = [id,      nand]
        self.table = ["BUFa",  "NAND"]
        self.arity = [1,       2]
        self.str   = ["",      "~(a & b)"]
        self.op    = self.table



    def symbolicRegression(self):
        self.type  = EQUATION
        self.set   = [_0_25,  _0_50,  _1_00,  id_,     add,    sub,    mul,    div]
        self.table = ["0.25", "0.50", "1.00", " ID ", " ADD", " SUB", " MUL", " DIV"]
        self.op    = ["0.25", "0.50", "1.00", "",     "+",    "-",    "*",    "/"]
        self.arity = [0,      0,      0,      1,      2,      2,      2,      2]
        self.str   = ["0.25", "0.50", "1.00", "a",    "a+b",  "a-b",  "a*b",  "a/b"]
    
    def symbolicRegressionWithSin(self):
        self.type  = EQUATION
        self.set   = [_0_25,  _0_50,  _1_00,  id_,     add,    sub,    mul,    div,    sin_]
        self.table = ["0.25", "0.50", "1.00", " ID ", " ADD", " SUB", " MUL", " DIV", "SIN "]
        self.op    = ["0.25", "0.50", "1.00", "",     "+",    "-",    "*",    "/",    "sin"]
        self.arity = [0,      0,      0,      1,      2,      2,      2,      2,      1]
        self.str   = ["0.25", "0.50", "1.00", "a",    "a+b",  "a-b",  "a*b",  "a/b",  "sin(a)"]
