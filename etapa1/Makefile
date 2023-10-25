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
	$(CC) -c lex.yy.c $(CFLAGS)

test: etapa1
	./etapa1 < test.txt > output.txt

clean:
	rm *.o lex.yy.c etapa1
