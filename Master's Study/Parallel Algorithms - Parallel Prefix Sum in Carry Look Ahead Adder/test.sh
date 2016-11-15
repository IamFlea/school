#!/bin/bash

echoerr() { echo "$@" 1>&2; }

if [ $# -lt 1 ];then 
    size=8
else
    size=$1
fi

size=`python -c "a = $size; a -= 1; a = a | (a>>1); a = a | (a>>2);a=a|(a>>4);a=a|(a>>8);a=a|(a>>16);a=a|(a>>32);a=a|(a>>64); a+=1; print a"`
#prelozime
mpic++ --prefix /usr/local/share/OpenMPI -o mm mm.cpp #2>/dev/null >/dev/null

#pokud neni testovaci soubor, vytvorime
if [ ! -f numbers ]
then
    for line in {0..1}
    do
        rand=""
        for i in $(seq 1 1 $size)
        do
            rand="$rand$((RANDOM%2))"
        done
        echo $rand >>numbers
    done
    cpus=$(($size * 2 - 1 ))
    mpirun --prefix /usr/local/share/OpenMPI -np $cpus mm
    cat numbers >.numbers
    rm numbers
else
    cpus=$(($size * 2 - 1 ))
    mpirun --prefix /usr/local/share/OpenMPI -np $cpus mm
fi 
rm mm
