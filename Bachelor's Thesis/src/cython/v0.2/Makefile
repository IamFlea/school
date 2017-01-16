# Make fail 
.PHONY: clean, py2, py3, pack
all: py3
py3:
	# Building 
	python3 -c "from distutils.core import setup; from distutils.extension import Extension; from Cython.Distutils import build_ext; setup( name = 'Cartesian Genetic Programming', cmdclass = {'build_ext': build_ext}, ext_modules = [Extension('cgp', ['cgp.pyx'])]);" build_ext --inplace

py2:
	# Building 
	python2 -c "from distutils.core import setup; from distutils.extension import Extension; from Cython.Distutils import build_ext; setup( name = 'Cartesian Genetic Programming', cmdclass = {'build_ext': build_ext}, ext_modules = [Extension('cgp', ['cgp.pyx'])]);" build_ext --inplace

clean: 
	rm -rf *.c *.so build/

pack:
	tar -cvzf cgp4py.tar.gz Makefile *.pyx
	zip cgp4py.zip Makefile *.pyx 

	
