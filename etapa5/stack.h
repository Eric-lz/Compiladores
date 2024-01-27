#ifndef _PILHA_TABELAS_H_
#define _PILHA_TABELAS_H_

#include "table.h"

#define ERR_UNDECLARED 10 //2.2
#define ERR_DECLARED 	 11 //2.2
#define ERR_VARIABLE 	 20 //2.3
#define ERR_FUNCTION	 21 //2.3

typedef struct pilha_tabelas {
    tabela_simbolos_t *tabela;
    struct pilha_tabelas *anterior;
} pilha_tabelas_t;


pilha_tabelas_t* novaPilha();
pilha_tabelas_t* empilharTabela(pilha_tabelas_t *pilha, tabela_simbolos_t *tabela);
pilha_tabelas_t* desempilharTabela(pilha_tabelas_t *pilha);


tabela_simbolos_t *topoDaPilha(pilha_tabelas_t *pilha);
tabela_simbolos_t *baseDaPilha(pilha_tabelas_t *pilha);

void freePilhaTabelas(pilha_tabelas_t *pilha);
int existeSimboloPilha(pilha_tabelas_t *pilha, const char *chave, simbolo_natureza natureza);
void printPilha(pilha_tabelas_t *pilha);

void declaracao_var(pilha_tabelas_t *pilha, const char *lexema, int num_linha, simbolo_tipo tipo);
void declaracao_func(pilha_tabelas_t *pilha, const char *lexema, int num_linha, simbolo_tipo tipo);
void declaracao_literal(pilha_tabelas_t *pilha, const char *lexema, int num_linha, simbolo_tipo tipo);

simbolo_tipo verifica_declaracao(pilha_tabelas_t *pilha, const char *lexema, simbolo_natureza natureza);

#endif //_PILHA_TABELAS_H_
