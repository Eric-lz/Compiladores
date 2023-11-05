CC=gcc
CFLAGS=
OBJ = main.o lex.yy.o utils.o parser.tab.o

%.o: %.c flex
	$(CC) -c -o $@ $< $(CFLAGS)

all: $(OBJ)
	$(CC) -o etapa2 $^ $(CFLAGS)

bison: parser.y
	bison -d parser.y

flex: scanner.l bison
	flex scanner.l

test: etapa2
	./etapa2 < input.txt

clean:
	rm -f *.o lex.yy.c parser.tab.* etapa2
