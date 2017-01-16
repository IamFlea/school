#!/bin/python2
# Generates Kogges-stone adder
#   Mile deti, vzdycky komentujte svoje zdrojaky
import sys



dic = {}
cnt = 16
BITSIZE = 8
print "GENERATING FIRST ROW"

operation = ["BUF", "NOT", "AND", "OR", "XOR", "NAND", "NOR", "XNOR"]
inputs = {("y", 0) : 15, 
          ("y", 1) : 14, 
          ("y", 2) : 13, 
          ("y", 3) : 12, 
          ("y", 4) : 11, 
          ("y", 5) : 10, 
          ("y", 6) : 9, 
          ("y", 7) : 8, 
          ("x", 0) : 7, 
          ("x", 1) : 6, 
          ("x", 2) : 5, 
          ("x", 3) : 4, 
          ("x", 4) : 3, 
          ("x", 5) : 2, 
          ("x", 6) : 1, 
          ("x", 7) : 0
         }
chrom = ""
#print inputs
for i in xrange(BITSIZE):
    print str(cnt).rjust(3)+": p_"+str(i)+" = x_"+str(i) + " | y_"+ str(i)
    chrom += "(["+str(cnt)+"]"+str(inputs["x",i])+","+str(inputs["y",i])+","+ str(operation.index("OR")) +")" 
    dic["p", i] = cnt
    cnt += 1
for i in xrange(BITSIZE):
    print str(cnt).rjust(3)+": g_"+str(i)+" = x_"+str(i) + " & y_"+ str(i)
    chrom += "(["+str(cnt)+"]"+str(inputs["x",i])+","+str(inputs["y",i])+","+ str(operation.index("AND")) +")" 
    dic["g", i] = cnt
    cnt += 1
#for i in xrange(BITSIZE):
#    print str(cnt).rjust(3)+": x_"+str(i)+" = x_"+str(i) + " ^ y_"+ str(i)
#    chrom += "(["+str(cnt)+"]"+str(inputs["x",i])+","+str(inputs["y",i])+","+ str(operation.index("XOR")) +")" 
#    dic["x", i] = cnt
#    cnt += 1

step = 1
rows = cnt - 2*BITSIZE # - pocet hradel XOR 
pocet_xor = 0
cols = 1
#{16,9,8,16,2,1,1}([16]7,15,3)([17]6,14,3)([18]5,13,3)([19]4,12,3)([20]3,11,3)([21]2,10,3)([22]1,9,3)([23]0,8,3)([24]7,15,2)([25]6,14,2)([26]5,13,2)([27]4,12,2)([28]3,11,2)([29]2,10,2)([30]1,9,2)([31]0,8,2)([32]17,16,2)([33]18,17,2)([34]19,18,2)([35]20,19,2)([36]21,20,2)([37]22,21,2)([38]23,22,2)([39]17,24,2)([40]18,25,2)([41]19,26,2)([42]20,27,2)([43]21,28,2)([44]22,29,2)([45]23,30,2)([46]7,15,4)([47]6,14,4)([48]25,39,3)([49]26,40,3)([50]27,41,3)([51]28,42,3)([52]29,43,3)([53]30,44,3)([54]31,45,3)([55]0,0,0)([56]0,0,0)([57]0,0,0)([58]0,0,0)([59]0,0,0)([60]0,0,0)([61]0,0,0)([62]0,0,0)([63]0,0,0)([64]33,16,2)([65]34,32,2)([66]35,33,2)([67]36,34,2)([68]37,35,2)([69]38,36,2)([70]33,24,2)([71]34,48,2)([72]35,49,2)([73]36,50,2)([74]37,51,2)([75]38,52,2)([76]5,13,4)([77]4,12,4)([78]3,11,4)([79]2,10,4)([80]49,70,3)([81]50,71,3)([82]51,72,3)([83]52,73,3)([84]53,74,3)([85]54,75,3)([86]0,0,0)([87]0,0,0)([88]0,0,0)([89]0,0,0)([90]0,0,0)([91]0,0,0)([92]0,0,0)([93]0,0,0)([94]0,0,0)([95]0,0,0)([96]66,16,2)([97]67,32,2)([98]68,64,2)([99]69,65,2)([100]66,24,2)([101]67,48,2)([102]68,80,2)([103]69,81,2)([104]1,9,4)([105]0,8,4)([106]0,0,0)([107]0,0,0)([108]0,0,0)([109]0,0,0)([110]0,0,0)([111]0,0,0)([112]82,100,3)([113]83,101,3)([114]84,102,3)([115]85,103,3)([116]0,0,0)([117]0,0,0)([118]0,0,0)([119]0,0,0)([120]0,0,0)([121]0,0,0)([122]0,0,0)([123]0,0,0)([124]0,0,0)([125]0,0,0)([126]0,0,0)([127]0,0,0)([128]46,0,0)([129]24,47,4)([130]48,76,4)([131]80,77,4)([132]81,78,4)([133]112,79,4)([134]113,104,4)([135]114,105,4)([136]0,0,0)([137]0,0,0)([138]0,0,0)([139]0,0,0)([140]0,0,0)([141]0,0,0)([142]0,0,0)([143]0,0,0)(115,135,134,133,132,131,130,129,128)

print "GENERATING SECOND ROW"
while step < BITSIZE:
    cols += 2
    new_dic = dict(dic)
    pew_dic = {}
    sloupec = 0
    for i in xrange(step, BITSIZE):
        print str(cnt).rjust(3)+": p_"+str(i)+","+str(i-step) + " = ["+str(dic["p", i])+"] & ["+str(dic["p", (i-step)])+"]"
        chrom += "(["+str(cnt)+"]"+str(dic["p",i])+","+str(dic["p", (i-step)])+","+ str(operation.index("AND")) +")" 
        new_dic["p", i] = cnt
        sloupec += 1
        cnt += 1
    for i in xrange(step, BITSIZE):
        print str(cnt).rjust(3)+": g_"+str(i)+","+str(i-step) + " = /* ["+str(dic["g", i])+"] | */ ["+str(dic["g", (i-step)])+"] & ["+str(dic["p", i])+"]"
        chrom += "(["+str(cnt)+"]"+str(dic["p",i])+","+str(dic["g", (i-step)])+","+ str(operation.index("AND")) +")" 
        pew_dic[i] = cnt
        cnt += 1
        sloupec += 1
    for i in xrange(rows-sloupec):
        if pocet_xor < BITSIZE:
            print str(cnt).rjust(3)+": x_"+str(pocet_xor)+" = x_"+str(pocet_xor) + " ^ y_"+ str(pocet_xor)
            chrom += "(["+str(cnt)+"]"+str(inputs["x",pocet_xor])+","+str(inputs["y",pocet_xor])+","+ str(operation.index("XOR")) +")" 
            new_dic["x", pocet_xor] = cnt
            pocet_xor+=1
        else:
            chrom += "(["+str(cnt)+"]0,0,0)" 
            
        cnt+=1
    print rows-sloupec
    sloupec = 0
    for i in xrange(step, BITSIZE):
        print str(cnt).rjust(3)+": g_"+str(i)+","+str(i-step) + " = ["+str(dic["g", i])+"] | ["+str(pew_dic[i])+"]"
        chrom += "(["+str(cnt)+"]"+str(dic["g",i])+","+str(pew_dic[i])+","+ str(operation.index("OR")) +")" 
        new_dic["g", i] = cnt
        cnt += 1
        sloupec += 1
    for i in xrange(rows-sloupec):
        chrom += "(["+str(cnt)+"]0,0,0)" 
        cnt+=1
    print rows-sloupec
    dic = new_dic
    step = step << 1
    print
out = []
cols += 1
sloupec = 0
for i in xrange(BITSIZE):
    print str(cnt).rjust(3)+": s_"+str(i)+" = ["+str(dic["g", i]) + "] ^ ["+ str(dic["x", (i)])+"]"
    try:
        chrom += "(["+str(cnt)+"]"+str(dic["g",i-1])+","+str(dic["x", i])+","+ str(operation.index("XOR")) +")" 
    except:
        chrom += "(["+str(cnt)+"]"+str(dic["x", i])+",0,"+ str(operation.index("BUF")) +")" 
    out.append(cnt)
    cnt += 1
    sloupec += 1
print "ADDING CARRY AS OUTPUT"
out.append(dic["g",BITSIZE-1])
for i in xrange(rows-sloupec):
    chrom += "(["+str(cnt)+"]0,0,0)" 
    cnt += 1
chrom +="("
for i in out[::-1]:
    chrom += str(i)+","
chrom = chrom[:-1]
chrom +=")"
print out[::-1]

print "OBTAINED CHROMOSOME"
metadata = "{"+str(2*BITSIZE)+","+str(BITSIZE + 1)+","+str(cols)+","+str(rows)+",2,1,1}"

print metadata+chrom
f = open("kogge_stone.chr", 'w')
f.write(metadata+chrom+'\n')
f.close()
print "OPTIMISE CHROMOSOME VIA circuit.py!!"