#include <stdio.h>
#include <stdlib.h>
#include <string.h>

////////////////////// TABELA DE SIMBOLOS //////////////////////

typedef enum { LITERAL, IDENTIFICADOR, FUNCAO } simbolo_natureza;
typedef enum { INT, FLOAT, BOOL } simbolo_tipo;

typedef struct {
    int num_linha;
    simbolo_natureza natureza;
    simbolo_tipo tipo;
    char valor[40];
} simbolo_conteudo_t;

typedef struct {
    char chave[40];
    simbolo_conteudo_t conteudo;
} entrada_tabela_simbolos_t;

typedef struct {
    entrada_tabela_simbolos_t *entradas;
    int num_entradas;
} tabela_simbolos_t;

// Fun��o para inicializar uma tabela de s�mbolos vazia
void inicializarTabelaSimbolos(tabela_simbolos_t *tabela)
{
    tabela->entradas = NULL;
    tabela->num_entradas = 0;
}

// Fun��o para adicionar um s�mbolo � tabela de s�mbolos
void adicionarSimbolo(tabela_simbolos_t *tabela, const char *chave, int num_linha, simbolo_natureza natureza, simbolo_tipo tipo, const char* valor)
{
    tabela->num_entradas++;
    tabela->entradas = realloc(tabela->entradas, tabela->num_entradas * sizeof(entrada_tabela_simbolos_t));
    entrada_tabela_simbolos_t *nova_entrada = &(tabela->entradas[tabela->num_entradas - 1]);

    strcpy(nova_entrada->chave, chave);
    nova_entrada->chave[sizeof(nova_entrada->chave) - 1] = '\0';

    nova_entrada->conteudo.num_linha = num_linha;
    nova_entrada->conteudo.natureza = natureza;
    nova_entrada->conteudo.tipo = tipo;
    strcpy(nova_entrada->conteudo.valor, valor);
}

// Fun��o para buscar um s�mbolo na tabela de s�mbolos
simbolo_conteudo_t* buscarSimbolo(tabela_simbolos_t *tabela, const char *chave)
{
    for (int i = 0; i < tabela->num_entradas; i++)
    {
        if (strcmp(tabela->entradas[i].chave, chave) == 0)
        {
            return &(tabela->entradas[i].conteudo);
        }
    }
    return NULL;  // S�mbolo n�o encontrado
}

//////////////////////////////////////////////////////////////
////////////////////// PILHA DE TABELAS //////////////////////

// Estrutura para representar a pilha de tabelas de s�mbolos
typedef struct NodoPilha
{
    tabela_simbolos_t tabela;
    struct NodoPilha *proximo;
} NodoPilhaTabelas;

// Fun��o para inicializar a pilha de tabelas de s�mbolos
void inicializarPilhaTabelas(NodoPilhaTabelas **pilha)
{
    *pilha = NULL;
}

// Fun��o para empilhar uma tabela de s�mbolos na pilha
void empilharTabela(NodoPilhaTabelas **pilha, tabela_simbolos_t tabela)
{
    NodoPilhaTabelas *novoNodo = malloc(sizeof(NodoPilhaTabelas));
    novoNodo->tabela = tabela;
    novoNodo->proximo = *pilha;
    *pilha = novoNodo;
}

// Fun��o para obter o topo da pilha (a tabela de s�mbolos no topo)
tabela_simbolos_t *topoDaPilha(NodoPilhaTabelas *pilha)
{
    return &pilha->tabela;
}

// Fun��o para desempilhar uma tabela de s�mbolos da pilha
void desempilharTabela(NodoPilhaTabelas **pilha)
{
    if (*pilha == NULL)
    {
        fprintf(stderr, "Erro: Tentativa de desempilhar tabela de s�mbolos de uma pilha vazia.\n");
        exit(EXIT_FAILURE);
    }

    NodoPilhaTabelas *temp = *pilha;
    *pilha = (*pilha)->proximo;
    free(temp->tabela.entradas);
    free(temp);
}

// Fun��o para liberar a mem�ria ocupada pela pilha de tabelas de s�mbolos
void liberarPilhaTabelas(NodoPilhaTabelas **pilha)
{
    while (*pilha != NULL)
    {
        desempilharTabela(pilha);
    }
}

int main() {
    // Exemplo de uso das estruturas
    tabela_simbolos_t tabela1, tabela2;
    inicializarTabelaSimbolos(&tabela1);
    adicionarSimbolo(&tabela1, "x", 10, IDENTIFICADOR, INT, "socket");
    adicionarSimbolo(&tabela2, "y", 15, LITERAL, FLOAT, "32");

    NodoPilhaTabelas *pilha;
    inicializarPilhaTabelas(&pilha);

    empilharTabela(&pilha, tabela1);
    empilharTabela(&pilha, tabela2);

    // Buscar um s�mbolo na tabela no topo da pilha
    const char *chaveBusca = "y";
    simbolo_conteudo_t *dadosSimbolo = buscarSimbolo(topoDaPilha(pilha), chaveBusca);

    if (dadosSimbolo != NULL)
    {
        printf("S�mbolo encontrado:\n");
        printf("Chave: %s\n", chaveBusca);
        printf("Localiza��o: %d\n", dadosSimbolo->num_linha);
        printf("Natureza: %d\n", dadosSimbolo->natureza);
        printf("Tipo: %d\n", dadosSimbolo->tipo);
        printf("Tipo: %s\n", dadosSimbolo->valor);
    }
    else
    {
        printf("S�mbolo n�o encontrado: %s\n", chaveBusca);
    }

    // Liberar a mem�ria ocupada pela pilha de tabelas
    liberarPilhaTabelas(&pilha);

    return 0;

}

