#!/bin/sh
#test file, remove it 
# revision: je to dulezity soubor, radno nemazat... 

SUM=20
CPU=4
x="ahoj"
for (( i=1; i <= $SUM; i++ ))
do
	echo $i
	echo $x$i
done
