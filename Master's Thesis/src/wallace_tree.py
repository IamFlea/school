#!/bin/python2

# WOLOLO 
BITCNT = 8
operation = ["BUF", "NOT", "AND", "OR", "XOR", "NAND", "NOR", "XNOR"]
idx = BITCNT*2
d = {("a", 0) : 15, 
     ("a", 1) : 14, 
     ("a", 2) : 13, 
     ("a", 3) : 12, 
     ("a", 4) : 11, 
     ("a", 5) : 10, 
     ("a", 6) : 9, 
     ("a", 7) : 8, 
     ("b", 0) : 7, 
     ("b", 1) : 6, 
     ("b", 2) : 5, 
     ("b", 3) : 4, 
     ("b", 4) : 3, 
     ("b", 5) : 2, 
     ("b", 6) : 1, 
     ("b", 7) : 0
    }
chrom = ""
for i in xrange(BITCNT):
	for j in xrange(BITCNT):
		#print "a_"+str(i),"b_",str(j), "AND", "(["+str(idx)+"]"+str(d["a",i])+","+str(d["b",j])+","+str(operation.index("AND"))+")"
		chrom += "(["+str(idx)+"]"+str(d["a",i])+","+str(d["b",j])+","+str(operation.index("AND"))+")"
		d[j,i] = idx
		idx += 1

def FA(x,y,z):
	global chrom, idx
	chrom += "(["+str(idx)+"]"+str(x)+","+str(y)+","+str(operation.index("XOR"))+")"
	xor_x_y = idx; idx += 1
	chrom += "(["+str(idx)+"]"+str(x)+","+str(y)+","+str(operation.index("AND"))+")"
	and_x_y = idx; idx += 1
	chrom += "(["+str(idx)+"]"+str(xor_x_y)+","+str(z)+","+str(operation.index("XOR"))+")"
	s = idx; idx += 1
	chrom += "(["+str(idx)+"]"+str(xor_x_y)+","+str(z)+","+str(operation.index("AND"))+")"
	and_xor_x_y_z = idx; idx+=1
	chrom += "(["+str(idx)+"]"+str(and_xor_x_y_z)+","+str(and_x_y)+","+str(operation.index("OR"))+")"
	c = idx; idx += 1
	return s, c
def HA(x,y):
	global chrom, idx
	chrom += "(["+str(idx)+"]"+str(x)+","+str(y)+","+str(operation.index("XOR"))+")"
	s = idx; idx += 1
	chrom += "(["+str(idx)+"]"+str(x)+","+str(y)+","+str(operation.index("AND"))+")"
	c = idx; idx += 1
	return s, c
# RTFT [Read the f. thesis]
s0, c0 = HA(d[1,0], d[0,1])
s1, c1 = FA(d[2,0], d[1,1], d[0,2])
s2, c2 = FA(d[3,0], d[2,1], d[1,2])
s3, c3 = FA(d[4,0], d[3,1], d[2,2])
s4, c4 = FA(d[5,0], d[4,1], d[3,2])
s5, c5 = FA(d[6,0], d[5,1], d[4,2])
s6, c6 = FA(d[7,0], d[6,1], d[5,2])
s7, c7 = HA(        d[7,1], d[6,2])

s8, c8 = HA(d[1,3], d[0,4])       # left block
s9, c9 = FA(d[2,3], d[1,4], d[0,5])
s10,c10= FA(d[3,3], d[2,4], d[1,5])
s11,c11= FA(d[4,3], d[3,4], d[2,5])
s12,c12= FA(d[5,3], d[4,4], d[3,5])
s13,c13= FA(d[6,3], d[5,4], d[4,5])
s14,c14= FA(d[7,3], d[6,4], d[5,5])
s15,c15= HA(        d[7,4], d[6,5])

s16,c16= HA(c0, s1            )
s17,c17= FA(c1, s2    , d[0,3])
s18,c18= FA(c2, s3    , s8    )
s19,c19= FA(c3, s4    , s9    )
s20,c20= FA(c4, s5    , s10   )
s21,c21= FA(c5, s6    , s11   )
s22,c22= FA(c6, s7    , s12   )
s23,c23= FA(c7, d[7,2], s13   )

s24,c24= HA(c9 ,d[0,6]       )
s25,c25= FA(c10,d[1,6],d[0,7])
s26,c26= FA(c11,d[2,6],d[1,7])
s27,c27= FA(c12,d[3,6],d[2,7])
s28,c28= FA(c13,d[4,6],d[3,7])
s29,c29= FA(c14,d[5,6],d[4,7])
s30,c30= FA(c15,d[6,6],d[5,7])
s31,c31= HA(    d[7,6],d[6,7])

s32,c32= HA(s17,c16)
s33,c33= HA(s18,c17)
s34,c34= FA(s19,c18,c8)
s35,c35= FA(s20,c19,s24)
s36,c36= FA(s21,c20,s25)
s37,c37= FA(s22,c21,s26)
s38,c38= FA(s23,c22,s27)
s39,c39= FA(s14,c23,s28)
s40,c40= HA(s15,    s29)
s41,c41= HA(d[7,5] ,s30)

s42,c42= HA(s33, c32)
s43,c43= HA(s34, c33)
s44,c44= HA(s35, c34)
s45,c45= FA(s36, c35, c24)
s46,c46= FA(s37, c36, c25)
s47,c47= FA(s38, c37, c26)
s48,c48= FA(s39, c38, c27)
s49,c49= FA(s40, c39, c28)
s50,c50= FA(s41, c40, c29)
s51,c51= FA(s31, c41, c30)
s52,c52= HA(d[7,7]  , c31)

s53,c53= HA(s43,c42)
s54,c54= FA(s44,c43,c53)
s55,c55= FA(s45,c44,c54)
s56,c56= FA(s46,c45,c55)
s57,c57= FA(s47,c46,c56)
s58,c58= FA(s48,c47,c57)
s59,c59= FA(s49,c48,c58)
s60,c60= FA(s50,c49,c59)
s61,c61= FA(s51,c50,c60)
s62,c62= FA(s52,c51,c61)
s63,c63= HA(    c52,c62)

outputs= [str(s53),str(s54),str(s55),str(s56),str(s57),str(s58),str(s59),str(s60),str(s61),str(s62),str(s63)]
#print outputs
output_node = "("+ reduce(lambda x,y : y+","+x, outputs)
#print output_node
	#str(s53)+","+str(s54)+","+str(s55)+","+str(s56)+","+str(s57)+","+str(s58)+","+str(s59)+","+str(s60)+","+str(s61)+","+str(s62)+","+str(s63)+","
output_node+= ","+ str(s42) +","+str(s32)+","+str(s16)+","+str(s0)+","+str(d[0,0])+")"

metadata = "{16,16,"+str(idx-1-BITCNT*2)+",1, 2,1, "+str(idx-1-BITCNT*2)+"}"

f = open("8b_multiplier.chr", 'w')
f.write(metadata + chrom+output_node + '\n')
