
CC=clang
CFLAGS=-g -Wall

SRC=src
OBJ=obj
BINDIR=bin

SRCS=$(wildcard $(SRC)/*.c)
OBJS=$(patsubst $(SRC)/%.c, $(OBJ)/%.o, $(SRCS))

BIN=$(BINDIR)/main

mkdirs:
	mkdir -p $(BINDIR)
	mkdir -p $(OBJ)

all:$(BIN)

relase: CFLAGS=-Wall -O2 -DNDEBUG
relase: clean
relase: $(BIN)

$(BIN): $(OBJS) mkdirs
	$(CC) $(CFLAGS) $(OBJS) -o $@

$(OBJ)/%.o: $(SRC)/%.c mkdirs
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) -r $(BINDIR)/* $(OBJ)/*

run: $(BIN)
	./$(BIN)
	
