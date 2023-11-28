all:
	bison -d parser.y --report=all --report-file=parser.output
	flex scanner.l
#	gcc -fsanitize=address -g -Werror -o etapa3 *.c
	gcc -g -Werror -o etapa3 *.c

test: etapa3
	./etapa3 < input.txt > output.txt
	./output2dot.sh < output.txt > saida.dot
	xdot saida.dot

clean:
	rm -f *.o lex.yy.c parser.tab.* etapa3 *.output *.dot output.txt
