#!/bin/bash

#mpicc --prefix /usr/local/share/OpenMPI -o hello hello.c
#
#mpirun --prefix /usr/local/share/OpenMPI -np $1 hello
#
#rm -f hello


#pocet cisel bud zadam nebo 10 :)
if [ $# -lt 1 ];then 
    numbers=10;
else
    numbers=$1;
fi;

#preklad cpp zdrojaku
mpic++ --prefix /usr/local/share/OpenMPI -o oes es.cpp 2>/dev/null >/dev/null


#vyrobeni souboru s random cisly
dd if=/dev/random bs=1 count=$numbers of=numbers 2>/dev/null >/dev/null

#spusteni
mpirun --prefix /usr/local/share/OpenMPI -np $numbers oes 2>/dev/null


#uklid
rm -f oes numbers


