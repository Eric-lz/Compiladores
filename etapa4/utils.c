/*
Grupo E
Eric Peracchi Pisoni - 00318500
Pedro Arejano Scheunemann - 00335768
*/

#include <stdio.h>

extern int yylineno;

int get_line_number(void)
{
	return yylineno;
}

void yyerror(char *mensagem){
	printf("Na linha %d: %s\n", get_line_number(), mensagem);
}