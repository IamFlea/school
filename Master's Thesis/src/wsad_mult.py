#!/bin/python2
d={}
for a in xrange(256):
	for b in xrange(256):
		d[(a,b)] = a*b

import cv2
import numpy as np

files = ["nasobeni-barbara.png", 
 "nasobeni-cameraman.png",  
 "nasobeni-lena.png",
 "nasobeni-mandrill.png",
 #"nasobeni-peppers.png"
 ]

files = map(lambda x: "nasobicka/"+x, files)
img = cv2.imread(files[0],0)

for f in files[1:]:
	img2 = cv2.imread(f,0)
	img = cv2.bitwise_or(img, img2)

good = {}
bad = {}
result = []
for row in xrange(img.shape[1]):
	for col in xrange(img.shape[0]):
		if img[col][row] == 255:
			good[(col,row)] = col*row
		else:
			bad[(col,row)] = col*row
result=sorted(good, key=good.get) + sorted(bad, key=bad.get)
l = range(0, len(result)/64)
suma = 0
w = 2
for i in result: 
	try: val = good[i]
	except: val = bad[i]
	suma += val

cv2.imshow('img', img)
cv2.waitKey(0)
k = 0
f = open("sad_multiplier_8x8.txt", 'w')
for i in sorted(good, key=good.get):
	line = ""
	line += bin(i[0])[2:].zfill(8)
	line += " "
	line += bin(i[1])[2:].zfill(8)
	line += " : "
	line += bin(good[i])[2:].zfill(16)
	line += " # "+str((i[0],"*",i[1], "=", good[i])) + "\n"
	suma += good[i]
	f.write(line)
	#print line,
	k+=1
	if k == 64:
		k = 0
		if suma < 64: 
			suma = 64
		#f.write("> "+str(suma/64)+"\n")
		#print "> "+str(suma/64)+"\n",
		suma = 0

i = (0,0); 
for _ in xrange(k, 64):
	line = ""
	line += bin(i[0])[2:].zfill(8)
	line += " "
	line += bin(i[1])[2:].zfill(8)
	line += " : "
	line += bin(good[i])[2:].zfill(16)
	line += " # "+str((i[0],"*",i[1], "=", good[i])) + "\n"
	suma += good[i]
	f.write(line)
	#print line,
	k+=1
	if k == 64:
		k = 0
		if suma < 64: 
			suma = 64
		#f.write("> "+str(suma/64)+"\n")
		#print "> "+str(suma/64)+"\n",
		suma = 0
f.close()

k = 0
f = open("sad_multiplier_8x8.txt", 'w')
for i in sorted(good, key=good.get):
	line = ""
	line += bin(i[0])[2:].zfill(8)
	line += " "
	line += bin(i[1])[2:].zfill(8)
	line += " : "
	line += bin(good[i])[2:].zfill(16)
	line += " # "+str((i[0],"*",i[1], "=", good[i])) + "\n"
	suma += good[i]
	f.write(line)
	#print line,
	k+=1
	if k == 64:
		k = 0
		if suma < 64: 
			suma = 64
		#f.write("> "+str(suma/64)+"\n")
		#print "> "+str(suma/64)+"\n",
		suma = 0

i = (0,0); 
for _ in xrange(k, 64):
	line = ""
	line += bin(i[0])[2:].zfill(8)
	line += " "
	line += bin(i[1])[2:].zfill(8)
	line += " : "
	line += bin(good[i])[2:].zfill(16)
	line += " # "+str((i[0],"*",i[1], "=", good[i])) + "\n"
	suma += good[i]
	f.write(line)
	#print line,
	k+=1
	if k == 64:
		k = 0
		if suma < 64: 
			suma = 64
		#f.write("> "+str(suma/64)+"\n")
		#print "> "+str(suma/64)+"\n",
		suma = 0
f.close()
#/cgp_sad/cgp_native -x 329gated_mult.chr -g 500000 -r 1 -c 333 -l 333 -n 329 -m 16 -p 5 -s 8738260060 data/sad_multiplier_8x8.txt  
k = 0
f = open("wsad_multiplier_8x8.txt", 'w')
lines = ""
for i in sorted(good, key=lambda l:l[0]+l[1]):
	line = ""
	line += bin(i[0])[2:].zfill(8)
	line += " "
	line += bin(i[1])[2:].zfill(8)
	line += " : "
	line += bin(good[i])[2:].zfill(16)
	line += " # "+str((i[0],"*",i[1], "=", good[i])) + "\n"
	suma += good[i]
	f.write(line)
	#print line,
	k+=1
	if k == 64:
		k = 0
		if suma < 64: 
			suma = 64
		#f.write("> "+str(suma/64)+"\n")
		#print "> "+str(suma/64)+"\n",
		suma = 0

i = (0,0); 
for _ in xrange(k, 64):
	line = ""
	line += bin(i[0])[2:].zfill(8)
	line += " "
	line += bin(i[1])[2:].zfill(8)
	line += " : "
	line += bin(good[i])[2:].zfill(16)
	line += " # "+str((i[0],"*",i[1], "=", good[i])) + "\n"
	f.write(line)
	#print line,
	k+=1
	if k == 64:
		k = 0
		if suma < 64: 
			suma = 64
		#f.write("> "+str(suma/64)+"\n")
		#print "> "+str(suma/64)+"\n",
		suma = 0
f.close()