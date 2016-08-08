LIBS = /usr/local/openmpi/gcc-4.9.2/1.8.4/lib/libmpi.a
INC = /usr/local/openmpi/gcc-4.9.2/1.8.4/include

%: %.f90
	gfortran -fopenmp -o $@ $< $(LIBS) -I$(INC)
