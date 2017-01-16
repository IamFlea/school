#!/bin/sh

echo "TODO: MAKE NEW TESTS"
exit 1
echo "Running acceleration tests for SAD method. Please wait few hours."
echo
gen=1000000
echo "" >make.log
echo "" >normal_adder3_3.log
echo "" >normal_adder4_4.log
echo "" >normal_adder5_5.log
echo "" >normal_adder6_6.log

echo "" >normal_multiplier4x4.log
echo "" >normal_multiplier5x5.log
echo "" >normal_multiplier6x6.log


echo "" >jit_adder3_3.log
echo "" >jit_adder4_4.log
echo "" >jit_adder5_5.log
echo "" >jit_adder6_6.log

echo "" >jit_multiplier4x4.log
echo "" >jit_multiplier5x5.log
echo "" >jit_multiplier6x6.log

echo "" >jit_woc_adder3_3.log
echo "" >jit_woc_adder4_4.log
echo "" >jit_woc_adder5_5.log
echo "" >jit_woc_adder6_6.log

echo "" >jit_woc_multiplier4x4.log
echo "" >jit_woc_multiplier5x5.log
echo "" >jit_woc_multiplier6x6.log
for i in {0..9} 
do  
    seed=$RANDOM
    cd cgp_sad
    make clean >>../make.log 2>>../make.log
    make >>../make.log 2>>../make.log

    echo "3+3"
    ./cgp -s $seed -g $gen data/adder3_3.txt >>../normal_adder3_3.log
    echo "4+4"
    ./cgp -s $seed -g $gen data/adder4_4.txt >>../normal_adder4_4.log
    echo "5+5"
    ./cgp -s $seed -g $gen data/adder5_5.txt >>../normal_adder5_5.log
    echo "6+6"
    ./cgp -s $seed -g $gen data/adder6_6.txt >>../normal_adder6_6.log

    echo "4x4"
    ./cgp -s $seed -g $gen data/multiplier4x4.txt >>../normal_multiplier4x4.log
    echo "5x5"
    ./cgp -s $seed -g $gen data/multiplier5x5.txt >>../normal_multiplier5x5.log
    echo "6x6"
    ./cgp -s $seed -g $gen data/multiplier6x6.txt >>../normal_multiplier6x6.log

    make clean >>../make.log 2>>../make.log
    make jit >>../make.log 2>>../make.log
    echo "3+3"
    ./cgp -s $seed -g $gen data/adder3_3.txt >>../jit_adder3_3.log
    echo "4+4"
    ./cgp -s $seed -g $gen data/adder4_4.txt >>../jit_adder4_4.log
    echo "5+5"
    ./cgp -s $seed -g $gen data/adder5_5.txt >>../jit_adder5_5.log
    echo "6+6"
    ./cgp -s $seed -g $gen data/adder6_6.txt >>../jit_adder6_6.log

    echo "4x4"
    ./cgp -s $seed -g $gen data/multiplier4x4.txt >>../jit_multiplier4x4.log
    echo "5x5"
    ./cgp -s $seed -g $gen data/multiplier5x5.txt >>../jit_multiplier5x5.log
    echo "6x6"
    ./cgp -s $seed -g $gen data/multiplier6x6.txt >>../jit_multiplier6x6.log

    cd ..
    cd cgp_sad_without_fit_compile

    make clean >>../make.log 2>>../make.log
    make jit >>../make.log 2>>../make.log
    echo "3+3"
    ./cgp -s $seed -g $gen data/adder3_3.txt >>../jit_woc_adder3_3.log
    echo "4+4"
    ./cgp -s $seed -g $gen data/adder4_4.txt >>../jit_woc_adder4_4.log
    echo "5+5"
    ./cgp -s $seed -g $gen data/adder5_5.txt >>../jit_woc_adder5_5.log
    echo "6+6"
    ./cgp -s $seed -g $gen data/adder6_6.txt >>../jit_woc_adder6_6.log

    echo "4x4"
    ./cgp -s $seed -g $gen data/multiplier4x4.txt >>../jit_woc_multiplier4x4.log
    echo "5x5"
    ./cgp -s $seed -g $gen data/multiplier5x5.txt >>../jit_woc_multiplier5x5.log
    echo "6x6"
    ./cgp -s $seed -g $gen data/multiplier6x6.txt >>../jit_woc_multiplier6x6.log
    cd ..
done

echo "Benchmark results for 10 runs. Result is average value of evaluations per second."
echo ""
echo "INTERPETED EVALUATION"
echo "---------------------"
echo "Adder 3+3"
cat normal_adder3_3.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Adder 4+4"
cat normal_adder4_4.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Adder 5+5"
cat normal_adder5_5.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Adder 6+6"
cat normal_adder6_6.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'

echo
echo "Multiplier 4x4"
cat normal_multiplier4x4.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Multiplier 5x5"
cat normal_multiplier5x5.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Multiplier 6x6"
cat normal_multiplier6x6.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'

echo 
echo "JIT CHROMOSOME COMPILER"
echo "-----------------------"
echo "Adder 3+3"
cat jit_woc_adder3_3.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Adder 4+4"
cat jit_woc_adder4_4.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Adder 5+5"
cat jit_woc_adder5_5.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Adder 6+6"
cat jit_woc_adder6_6.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'

echo
echo "Multiplier 4x4"
cat jit_woc_multiplier4x4.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Multiplier 5x5"
cat jit_woc_multiplier5x5.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Multiplier 6x6"
cat jit_woc_multiplier6x6.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'

echo 
echo "JIT CHROMOSOME AND FITNESS COMPILER"
echo "-----------------------------------"
echo "Adder 3+3"
cat jit_adder3_3.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Adder 4+4"
cat jit_adder4_4.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Adder 5+5"
cat jit_adder5_5.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Adder 6+6"
cat jit_adder6_6.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'

echo
echo "Multiplier 4x4"
cat jit_multiplier4x4.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Multiplier 5x5"
cat jit_multiplier5x5.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
echo "Multiplier 6x6"
cat jit_multiplier6x6.log | grep Eval | sed -e 's/[^:]*:[^:]*: \(.*\)/\1/g' | awk '{s+=$1} END {print s/10}'
