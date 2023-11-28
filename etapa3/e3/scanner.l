/*
Grupo E
Eric Peracchi Pisoni - 00318500
Pedro Arejano Scheunemann - 00335768
*/

%{

#include "parser.tab.h"

void set_valor_lexico(token_tipo tipo)
{
	valor_lexico_t vl; 
	vl.num_linha = yylineno;
	vl.valor = strdup(yytext);
	vl.tipo = tipo; 
	yylval.valor_lexico = vl;
}

%}

%option yylineno
%option noyywrap

%x COMMENTS

INT [0-9]+
FLOAT [0-9]*\.[0-9]+
IDENT [_a-z][_a-z0-9]*
SPECIAL [-+!*/%<>{}()=,;]
WHITE [ \t]+
NEW_LINE ("\r\n"|"\n")

%%

"//".* ;

"/*" BEGIN(COMMENTS);
<COMMENTS>
{
<<EOF>> { return TK_ERRO; }
"*/" BEGIN(0);
}
<COMMENTS>\n { }
<COMMENTS>. { }

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

"true" { set_valor_lexico(LITERAL); return TK_LIT_TRUE; }

"false" { set_valor_lexico(LITERAL); return TK_LIT_FALSE; }

{FLOAT} { set_valor_lexico(LITERAL); return TK_LIT_FLOAT; }

{INT} { set_valor_lexico(LITERAL); return TK_LIT_INT; }

{IDENT} { set_valor_lexico(IDENTIFICADOR); return TK_IDENTIFICADOR; }

. { return TK_ERRO; }

\n { }

%%
