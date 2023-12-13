/*
Grupo E
Eric Peracchi Pisoni - 00318500
Pedro Arejano Scheunemann - 00335768
*/


// todo create node tem que botar tipo
// nos operadores tb -> tipo segue a regra de inferencia da spec

%{

#include <stdio.h>
#include <string.h>

int yylex(void);
void yyerror (char const *mensagem);
extern void* arvore;

%}

%code requires { #include "ast.h" }

%define parse.error verbose

%union 
{
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

abre_escopo: /* vazio */ 
{

};

fecha_escopo: /* vazio */ 
{

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
	// inserir na tabela cada variavel que vem de ls_Var / faz um for / antes ve se a var nao ta na pilha
}; 

ls_var: ls_var ',' TK_IDENTIFICADOR 
{ 
	free($3.valor); 
};

ls_var: TK_IDENTIFICADOR 
{ 
	free($1.valor); 
};

// Definicao de Funcoes

funcao: cabecalho corpo 
{ 
	$$ = $1; 
	astAddChild($$, $2); 
};

cabecalho: 	'(' parametros ')' TK_OC_GE tipo '!' TK_IDENTIFICADOR 
{ 
	$$ = astNewNode($7.valor); // tipo vai ser igual a tipo
	free($7.valor); 
};
	
parametros: ls_parametros | /* vazio */;

ls_parametros: 	ls_parametros ',' param | param;

param: tipo TK_IDENTIFICADOR 
{ 
	free($2.valor); 
};

tipo: TK_PR_INT | TK_PR_FLOAT | TK_PR_BOOL;

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

comando: decl_local 		{ $$ = NULL; }
		| atribuicao 		{ $$ = $1; }
		| chamada_func 		{ $$ = $1; }
		| retorno 			{ $$ = $1; }
		| controle_fluxo 	{ $$ = $1; }
		| bloco 			{ $$ = $1; };

// Declaracao de variavel local

decl_local: tipo ls_var 
{

};

// Atribuicao

atribuicao: TK_IDENTIFICADOR '=' expr 
{ 
	// passo 1: verificar se tk_ident existe na tabela e se é uma variavel
	$$ = astNewNode("="); // o tipo vai ser o tipo do tk_ident
	astAddChild($$, astNewNode($1.valor)); 
	free($1.valor); 
	astAddChild($$, $3); 
};

// Chamada de funcao

chamada_func: TK_IDENTIFICADOR '(' argumentos ')' 
{ 
	// passo 1: verificar se tk_ident existe na tabela e se é uma função
	char label[] = "call "; 
	strcat(label, $1.valor); 
	free($1.valor); 
	$$ = astNewNode(label); 
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
	$$ = astNewNode("return"); 
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
	$$ = astNewNode("while"); 
	astAddChild($$, $3); 
	astAddChild($$, $5); 
};

// Condicional if

if: TK_PR_IF '(' expr ')' bloco else 
{ 
	$$ = astNewNode("if"); 
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
	$$ = astNewNode("|");
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr: expr2 
{ 
	$$ = $1; 
};
		
expr2: 	expr2 TK_OC_AND expr3 
{ 
	$$ = astNewNode("&");
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr2: expr3 
{ 
	$$ = $1; 
};
	
expr3: expr3 igual expr4 
{ 
	$$ = $2; 
	astAddChild($$,$1); 
	astAddChild($$,$3); 
}

expr3: expr4 
{ 
	$$ = $1; 
};
	
expr4: expr4 compara expr5 
{ 
	$$ = $2; 
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr4: expr5 
{ 
	$$ = $1; 
};
	
expr5: expr5 addsub expr6 
{ 
	$$ = $2; 
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr5: expr6 
{ 
	$$ = $1; 
};
	
expr6: expr6 muldiv expr7 
{ 
	$$ = $2; 
	astAddChild($$,$1); 
	astAddChild($$,$3); 
};

expr6: expr7 
{ 
	$$ = $1; 
};
	
expr7: neg expr7 
{ 
	$$ = $1; 
	astAddChild($$, $2); 
}

expr7: expr8 
{ 
	$$ = $1; 
};
	
expr8: '(' expr ')' 
{ 
	$$ = $2; 
}

expr8: operando 
{ 
	$$ = $1; 
};

operando: TK_IDENTIFICADOR 
{ 
	// procura o tk_ident $1.lexema na tabela de simbolos  
	// se nao encontrar: ERR_UNDECLARED
	// se encontrar: 
	$$ = astNewNode($1.valor); // tem que botar o tipo, procura na tabela
	free($1.valor);
};

operando: literal 
{ 
	$$ = $1; 
}

operando: chamada_func 
{ 
	$$ = $1; 
};  
	
literal: TK_LIT_INT 
{ 
	$$ = astNewNode($1.valor); 
	free($1.valor); 
};

literal: TK_LIT_FLOAT 
{ 
	$$ = astNewNode($1.valor); 
	free($1.valor);
};

literal: TK_LIT_TRUE 
{ 
	$$ = astNewNode($1.valor); 
	free($1.valor);
};

literal: TK_LIT_FALSE 
{ 
	$$ = astNewNode($1.valor); 
	free($1.valor);
};




igual:    				TK_OC_EQ { $$ = astNewNode("=="); }
								| TK_OC_NE { $$ = astNewNode("!="); };
	
compara:  				'<' { $$ = astNewNode("<"); }
								| '>' { $$ = astNewNode(">"); }
								| TK_OC_LE { $$ = astNewNode("<="); }
								| TK_OC_GE { $$ = astNewNode(">="); };
	
addsub:   				'+' { $$ = astNewNode("+"); }
								| '-' { $$ = astNewNode("-"); };
	
muldiv:   				'*' { $$ = astNewNode("*"); }
								| '/' { $$ = astNewNode("/"); }
								| '%' { $$ = astNewNode("%"); };
	
neg:      				'-' { $$ = astNewNode("-"); }
								| '!' { $$ = astNewNode("!"); };

%%
