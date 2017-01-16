#!/bin/sh
# Batch file 
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Date: 3rd November 2014
# Filename: batch_heuristic_design_adders.sh
# Description: TODO

CPU=2

# Function
DATA="adder"  #multiplier
BIT_WIDTH=3

# CGP parameters
ROWS=1
COLS=40
# LBACK == COLS
# MAX_USED_NODES == $COLS
ADDED_COLS=2

GENERATIONS=10000000
POPULATION_SIZE=5
MUTATED_GENES=2

# Count of runs.
RUNS=10

# File with seeds, need to be true random! MUST CONTAIN $RUNS NUMBERS!!
FILE_SEEDS="random_seeds_100"

# Method of evaluation of fitness. String must contain one of: 
#    "shd" sum of humming distances
#    "shd_weighted" sum of weighted humming distances
#    "sad" sum of absolute differences
FITNESS_METHOD="shd"

# Method of compilation chromosome. String must be one of these:
#    "" chromosome is interpreted
#    "jit" chromosome is compilated with fitness
#    "jit_nofit" chromosome is compilated without fitness
COMPILE="jit" # budem potrebovat JIT 

LOGDIR_PREFIX="full_"$DATA"_"
DATADIR="data/" # Input data dir must containt files ie. adder4_4.txt .. 

# Obtaining seeds
echo "Obtaining seeds from file "$FILE_SEEDS
i=0
while read in; do 
	SEED[i]=$in 
	let i++
done < $FILE_SEEDS


# Vygenerujeme data. 
echo "Generating data."
python2 adder_generator.py data
python2 multiplier_generator.py data

# Prelozime vse.
echo "Compiling."
cd ../cgp_sad
make clean; make $COMPILE
cd ../cgp_shd
make clean; make $COMPILE
cd ../cgp_shd_weighted
make clean; make $COMPILE
cd ../scripts


DATAFILE=$DATADIR$DATA$BIT_WIDTH"_"$BIT_WIDTH".txt"
LOGDIR=$LOGDIR_PREFIX$BIT_WIDTH"_"$BIT_WIDTH

mkdir $LOGDIR

# Vyvorime klasickou scitacku/nasobicku
echo "Running CGP."
for (( i=1; i <= $RUNS; i++ ))
do
	ulimit -t unlimited
	nohup ../cgp_$FITNESS_METHOD/cgp -g $GENERATIONS -r $ROWS -c $COLS -l $COLS -n $COLS -m $MUTATED_GENES -p $POPULATION_SIZE -s ${SEED[$i]} $DATAFILE >$LOGDIR"/"$i"_run.log" &

	let x=i%$CPU
	if [[ x -eq 0 ]]; then
		wait
	fi
done

# Ulozime si pocet vstupu a vystupu obvodu.
if [ $DATA == "adder" ]; then # 3+3
	let input_width=BIT_WIDTH+BIT_WIDTH  # 6 inputs
	let output_width=BIT_WIDTH+1   #4 outputs
else
	let input_width=BIT_WIDTH+BIT_WIDTH  # 6 in
	let output_width=BIT_WIDTH+BIT_WIDTH # 6 out
fi

echo 
# Spustime testy.
for (( j=$BIT_WIDTH; j < 9; j++ ))
do
	# VYTVARIME obvod s lichym poctem primarnich vstupu ie. 3+4,
	let BIT_WIDTH_A=j 
	let BIT_WIDTH_B=j+1
	let output_width++
	let input_width++
	FILE_SEED="seed_for_"$BIT_WIDTH_A"_"$BIT_WIDTH_B".txt"
	DATAFILE=$DATADIR$DATA$BIT_WIDTH_A"_"$BIT_WIDTH_B".txt"
	let COLS=COLS+ADDED_COLS
	
	# Najdeme plne funkcni obvod
	echo "Finding seed for "$DATA" "$BIT_WIDTH_A" "$BIT_WIDTH_B
	python2 heuristic_full_circuit.py "./"$LOGDIR"/" $ADDED_COLS $input_width $output_width >$FILE_SEED
	if [ $? -eq 1 ]; then # Nenalezli jsme plne funkcni obvod.
		break
	fi
	LOGDIR=$LOGDIR_PREFIX$BIT_WIDTH_A"_"$BIT_WIDTH_B
	mkdir $LOGDIR

	echo "Running tests"
	# Spustime nekolik behu CGP.
	for (( i=1; i <= $RUNS; i++ ))
	do
		ulimit -t unlimited
		nohup ../cgp_$FITNESS_METHOD/cgp -x $FILE_SEED -g $GENERATIONS -r $ROWS -c $COLS -l $COLS -n $COLS -m $MUTATED_GENES -p $POPULATION_SIZE -s ${SEED[$i]} $DATAFILE >$LOGDIR"/"$i"_run.log" &
		# Spustime $CPU procesu
		let x=i%$CPU
		if [[ x -eq 0 ]]; then
			wait # A pockame nez nam dobehnou
		fi
	done
	
	# Vyvarime obvod se sudym poctem primarnich vstupu ie. 4+4
	let BIT_WIDTH_A=j+1
	let BIT_WIDTH_B=j+1
	let input_width++
	if [ $DATA == "multiplier" ]; then
		let output_width++
	fi
	FILE_SEED="seed_for_"$BIT_WIDTH_A"_"$BIT_WIDTH_B".txt"
	DATAFILE=$DATADIR$DATA$BIT_WIDTH_A"_"$BIT_WIDTH_B".txt"
	let COLS=COLS+ADDED_COLS

	# Najdeme plne funkcni obvod
	echo "Finding seed for "$DATA" "$BIT_WIDTH_A" "$BIT_WIDTH_B
	python2 heuristic_full_circuit.py "./"$LOGDIR $ADDED_COLS $input_width $output_width >$FILE_SEED
	if [ $? -eq 1 ]; then # Nenalezli jsme plne funkcni obvod.
		break
	fi
	
	LOGDIR=$LOGDIR_PREFIX$BIT_WIDTH_A"_"$BIT_WIDTH_B
	mkdir $LOGDIR
	echo "Running tests"
	# Spustime nekolik behu CGP.
	for (( i=1; i <= $RUNS; i++ ))
	do
		ulimit -t unlimited
		nohup ../cgp_$FITNESS_METHOD/cgp -x $FILE_SEED -g $GENERATIONS -r $ROWS -c $COLS -l $COLS -n $COLS -m $MUTATED_GENES -p $POPULATION_SIZE -s ${SEED[$i]} $DATAFILE >$LOGDIR"/"$i"_run.log" &
		# Spustime $CPU procesu
		let x=i%$CPU
		if [[ x -eq 0 ]]; then
			wait # A pockame nez nam dobehnou
		fi
	done
done
