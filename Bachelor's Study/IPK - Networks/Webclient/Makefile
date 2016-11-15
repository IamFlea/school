# File:   Makefile
# Author: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
#
CC=g++
CFLAGS=-std=c++98 -pedantic -Wall -W -g
PROJECT=webclient
OBJS=webclient.o 

.PHONY: pack clean dep packall
all: webclient

webclient: webclient.o
	$(CC) $(CFLAGS) $(OBJS) -o $(PROJECT)

clean:
	rm -f $(OBJS) $(PROJECT)

pack:
	tar -cvf xdvora0n.tar Makefile *.cpp

packall:
	tar -cvf xdvora0n.tar *
