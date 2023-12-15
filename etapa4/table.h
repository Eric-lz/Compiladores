#ifndef _TABELA_SIMBOLOS_H_
#define _TABELA_SIMBOLOS_H_

typedef enum { SYM_LITERAL, SYM_IDENTIFICADOR, SYM_FUNCAO } simbolo_natureza;
typedef enum { SYM_INT = 4, SYM_FLOAT = 5, SYM_BOOL = 6, SYM_UNDEFINED = 7} simbolo_tipo;

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

char* simbolo_tipo_string(simbolo_tipo tipo);
char* simbolo_natureza_string(simbolo_natureza natureza);

tabela_simbolos_t* novaTabela();
void adicionarSimboloTabela(tabela_simbolos_t *tabela, const char *lexema, int num_linha, simbolo_natureza natureza, simbolo_tipo tipo);
int existeSimboloTabela(tabela_simbolos_t *tabela, const char *chave, simbolo_natureza natureza);
void printTabela(tabela_simbolos_t *tabela);
simbolo_tipo infere_tipo(simbolo_tipo s1, simbolo_tipo s2);

#endif
