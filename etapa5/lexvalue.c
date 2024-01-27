#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lexvalue.h"

void inicializarListaVariaveis(vetor_variaveis_t *lista)
{
	lista->variaveis = NULL;
	lista->num_variaveis = 0;
}

void adicionarVariavelLista(vetor_variaveis_t *lista, valor_lexico_t valor_lexico)
{
	lista->num_variaveis++;
  lista->variaveis = realloc(lista->variaveis, lista->num_variaveis * sizeof(vetor_variaveis_t));

  valor_lexico_t *nova_entrada = &(lista->variaveis[lista->num_variaveis - 1]);
  nova_entrada->num_linha = valor_lexico.num_linha;
  nova_entrada->tipo = valor_lexico.tipo;
  nova_entrada->valor = strdup(valor_lexico.valor);
}
