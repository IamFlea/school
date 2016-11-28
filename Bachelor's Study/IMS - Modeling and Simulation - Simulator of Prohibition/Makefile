# Meke fail do projektu IMS
# Autori: Josef Kylousek <xkylou00@stud.fit.vutbr.cz>
#         Petr Dvoracek  <xdvora0n@stud.fit.vutbr.cz>
# Date:   Nov-Dec, 2012

# Prekladac
CC=g++
# Parametry prekladu
CFLAGS=-std=c++98 -pedantic -Wall -W -g #-lm -lsimlib 
# Nazev projektu
PROJECT=simulace
# Objekty 
OBJS=main.o 

# Neni nazev souboru
.PHONY: pack clean dep cleanvim run

# Spoji objekty?
all: $(OBJS)
	g++ -O2 -g -o model main.cpp -lsimlib -lm

run:
	./model 

# Udela obejkty
#*.o : *.cpp *.h
#	$(CC) $(CFLAGS) -c -o $@ $< -lsimlib -lm

clean:
	rm -f $(OBJS) $(PROJECT)

# Smazani bordelu (zaloznich souboru?) od vimu 
cleanvim:
	rm -f *~

# Archivace
pack:
	zip -r    08_xkylou00_xdvora0n.zip    Makefile *.cpp *.h dokumentace.pdf input
	tar -cvzf 08_xkylou00_xdvora0n.tar.gz Makefile *.cpp *.h dokumentace.pdf input
