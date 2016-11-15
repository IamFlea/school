CC=gcc
CFLAGS=-std=gnu99 -Wall -Wextra -Werror -pedantic -lrt
TARGET=barbers
OBJS=barbers.o
SRCS=makefile *.c #*.h

# LIBS=

all: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)

*.o : *.c # *.h
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean pack test test2 test3 test4
clean:
	rm -f $(OBJS) $(TARGET)

pack:
	tar -cvzf $(TARGET).tar.gz $(SRCS)
	zip $(TARGET).zip $(SRCS)

test:
	./$(TARGET) 10 0 0 1 -

test2:
	./$(TARGET) 10 0 0 10 -

test3:
	./$(TARGET) 1 0 0 10 -

test4:
	./$(TARGET) 3 100 10 10 -
