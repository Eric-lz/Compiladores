/*
Grupo E
Eric Peracchi Pisoni - 00318500
Pedro Arejano Scheunemann - 00335768
*/

%{

#include <stdio.h>
#include <string.h>
#include "stack.h"

int yylex(void);
void yyerror (char const *mensagem);
extern void* arvore;
pilha_tabelas_t *pilha;

%}

%code requires { 
	#include "ast.h" 
	#include "lexvalue.h"
	#include "stack.h"
}

%define parse.error verbose

%union {
  valor_lexico_t valor_lexico;
  vetor_variaveis_t lista_valores_lexicos;
  asd_tree_t *nodo_arvore;
  simbolo_tipo tipo_dado;
}

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
%token<valor_lexico> TK_IDENTIFICADOR
%token<valor_lexico> TK_LIT_INT
%token<valor_lexico> TK_LIT_FLOAT
%token<valor_lexico> TK_LIT_FALSE
%token<valor_lexico> TK_LIT_TRUE
%token TK_ERRO

//%type<nodo_arvore> programa 
//%type<nodo_arvore> programa 

%type<nodo_arvore> programa 					
%type<nodo_arvore> lista 						
%type<nodo_arvore> elemento 					
%type<lista_valores_lexicos> decl_global				
%type<lista_valores_lexicos> ls_var 				
%type<nodo_arvore> funcao
%type<nodo_arvore> cabecalho
// %type<nodo_arvore> parametros
// %type<nodo_arvore> ls_parametros
// %type<nodo_arvore> param 							
%type<tipo_dado> tipo						
%type<nodo_arvore> corpo
%type<nodo_arvore> bloco					
%type<nodo_arvore> ls_comandos	
%type<nodo_arvore> comando	
%type<lista_valores_lexicos> decl_local 			
%type<nodo_arvore> atribuicao 			
%type<nodo_arvore> chamada_func 		
%type<nodo_arvore> argumentos				
%type<nodo_arvore> ls_argumentos 								
%type<nodo_arvore> arg 							
%type<nodo_arvore> retorno 					
%type<nodo_arvore> controle_fluxo 
%type<nodo_arvore> while 					
%type<nodo_arvore> if 							
%type<nodo_arvore> else 						
%type<nodo_arvore> expr   						
%type<nodo_arvore> expr2 				
%type<nodo_arvore> expr3  					
%type<nodo_arvore> expr4 					
%type<nodo_arvore> expr5 				
%type<nodo_arvore> expr6  				
%type<nodo_arvore> expr7  				
%type<nodo_arvore> expr8 					
%type<nodo_arvore> operando
%type<nodo_arvore> literal

%%

inicio: abre_escopo programa fecha_escopo;

abre_escopo: /* vazio */
{
	pilha = empilharTabela(pilha, novaTabela());
};

fecha_escopo: /* vazio */
{
	pilha = desempilharTabela(pilha);
};

programa: lista 
{ 
	$$ = $1; 
	arvore = $$;
};

programa: /* vazio */ 
{ 
	$$ = NULL; 
};

lista: 	elemento lista 
{ 
	if($1 == NULL)
	{
		$$ = $2; 
	}
	else
	{ 
		$$ = $1; 
		astAddChild($$, $2); 
	} 
};

lista:	elemento 
{ 
	$$ = $1; 
};

elemento: decl_global 
{ 
	$$ = NULL; 
};

elemento: funcao 
{ 
	$$ = $1; 
};
		
// Declaracao de variavel global

decl_global: tipo ls_var ';'
{
	for (int i = 0; i < $2.num_variaveis; i++)
	{
		declaracao_var(pilha, $2.variaveis[i].valor, $2.variaveis[i].num_linha, $1);
	}
}; 

ls_var: ls_var ',' TK_IDENTIFICADOR 
{
	adicionarVariavelLista(&($1), $3);
	$$ = $1;
	free($3.valor); 
};

ls_var: TK_IDENTIFICADOR 
{ 
	vetor_variaveis_t lista;
  inicializarListaVariaveis(&lista);
  adicionarVariavelLista(&lista, $1);
  $$ = lista;
	free($1.valor); 
};

// Definicao de Funcoes

funcao: abre_escopo cabecalho corpo fecha_escopo
{ 
	$$ = $2; 
	astAddChild($$, $3); 
};

cabecalho: 	'(' parametros ')' TK_OC_GE tipo '!' TK_IDENTIFICADOR 
{ 
	$$ = astNewNode($7.valor, $5); 
	declaracao_func(pilha, $7.valor, $7.num_linha, $5);
	free($7.valor); 
};
	
parametros: ls_parametros | /* vazio */;

ls_parametros: 	ls_parametros ',' param | param;

param: tipo TK_IDENTIFICADOR 
{ 
	declaracao_var(pilha, $2.valor, $2.num_linha, $1);
	free($2.valor); 
};

tipo: TK_PR_INT 
{
	$$ = SYM_INT;
};

tipo: TK_PR_FLOAT
{
	$$ = SYM_FLOAT;
};

tipo: TK_PR_BOOL
{
	$$ = SYM_BOOL;
};

corpo: bloco 
{ 
	$$ = $1; 
};

// Bloco de comandos

bloco: 	'{' ls_comandos '}' 
{ 
	$$ = $2; 
};

ls_comandos: comando ';' ls_comandos 
{ 
	if($1 == NULL)
	{ 
		$$ = $3; 
	}
	else
	{ 
		$$ = $1; 
		astAddChild($$, $3); 
	}  
}; 

ls_comandos: /* vazio */ 
{ 
	$$ = NULL; 
};

comando: decl_local 
{ 
	$$ = NULL; 
};

comando: atribuicao 		
{ 
	$$ = $1; 
};

comando: chamada_func 		
{ 
	$$ = $1; 
};

comando: retorno 			
{ 
	$$ = $1; 
};

comando: controle_fluxo 	
{ 
	$$ = $1; 
};

comando: abre_escopo bloco fecha_escopo
{ 
	$$ = $2; 
}; 


// Declaracao de variavel local

decl_local: tipo ls_var 
{
	for (int i = 0; i < $2.num_variaveis; i++)
	{
		declaracao_var(pilha,  $2.variaveis[i].valor, $2.variaveis[i].num_linha, $1);
	}
};

// Atribuicao

atribuicao: TK_IDENTIFICADOR '=' expr 
{ 
	simbolo_tipo tipo = verifica_declaracao(pilha, $1.valor, SYM_IDENTIFICADOR);
	$$ = astNewNode("=", tipo); 
	astAddChild($$, astNewNode($1.valor, tipo)); 
	free($1.valor); 
	astAddChild($$, $3); 
};

// Chamada de funcao

chamada_func: TK_IDENTIFICADOR '(' argumentos ')' 
{ 
	simbolo_tipo tipo = verifica_declaracao(pilha, $1.valor, SYM_FUNCAO);
	char label[] = "call "; 
	strcat(label, $1.valor); 
	free($1.valor); 
	$$ = astNewNode(label, tipo); 
	astAddChild($$, $3); 
};

argumentos:	ls_argumentos { $$ = $1; } 
			| /* vazio */ { $$ = NULL; };

ls_argumentos: 	arg ',' ls_argumentos 
{ 
	$$ = $1; 
	astAddChild($$, $3); 
};

ls_argumentos: arg 
{ 
	$$ = $1; 
};
								
arg: expr 
{ 
	$$ = $1; 
};

// Retorno

retorno: TK_PR_RETURN expr 
{ 
	$$ = astNewNode("return", $2->tipo_dado); 
	astAddChild($$, $2); 
};

// Controle de fluxo

controle_fluxo: while 
{ 
	$$ = $1; 
};

controle_fluxo: if 
{ 
	$$ = $1; 
};

// Repeticao while

while: 	TK_PR_WHILE '(' expr ')' bloco 
{ 
	$$ = astNewNode("while", $3->tipo_dado); 
	astAddChild($$, $3); 
	astAddChild($$, $5); 
};

// Condicional if

if: TK_PR_IF '(' expr ')' bloco else 
{ 
	$$ = astNewNode("if", $3->tipo_dado); 
	astAddChild($$, $3); 
	astAddChild($$, $5); 
	astAddChild($$, $6); 
};

else: TK_PR_ELSE bloco 
{ 
	$$ = $2; 
};

else: /* vazio */ 
{ 
	$$ = NULL; 
};


// Expressoes

expr:  expr TK_OC_OR expr2 
{ 
	$$ = astNewNode("|", infere_tipo($1->tipo_dado, $3->tipo_dado));
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr: expr2 
{ 
	$$ = $1; 
};
		
expr2: 	expr2 TK_OC_AND expr3 
{ 
	$$ = astNewNode("&", infere_tipo($1->tipo_dado, $3->tipo_dado));
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr2: expr3 
{ 
	$$ = $1; 
};
	
expr3: expr3 TK_OC_EQ expr4 
{ 
	$$ = astNewNode("==", infere_tipo($1->tipo_dado, $3->tipo_dado)); 
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr3: expr3 TK_OC_NE expr4 
{ 
	$$ = astNewNode("!=", infere_tipo($1->tipo_dado, $3->tipo_dado)); 
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr3: expr4 
{ 
	$$ = $1; 
};
	
expr4: expr4 '<' expr5 
{ 
	$$ = astNewNode("<", infere_tipo($1->tipo_dado, $3->tipo_dado)); 
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr4: expr4 '>' expr5 
{ 
	$$ = astNewNode(">", infere_tipo($1->tipo_dado, $3->tipo_dado));
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr4: expr4 TK_OC_LE expr5 
{ 
	$$ = astNewNode("<=", infere_tipo($1->tipo_dado, $3->tipo_dado));
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr4: expr4 TK_OC_GE expr5 
{ 
	$$ = astNewNode(">=", infere_tipo($1->tipo_dado, $3->tipo_dado));
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr4: expr5 
{ 
	$$ = $1; 
};
	
expr5: expr5 '+' expr6 
{ 
	$$ = astNewNode("+", infere_tipo($1->tipo_dado, $3->tipo_dado));
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr5: expr5 '-' expr6 
{ 
	$$ = astNewNode("-", infere_tipo($1->tipo_dado, $3->tipo_dado));
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr5: expr6 
{ 
	$$ = $1; 
};
	
expr6: expr6 '*' expr7 
{ 
	$$ = astNewNode("*", infere_tipo($1->tipo_dado, $3->tipo_dado));
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr6: expr6 '/' expr7 
{ 
	$$ = astNewNode("/", infere_tipo($1->tipo_dado, $3->tipo_dado));
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr6: expr6 '%' expr7 
{ 
	$$ = astNewNode("%", infere_tipo($1->tipo_dado, $3->tipo_dado));
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr6: expr7 
{ 
	$$ = $1; 
};
	
expr7: '-' expr7 
{ 
	$$ = astNewNode("-", $2->tipo_dado);
	astAddChild($$, $2); 
};

expr7: '!' expr7 
{ 
	$$ = astNewNode("!", $2->tipo_dado);
	astAddChild($$, $2); 
};

expr7: expr8 
{ 
	$$ = $1; 
};
	
expr8: '(' expr ')' 
{ 
	$$ = $2; 
};

expr8: operando 
{ 
	$$ = $1; 
};

operando: TK_IDENTIFICADOR 
{ 
	simbolo_tipo tipo = verifica_declaracao(pilha, $1.valor, SYM_IDENTIFICADOR);
	$$ = astNewNode($1.valor, tipo); 
	free($1.valor);
};

operando: literal 
{ 
	$$ = $1; 
};

operando: chamada_func 
{ 
	$$ = $1; 
};  
	
literal: TK_LIT_INT 
{ 
	declaracao_literal(pilha, $1.valor, $1.num_linha, SYM_INT);
	$$ = astNewNode($1.valor, SYM_FLOAT); 
	free($1.valor); 
};

literal: TK_LIT_FLOAT 
{ 
	declaracao_literal(pilha, $1.valor, $1.num_linha, SYM_FLOAT);
	$$ = astNewNode($1.valor, SYM_FLOAT); 
	free($1.valor);
};

literal: TK_LIT_TRUE 
{ 
	declaracao_literal(pilha, $1.valor, $1.num_linha, SYM_BOOL);
	$$ = astNewNode($1.valor, SYM_BOOL); 
	free($1.valor);
};

literal: TK_LIT_FALSE 
{ 
	declaracao_literal(pilha, $1.valor, $1.num_linha, SYM_BOOL);
	$$ = astNewNode($1.valor, SYM_BOOL); 
	free($1.valor);
};

%%
