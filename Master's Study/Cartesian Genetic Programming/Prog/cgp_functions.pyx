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
cpdef float sin_ (float a, float b):
    #if a == float("inf") or a == float("-inf"): return 1e10
    return sin(a)
cpdef float _0_25 (float a, float b):
    return 0.25
cpdef float _0_50 (float a, float b):
    return 0.50
cpdef float _1_00 (float a, float b):
    return 1.00


# CLASSIFICATION FUNCTIONS
cpdef float C_1_24 (float a, float b, float c):
    return 1.24
cpdef float C_2_71 (float a, float b, float c):
    return 2.71
cpdef float C_3_14 (float a, float b, float c):
    return 3.14
cpdef float C_add (float a, float b, float c):
    return a+b
cpdef float C_sub (float a, float b, float c):
    return a-b
cpdef float C_mul (float a, float b, float c):
    return a*b
cpdef float C_div (float a, float b, float c):
    if b == 0.0: return 1e10
    else:        return a/b
cpdef float C_neg   (float a, float b, float c):
    return -a

cpdef float C_if    (float a, float b, float c):
    if 1 if a >= 0.0 else 0: return b
    else: return c
cpdef float C_iflez (float a, float b, float c):
    if a <= 0.0: return b
    else: return c
# Good luck in decoding this functions.
# Hint: using ternarz operators..
cpdef float C_lt    (float a, float b, float c):
    return 1.0 if a < b  else -1.0
cpdef float C_lte   (float a, float b, float c):
    return 1.0 if a <= b  else -1.0
cpdef float C_gt    (float a, float b, float c):
    return 1.0 if a >  b  else -1.0
cpdef float C_gte   (float a, float b, float c):
    return 1.0 if a >=  b  else -1.0
cpdef float C_eq    (float a, float b, float c):
    return 1.0 if a ==  b  else -1.0
cpdef float C_and   (float a, float b, float c):
    return 1.0 if (    (1 if a >= 0.0 else 0) and(1 if b >= 0.0 else 0)) else -1.0
cpdef float C_or    (float a, float b, float c):
    return 1.0 if (    (1 if a >= 0.0 else 0) or (1 if b >= 0.0 else 0)) else -1.0
cpdef float C_not   (float a, float b, float c):
    return 1.0 if (not (1 if a >= 0.0 else 0))                        else -1.0
cpdef float C_nand  (float a, float b, float c):
    return 1.0 if (not((1 if a >= 0.0 else 0) and(1 if b >= 0.0 else 0)))else -1.0
cpdef float C_nor   (float a, float b, float c):
    return 1.0 if (not((1 if a >= 0.0 else 0) or (1 if b >= 0.0 else 0)))else -1.0


"""
cpdef float C_lt    (float a, float b, float c):
    return b2f(f2b(a) <  f2b(b))
cpdef float C_lte   (float a, float b, float c):
    return b2f(f2b(a) <= f2b(b))
cpdef float C_gt    (float a, float b, float c):
    return b2f(f2b(a) >  f2b(b))
cpdef float C_gte   (float a, float b, float c):
    return b2f(f2b(a) >= f2b(b))
cpdef float C_eq    (float a, float b, float c):
    return b2f(f2b(a) == f2b(b))
cpdef float C_and   (float a, float b, float c):
    return b2f(f2b(a) and f2b(b))
cpdef float C_or    (float a, float b, float c):
    return b2f(f2b(a) or f2b(b))
cpdef float C_not   (float a, float b, float c):
    return b2f(not f2b(b))
cpdef float C_nand  (float a, float b, float c):
    return b2f(not(f2b(a) and f2b(b)))
cpdef float C_nor   (float a, float b, float c):
    return b2f(not(f2b(a) or f2b(b)))
"""

class CgpFunctions:
    """This object contains function informations.
CIRCUIT
    allLogicalOperations = {id, and, or, xor, not, nand, nor, nxor}
    booleanAlgebra = {id, and, or, not}
    reedMuller = {id, or, xor, not}
    moje = {id, or, xor, and}
    nandOnly = {id, nand}
SYMBOLIC REGRESSION
    symbolicRegression = {0.25, 0.50, 1.00, id, add, sub, mul, div}
    symbolicRegressionWithSin = {0.25, 0.50, 1.00, id, add, sub, mul, div, sin}
CLASSIFICATION
    classification = {id, add, sub, mul, div, lt, lte, gt, gte, eq, and, or, not, nor, nand, neg, if, iflez, 1.24, 2.71, 3.14}
"""
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
"""
    # Ne
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

    def classification(self):
        self.type  = EQUATION
        self.set   = [C_1_24, C_2_71, C_3_14, C_add, C_sub, C_mul, C_div, C_neg, C_if, C_iflez, C_lt, C_lte, C_gt, C_gte, C_eq, C_and, C_or, C_not, C_nand, C_nor]
        self.table = ["1_24", "2_71", "3_14", "add", "sub", "mul", "div", "neg", "if", "iflez", "lt", "lte", "gt", "gte", "eq", "and", "or", "not", "nand", "nor"]
        self.arity = [0,      0,      0,      2,     2,     2,     2,     1,     3,    3,       2,    2,     2,    2,     2,    2,     2,    1,     2,      2    ]
        self.str   = self.table
        self.op    = self.str
        self.inputs= 3
"""
