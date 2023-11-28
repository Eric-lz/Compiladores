/*
Grupo E
Eric Peracchi Pisoni - 00318500
Pedro Arejano Scheunemann - 00335768
*/

%{

#include <stdio.h>
#include <string.h>

int yylex(void);
void yyerror (char const *mensagem);
extern void* arvore;

%}

%code requires { #include "asd.h" }

%define parse.error verbose

%union {
  valor_lexico_t valor_lexico;
  asd_tree_t *nodo_arvore;
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

%type<nodo_arvore> programa 					
%type<nodo_arvore> lista 						
%type<nodo_arvore> elemento 					
//%type<nodo_arvore> decl_global				
//%type<nodo_arvore> ls_var 				
%type<nodo_arvore> funcao
%type<nodo_arvore> cabecalho
// %type<nodo_arvore> parametros
// %type<nodo_arvore> ls_parametros
// %type<nodo_arvore> param 							
// %type<nodo_arvore> tipo						
%type<nodo_arvore> corpo
%type<nodo_arvore> bloco					
%type<nodo_arvore> ls_comandos	
%type<nodo_arvore> comando	
//%type<nodo_arvore> decl_local 			
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
%type<nodo_arvore> or
%type<nodo_arvore> and
%type<nodo_arvore> igual
%type<nodo_arvore> compara
%type<nodo_arvore> addsub
%type<nodo_arvore> muldiv
%type<nodo_arvore> neg


%%

programa: 					lista { $$ = $1; arvore = $$; asd_print_graphviz($$); asd_free($$); }
									| /* vazio */ { $$ = NULL; };

lista: 							elemento lista { if($1 == NULL){ $$ = $2; }else{ $$ = $1; asd_add_child($$, $2); } }
									| elemento { $$ = $1; };

elemento: 					decl_global { $$ = NULL; }
									| funcao { $$ = $1; };
		
// Declaracao de variavel global

decl_global: 				tipo ls_var ';';

ls_var: 						ls_var ',' TK_IDENTIFICADOR 
									| TK_IDENTIFICADOR;

// Definicao de Funcoes

funcao: 						cabecalho corpo { $$ = $1; asd_add_child($$, $2);};

cabecalho: 					'(' parametros ')' TK_OC_GE tipo '!' TK_IDENTIFICADOR { $$ = asd_new(strdup($7.valor)); } ;
	
parametros: 				ls_parametros 
									| /* vazio */;

ls_parametros: 			ls_parametros ',' param 
									| param;

param: 							tipo TK_IDENTIFICADOR;

tipo: 							TK_PR_INT
									| TK_PR_FLOAT 
									| TK_PR_BOOL;

corpo: bloco { $$ = $1; };

// Bloco de comandos

bloco: 						'{' ls_comandos '}' { $$ = $2; }

ls_comandos: 			comando ';' ls_comandos { if($1 == NULL){ $$ = $3; }else{ $$ = $1; asd_add_child($$, $3); }  } // por conta do decl_local => NULL
								| /* vazio */ { $$ = NULL; };

comando: 					decl_local { $$ = NULL; }
								| atribuicao { $$ = $1; }
								| chamada_func { $$ = $1; }
								| retorno { $$ = $1; }
								| controle_fluxo { $$ = $1; }
								| bloco { $$ = $1; };

// Declaracao de variavel local

decl_local: 			tipo ls_var;

// Atribuicao

atribuicao: 			TK_IDENTIFICADOR '=' expr { $$ = asd_new("="); asd_add_child($$, asd_new(strdup($1.valor))); asd_add_child($$, $3); };

// Chamada de funcao

chamada_func: 		TK_IDENTIFICADOR '(' argumentos ')' { char label[] = "call "; strcat(label, strdup($1.valor)); $$ = asd_new(strdup(label)); asd_add_child($$, $3); };

argumentos:				ls_argumentos { $$ = $1; } 
								| /* vazio */ { $$ = NULL; };

ls_argumentos: 		arg ',' ls_argumentos { $$ = $1; asd_add_child($$, $3); }
								| arg { $$ = $1; };
								
arg: 							expr { $$ = $1; };

// Retorno

retorno: 					TK_PR_RETURN expr { $$ = asd_new("return"); asd_add_child($$, $2); };

// Controle de fluxo

controle_fluxo: 	while { $$ = $1; }
								| if { $$ = $1; };

// Repeticao while

while: 						TK_PR_WHILE '(' expr ')' bloco { $$ = asd_new("while"); asd_add_child($$, $3); asd_add_child($$, $5); };

// Condicional if

if: 							TK_PR_IF '(' expr ')' bloco else { $$ = asd_new("if"); asd_add_child($$, $3); asd_add_child($$, $5); asd_add_child($$, $6); };

else: 						TK_PR_ELSE bloco { $$ = $2; }
								| /* vazio */ { $$ = NULL; };

// Expressoes

expr:   					expr or expr2 { $$ = $2; asd_add_child($$,$1); asd_add_child($$,$3); }
								| expr2 { $$ = $1; };
		
expr2: 						expr2 and expr3 { $$ = $2; asd_add_child($$,$1); asd_add_child($$,$3); }
								| expr3 { $$ = $1; };
	
expr3:  					expr3 igual expr4 { $$ = $2; asd_add_child($$,$1); asd_add_child($$,$3); }
								| expr4 { $$ = $1; };
	
expr4:  					expr4 compara expr5 { $$ = $2; asd_add_child($$,$1); asd_add_child($$,$3); }
								| expr5 { $$ = $1; };
	
expr5:  					expr5 addsub expr6 { $$ = $2; asd_add_child($$,$1); asd_add_child($$,$3); }
								| expr6 { $$ = $1; };
	
expr6:  					expr6 muldiv expr7 { $$ = $2; asd_add_child($$,$1); asd_add_child($$,$3); }
								| expr7 { $$ = $1; };
	
expr7:  					neg expr7 { $$ = $1; asd_add_child($$, $2); }
								| expr8 { $$ = $1; };
	
expr8:  					'(' expr ')' { $$ = $2; }
								| operando { $$ = $1; };

operando: 				TK_IDENTIFICADOR { $$ = asd_new(strdup($1.valor)); }
								| literal { $$ = $1; }
								| chamada_func { $$ = $1; };  
	
literal: 					TK_LIT_INT { $$ = asd_new(strdup($1.valor)); }
								| TK_LIT_FLOAT { $$ = asd_new(strdup($1.valor)); }
								| TK_LIT_TRUE { $$ = asd_new(strdup($1.valor)); }
								| TK_LIT_FALSE { $$ = asd_new(strdup(strdup($1.valor))); };

or:       				TK_OC_OR { $$ = asd_new("|"); };

and:      				TK_OC_AND { $$ = asd_new("&"); };

igual:    				TK_OC_EQ { $$ = asd_new("=="); }
								| TK_OC_NE { $$ = asd_new("!="); };
	
compara:  				'<' { $$ = asd_new("<"); }
								| '>' { $$ = asd_new(">"); }
								| TK_OC_LE { $$ = asd_new("<="); }
								| TK_OC_GE { $$ = asd_new(">="); };
	
addsub:   				'+' { $$ = asd_new("+"); }
								| '-' { $$ = asd_new("-"); };
	
muldiv:   				'*' { $$ = asd_new("*"); }
								| '/' { $$ = asd_new("/"); }
								| '%' { $$ = asd_new("%"); };
	
neg:      				'-' { $$ = asd_new("-"); }
								| '!' { $$ = asd_new("!"); };

%%
