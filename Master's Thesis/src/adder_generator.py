# Adder generator
# ===============
#
# File: adder_generator.py
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Date: 24th October 2014
# Description: The script gnerates adders, 3+3, 3+4, 4+4 .. 8+8 into folder defined as parameter sys.argv[1]

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
def make_adder(a, b):
	mult = ""
	for i in xrange(2**(a+b)):
		#print bin(i)
		i_str = bin(i)[2:].zfill(a+b)
		x_str = i_str[:len(i_str)/2]
		y_str = i_str[len(i_str)/2:]
		result = int(x_str, 2) + int(y_str, 2)
		mult += x_str +" "+ y_str +" : " 
		mult += bin(result)[2:].zfill(b + 1)  # add padding 
		# add coment
		mult += " # "+ str(int(x_str,2)) +"+"+ str(int(y_str,2)) +"="+ str(result) 
		mult += "\n"
	return mult


##
# Save 'output' string in the file:  path/multiplier_'a'x'b'.txt
# The path is defined on the top of this file. 
def save(a, b, output):
	global path 
	#print path
	#print output
	f = open(path +"/adder"+str(a) + "_" + str(b) +".txt", 'w')
	f.write(output)

	
# Priting 3x3 .. 8x9 adders
for i in xrange(3,9):
	# Multiplier a, a
	output = "# "+str(i)+"-bit adder\n" 
	output += "# "+str(i)+"+"+str(i) + " inputs, "+ str(i+1) +" outputs\n"
	output += "#%i "
	for j in range(i-1, -1, -1):
		output+="b"+str(j)+","
	for j in range(i-1, -1, -1):
		output+="a"+str(j)+","
	output = output[:-1] + "\n"
	output += "#%o "
	for j in range(i, -1, -1):
		output+="s"+str(j)+","
	output = output[:-1]+"\n"
	output += make_adder(i,i)
	save(i, i, output)

	# Multiplier a, a+1
	output = "# "+str(i)+".5-bit adder\n" 
	output += "# "+str(i)+"+"+str(i+1) + " inputs, "+ str(i+2) +" outputs\n"
	output += "#%i "
	for j in range(i-1, -1, -1):
		output+="b"+str(j)+","
	for j in range(i, -1, -1):
		output+="a"+str(j)+","
	output = output[:-1] + "\n"
	output += "#%o "
	for j in range(i+1, -1, -1):
		output+="s"+str(j)+","
	output = output[:-1]+"\n"
	output += make_adder(i,i+1)
	save(i, i+1, output)
	
