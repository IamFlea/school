# Analyse heuristic design for adders
# ===================================
#
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Date: 24th October 2014
# Filename: analyse_adder_heuristic_design_lsb.py
# Description: The script analyses an error bits when we use smaller adders
#              as a seed for a bigger adder. The output of this script is a table.


import sys
MIN_OPERAND_SIZE = 3
MAX_OPERAND_SIZE = 8

def compute_error(init_a, init_b):
    #print "CREATING  from ", init_a, init_b, " this", init_a+1, init_b
    error = 0
    sad = 0
    shift = init_a 
    maximal = (2**(init_a +init_b+1) * 2**(init_a+init_b+1))
    # Nemusime pocitat polovinu starych veci, jsou stejne jak minule.
    for a in xrange(2**init_a): 
        for b in xrange(2**init_b):
            error += bin(((a*b)<<1) ^ (b* ((a << 1) | 1))).count('1')
            sad += abs(((a*b)<<1) - (b* ((a << 1) | 1)))
            #print bin(a) + "\t-> " + bin(a<<1 | 1) +" * " + bin(b) + " = "+bin((a<<1 | 1) * (b))
            #print bin(a) + " "+ bin(b) + " => " +  bin(a*b) + " || " + bin((a << 1) | 1)  +" "+bin(b) + " XORED " +bin((a*b) ^ (b * ((a << 1) | 1)))
    max_fitness = (init_a+init_b+1) * 2**(init_a + init_b + 1)
    init_fitness = max_fitness - error
    error_rate =  float(init_fitness) / float(max_fitness)
    result = str(init_a) + "*" + str(init_b) + " => "
    if init_a == init_b:
        result += str(init_a) + "*" + str(init_b+1) + " "
    else:
        result += str(init_a+1) + "*" + str(init_b) + " "
    result += str(max_fitness) +" "+ str(error) +" "+ str(init_fitness) + " " +str(error_rate) + "    SAD ["+str(sad)+"] ->" + str(float(sad)/float(maximal))
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
First half works correct. 
                        ERROR
 A   B   OBT    REF   SAD  SHD
001 00  00000  00000   0    0
001 01  00000  00001   1    1   
001 10  00000  00010   2    1
001 11  00000  00011   3    2
011 00  00000  00000   0    0
011 01  00010  00011   1    1
011 10  00100  00110   2    1
011 11  00110  01001   3    4
101 00  00000  00000   0    0
101 01  00100  00101   1    1
101 10  01000  01010   2    1
101 11  01100  01111   3    2
111 00  00000  00000   0    0
111 01  00110  00111   1    1
111 10  01100  01110   2    1
111 11  10010  10101   3    3  
                 SUM  24   19
# Je FAKT ze nam davala predchozi metoda mesi chybovost 

 A   B     OBT    REF    SHD  SAD
000 001  000000  000000   0       
000 011  000000  000000   0       
000 101  000000  000000   0       
000 111  000000  000000   0       
010 001  000000  000010   1    2   
010 011  000010  000110   1    4   
010 101  000100  001010   3    6   
010 111  000110  001110   1    8  
100 001  000000  000100   1    4   
100 011  000100  001100   1    8   
100 101  001000  010100   3   12   
100 111  001100  011100   1   16    
110 001  000000  000110   2    6   
110 011  000110  010010   2   12   
110 101  001100  011110   2   18    
110 111  010010  101010   3   24    
001 001  000000  000001   1    1   
001 011  000010  000011   1    1   
001 101  000100  000101   1    1   
001 111  000110  000111   1    1  
011 001  000000  000011   2    3   
011 011  000110  001001   3    9   
011 101  001100  001111   2       
011 111  010010  010101   3       
101 001  000000  000101   2       
101 011  001010  001111   2       
101 101  010100  011001   3       
101 111  011110  100011   4       
111 001  000000  000111   3       
111 011  001110  010101   4       
111 101  011100  100011   6       
111 111  101010  110001   4       
"""