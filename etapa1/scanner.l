%{

#include "tokens.h"
int line_number = 1;

%}

INT [0-9]+
FLOAT [0-9]*\.[0-9]+
IDENT [_a-z][_a-z0-9]*
SPECIAL [-+!*/%<>{}()=,;]
WHITE [ \t]+
NEW_LINE ("\r\n"|"\n")

%x COMMENTS

%option yylineno
%option noyywrap

%%

"//".* ;

"/*" BEGIN(COMMENTS);

{NEW_LINE} { line_number++; }

{WHITE} ;

"<=" { return TK_OC_LE; }

">=" { return TK_OC_GE; }

"==" { return TK_OC_EQ; }

"!=" { return TK_OC_NE; }

{SPECIAL} { return yytext[0]; }

"&" { return TK_OC_AND; }

"|" { return TK_OC_OR; }

"int" { return TK_PR_INT; }

"float" { return TK_PR_FLOAT; }

"bool" { return TK_PR_BOOL; }

"if" { return TK_PR_IF; }

"else" { return TK_PR_ELSE; }  

"while" { return TK_PR_WHILE; }

"return" { return TK_PR_RETURN; }

"true" { return TK_LIT_TRUE; }

"false" { return TK_LIT_FALSE; }

{FLOAT} { return TK_LIT_FLOAT; }

{INT} { return TK_LIT_INT; }

{IDENT} { return TK_IDENTIFICADOR; }

<COMMENTS>
{
<<EOF>> { return TK_ERRO; }
{NEW_LINE} { line_number++; } 
"*/" BEGIN(0);
}

. { return TK_ERRO; }

%%
