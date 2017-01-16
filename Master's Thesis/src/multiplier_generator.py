# Multiplier generator
# ====================
#
# File: multiplier_generator.py
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Date: 19th October 2014
# Description: The script gnerates multipliers, 3x3, 3x4, 4x4 .. 8x8 into sys.argv[1]

import sys
import os

try:
	path = sys.argv[1]
except:
	sys.stderr.write("SYNOPSIS\n    python2 multiplier_generator.py path/to/dir\n")
	exit(1)

try:
	os.mkdir(path)
except:
	pass


##
# Make multiplier 'a' x 'b' 
def make_mult(a, b):
	mult = ""
	for i in xrange(2**(a+b)):
		#print bin(i)
		i_str = bin(i)[2:].zfill(a+b)
		x_str = i_str[:len(i_str)/2]
		y_str = i_str[len(i_str)/2:]
		result = int(x_str, 2) * int(y_str, 2)
		mult += x_str +" "+ y_str +" : "+ bin(result)[2:].zfill(a+b) + " # "+ str(int(x_str,2)) +"*"+ str(int(y_str,2)) +"="+ str(result) +"\n"
	return mult


##
# Save 'output' string in the file:  path/multiplier_'a'x'b'.txt
# The path is defined on the top of this file. 
def save(a, b, output):
	global path 
	f = open(path +"/multiplier"+str(a) + "_" + str(b) +".txt", 'w')
	f.write(output)

	
# Priting 3x3 .. 8x9 multipliers
for i in xrange(3,9):
	# Multiplier a, a
	output = "# "+str(i)+"-bit multiplier\n" 
	output += "# "+str(i)+"+"+str(i) + " inputs, "+ str(i+i) +" outputs\n"
	output += "#%i "
	for j in range(i-1, -1, -1):
		output+="b"+str(j)+","
	for j in range(i-1, -1, -1):
		output+="a"+str(j)+","
	output = output[:-1] + "\n"
	output += "#%o "
	for j in range(2*i-2, -1, -1):
		output+="s"+str(j)+","
	output = output[:-1]+"\n"
	output += make_mult(i,i)
	save(i, i, output)

	# Multiplier a, a+1
	output = "# "+str(i)+".5-bit multiplier\n" 
	output += "# "+str(i)+"+"+str(i+1) + " inputs, "+ str(i+i+1) +" outputs\n"
	output += "#%i "
	for j in range(i-1, -1, -1):
		output+="b"+str(j)+","
	for j in range(i, -1, -1):
		output+="a"+str(j)+","
	output = output[:-1] + "\n"
	output += "#%o "
	for j in range(2*i-1, -1, -1):
		output+="s"+str(j)+","
	output = output[:-1]+"\n"
	output += make_mult(i,i+1)
	save(i, i+1, output)
