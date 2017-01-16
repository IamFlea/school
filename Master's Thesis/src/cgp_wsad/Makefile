all:	cgp_native

cgp_native:	cgp_native.cpp cgp.h compiler.h circ.h
	g++ cgp_native.cpp -o cgp_native -m64

.PHONY: clean

jit:	cgp_native.cpp cgp.h compiler.h circ.h
	g++ cgp_native.cpp -o cgp_native -DCOMPILE -m64

jitfit:	cgp_native.cpp cgp.h compiler.h circ.h
	g++ cgp_native.cpp -o cgp_native -DCOMPILE -DCOMPILE_FITNESS -m64

clean:
	rm -rf cgp_native

