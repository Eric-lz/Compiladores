#ifndef _TABELA_SIMBOLOS_H_
#define _TABELA_SIMBOLOS_H_

typedef enum { LITERAL, IDENTIFICADOR, FUNCAO } simbolo_natureza;
typedef enum { INT, FLOAT, BOOL } simbolo_tipo;

typedef struct {
    char* lexema;
    int num_linha;
    simbolo_natureza natureza;
    simbolo_tipo tipo;
} tabela_entrada_t;

typedef struct {
    tabela_entrada_t *entradas;
    int num_entradas;
} tabela_simbolos_t;

typedef struct pilha_tabelas {
    tabela_simbolos_t tabela;
    struct pilha_tabelas *anterior;
} pilha_tabelas_t;

char* simbolo_tipo_string(simbolo_tipo tipo);
char* simbolo_natureza_string(simbolo_natureza natureza);

void inicializarTabelaSimbolos(tabela_simbolos_t *tabela);
void adicionarSimbolo(tabela_simbolos_t *tabela, const char *chave, int num_linha, simbolo_natureza natureza, simbolo_tipo tipo, const char* valor);
simbolo_conteudo_t* buscarSimbolo(tabela_simbolos_t *tabela, const char *chave);
void printTabela(tabela_simbolos_t *tabela);

void inicializarPilhaTabelas(NodoPilhaTabelas **pilha);
void empilharTabela(NodoPilhaTabelas **pilha, tabela_simbolos_t tabela);
void desempilharTabela(NodoPilhaTabelas **pilha);
tabela_simbolos_t *topoDaPilha(NodoPilhaTabelas *pilha);
void freePilhaTabelas(NodoPilhaTabelas **pilha);
void printPilha(pilha_tabelas_t **pilha);

#endif //_TABELA_SIMBOLOS_H_
