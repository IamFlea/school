#!/bin/python3
# -*- coding: utf-8 -*-

import sys, os
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from matplotlib import cm
matplotlib.rc('font', serif='Nimbus Sans L') 
from matplotlib.font_manager import FontProperties

def create_dotplot(filename):
	gates = filename.split("/")[-1].split(".")[0]
	qq = 96 # +1
	data = np.zeros(shape=(256, 256))
	data2 = np.zeros(shape=(256, 256))
	errors = []
	for line in open(filename):
		l = line.split('#')[0][:-1]
		try:
			vals, err = l.split("[")[0], abs(int(l.split("[")[1][:-1]))
			inputs, outputs = vals.split("=")
			a_in, b_in = inputs.split("*")
			data[int(a_in)][int(b_in)] = err
			data2[int(a_in)][int(b_in)] = err
			errors += [err]
		except:
			continue
	errors = sorted(errors)
	listek =  list(map(lambda x: errors[int(x*len(errors)/qq)],list(range(qq))))
	for x in np.nditer(data2, op_flags=['readwrite']):
		x[...] = errors[-1] - x
	for x in np.nditer(data, op_flags=['readwrite']):
		new_val = 0
		for q in listek:
			if int(x) <= q:
				break
			new_val+=1
		x[...] = (new_val)
	qq = 10
	listek =  list(map(lambda x: errors[int(x*len(errors)/qq)],list(range(qq))))
	fig = plt.figure(num=None, figsize=(5, 5), dpi=80)
	cax = plt.matshow(data, fignum=1, cmap=cm.gray_r)
	#cax = ax.matshow(data2, fignum=2, cmap=cm.gray)
	cbar = fig.colorbar(cax, label=u"\n\nAbsolutní chyba k plne funkčnímu rešení", ticks=[         ], shrink=.75)
	listek.append(errors[-1])
	for j, lab in enumerate(['$'+str(i)+'$' for i in listek]):
		cbar.ax.text(2.5, ( j) / 10.015, lab, ha='center', va='center')

	#3print (listek)
	#seznam = list(
	#			map(lambda x: str(listek[x]),
	#				map(lambda x: (int(float(x.get_text()))), 
	#					cbar.ax.get_yticklabels())
	#				)
	#			)
	#cbar.ax.set_yticklabels(seznam)
	#cbar.ax.set_xticklabels(errors[-1])
	plt.title("Chybovost osmibitové násobičky o "+gates+" hradlech", y=1.1)
	plt.ylabel('Hodnota A')
	plt.xlabel('Hodnota B')

	plt.savefig('./mult/gates'+gates.zfill(3)+".png")
	plt.savefig('./mult/gates'+gates.zfill(3)+".pdf")
	plt.close()

	
import os
if __name__ == '__main__':
	dirname = sys.argv[1]
	#create_dotplot(dirname)
	#exit(1)
	l = map(lambda x: dirname + x , os.listdir(dirname))
	for f in l:
		if "fuse" in f: continue
		print("Processing:", f)
		create_dotplot(f)
		#create_dotplot("./dumb_mults_v2/1.log")
		#exit(1)
