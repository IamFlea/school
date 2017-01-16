#!/bin/python2
import os, sys
dirname = sys.argv[1]
testing_image = sys.argv[2]
out_dir = sys.argv[3]
prefix = sys.argv[4] if len(sys.argv) > 4 else ""
for i in map(lambda x: dirname + x , os.listdir(dirname)):
    gates =  i.split('/')[1].split('.')[0]
    if gates == "tmp": continue
    print "Starting detection of "+ i, gates.zfill(3)
    # BARBARA
    #os.system("./canny_detection/canny "+testing_image+" 1.5 10 20 "+i)
    # LENA
    #os.system("./canny_detection/canny "+testing_image+" 1.5 20 40 "+i)
    # 
    #os.system("./canny_detection/canny "+testing_image+" 1.5 15 30 "+i)
    #os.system("cp ./out.png ./"+out_dir+"/"+prefix+"edges_"+ gates.zfill(3)+".png")
    # DUMB
    os.system("./canny_detection/canny "+testing_image+" 1.5 0 0 "+i)
    os.system("cp ./out.png ./"+out_dir+"/"+prefix+"edges_"+ gates.zfill(3)+".png")
