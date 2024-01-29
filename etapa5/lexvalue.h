#ifndef _VALOR_LEXICO_H_
#define _VALOR_LEXICO_H_

typedef enum { TK_IDENT, TK_LIT } token_tipo;

typedef struct valor_lexico
{
  int num_linha;
  token_tipo tipo;
  char* valor;
} valor_lexico_t;

typedef struct {
    valor_lexico_t *variaveis;
    int num_variaveis;
} vetor_variaveis_t;

void inicializarListaVariaveis(vetor_variaveis_t *lista);
void adicionarVariavelLista(vetor_variaveis_t *lista, valor_lexico_t valor_lexico);

#endif //_VALOR_LEXICO_H_
