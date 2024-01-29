#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbols.h"

void inicializarTabelaSimbolos(tabela_simbolos_t *tabela)
{
    tabela->entradas = NULL;
    tabela->num_entradas = 0;
}

void adicionarSimbolo(tabela_simbolos_t *tabela, const char *lexema, int num_linha, simbolo_natureza natureza, simbolo_tipo tipo)
{
    tabela->num_entradas++;
    tabela->entradas = realloc(tabela->entradas, tabela->num_entradas * sizeof(tabela_entrada_t));

    tabela_entrada_t *nova_entrada = &(tabela->entradas[tabela->num_entradas - 1]);
    nova_entrada->lexema = strdup(lexema);
    nova_entrada->num_linha = num_linha;
    nova_entrada->natureza = natureza;
    nova_entrada->tipo = tipo;
}

tabela_entrada_t* buscarSimboloTabela(tabela_simbolos_t *tabela, const char *chave)
{
    for (int i = 0; i < tabela->num_entradas; i++)
    {
        if (strcmp(tabela->entradas[i].lexema, chave) == 0)
        {
            return &(tabela->entradas[i]);
        }
    }
    return NULL;
}

void printTabela(tabela_simbolos_t *tabela)
{
    for (int i = 0; i < tabela->num_entradas; i++)
    {
        printf("Simbolo: %s ", tabela->entradas[i].lexema);
        printf("| Linha: %d ", tabela->entradas[i].num_linha);
        printf("| Tipo: %s ", simbolo_tipo_string(tabela->entradas[i].tipo));
        printf("| Natureza: %s \n", simbolo_natureza_string(tabela->entradas[i].natureza));
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

void inicializarPilhaTabelas(pilha_tabelas_t **pilha)
{
    *pilha = NULL;
}

void empilharTabela(pilha_tabelas_t **pilha, tabela_simbolos_t tabela)
{
    pilha_tabelas_t *novaTabela = malloc(sizeof(pilha_tabelas_t));
    novaTabela->tabela = tabela;
    novaTabela->anterior = *pilha;
    *pilha = novaTabela;
}

void desempilharTabela(pilha_tabelas_t **pilha)
{
    if (*pilha == NULL)
    {
        fprintf(stderr, "Erro: Tentativa de desempilhar uma pilha vazia.\n");
        exit(EXIT_FAILURE);
    }
    pilha_tabelas_t *temp = *pilha;
    *pilha = (*pilha)->anterior;
    free(temp->tabela.entradas);
    free(temp);
}

tabela_simbolos_t *topoDaPilha(pilha_tabelas_t *pilha)
{
    if (pilha == NULL)
    {
        fprintf(stderr, "Erro: Tentativa de pegar topo de uma pilha vazia.\n");
        exit(EXIT_FAILURE);
    }
    return &pilha->tabela;
}

void freePilhaTabelas(pilha_tabelas_t **pilha)
{
    while (*pilha != NULL)
    {
        desempilharTabela(pilha);
    }
}

tabela_entrada_t* buscarSimboloPilha(pilha_tabelas_t **pilha, const char *chave)
{
    pilha_tabelas_t *temp = *pilha;
    while (temp != NULL)
    {
        tabela_entrada_t *simbolo = buscarSimboloTabela(&(temp->tabela), chave);
        if (simbolo != NULL)
        {
            return simbolo;
        }
        temp = temp->anterior;
    }
    return NULL;
}

void printPilha(pilha_tabelas_t **pilha)
{
    pilha_tabelas_t *temp = *pilha;
    while (temp != NULL)
    {
        printTabela(&(temp->tabela));
        temp = temp->anterior;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

int main()
{

    // Exemplo de uso das estruturas
    tabela_simbolos_t tabela1, tabela2;
    inicializarTabelaSimbolos(&tabela1);
    inicializarTabelaSimbolos(&tabela2);
    adicionarSimbolo(&tabela1, "x", 10, IDENTIFICADOR, INT);
    adicionarSimbolo(&tabela1, "z", 11, FUNCAO, BOOL);
    adicionarSimbolo(&tabela2, "f", 12, LITERAL, FLOAT);
    adicionarSimbolo(&tabela2, "g", 13, IDENTIFICADOR, BOOL);

    pilha_tabelas_t *pilha;
    inicializarPilhaTabelas(&pilha);

    empilharTabela(&pilha, tabela1);
    empilharTabela(&pilha, tabela2);

    // Buscar um s�mbolo na tabela no topo da pilha
    const char *chaveBusca = "f";
    tabela_entrada_t *dadosSimbolo = buscarSimboloPilha(&pilha, chaveBusca);

    if (dadosSimbolo != NULL)
    {
        printf("S�mbolo encontrado:\n");
        printf("Chave: %s\n", chaveBusca);
        printf("Localiza��o: %d\n", dadosSimbolo->num_linha);
        printf("Natureza: %d\n", dadosSimbolo->natureza);
        printf("Tipo: %d\n", dadosSimbolo->tipo);
    }
    else
    {
        printf("S�mbolo n�o encontrado: %s\n", chaveBusca);
    }

    freePilhaTabelas(&pilha);

    return 0;
}

