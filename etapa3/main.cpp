/*
Função principal para realização da análise sintática.

Este arquivo será posterioremente substituído, não acrescente nada.
*/
#include <stdio.h>
#include "parser.tab.h" //arquivo gerado com bison -d parser.y
#include "ast.h"
extern int yyparse(void);
extern int yylex_destroy(void);
AST arvore;

int main (int argc, char **argv)
{
  int ret = yyparse();
  arvore.exporta();
  yylex_destroy();
  return ret;
}