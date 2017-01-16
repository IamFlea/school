#!/bin/python2
import numpy as np 
import cv2, sys
prefix=sys.argv[1]
sufix=".png"
filename = prefix + str(330) + sufix
ref_img = cv2.imread(filename, 0)
for i in xrange(330):
	i = str(i).zfill(3)
	filename = prefix + str(i) + sufix
	obt_img = cv2.imread(filename, 0)
	if obt_img is None: continue
	img = cv2.bitwise_xor(ref_img, obt_img) 
	#cv2.imshow(str(i), img)
	#cv2.waitKey()
	img = np.greater(img, 0)
	print i, sum(sum(img))
	