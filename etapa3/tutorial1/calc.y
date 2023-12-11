%{
#include <math.h>
#include <stdio.h>
int yyerror (char const *s);
extern int yylex (void);
%}

%token NUMBER
%token PLUS TIMES
%token LEFT RIGHT
%token END
%token END_OF_FILE

%define api.value.type { double }

%define parse.error verbose
%start Input

%%

Input: /* A entrada vazia é válida */;
Input: Input Line

Line: END
Line: END_OF_FILE { return EOF; }
Line: E END { printf("Expressão aritmética reconhecida com sucesso. Seu valor é %.2f.\n", $1); }

E: E PLUS T {$$ = $1 + $3;}
E: T {$$ = $1;}

T: T TIMES F {$$ = $1 * $3;}
T: F {$$ = $1;}

F: LEFT E RIGHT {$$ = $2;}
F: NUMBER {$$ = $1;}

%%

extern void yylex_destroy(void);
int yyerror(char const *s) {
  printf("%s\n", s);
  return 1;
}

int main() {
  int ret;
  do {
     ret = yyparse();
  } while(ret != EOF);
  printf("Fim.\n");
  yylex_destroy();
  return 0;
}
