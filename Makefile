NAME=hny
CC=clang
CFLAGS=-O3 -ansi -pedantic -Wall
LD=clang
LDFLAGS=-lpthread -larchive
SHAREDFLAG=-shared
LIB=build/lib/lib$(NAME).so
BIN=build/bin/$(NAME)

HEADERS=-I./include/
SOURCES=$(wildcard src/*.c)
OBJECTS=$(patsubst src/%.c, build/obj/%.o, $(SOURCES))
BUILDDIRS=build/ build/obj build/bin build/lib
BINSOURCE=main.c

.PHONY: all doc tests clean

all: $(BUILDDIRS) $(BIN)

doc: $(BUILDDIRS)
	doxygen doc/Doxyfile

tests: all
	./tests/run.sh

clean:
	rm -rf build/

build/obj/%.o: src/%.c
	$(CC) $(CFLAGS) $(HEADERS) -fPIC -o $@ -c $<

$(BUILDDIRS):
	mkdir $@

$(OBJECTS): $(SOURCES)

$(LIB): $(OBJECTS)
	$(LD) $(SHAREDFLAG) -o $@ $^ $(LDFLAGS)

$(BIN): $(BINSOURCE) $(LIB)
	$(CC) $(CFLAGS) $(HEADERS) -o $@ $< -l$(NAME) -L./build/lib

