#ifndef _ARVORE_H_
#define _ARVORE_H_

#include "table.h"

typedef struct asd_tree
{
  char *label;
  int number_of_children;
  simbolo_tipo tipo_dado;
  struct asd_tree **children;
} asd_tree_t;

asd_tree_t *astNewNode(const char *label, simbolo_tipo tipo);

void astFree(asd_tree_t *tree);

void astAddChild(asd_tree_t *tree, asd_tree_t *child);

void exporta(asd_tree_t *tree);

#endif //_ARVORE_H_
