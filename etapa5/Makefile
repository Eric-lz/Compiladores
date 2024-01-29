all:
	bison -d parser.y --report=all --report-file=parser.output
	flex scanner.l
#	gcc -fsanitize=address -g -Werror -o etapa4 *.c
	gcc -g -Werror -o etapa4 *.c

test: etapa4
	./etapa4 < input.txt > output.txt
	./output2dot.sh < output.txt > saida.dot
	xdot saida.dot

clean:
	rm -f *.o lex.yy.c parser.tab.* etapa4 *.output *.dot output.txt
