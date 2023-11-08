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

/* 
Um programa na linguagem é composto por dois
elementos, todos opcionais: um conjunto de de-
clarações de variáveis globais e um conjunto de
funções. Esses elementos podem estar intercala-
dos e em qualquer ordem.
*/

// Programa = lista de elementos (pode ser vazia)
programa: lista | /* vazio */ ;
lista: lista elemento | elemento;
elemento: funcao | decl_global;

// Definicao de Funcoes
// Funcao = cabecalho + corpo
// Cabecalho = lista de parametros >= tipo de retorno ! nome da funcao
// Corpo = bloco de comandos
funcao: cabecalho corpo;
cabecalho: '(' ls_parametros ')' TK_OC_GE tipo '!' TK_IDENTIFICADOR;
ls_parametros: parametro | parametro ',' ls_parametros | /* vazio */;
parametro: tipo TK_IDENTIFICADOR;
corpo: bloco;

// Declaracao de variavel global
// tipo + lista de identificadores;
decl_global: tipo TK_IDENTIFICADOR ls_nomes;
tipo: TK_PR_INT | TK_PR_FLOAT | TK_PR_BOOL;
ls_nomes: ',' TK_IDENTIFICADOR ls_nomes | ';';

// Declaracao de variavel local
// tipo + lista de identificadores;
decl_var: tipo TK_IDENTIFICADOR ls_var;
ls_var: ls_var ',' TK_IDENTIFICADOR | /* vazio */;

// Bloco de comandos
// { lista de comandos simples; }
bloco: '{' ls_comandos '}' ;
ls_comandos: ls_comandos comando ';' | /* vazio */;
comando: decl_var;
comando: TK_IDENTIFICADOR TK_OC_EQ expressao;
comando: chamada_func;
comando: TK_PR_RETURN expressao;
comando: controle_fluxo;
comando: /* vazio */;

// Chamada de funcao
chamada_func: nome_func argumentos;
nome_func: TK_IDENTIFICADOR;
argumentos: '(' ls_argumentos ')';
ls_argumentos: expressao;
ls_argumentos: ls_argumentos ',' arg | arg | /* vazio */;
arg: TK_IDENTIFICADOR;

// Controle de fluxo
// Repeticao while
controle_fluxo: TK_PR_WHILE '(' expressao ')' bloco;

// Condicional if
controle_fluxo: TK_PR_IF '(' expressao ')' bloco else;
else: TK_PR_ELSE bloco | /* vazio */;

// Expressoes
expressao: '+' /**/;

%%
