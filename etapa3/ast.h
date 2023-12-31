#ifndef _ARVORE_H_
#define _ARVORE_H_

typedef enum { IDENTIFICADOR, LITERAL } token_tipo;

typedef struct valor_lexico
{
  int num_linha;
  token_tipo tipo;
  char* valor;
} valor_lexico_t;

typedef struct asd_tree 
{
  char *label;
  int number_of_children;
  struct asd_tree **children;
} asd_tree_t;

asd_tree_t *astNewNode(const char *label);

void astFree(asd_tree_t *tree);

void astAddChild(asd_tree_t *tree, asd_tree_t *child);

void exporta(asd_tree_t *tree);

#endif //_ARVORE_H_
