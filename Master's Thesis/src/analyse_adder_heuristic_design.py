# Analyse heuristic design for adders
# ===================================
#
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Date: 24th October 2014
# Filename: analyse_adder_heuristic_design.py
# Description: The script analyses an error bits when we use smaller adders
#              as a seed for a bigger adder. The output of this script is a table.

# todo check z liche sudou

import sys
MIN_OPERAND_SIZE = 3
MAX_OPERAND_SIZE = 8

def compute_error(init_a, init_b):
    error = 0
    shift = init_a 
    sad = 0    
    maximal = (2**(init_a +init_b+1) * 2**(init_b+1))
    # Nemusime pocitat polovinu starych veci, jsou stejne jak minule.
    for a in xrange(2**init_a): 
        for b in xrange(2**init_b):
            #sad += 
            sad += abs((a+b) - (b+ (a | 1<< shift )))
            error += bin((a+b) ^ (b+ (a | 1<< shift ))).count('1')
            #print bin(a) + " "+ bin(b) + " => " +  bin(a+b) + " || " + bin(a | 1<< shift)  +" "+bin(b + (a | 1<< shift )) + " XORED " +bin((a+b) ^ (b+ (a | 1<< shift )))
    max_fitness = (init_a+2) * 2**(init_a + init_b + 1)
    init_fitness = max_fitness - error
    error_rate =  float(init_fitness) / float(max_fitness)
    result = str(init_a) + "+" + str(init_b) + " => "
    if init_a == init_b:
        result += str(init_a) + "+" + str(init_b+1) + " "
    else:
        result += str(init_a+1) + "+" + str(init_b) + " "
    result += str(max_fitness) +" "+ str(error) +" "+ str(init_fitness) + " " +str(error_rate)+ "    SAD ["+str(sad)+"] -> " + str(float(sad)/ float(maximal)) 
    return result

for operand_bits in xrange(MIN_OPERAND_SIZE, MAX_OPERAND_SIZE):
    print compute_error(operand_bits, operand_bits)
    print compute_error(operand_bits, operand_bits+1)


