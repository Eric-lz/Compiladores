/*
Grupo E
Eric Peracchi Pisoni - 00318500
Pedro Arejano Scheunemann - 00335768
*/

%{

int yylex(void);
void yyerror (char const *mensagem);

%}

%define parse.error verbose

%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_IF
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_RETURN
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token TK_IDENTIFICADOR
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_LIT_FALSE
%token TK_LIT_TRUE
%token TK_ERRO

%%

// Programa = lista de elementos (pode ser vazia)
programa: lista | /* vazio */ ;
lista: lista elemento | elemento;
elemento: decl_global | funcao;

// Declaracao de variavel global
// tipo + lista de identificadores + ;
decl_global: tipo ls_var ';';
ls_var: ls_var ',' TK_IDENTIFICADOR | TK_IDENTIFICADOR;

// Definicao de Funcoes
// Funcao = cabecalho + corpo
// Cabecalho = (lista de parametros) >= tipo de retorno ! nome da funcao
// Corpo = bloco de comandos
funcao: cabecalho corpo;
cabecalho: '(' parametros ')' TK_OC_GE tipo '!' TK_IDENTIFICADOR;
parametros: ls_parametros | /* vazio */;
ls_parametros: ls_parametros ',' param | param;
param: tipo TK_IDENTIFICADOR;
tipo: TK_PR_INT | TK_PR_FLOAT | TK_PR_BOOL;
corpo: bloco;

// Bloco de comandos
// { lista de comandos simples; } (pode ser vazia)
bloco: '{' ls_comandos '}' ;
ls_comandos: ls_comandos comando ';' | /* vazio */;
comando: decl_local | atribuicao | chamada_func | retorno | controle_fluxo | bloco;

// Declaracao de variavel local
// tipo + lista de identificadores
decl_local: tipo ls_var;

// Atribuicao
atribuicao: TK_IDENTIFICADOR '=' expr;

// Chamada de funcao
chamada_func: TK_IDENTIFICADOR '(' argumentos ')';
argumentos: ls_argumentos | /* vazio */;
ls_argumentos: ls_argumentos ',' arg | arg;
arg: expr;

// Retorno
retorno: TK_PR_RETURN expr;

// Controle de fluxo
controle_fluxo: while | if;

// Repeticao while
while: TK_PR_WHILE '(' expr ')' bloco;

// Condicional if
if: TK_PR_IF '(' expr ')' bloco else;
else: TK_PR_ELSE bloco | /* vazio */;

// Expressoes
expr:   expr  or      expr2 | expr2;
expr2:  expr2 and     expr3 | expr3;
expr3:  expr3 igual   expr4 | expr4;
expr4:  expr4 compara expr5 | expr5;
expr5:  expr5 addsub  expr6 | expr6;
expr6:  expr6 muldiv  expr7 | expr7;
expr7:  neg expr7           | expr8;
expr8:  '(' expr ')'        | operando;

operando: TK_IDENTIFICADOR | literal | chamada_func;
literal: TK_LIT_INT | TK_LIT_FLOAT | TK_LIT_TRUE | TK_LIT_FALSE;

or:       TK_OC_OR;
and:      TK_OC_AND;
igual:    TK_OC_EQ  | TK_OC_NE;
compara:  '<' | '>' | TK_OC_LE | TK_OC_GE;
addsub:   '+' | '-';
muldiv:   '*' | '/' | '%';
neg:      '-' | '!';

%%
