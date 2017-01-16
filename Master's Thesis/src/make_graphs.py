#!/bin/python3
# -*- coding: utf-8 -*-
import sys, os
import numpy as np
import matplotlib.pyplot as plt

from matplotlib import cm
from mpl_toolkits.axes_grid1 import host_subplot
import mpl_toolkits.axisartist as AA
import matplotlib.pyplot as plt

import itertools
mults = "gif/"
dirname_logs  = ["barbara/", "cameraman/", "lenna/", "mandrill/", "peppers/", mults]
dick = {}
for dirname, filename in itertools.product(dirname_logs, ["s1.log", "s2.log"]):
	path = dirname + filename
	listerino = []
	for line in open(path):
		try: listerino.append((int(line.split(" ")[0]), int(line.split(" ")[1][:-1])))
		except: listerino.append((int(line.split(" ")[0]), 99- float(line.split(" ")[1][:-1])))
	dick[path] = sorted(listerino)
	
s1_filename = "cameraman/s1.log"
s2_filename = "cameraman/s2.log"
for i in dick:
	k,v=zip(*dick[i])
	dick[i] = [list(k), list(v)]

def adjustFigAspect(fig,aspect=1):
	'''
	Adjust the subplot parameters so that the figure has the correct
	aspect ratio.
	'''
	xsize,ysize = fig.get_size_inches()
	minsize = min(xsize,ysize)
	xlim = .4*minsize/xsize
	ylim = .4*minsize/ysize
	if aspect < 1:
		xlim *= aspect
	else:
		ylim /= aspect
	fig.subplots_adjust(left=.5-xlim,
						right=.5+xlim,
						bottom=.5-ylim,
						top=.5+ylim)
if 1:
	fig = plt.figure()
	adjustFigAspect(fig,2)
	host = host_subplot(111, axes_class=AA.Axes)
	plt.subplots_adjust(right=0.75)
	
	par1 = host.twinx()

	offset = 60


	host.set_xlim(1,330)
	par1.set_yscale('log')
	par1.set_ylim(100, 100000000)
	host.set_ylim(0, 8000)

	host.set_xlabel("Pocet hradel")
	par1.set_ylabel("Chybovost nasobicky")
	host.set_ylabel("Chybovost detekce")
	p1, = par1.plot(dick[mults+"s1.log"][0], dick[mults+"s1.log"][1], label="Nasobeni S1", color="red", dashes= [1]*330 )
	p1, = par1.plot(dick[mults+"s2.log"][0], dick[mults+"s2.log"][1], label="Nasobeni S2", color="blue", dashes=[1]*330)
	gates = dick[s1_filename][0]
	error = dick[s1_filename][1]
	p2, = host.plot(gates, error, label="Detekce S1", color="red")
	gates = dick[s2_filename][0]
	error = dick[s2_filename][1]
	p2, = host.plot(gates, error, label="Detekce S2", color="blue")
	
	#par1.set_ylim(0, 4)
	host.legend()

	plt.legend(loc='upper right', bbox_to_anchor=(1., 1.))
	plt.draw()
	fig.tight_layout()
	plt.show()
	#plt.savefig('/tmp/graphs.pdf')
