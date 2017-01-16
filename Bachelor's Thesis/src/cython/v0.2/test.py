from cgp import Cgp

row   = 1
col   = 40
lback = 40
pop   = 5
mut   = 3
acc   = 0.01
gen = 500000

if 1:
    print("Test: 1")
    print("Benchmark Obvodu")

    cgp = Cgp(row, col, lback)
    cgp.file("../../data/adder3_3.txt")
    cgp.run(gen, pop, mut, acc)
    print("adder 3+3   (64)", cgp.evalspersec, "evals/sec")

    cgp = Cgp(row, col, lback)
    cgp.file("../../data/adder4_4.txt")
    cgp.run(gen, pop, mut, acc)
    print("adder 4+4  (256)", cgp.evalspersec, "evals/sec")
    cgp = Cgp(row, col, lback)
    cgp.file("../../data/adder5_5.txt")
    cgp.run(gen, pop, mut, acc)
    print("adder 5+5 (1024)", cgp.evalspersec, "evals/sec")

    cgp = Cgp(row, col, lback)
    cgp.file("../../data/adder6_6.txt")
    cgp.run(gen, pop, mut, acc)
    print("adder 6+6 (4096)", cgp.evalspersec, "evals/sec")

    cgp = Cgp(row, col, lback)
    cgp.file("../../data/multiplier4x4.txt")
    cgp.run(gen, pop, mut, acc)
    print("mult 4x4   (256)", cgp.evalspersec, "evals/sec")

    cgp = Cgp(row, col, lback)
    cgp.file("../../data/multiplier5x5.txt")
    cgp.run(gen, pop, mut, acc)
    print("mult 5x5  (1024)", cgp.evalspersec, "evals/sec")

    cgp = Cgp(row, col, lback)
    cgp.file("../../data/multiplier6x6.txt")
    cgp.run(gen, pop, mut, acc)
    print("mult 6x6  (4096)", cgp.evalspersec, "evals/sec")

    cgp = Cgp(row, col, lback)
    cgp.file("../../data/parity9.txt")
    cgp.run(gen, pop, mut, acc)
    print("parity 9   (512)", cgp.evalspersec, "evals/sec")
    print()
    print()
    print()
print("Test: 2")
print("Benchmark Symbolicke regrese")

cgp = Cgp(row, col, lback)
cgp.file("../../data/logx5.txt")
cgp.run(gen, pop, mut, acc)
print(" 5 trains", cgp.evalspersec, "evals/sec")

cgp = Cgp(row, col, lback)
cgp.file("../../data/logx10.txt")
cgp.run(gen, pop, mut, acc)
print("10 trains", cgp.evalspersec, "evals/sec")

cgp = Cgp(row, col, lback)
cgp.file("../../data/logx25.txt")
cgp.run(gen, pop, mut, acc)
print("25 trains", cgp.evalspersec, "evals/sec")

cgp = Cgp(row, col, lback)
cgp.file("../../data/logx50.txt")
cgp.run(gen, pop, mut, acc)
print("50 trains", cgp.evalspersec, "evals/sec")

cgp = Cgp(row, col, lback)
cgp.file("../../data/logx100.txt")
cgp.run(gen, pop, mut, acc)
print("100 trains", cgp.evalspersec, "evals/sec")


cgp = Cgp(row, col, lback)
cgp.file("../../data/logx200.txt")
cgp.run(gen, pop, mut, acc)
print("200 trains", cgp.evalspersec, "evals/sec")

cgp = Cgp(row, col, lback)
cgp.file("../../data/logx500.txt")
cgp.run(gen, pop, mut, acc)
print("500 trains", cgp.evalspersec, "evals/sec")

print()
print()
print()
print("Test: 3")
print("Jednotlive funkce.")
print("3000 generaci.")
print("1000 training vectors.")
gen = 30000

cgp = Cgp(row, col, lback)
cgp.file("../../data/cosx.txt")
cgp.run(gen, pop, mut, acc)
print("cosx", cgp.evalspersec, "evals/sec")

cgp = Cgp(row, col, lback)
cgp.file("../../data/sinx.txt")
cgp.run(gen, pop, mut, acc)
print("sinx", cgp.evalspersec, "evals/sec")

cgp = Cgp(row, col, lback)
cgp.file("../../data/logx.txt")
cgp.run(gen, pop, mut, acc)
print("logx", cgp.evalspersec, "evals/sec")

cgp = Cgp(row, col, lback)
cgp.file("../../data/xxyz.txt")
cgp.run(gen, pop, mut, acc)
print("xxyz", cgp.evalspersec, "evals/sec")

#print(cgp.pop[cgp.parent])
