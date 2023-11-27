CC=g++
CFLAGS=
OBJ = main.o lex.yy.o utils.o parser.tab.o

%.o: %.c flex
	$(CC) -c -o $@ $< $(CFLAGS)

all: $(OBJ)
	$(CC) -o etapa3 $^ $(CFLAGS)

bison: parser.y
	bison -d parser.y --report=all --report-file=parser.output

flex: scanner.l bison
	flex scanner.l

test: etapa3
	./etapa3 < input.txt

example: ast.cpp
	$(CC) ast.cpp -o ast
	./ast | ./output2dot.sh | xdot -

clean:
	rm -f *.o lex.yy.c parser.tab.* etapa3 *.output
