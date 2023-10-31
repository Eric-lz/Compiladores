CC=gcc
CFLAGS=-I.
DEPS = tokens.h
OBJ = main.o lex.yy.o utils.o

%.o: %.c $(DEPS) flex
	$(CC) -c -o $@ $< $(CFLAGS)

etapa2: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

bison: parser.tab.o
	bison -d parser.y

flex: scanner.l
	flex scanner.l
	$(CC) -c lex.yy.c $(CFLAGS)

test: etapa2
	./etapa2 < test.txt > output.txt

clean:
	rm -f *.o lex.yy.c parser.tab.* etapa2

pratica:
	bison -d parser.y
	flex scanner.l
	gcc -c *.c
	gcc -o etapa2 *.o