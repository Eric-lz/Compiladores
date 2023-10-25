CC=gcc
CFLAGS=-I.
DEPS = tokens.h
OBJ = main.o lex.yy.o utils.o

%.o: %.c $(DEPS) flex
	$(CC) -c -o $@ $< $(CFLAGS)

etapa1: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

flex:
	flex scanner.l

clean:
	rm *.o etapa1
