# Make fail 
.PHONY: clean, py2, py3, pack
all: py3
py3:
	# Links modules..
	cat cgp_core.py > cgp_linked.pyx
	cat cgp_circuit.py >> cgp_linked.pyx
	cat cgp_equation.py >> cgp_linked.pyx
	cat cgp.py >> cgp_linked.pyx
	# Building 
	python3 -c "from distutils.core import setup; from distutils.extension import Extension; from Cython.Distutils import build_ext; setup( name = 'Cartesian Genetic Programming', cmdclass = {'build_ext': build_ext}, ext_modules = [Extension('cgp', ['cgp_linked.pyx'])]);" build_ext --inplace

py2:
	echo "Not supported"
	#cat cgp_core.pyx > cgp_linked.pyx
	#cat cgp_circuit.pyx >> cgp_linked.pyx
	#cat cgp_equation.pyx >> cgp_linked.pyx
	#cat cgp.pyx >> cgp_linked.pyx
	## Building 
	#python2 -c "from distutils.core import setup; from distutils.extension import Extension; from Cython.Distutils import build_ext; setup( name = 'Cartesian Genetic Programming', cmdclass = {'build_ext': build_ext}, ext_modules = [Extension('cgp', ['cgp_linked.pyx'])]);" build_ext --inplace

clean: 
	rm -rf cgp.c cgp_core.c cgp_equation.c cgp_circuit.c *.so build/

pack:
	tar -cvzf cgp4py.tar.gz Makefile cgp.pyx cgp_core.pyx cgp_equation.pyx cgp_circuit.pyx
	zip cgp4py.zip Makefile cgp.pyx cgp_core.pyx cgp_equation.pyx cgp_circuit.pyx 

	
