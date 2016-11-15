SRCS=bwted.c bwted.h main.c
OBJS=bwted.o main.o
TARGET=bwted
BLOCK_SIZE=200000
PARAMS=-Wall -std=gnu99 -pedantic -Wall 
#-Werror


.PHONY: pack clean test
#all : $(TARGET)
all: $(OBJS)
	gcc $(OBJS) -o $(TARGET)

bwted.o : bwted.c bwted.h
	gcc $(PARAMS) -c bwted.c -DBLOCK_SIZE=$(BLOCK_SIZE)

main.o : main.c
	gcc $(PARAMS) -c main.c -DBLOCK_SIZE=$(BLOCK_SIZE)
	

	
#vymazani obj souboru
clean:
	rm $(OBJS) $(TARGET)

#vymazani obj souboru
test:
	./$(TARGET) -c -i test.txt -o compressed
	./$(TARGET) -x -i compressed -o test2.txt


#zabaleni
pack:
	zip kko.proj2.xdvora0n.zip $(SRCS) Makefile bwted.pdf
