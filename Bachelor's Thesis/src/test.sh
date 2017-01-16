# Make libraries
cd ./cython/v0.1
make
cd ../v0.2
make
cd ../v0.3
make
cd ../..

cd cython/v0.1/
python3 ./test.py > ./results
cd ../v0.2/
python3 ./test.py > ./results
cd ../v0.3/
python3 ./test.py > ./results

cd ../../v0.1/pypy
pypy    ./test.py > ./results
cd ../py2
python2 ./test.py  > ./results
cd ../py3
python3 ./test.py  > ./results

cd ../../v0.2/pypy
pypy    ./test.py > ./results
cd ../py2
python2 ./test.py  > ./results
cd ../py3
python3 ./test.py  > ./results

cd ../../v0.3/pypy
pypy    ./test.py > ./results
cd ../py2
python2 ./test.py  > ./results
cd ../py3
python3 ./test.py  > ./results

cd ../../v0.4/pypy
pypy    ./test.py > ./results
cd ../py2
python2 ./test.py  > ./results
cd ../py3
python3 ./test.py  > ./results

cd ../../v0.5/pypy
pypy    ./test.py > ./results
cd ../py2
python2 ./test.py  > ./results
cd ../py3
python3 ./test.py  > ./results

cd ../../v0.6/pypy
pypy    ./test.py > ./results
cd ../py2
python2 ./test.py  > ./results
cd ../py3
python3 ./test.py  > ./results


cd ../..

python3 parseresults.py > table
# Parse results


