#!/bin/sh
# Batch file 
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Date: 15th February 2014
# Filename: batch_run_fitness_compare.sh
# Description: This script create a paralel runs of n CGPs. It is usefull when you have 2 or more CPUs. 


CPU=10 # How many CGPs can run in paralel.
DATAFILE="./data/adder3_3.txt"   

# CGP parameters
ROWS=1
COLS=20
LBACK=20

GENERATIONS=10000000
POPULATION_SIZE=5
MUTATED_GENES=1

# Count of runs.
RUNS=100

# File with seeds, need to be true random! MUST CONTAIN $RUNS NUMBERS!!
FILE_SEEDS="random_seeds_100"


# Method of evaluation of fitness. String must contain one of: 
#    "shd" sum of humming distances
#    "shd_weighted" sum of weighted humming distances
#    "sad" sum of absolute differences
FITNESS_METHOD="sad"

# Method of compilation chromosome. String must be one of these:
#    "" chromosome is interpreted
#    "jit" chromosome is compilated with fitness
#    "jit_nofit" chromosome is compilated without fitness
COMPILE="" # creating 3_3 adder

# Dir with cgp logs
LOGDIR="sad_3_3adder"




echo "Setting params of CGP"
echo "---------------------"
echo "Cols:  "$COLS" Rows: "$ROWS
echo "Lback: "$LBACK
echo "Generations:   "$GENERATIONS
echo "Mutated genes: "$MUTATED_GENES
echo "Pop size:      "$POPULATION_SIZE
echo
echo "Data file: "$DATAFILE
echo "Fitness: "$FITNESS_METHOD
echo "Optimalization: "$COMPILE
echo "Runs: "$RUNS
echo "Logdir: "$LOGDIR
echo

# Obtaining seeds
echo "Obtaining seeds from file "$FILE_SEEDS
i=0
while read in; do 
	SEED[i]=$in 
	let i++
done < $FILE_SEEDS


# Prelozime vse.
echo "Recompiling CGP"
cd ../cgp_sad
make clean; make $COMPILE
cd ../cgp_shd
make clean; make $COMPILE
cd ../cgp_shd_weighted
make clean; make $COMPILE
cd ../scripts


mkdir $LOGDIR


# Spustime testy.
for (( j=1; j < 15; j++ ))
do
	LOGDIRDIR=$LOGDIR/$j"_gates"
	mkdir $LOGDIRDIR

	echo "Running tests for "$j" gated circuit"
	# Spustime nekolik behu CGP.
	for (( i=1; i <= $RUNS; i++ ))
	do
		ulimit -t unlimited
		nohup ../cgp_$FITNESS_METHOD/cgp -g $GENERATIONS -r $ROWS -c $COLS -l $LBACK -n $j -m $MUTATED_GENES -p $POPULATION_SIZE -s ${SEED[$i]} $DATAFILE >$LOGDIR"/"$j"_gates/"$i"_run.log" &
		# Spustime $CPU procesu
		let x=i%$CPU
		if [[ x -eq 0 ]]; then
			wait # A pockame nez nam dobehnou
		fi
	done
done
