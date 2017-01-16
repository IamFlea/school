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
    sad = 0
    shift = init_a 
    maximal = (2**(init_a +init_b+1) * 2**(init_a+init_b+1))
    # Nemusime pocitat polovinu starych veci, jsou stejne jak minule.
    for a in xrange(2**init_a): 
        for b in xrange(2**init_b):
            error += bin((a*b) ^ (b* (a | 1<< shift ))).count('1')
            sad += abs((a*b) - (b* (a | 1<< shift )))
            #print bin(a) + " "+ bin(b) + " => " +  bin(a+b) + " || " + bin(a | 1<< shift)  +" "+bin(b + (a | 1<< shift )) + " XORED " +bin((a+b) ^ (b+ (a | 1<< shift )))
    max_fitness = (init_a+init_b+1) * 2**(init_a + init_b + 1)
    init_fitness = max_fitness - error
    error_rate =  float(init_fitness) / float(max_fitness)
    result = str(init_a) + "*" + str(init_b) + " => "
    if init_a == init_b:
        result += str(init_a) + "*" + str(init_b+1) + " "
    else:
        result += str(init_a+1) + "*" + str(init_b) + " "
    result += str(max_fitness) +" "+ str(error) +" "+ str(init_fitness) + " " +str(error_rate) + "    SAD ["+str(sad)+"] -> " + str(float(sad)/ float(maximal)) 
    return result

for operand_bits in xrange(MIN_OPERAND_SIZE, MAX_OPERAND_SIZE):
    print compute_error(operand_bits, operand_bits)
    print compute_error(operand_bits, operand_bits+1)


"""


init 2, 2 multiplier
00 00  0000
00 01  0000
00 10  0000
00 11  0000
01 00  0000
01 01  0001
01 10  0010
01 11  0011
10 00  0000
10 01  0010
10 10  0100
10 11  0110
11 00  0000
11 01  0011
11 10  0110
11 11  1001  

creating 2,3 multiplier
000 00  00000
000 01  00000
000 10  00000
000 11  00000
001 00  00000
001 01  00001
001 10  00010
001 11  00011
010 00  00000
010 01  00010
010 10  00100
010 11  00110
011 00  00000
011 01  00011
011 10  00110
011 11  01001
100 00  00000  
100 01  00100   1
100 10  01000   1
100 11  10000   1
101 00  00000
101 01  00101   1
101 10  01010   1
101 11  01111   2
110 00  00000
110 01  00110   1
110 10  01100   1
110 11  10010   2
111 00  00000
111 01  00111   1
111 10  01110   1
111 11  10101   3

9+7 = 16


creating 3x4
000 100  000000   
000 101  000000
000 110  000000
000 111  000000

001 100  000000
001 101  000101     1 
001 110  000110     1
001 111  000111     1

010 100  001000     1
010 101  001010     1
010 110  001100     1
010 111  001110     1


7 


011 100  000000     
011 101  001111     2
011 110  010010     2
011 111  010101     3

7


100 100  000000  
100 101  010100     1
100 110  011000     1
100 111  011100     1

101 100  000000     
101 101  011001     3
101 110  011110     2
101 111  100011     3

11

110 100  000000
110 101  011110     2
110 110  100100     2
110 111  101010     3

7

111 100  000000  
111 101  100011     2
111 110  101010     2
111 111  110001     2


6


14+13+11
25+13
38


"""
