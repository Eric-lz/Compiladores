all:
	bison -d parser.y --report=all --report-file=parser.output
	flex scanner.l
	gcc -g -Werror -o etapa3 *.c


test: etapa3
	./etapa3 < input.txt

clean:
	rm -f *.o lex.yy.c parser.tab.* etapa3 *.output
