# Meke fail for TCP SEARCH
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Date:   Nov, 2012

CC=g++
CFLAGS=-std=c++98 -pedantic -Wall -W -g
PROJECT=tcpsearch
OBJS=main.o 

.PHONY: pack clean dep packall

all: $(OBJS)
	$(CC) $(OBJS) -o $(PROJECT)

*.o : *.cpp *.h
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS) $(PROJECT)

pack:
	tar -cvf xdvora0n.tar Makefile *.cpp

packall:
	tar -cvf xdvora0n.tar *
