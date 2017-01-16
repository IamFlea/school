#!/bin/sh
# Batch file 
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Date: 3rd November 2014
# Filename: batch_heuristic_design_adders.sh
# Description: TODO

# Pocet paralelismu
CPU=2 

# Function
REF_DATA="data/adder8_8.txt"  

# CGP parameters
GENERATIONS=100000
GENERATIONS=10
POPULATION_SIZE=5
MUTATION_RATE=5 # V PROCENTECH!!!!!!!!!!

# Count of runs.
RUNS=2 #50

# Obtaining seeds
# File with seeds, need to be true random! MUST CONTAIN $RUNS NUMBERS!!
FILE_SEEDS="random_seeds_100"
i=0
while read in; do 
	SEED[i]=$in 
	let i++
done < $FILE_SEEDS

DATADIR="dumb_adders/"

mkdir $DATADIR 2>/dev/null

# Spustime testy.
CHROM_FILE="kogge_stone_v2.chr"
OUT_FILE_SUFFIX="gated_ks_adder.chr"
for (( j=73; j > 0; j-- ))
do
	mkdir $DATADIR"/"$j 2>/dev/null
	echo "Testing "$j" gated solution"
	#echo "Testing "$j" gated solution" >> mult_run.log
	remove=0
	python2 remove_gate_adder.py $CHROM_FILE $j$OUT_FILE_SUFFIX $REF_DATA #>> mult_run.log
	CHROM_FILE=$j$OUT_FILE_SUFFIX
	cols=`sed 's/{[0-9]*,[0-9]*,\([0-9]*\).*/\1/' <$j"gated_ks_adder.chr"`
	rows=`sed 's/{[0-9]*,[0-9]*,[0-9]*,\([0-9]*\).*/\1/' <$j"gated_ks_adder.chr"`

	let mu=$MUTATION_RATE*$cols*$rows/100
	if [[ $mu -eq 0 ]]; then
		mu=1
	fi
	
	# Spustime nekolik behu CGP.
	for (( i=1; i <= $RUNS; i++ ))
	do
		ulimit -t unlimited
		a=${SEED[$i]}
		b=`date +%s`
		s=`python2 -c "print int(\"$a\")+int(\"$b\")"`
		#echo $s
		nohup ./cgp_sad/cgp_native -x $CHROM_FILE -g $GENERATIONS -r $rows -c $cols -l $cols -n $j -m $mu -p $POPULATION_SIZE -s ${SEED[$i]} $REF_DATA  &>$DATADIR"/"$j"/"$i"_run.log" &
		# Spustime $CPU procesu
		let x=$i%$CPU
		if [[ $x -eq 0 ]]; then
			#echo "Started "$j" run"	
			wait # A pockame nez nam dobehnou
		fi
	done
	wait
	python2 gimmeh_the_best_circuit.py $DATADIR""$j"/"  > $CHROM_FILE
done

