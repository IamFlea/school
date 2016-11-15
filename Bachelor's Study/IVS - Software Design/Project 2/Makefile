export LD_LIBRARY_PATH=../curl/lib/.libs/
#prekladac
CC=gcc

#cflags a knihovny
CFLAGS=-std=c99 -pedantic -Wall -W -g -I../curl/include

LIBS=-L../curl/lib/.libs/ -lcurl 
#zdrojove kody
SRCS=*.c *.h 

#objektove soubory
OBJS=file_parity.o get_url.o main.o

#cilovy soubor
TARGET=xdvora0n
	
#phony pack clean etc.. nejsou soubory
.PHONY: pack clean debug doc test dep
.SILENT: test
#all : $(TARGET)
all: $(OBJS)
	gcc -L ../curl/lib/.libs/ -lcurl $(OBJS) -o $(TARGET)

*.o : *.c *.h
	gcc -Wall -I../curl/include/ -std=gnu99 -pedantic -Wall -Werror -c -o $@ $<

#	gcc -Wall -I../curl/include/ -std=gnu99 -pedantic -Wall -Werror -c -o file_parity.o file_parity.c
#	gcc -Wall -I../curl/include/ -std=gnu99 -pedantic -Wall -Werror -c -o main.o main.c
#cilovy program sestaven s obj. souboru
#$(TARGET): $(OBJS)
#	$(CC) $(INCL) -MM *.c
#	$(CC) $(CFLAGS) $(LIBS) -o $@ $(OBJS)


dep:
	$(CC) $(INCL) -MM *.c >makefile.dep


#dokumentace
doc:
	doxygen


#testovani
test:
	if [ ! -e $(TARGET) ]; then echo "Projekt neexistuje. Zkus ho prelozit."; exit 0; fi; \
	OK=0; \
	wget -q http://eva.fit.vutbr.cz/~xdvora0n/hlasky_prvak.txt;\
	./$(TARGET) http://eva.fit.vutbr.cz/~xdvora0n/hlasky_prvak.txt hlasky.txt >/dev/null; \
	if [ `md5sum hlasky_prvak.txt | sed 's/\([^ ]*\).*/\1/'` = `md5sum hlasky.txt | sed 's/\([^ ]*\).*/\1/'` ] ;\
	then \
		echo "Test1: Download OK";\
	else\
		echo "Test1: Download FAILED";\
	fi;\
	echo 1233 >test2 ;\
	if [ `./$(TARGET) ./test2` -eq 1 ] ;\
	then\
		echo "Test2: Parity FAILED";\
	else\
		echo "Test2: Parity OK";\
	fi;\
	echo 1234 >test3 ;\
	if [ `./$(TARGET) ./test3` -eq 0 ];\
	then\
		echo "Test3: Parity FAILED";\
	else\
		echo "Test3: Parity OK";\
	fi;\
	rm -f hlasky_prvak.txt hlasky.txt test2 test3;\


#debuging
debug:
	make -B all "CFLAGS=-g3"

#vymazani obj souboru
clean:
	rm $(OBJS) $(TARGET)

#zabaleni
pack:
	tar -cvzf $(TARGET).tar.gz $(SRCS)
	zip $(TARGET).zip $(SRCS)

-include makefile.dep
