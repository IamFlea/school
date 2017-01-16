import re

def parse(filename):
    f = open(filename, 'r')
    sen = {}
    for line in f:
        if line.find("evals/sec") != -1:
            evals = ((line.split(" ")[-2]).split(".")[0])
            if   line.find("adder 3+3") != -1: sen["ADD    3+3"] = evals
            elif line.find("adder 4+4") != -1: sen["ADD    4+4"] = evals
            elif line.find("adder 5+5") != -1: sen["ADD    5+5"] = evals
            elif line.find("adder 6+6") != -1: sen["ADD    6+6"] = evals
            elif line.find("mult 4x4")  != -1: sen["MUL    4x4"] = evals
            elif line.find("mult 5x5")  != -1: sen["MUL    5x5"] = evals
            elif line.find("mult 6x6")  != -1: sen["MUL    6x6"] = evals
            elif line.find("parity 9")  != -1: sen["PARITY   9"] = evals
            elif line.find(" 5 trains") != -1: sen["  5 TRAINS"] = evals
            elif line.find("10 trains") != -1: sen[" 10 TRAINS"] = evals
            elif line.find("25 trains") != -1: sen[" 25 TRAINS"] = evals
            elif line.find("50 trains") != -1: sen[" 50 TRAINS"] = evals
            elif line.find("100 trains")!= -1: sen["100 TRAINS"] = evals
            elif line.find("200 trains")!= -1: sen["200 TRAINS"] = evals
            elif line.find("500 trains")!= -1: sen["500 TRAINS"] = evals
            elif line.find("logx")      != -1: sen["LOGX      "] = evals
            elif line.find("cosx")      != -1: sen["COSX      "] = evals
            elif line.find("sinx")      != -1: sen["SINX      "] = evals
            elif line.find("xxyz")      != -1: sen["XXYZ      "] = evals
            else: raise
    f.close()
    return sen

def parse2(filename):
    f = open(filename, 'r')
    sen = {} # california dreaming
    sen["  5 TRAINS"] = "-"
    sen[" 10 TRAINS"] = "-"
    sen[" 25 TRAINS"] = "-"
    sen[" 50 TRAINS"] = "-"
    sen["100 TRAINS"] = "-"
    sen["200 TRAINS"] = "-"
    sen["500 TRAINS"] = "-"
    sen["LOGX      "] = "-"
    sen["COSX      "] = "-"
    sen["SINX      "] = "-"
    sen["XXYZ      "] = "-"
    string = ""
    for line in f:
        if   line.find("adder3_3") != -1: string = "ADD    3+3"
        elif line.find("adder4_4") != -1: string = "ADD    4+4"
        elif line.find("adder5_5") != -1: string = "ADD    5+5"
        elif line.find("adder6_6") != -1: string = "ADD    6+6"
        elif line.find("multiplier4x4")  != -1: string = "MUL    4x4"
        elif line.find("multiplier5x5")  != -1: string = "MUL    5x5"
        elif line.find("multiplier6x6")  != -1: string = "MUL    6x6"
        elif line.find("parity9")  != -1: string = "PARITY   9"
        elif line.find("evals/sec") != -1:
            try:
                evals = ((line.split(" ")[0]).split(".")[0]).split("(")[1]
            except(IndexError):
                evals = ((line.split(" ")[0]).split(".")[0])
            sen[string] = evals

        else: print(line)
    f.close()
    return sen
r1py2 = parse("./v0.1/py2/results")
r1py3 = parse("./v0.1/py3/results")
r1pypy= parse("./v0.1/pypy/results")
r2py3 =parse2("./v0.2/py3/results")
r2py2 =parse2("./v0.2/py2/results")
r2pypy=parse2("./v0.2/pypy/results")
r3py2 = parse("./v0.3/py2/results")
r3py3 = parse("./v0.3/py3/results")
r3pypy= parse("./v0.3/pypy/results")
r4py2 = parse("./v0.4/py2/results")
r4py3 = parse("./v0.4/py3/results")
r4pypy= parse("./v0.4/pypy/results")
r5py2 = parse("./v0.5/py2/results")
r5py3 = parse("./v0.5/py3/results")
r5pypy= parse("./v0.5/pypy/results")
r6py2 = parse("./v0.6/py2/results")
r6py3 = parse("./v0.6/py3/results")
r6pypy= parse("./v0.6/pypy/results")

c1    = parse("./cython/v0.1/results")
c2    = parse("./cython/v0.2/results")
c3    = parse("./cython/v0.3/results")
a = ["ADD    3+3", "ADD    4+4", "ADD    5+5", "ADD    6+6", "MUL    4x4", "MUL    5x5", "MUL    6x6", "PARITY   9", "  5 TRAINS", " 10 TRAINS", " 25 TRAINS", " 50 TRAINS", "100 TRAINS", "200 TRAINS", "500 TRAINS", "LOGX      ", "COSX      ", "SINX      ", "XXYZ      "]

print(" ".rjust(10),
      "|",
      "Python2".rjust(8*6+5),
      "|",
      "Python3".rjust(8*6+5),
      "|",
      "PyPy".rjust(8*6+5),
      "|",
      "Cython".rjust(8*3+2)
     )

print("PROBLEM".rjust(10),
      "|",
      "bez eval".rjust(8),
      "paralel".rjust(8),
      "eval()".rjust(8),
      "JITv1".rjust(8),
      "JITv2".rjust(8),
      "JITv3".rjust(8),
      "|",
      "bez eval".rjust(8),
      "paralel".rjust(8),
      "eval()".rjust(8),
      "JITv1".rjust(8),
      "JITv2".rjust(8),
      "JITv3".rjust(8),
      "|",
      "bez eval".rjust(8),
      "paralel".rjust(8),
      "eval()".rjust(8),
      "JITv1".rjust(8),
      "JITv2".rjust(8),
      "JITv3".rjust(8),
      "|", 
      "Python".rjust(8),
      "static".rjust(8),
      "loops".rjust(8)
     )

for i in a: 
    print(i.rjust(10),"|", 
          r1py2[i].rjust(8), 
          r2py2[i].rjust(8), 
          r3py2[i].rjust(8), 
          r4py2[i].rjust(8), 
          r5py2[i].rjust(8), 
          r6py2[i].rjust(8), 
          "|", 
          r1py3[i].rjust(8), 
          r2py3[i].rjust(8), 
          r3py3[i].rjust(8), 
          r4py3[i].rjust(8), 
          r5py3[i].rjust(8), 
          r6py3[i].rjust(8), 
          "|", 
          r1pypy[i].rjust(8), 
          r2pypy[i].rjust(8), 
          r3pypy[i].rjust(8), 
          r4pypy[i].rjust(8), 
          r5pypy[i].rjust(8), 
          r6pypy[i].rjust(8),
          "|",
          c1[i].rjust(8),
          c2[i].rjust(8),
          c3[i].rjust(8)
         )
print()
