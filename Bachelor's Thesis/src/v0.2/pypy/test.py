#from bezevaluace.py3.cgp_algorithm import Cgp_algorithm
from cgp import Cgp
import os

row     = 1
col     = 40
lback   = 40
gen     = 10000
pop     = 5
mut     = 3



cgp = Cgp(row, col, lback)
for filename in os.listdir('../../data-cir/'):
    cgp.file("../../data-cir/" +filename)
    print(os.path.splitext(filename)[0])
    cgp.run(gen, pop, mut)
    print(cgp.evalspersec, " evals/sec " , cgp.elapsed)

