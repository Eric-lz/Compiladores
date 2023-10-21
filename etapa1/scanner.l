%{

#include "tokens.h"

%}

white [ \t]+
minusculo_ [a-z_]
digito [0-9]

%option noyywrap

%%

{white} { }
  
\; { return ';'; }
  
\, { return ','; }
 
\( { return '('; }
 
\) { return ')'; }

\! { return '!'; }
 
\* { return '*'; }
 
\/ { return '/'; }

\% { return '%'; }
  
\+ { return '+'; }
 
\- { return '-'; }
 
\< { return '<'; }

\> { return '>'; }

\{ { return '{'; }
  
\} { return '}'; }
 
\= { return '='; }
 
int { return TK_PR_INT; }

float { return TK_PR_FLOAT; }

bool { return TK_PR_BOOL; }

if { return TK_PR_IF; }

else { return TK_PR_ELSE; }  

while { return TK_PR_WHILE; }

return { return TK_PR_RETURN; }

{digito}*({digito}\.{digito}|\.{digito}){digito}* { return TK_LIT_FLOAT; }

{digito}+ { return TK_LIT_INT; }

{minusculo_}({minusculo_}|{digito})* { return TK_IDENTIFICADOR; }

. { return TK_ERRO; }
 
%%
