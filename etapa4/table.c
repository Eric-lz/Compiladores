#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table.h"
#include "stack.h"

char* simbolo_tipo_string(simbolo_tipo tipo)
{
	switch(tipo)
	{
		case(SYM_INT): return "int"; break;
		case(SYM_FLOAT): return "float"; break;
		case(SYM_BOOL): return "bool"; break;
	}
}

char* simbolo_natureza_string(simbolo_natureza natureza)
{
	switch(natureza)
	{
		case(SYM_LITERAL): return "literal"; break;
		case(SYM_IDENTIFICADOR): return "identificador"; break;
		case(SYM_FUNCAO): return "funcao"; break;
	}
}

tabela_simbolos_t* novaTabela()
{
    tabela_simbolos_t* tabela = calloc(1, sizeof(tabela_simbolos_t));
    tabela->entradas = calloc(1, sizeof(tabela_entrada_t));
    tabela->num_entradas = 0;

    return tabela;
}

void adicionarSimboloTabela(tabela_simbolos_t *tabela, const char *lexema, int num_linha, simbolo_natureza natureza, simbolo_tipo tipo)
{
    tabela->num_entradas++;

    tabela->entradas = realloc(tabela->entradas, tabela->num_entradas * sizeof(tabela_entrada_t));

    tabela_entrada_t *nova_entrada = &(tabela->entradas[tabela->num_entradas - 1]);
    nova_entrada->lexema = strdup(lexema);
    nova_entrada->num_linha = num_linha;
    nova_entrada->natureza = natureza;
    nova_entrada->tipo = tipo;
}

int existeSimboloTabela(tabela_simbolos_t *tabela, const char *chave, simbolo_natureza natureza)
{
    for (int i = 0; i < tabela->num_entradas; i++)
    {
        if (strcmp(tabela->entradas[i].lexema, chave) == 0)
        {
            if (tabela->entradas[i].natureza == natureza)
            {
                return tabela->entradas[i].tipo;
            }
            else
            {
                return tabela->entradas[i].natureza;
            }
        }
    }
    return 0;
}

void printTabela(tabela_simbolos_t *tabela)
{
    for (int i = 0; i < tabela->num_entradas; i++)
    {
        printf("Simbolo: %s ", tabela->entradas[i].lexema);
        printf("| Linha: %d ", tabela->entradas[i].num_linha);
        printf("| Natureza: %s ", simbolo_natureza_string(tabela->entradas[i].natureza));
        printf("| Tipo: %s \n", simbolo_tipo_string(tabela->entradas[i].tipo));
    }
}

simbolo_tipo infere_tipo(simbolo_tipo s1, simbolo_tipo s2)
{
    if (s1 == s2)
    {
        return s1;
    }
    else if ((s1 == SYM_FLOAT && s2 == SYM_INT) || (s2 == SYM_FLOAT && s1 == SYM_INT))
    {
        return SYM_FLOAT;
    }
    else if ((s1 == SYM_BOOL && s2 == SYM_INT) || (s2 == SYM_INT && s1 == SYM_BOOL))
    {
        return SYM_INT;
    }
    else if ((s1 == SYM_BOOL && s2 == SYM_FLOAT) || (s2 == SYM_FLOAT && s1 == SYM_BOOL))
    {
        return SYM_FLOAT;
    }
    return SYM_UNDEFINED;

}
