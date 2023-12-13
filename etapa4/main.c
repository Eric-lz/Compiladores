#include <stdio.h>
#include "ast.h"
extern int yyparse(void);
extern int yylex_destroy(void);
void *arvore = NULL;

int main (int argc, char **argv)
{
  int ret = yyparse(); 
  exporta(arvore);
  astFree(arvore);
  yylex_destroy();
  return ret;
}
