#!/bin/python2
import sys
from math import log, ceil 
"""
This file is used for generating adders for the seed of CGP. 
I'd like to denote that this script generates FASTER adders (at least one gate faster) than presnted in the thesis: http://www.fit.vutbr.cz/study/DP/BP.php?id=15869
TODO Optimization on used gates - remove redundant gates in the last step of propagation
"""

# Auxiliary list with names of gates. 
GENE_TRANSLATION = ["BUF", "NOT", "AND", "OR", "XOR", "NAND", "NOR", "XNOR"]

# List with lambda functions used in verification (testing)
INTERPRETATION   = [lambda a, b: a,
					lambda a, b: ~a, 
					lambda a, b: a & b, 
					lambda a, b: a | b,
					lambda a, b: a ^ b, 
					lambda a, b: ~(a & b),
					lambda a, b: ~(a | b), 
					lambda a, b: ~(a ^ b)]

LOGIC_CONSTANT_ZERO_IDX = -1
LOGIC_CONSTANT_ONE_IDX = -2


# Chromsome is in the list of nodes ended with a list of outputs, e.g. [node, node, node, node, outputs]
# Node list is in the format: [input index, input index, function index]
# Output list is in the format: [node idx, node idx, node idx, node idx]. 


#                            CARRY RIPPLE ADDERS
#                            -------------------
# Firstly, we create helpfull functions for creating smaller adders. 
# These small adders are used for constructing carry ripple adder (we connect their input/output carry signals)

# Generates half adder.
def half_adder(idx, a, b):
	"""
	@param idx - the position of the LAST node in the chromosome
	@param a - the index of the first input
	@param b - the index of the second input
	@return list - representating the half adder.
			|- the LIST of NODES
	        |- the index of SUM gate
	        |- the index of CARRY gate
	        \- the new index  of the LAST NODE
	"""
	# Append SUM gates; Get save index; Increment index
	chrom = [[a, b, GENE_TRANSLATION.index("XOR")]]
	s = idx
	idx = idx + 1
	
	# Append CARRY gates; Get save index; Increment index
	chrom += [[a, b, GENE_TRANSLATION.index("AND")]]
	c = idx
	idx = idx + 1
	return (chrom, s, c, idx)

# Append Full adder
def full_adder(idx, a, b, c):
	"""
	@param idx - the position of the LAST node in the chromosome
	@param a - the index of the first input
	@param b - the index of the second input
	@param c - the index of the input carry
	@return list - representating the half adder.
			|- the LIST of NODES
	        |- the index of SUM gate
	        |- the index of CARRY gate
	        \- the new index  of the LAST NODE
	"""
	# Calculation of SUM    a xor b xor c
	chrom = [[a, b, GENE_TRANSLATION.index("XOR")]]
	tmp_ab = idx;	idx += 1

	chrom += [[tmp_ab, c, GENE_TRANSLATION.index("XOR")]]
	s = idx; idx += 1

	# Calculation of CARRY ((a xor b) and c) or (a and b)
	chrom += [[c, tmp_ab, GENE_TRANSLATION.index("AND")]]
	tmp_abc = idx; idx += 1;

	chrom += [[a, b, GENE_TRANSLATION.index("AND")]]
	tmp_ab = idx; idx += 1
	
	chrom += [[tmp_ab, tmp_abc, GENE_TRANSLATION.index("OR")]]
	c = idx; idx += 1
	return (chrom, s, c, idx)

# Creation Carry Ripple Adder 
def carry_ripple_adder(bitwidth):
	"""
	@param bitwidth - the bitwidth of the adder
	@return chromosome - as mentioned on the begining of this script
	"""
	# List with primary inputs
	a = range(bitwidth)            # MSB [0,1,2,3] LSB   an example for 4 bitwidth
	b = range(bitwidth,bitwidth*2) # MSB [4,5,6,7] LSB

	# Define index varible, skip primary inputs
	idx = bitwidth*2 
	chrom = []

	# Append half adder to chromosome
	half_adder_chrom, s, c, idx = half_adder(idx, a[-1], b[-1]) # -1, get last item
	chrom += half_adder_chrom
	# Save output index
	out = [s]

	# Append full adders to chrom
	for i in xrange(bitwidth - 2, -1, -1): # e.g. bitwidth = 8, the result is [6,5,4,3,2,1,0]
		full_adder_chrom, s, c, idx = full_adder(idx, a[i], b[i], c)
		chrom += full_adder_chrom
		out = [s] + out
	# Carry for MSB
	out = [c] + out
	# Return chromosome with output genes
	return chrom + [out]

# Creation Carry Ripple Adder with Carryin
def carry_ripple_adder_with_carryin(bitwidth):
	"""
	@param bitwidth - the bitwidth of the adder
	@return chromosome - as mentioned on the begining of this script
	"""	
	# List with primary inputs
	a = range(bitwidth)            # MSB [0,1,2,3] LSB   an example for 4 bitwidth
	b = range(bitwidth,bitwidth*2) # MSB [4,5,6,7] LSB
	c = bitwidth*2 
	# Define index varible, skip primary inputs
	idx = bitwidth*2 + 1

	chrom = []
	out = []
	# Append full adders to chrom
	for i in xrange(bitwidth - 1, -1, -1): # e.g. bitwidth = 8, the result is [6,5,4,3,2,1,0]
		full_adder_chrom, s, c, idx = full_adder(idx, a[i], b[i], c)
		chrom += full_adder_chrom
		out = [s] + out
	# Carry for MSB
	out = [c] + out
	# Return chromosome with output genes
	return chrom + [out]

#                            PARALEL PREFIX ADDER
#                            --------------------
# We use the parallel calculation of sum of prefixes in order to obtain faster adder.
# See literature with keywords - "paralel sum of prefixes", "Kogge-stone adder"

# Prelude is same in each PPA.
def prelude(bitwidth, carry=False):
	"""
	@param bitwidth - the bitwideth of the adder
	@param carry - Is carry bit in?
	@return list - the list representating
			|- idx - the index of the LAST node
			|- a - the index list of the FIRST number inputs; the size of the list is defined by bitwidth
			|- b - the index list of the SECOND number inputs; the size of the list is defined by bitwidth
			|- p - the index list of the PROPAGATE values; (changes during creating time)
			|- g - the index list of the GENERATE values
			|- p - the index list of the XOR values; (this is used for in the epilogue; thats why they are the SAME)
			\- chrom - the list of NODES
	"""
	# List with primary inputs
	a = range(bitwidth)            # MSB [0,1,2,3] LSB   an example for 4 bitwidth
	b = range(bitwidth,bitwidth*2) # MSB [4,5,6,7] LSB
	c = bitwidth * 2
	# Define index varible, skip primary inputs, depends on carry bit
	idx = bitwidth*2
	if carry:
		idx += 1 

	chrom = []
	# First row of propagate and generate bits. 
	p = range(idx, idx+bitwidth)
	chrom = map(lambda x: [x[0],x[1],GENE_TRANSLATION.index("XOR")], zip(a,b))
	idx += bitwidth
	
	g = range(idx, idx+bitwidth)
	chrom += map(lambda x: [x[0],x[1],GENE_TRANSLATION.index("AND")], zip(a,b))
	idx += bitwidth

	if carry:
		chrom += [[a[-1], c, GENE_TRANSLATION.index("AND")]]
		chrom += [[b[-1], c, GENE_TRANSLATION.index("AND")]]
		chrom += [[idx, idx-1, GENE_TRANSLATION.index("OR")]]
		chrom += [[idx+2, idx+1, GENE_TRANSLATION.index("OR")]]
		idx += 4
		g[-1] = idx -1
	return idx, a, b, p, g, p, chrom

def epilogue(bitwidth, chrom, g, xor_gates, idx, carry=False):
	"""
	@param bitwidth - the bitwideth of the adder
	@param chrom - the list of NODES
	@param g - the index list of the GENERATE values
	@param xor_gates - the index list of the XOR values; (was created in the prologue)
	@param carry - Is carry bit in?
	@return chromosome
	"""
	
	chrom += map(lambda x: [x[0], x[1], GENE_TRANSLATION.index("XOR")], zip(xor_gates[:-1],g[1:]))
	out = range(idx, idx+bitwidth - 1)
	idx += bitwidth - 1
	if carry:
		chrom += [[xor_gates[-1], 2*bitwidth, GENE_TRANSLATION.index("XOR")]]
		out_genes = [g[:1]+ out + [idx]]
	else: 
		out_genes = [g[:1]+ out + xor_gates[-1:]]
	return chrom + out_genes

def carry_logic(p, g, a, b, idx, p_new, g_new):
	"""
	Append the carry logic 
	"""
	f = []
	f += [[p[a], p[b], GENE_TRANSLATION.index("AND")]]
	p_new[a] = idx
	idx += 1 
	f += [[p[a], g[b], GENE_TRANSLATION.index("AND")]]
	idx += 1
	f += [[g[a], idx-1, GENE_TRANSLATION.index("OR")]]
	g_new[a] = idx
	idx += 1
	return f, idx


# Creation of Kogge Stone
# https://en.wikipedia.org/wiki/Kogge%E2%80%93Stone_adder
def kogge_stone(bitwidth, carry=False):
	idx, a, b, p, g, xor_gates, chrom = prelude(bitwidth, carry) # You mad?
	# Calculate propagate and generate latency
	latency = int(ceil(log(bitwidth, 2)))

	# Create gates for each latecy depth
	p = p[::-1]
	g = g[::-1]
	for i in xrange(latency):
		shift = 1<<i
		# Temp lists of propagate generate
		p_new = list(p)
		g_new = list(g)
		# Append "sum of prefixes"
		t =  len(chrom)
		for j in xrange(bitwidth):
			if j + shift < bitwidth:
				a, b = j + shift, j
				f, idx = carry_logic(p, g, a, b, idx, p_new, g_new)
				chrom += f
		#print "---"
		# Update lists
		p = p_new
		g = g_new
	# XOR gates
	p = p[::-1]
	g = g[::-1]
	return epilogue(bitwidth, chrom, g, xor_gates, idx, carry)

	
# Creation of Brent Kung
def brent_kung(bitwidth, carry=False):
	idx, a, b, p, g, xor_gates, chrom = prelude(bitwidth, carry) # You mad?
	# Calculate propagate and generate latency
	latency = int(ceil(log(bitwidth, 2)))
	g = g[::-1]
	p = p[::-1]
	# Create gates for each latecy depth
	t = 0
	# Creates the prefix sum of the last carry
	for i in xrange(latency):
		shift = 1<<i
		# Temp lists of propagate generate
		p_new = list(p)
		g_new = list(g)
		# Append "sum of prefixes"
		for j in xrange(t, bitwidth, (shift<<1)):
			a, b = j + shift, j
			if a >= bitwidth or b < 0: continue
			f, idx = carry_logic(p, g, a, b, idx, p_new, g_new)
			chrom += f
		#print "==="
		t = 2**(i+1) - 1 
		# Update lists
		p = p_new
		g = g_new
	
	# Calculate the rest cerries
	for i in xrange(0,latency-1):
		p_new = list(p)
		g_new = list(g)
		shift = 1 << (latency -2 - i)
		for j in xrange(0,bitwidth,shift<<1):
			b = j - 1
			a = b + shift
			if b < 0 or a >= bitwidth: continue
			#print a, b
			f, idx = carry_logic(p, g, a, b, idx, p_new, g_new)
			chrom += f
		p = p_new
		g = g_new

		#print "=="
	g = g[::-1]
	p = p[::-1]
	# XOR gates
	return epilogue(bitwidth, chrom, g, xor_gates, idx, carry)

	
# Creation of Skalinski
def sklansky(bitwidth, carry=False):
	idx, a, b, p, g, xor_gates, chrom = prelude(bitwidth, carry) # You mad?
	# Calculate propagate and generate latency
	latency = int(ceil(log(bitwidth, 2)))
	g = g[::-1]
	p = p[::-1]
	# Create gates for each latecy depth
	t = 0
	for i in xrange(latency):
		shift = 1<<i
		# Temp lists of propagate generate
		p_new = list(p)
		g_new = list(g)
		# Append "sum of prefixes"
		for j in xrange(t, bitwidth, (shift<<1)):
			for k in xrange(1 << i):
				a = j + shift - k
				b = j
				if a >= bitwidth or b < 0: continue
				f, idx = carry_logic(p, g, a, b, idx, p_new, g_new)
				chrom += f
		#print "---"
		t = 2**(i+1) - 1 
		# Update lists
		p = p_new
		g = g_new
	g = g[::-1]
	p = p[::-1]
	# XOR gates
	return epilogue(bitwidth, chrom, g, xor_gates, idx, carry)

# Creation of Han Carlson Adder
def han_carlson(bitwidth, carry=False):
	idx, a, b, p, g, xor_gates, chrom = prelude(bitwidth, carry) # You mad?
	latency = int(ceil(log(bitwidth, 2)))
	g = g[::-1]
	p = p[::-1]

	# 1st stage
	p_new = list(p)
	g_new = list(g)
	for j in xrange(1, bitwidth, 2):
		a, b = j, j-1
		f, idx = carry_logic(p, g, a, b, idx, p_new, g_new)
		chrom += f
	p = p_new
	g = g_new

	# 2nd stage
	t = 2
	for i in xrange(1, latency):
		p_new = list(p)
		g_new = list(g)
		#print "---"
		for j in xrange(t, bitwidth-1, 2):
			a, b =  j+1, j-t+1
			f, idx = carry_logic(p, g, a, b, idx, p_new, g_new)
			chrom += f
		t = t << 1
		p = p_new
		g = g_new

	#3rd Stage
	p_new = list(p)
	g_new = list(g)
	# print "---"
	for j in xrange(1, bitwidth-1, 2):
		a, b = j+1, j
		f, idx = carry_logic(p, g, a, b, idx, p_new, g_new)
		chrom += f
	p = p_new[::-1]
	g = g_new[::-1]

	return epilogue(bitwidth, chrom, g, xor_gates, idx, carry)

def carry_save_adder(width):
	print "Carry save adder is used for multipliers!"

def multiplier(width, create_adder):
	print "I am an adder generator"



# Interpret circuit, returns Sum of Hamming's distance
# I dont recommand to run verfication with 2**32 training vectors (length of input_ref and output_ref)
# 
# @param chrom 		input circuit in vasicek syntax
# @param input_ref	input reference
# @param output_ref output refrence
# @param offset 	count of primary inputs of circuit
#
# @return int SHD,  0 if the circuit works correctly 
def evaluate_chrom(chrom, input_ref, output_ref, offset):
	buff = input_ref +  [0] * (len(chrom) - 1) + [-1, 0]
	for i, gene in enumerate(chrom[:-1]):
		buff[i + offset] = INTERPRETATION[gene[2]](buff[gene[0]], buff[gene[1]])
	# Get SHD
	print bin(buff[chrom[-1][0]])[2:].zfill(2**4)
	print bin(buff[chrom[-1][1]])[2:].zfill(2**4)
	print bin(buff[chrom[-1][2]])[2:].zfill(2**4)
	print bin(buff[chrom[-1][3]])[2:].zfill(2**4)
	return sum(map(lambda x, y : bin(buff[x] ^ y if buff[x] > 0 else (buff[x] ^ y) & ((1 << (1<<offset))-1)).count("1"), chrom[-1], output_ref))

def verification_adder(chrom, bitwidth):
	input_ref = [0]*(2*bitwidth)
	output_ref = [0]*(bitwidth+1)  
	for b in xrange(2**bitwidth):
		for a in xrange(2**bitwidth):
			s = a + b  
			for i in xrange(bitwidth):
				# MSB, LSB 
				input_ref[bitwidth - i -1] = int(b & (1 << i) is not 0) | input_ref[bitwidth - i -1]
			for i in xrange(bitwidth):
				# MSB, LSB
				input_ref[bitwidth*2 - i -1] = int(a & (1 << i) is not 0) | input_ref[bitwidth*2 - i -1]
			for i in xrange(bitwidth+1):
				output_ref[bitwidth+1 - i -1] = int(s & (1 << i) is not 0) | output_ref[bitwidth+1 - i-1]
			input_ref = map(lambda x : x << 1, input_ref)
			output_ref = map(lambda x : x << 1, output_ref)
			#print bin(a)[2:].zfill(bitwidth), bin(b)[2:].zfill(bitwidth), bin(s)[2:].zfill(bitwidth+1)
	input_ref = map(lambda x : x >> 1, input_ref)
	output_ref = map(lambda x : x >> 1, output_ref)
	return evaluate_chrom(chrom, input_ref, output_ref, bitwidth*2)

def verification_mult(chrom, bitwidth):
	input_ref = [0]*(2*bitwidth)
	output_ref = [0]*(bitwidth*2)  
	for b in xrange(2**bitwidth):
		for a in xrange(2**bitwidth):
			s = a * b  
			for i in xrange(bitwidth):
				# MSB, LSB 
				input_ref[bitwidth - i -1] = int(b & (1 << i) is not 0) | input_ref[bitwidth - i -1]
			for i in xrange(bitwidth):
				# MSB, LSB
				input_ref[bitwidth*2 - i -1] = int(a & (1 << i) is not 0) | input_ref[bitwidth*2 - i -1]
			for i in xrange(bitwidth*2):
				output_ref[bitwidth*2 - i -1] = int(s & (1 << i) is not 0) | output_ref[bitwidth*2 - i-1]
			input_ref = map(lambda x : x << 1, input_ref)
			output_ref = map(lambda x : x << 1, output_ref)
			print bin(a)[2:].zfill(bitwidth), bin(b)[2:].zfill(bitwidth), bin(s)[2:].zfill(bitwidth*2)
	input_ref = map(lambda x : x >> 1, input_ref)
	output_ref = map(lambda x : x >> 1, output_ref)
	return evaluate_chrom(chrom, input_ref, output_ref, bitwidth*2)


def verification_adder_with_carryin(chrom, bitwidth):
	input_ref = [0]*(2*bitwidth + 1)
	output_ref = [0]*(bitwidth+1)  
	for c in xrange(2):
		for b in xrange(2**bitwidth):
			for a in xrange(2**bitwidth):
				s = a + b + c 
				for i in xrange(bitwidth):
					# MSB, LSB 
					input_ref[bitwidth - i -1] = int(b & (1 << i) is not 0) | input_ref[bitwidth - i -1]
				for i in xrange(bitwidth):
					# MSB, LSB
					input_ref[bitwidth*2 - i -1] = int(a & (1 << i) is not 0) | input_ref[bitwidth*2 - i -1]
				input_ref[bitwidth*2] = c | input_ref[bitwidth*2]
				for i in xrange(bitwidth+2):
					output_ref[bitwidth+1 - i -1] = int(s & (1 << i) is not 0) | output_ref[bitwidth+1 - i-1]
				input_ref = map(lambda x : x << 1, input_ref)
				output_ref = map(lambda x : x << 1, output_ref)
				#print bin(a), bin(b), bin(c), bin(s)
	input_ref = map(lambda x : x >> 1, input_ref)
	output_ref = map(lambda x : x >> 1, output_ref)
	return evaluate_chrom(chrom, input_ref, output_ref, bitwidth*2+1)



def vasicek_syntax(chrom, bitwidth, carry=False, mult=False):
	inputs = bitwidth*2 if not carry else bitwidth*2 +1 
	outputs = bitwidth+1 if not mult else bitwidth*2
	rows = len(chrom) - 1 
	cols = 1
	node_in = 2 # pocet vstupu do hradla
	node_out = 1 # pocet vystupu hradla
	lback = rows

	metadata = [inputs, outputs, rows, cols, node_in, node_out, lback]
	metadata = "{" + ",".join(map(str, metadata)) + "}"

	chrom_str = ""
	idx = inputs
	#print chrom
	for gene in chrom[:-1]:
		chrom_str += "([" + str(idx) + "]"+ ",".join(map(str, gene)) + ")"
		idx += 1 
	chrom_str += "("+ ",".join(map(str, chrom[-1])) + ")"
	#print chrom_str
	return metadata + chrom_str




	
"""================================================================="""
"""================================================================="""
"""================================================================="""
"""================================================================="""


def make_adder(name, width, carrybit, verify):
	if name == "CRA" and not carrybit:
		adder = carry_ripple_adder(width)
		if verify and verification_adder(adder, width) != 0:
			print "Verification says that something is fucked up."
			exit(1)
		return vasicek_syntax(adder, width, carrybit)
	
	if name == "CRA" and carrybit:
		adder = carry_ripple_adder_with_carryin(width)
		if verify and verification_adder_with_carryin(adder, width) != 0:
			print "Verification says that something is fucked up."
			exit(1)
		return vasicek_syntax(adder, width, carrybit)
	
	if name == "KS":
		adder = kogge_stone(width, carrybit)
		if verify:
			if not carrybit and verification_adder(adder, width) != 0 \
				or carrybit and verification_adder_with_carryin(adder, width) != 0:
				print "Verification says that something is fucked up."
				exit(1)
		return vasicek_syntax(adder, width, carrybit)
	
	if name == "BK":
		adder = brent_kung(width, carrybit)
		if verify:
			if not carrybit and verification_adder(adder, width) != 0 \
				or carrybit and verification_adder_with_carryin(adder, width) != 0:
				print "Verification says that something is fucked up."
				exit(1)
		return vasicek_syntax(adder, width, carrybit)
	
	if name == "SK":
		adder = sklansky(width, carrybit)
		if verify:
			if not carrybit and verification_adder(adder, width) != 0 \
				or carrybit and verification_adder_with_carryin(adder, width) != 0:
				print "Verification says that something is fucked up."
				exit(1)
		return vasicek_syntax(adder, width, carrybit)
	
	if name == "HC":
		adder = han_carlson(width, carrybit)
		if verify:
			if not carrybit and verification_adder(adder, width) != 0 \
				or carrybit and verification_adder_with_carryin(adder, width) != 0:
				print "Verification says that something is fucked up."
				exit(1)
		return vasicek_syntax(adder, width, carrybit)
	
	
	if name == "mult":
		raise
		adder = carry_ripple_adder
		mult = multiplier(width, adder)
		return vasicek_syntax(mult, width, mult=True)
		if verify and verification_mult(mult, width) != 0: 
			print "Verification says that something is fucked up."


if __name__ == '__main__':
	try:
		name = sys.argv[1]
		width = int(sys.argv[2])
		carrybit = bool(int(sys.argv[3]))
		verify = True if len(sys.argv) > 4 else False
	except:
		print "./adder.py NAME bitwidth carrybit verify"
		print "   NAME - CRA       Carry ripple adder"
		print "        - KS        Kogge Stone adder"
		print "        - BK        Brent Knug adder"
		print "        - SK        Sklansky adder"
		print "        - HC        Han Carlson adder"
		print "   bitwidth  - int         Bit width of the adder"
		print "   carrybit  - int (1/0)   Carry bit which is input to adder."
		print "   verification - variable - any parameter will start verification"
		exit(1)
	print make_adder(name, width, carrybit, verify)
	