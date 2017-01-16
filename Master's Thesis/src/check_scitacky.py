#!/bin/python2 
import sys, os

dirname=sys.argv[1]

a = range(256)
b = range(256)



for i in map(lambda x: dirname + x , os.listdir(dirname)):
	try: 
		f = open(i)
		gates = i.split("/")[1].split(".")[0]
	except: 
		continue
	for line in f:
		if line[0] != "#": break
		try: 
			size, delay = line.split("VLSI width:")[1].split("L")
			size, delay = int(size), float(delay.split(":")[1])
		except: pass
		try: avg = (float(line.split("Contain")[0].split("Avg err: ")[1].split("S")[0]))
		except: pass
		try: sad = (int(line.split("SAD: ")[1]))
		except:pass
	f.close()
	"""
	suma_rel = 0
	for line in open(i):
		if line[0] == "#": continue
		a, line = line.split("*")
		a = int(a)
		b, line = line.split("=")
		b = int(b)
		c, line = line.split("[")
		c = int(c)
		d = int(line[:-2])
		suma_rel += c/float(a*b) if a*b != 0 else c

	rel = 100 - suma_rel/(2**16-1)

		
	err_relative = 0
	mrt =  sad/float(255*255)	
	new_line = str(gates) + " " +str(rel) + " " +str(size)
	"""

	new_line = str(gates) + " " +str(sad) + " " +str(size) + " " + str(delay)
	print(new_line)
	#exit(1)
	