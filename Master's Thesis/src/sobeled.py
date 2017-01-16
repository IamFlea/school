#!/bin/python2
import os, sys
try:
    dirname = sys.argv[1]
    testing_image = sys.argv[2]
    out_dir = sys.argv[3]
    prefix = sys.argv[4] 
except:
    print "sobeled.py approx_adders_dir testing_img output_dir prefix [thold]"
    exit(1)
try:
    thold = sys.argv[5]
    thold_str = "_thold"
except:
    thold = "-1"
    thold_str = ""

for i in map(lambda x: dirname + x , os.listdir(dirname)):
    gates =  i.split('/')[1].split('.')[0]
    if gates == "tmp": continue
    print "Starting detection of "+ i, gates.zfill(3)
    os.system("./sobel_detector"+thold_str+"/sobel "+testing_image+" "+i+" "+thold)
    os.system("cp ./out.png ./"+out_dir+"/"+prefix+"sobel_"+ gates.zfill(3)+".png")
