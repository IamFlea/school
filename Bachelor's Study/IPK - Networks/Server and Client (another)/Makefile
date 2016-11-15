####
# Makefile by Petr Dvoracek
CC=g++
CFLAGS=-std=c++98 -pedantic -Wall -W -g
SRCS=client.cpp server.cpp protokol.pdf

.PHONY: pack clean 
all: client server

client: client.o
	$(CC) $(CFLAGS) client.o -o client

server: server.o
	$(CC) $(CFLAGS) server.o -o server

clean:
	rm -f $(OBJS) $(PROJECT)

pack:
	tar -cvzf xdvora0n.tar.gz $(SRCS) Makefile
	zip xdvora0n.zip $(SRCS) Makefile


