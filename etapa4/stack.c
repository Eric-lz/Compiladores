#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "stack.h"
#include "utils.h"


pilha_tabelas_t* empilharTabela(pilha_tabelas_t *pilha, tabela_simbolos_t *tabela)
{
    pilha_tabelas_t *nova_pilha = calloc(1, sizeof(pilha_tabelas_t));
    nova_pilha->tabela = tabela;
    nova_pilha->anterior = pilha;
    return nova_pilha;
}

pilha_tabelas_t* desempilharTabela(pilha_tabelas_t *pilha)
{
    if (pilha != NULL)
    {
        pilha = pilha->anterior;
    }
    return pilha;
}


tabela_simbolos_t *topoDaPilha(pilha_tabelas_t *pilha)
{
    return pilha->tabela;
}


tabela_simbolos_t *baseDaPilha(pilha_tabelas_t *pilha)
{
    pilha_tabelas_t *temp = pilha;
    while (temp->anterior != NULL)
    {
        temp = temp->anterior;
    }
    return temp->tabela;
}


void freePilhaTabelas(pilha_tabelas_t *pilha)
{
    while (pilha != NULL)
    {
        pilha_tabelas_t *temp = pilha;
        pilha = pilha->anterior;
        free(temp);
    }
}


int existeSimboloPilha(pilha_tabelas_t *pilha, const char *chave, simbolo_natureza natureza)
{
    pilha_tabelas_t* temp = pilha;
    while (temp != NULL)
    {
        int resposta = existeSimboloTabela(temp->tabela, chave, natureza);
        if (resposta)
        {
            return resposta;
        }
        temp = temp->anterior;
    }
    return 0;
}


void printPilha(pilha_tabelas_t *pilha)
{
    pilha_tabelas_t *temp = pilha;
    while (temp != NULL)
    {
        printTabela(temp->tabela);
        temp = temp->anterior;
    }
}


void declaracao_var(pilha_tabelas_t *pilha, const char *lexema, int num_linha, simbolo_tipo tipo)
{
    if (existeSimboloPilha(pilha, lexema, SYM_IDENTIFICADOR))
    {
        printf("ERR_DECLARED: Na linha %d, variavel %s ja foi declarada.\n", get_line_number(), lexema);
        exit(ERR_DECLARED);
    }
    else
    {
        adicionarSimboloTabela(topoDaPilha(pilha), lexema, num_linha, SYM_IDENTIFICADOR, tipo);
    }
}

void declaracao_func(pilha_tabelas_t *pilha, const char *lexema, int num_linha, simbolo_tipo tipo)
{
    if (existeSimboloTabela(baseDaPilha(pilha), lexema, SYM_FUNCAO))
    {
        printf("ERR_DECLARED: Na linha %d, funcao %s ja foi declarada.\n", get_line_number(), lexema);
        exit(ERR_DECLARED);
    }
    else
    {
        adicionarSimboloTabela(baseDaPilha(pilha), lexema, num_linha, SYM_FUNCAO, tipo);
    }
}

void declaracao_literal(pilha_tabelas_t *pilha, const char *lexema, int num_linha, simbolo_tipo tipo)
{
    if (!existeSimboloTabela(topoDaPilha(pilha), lexema, SYM_LITERAL))
    {
        adicionarSimboloTabela(baseDaPilha(pilha), lexema, num_linha, SYM_LITERAL, tipo);
    }
}

simbolo_tipo verifica_declaracao(pilha_tabelas_t *pilha, const char *lexema, simbolo_natureza natureza)
{
    switch(existeSimboloPilha(pilha, lexema, natureza))
    {
        case(0):    printf("ERR_UNDECLARED: Na linha %d, identificador %s nao foi declarado.\n", get_line_number(),lexema);
                    exit(ERR_UNDECLARED);
                    break;
        case(2):    printf("ERR_VARIABLE: Na linha %d, variavel %s usada como funcao.\n", get_line_number(), lexema);
                    exit(ERR_FUNCTION);
                    break;
        case(3):    printf("ERR_FUNCTION: Na linha %d, funcao %s usada como variavel.\n", get_line_number(), lexema);
                    exit(ERR_VARIABLE);
                    break;
        case(4):    return SYM_INT;
                    break;
        case(5):    return SYM_FLOAT;
                    break;
        case(6):    return SYM_BOOL;
                    break;
    }
}
