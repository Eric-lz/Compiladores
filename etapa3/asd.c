#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "asd.h"

asd_tree_t *asd_new(const char *label)
{
  asd_tree_t *ret = NULL;
  ret = calloc(1, sizeof(asd_tree_t));
  if (ret != NULL){
    ret->label = strdup(label);
    ret->number_of_children = 0;
    ret->children = NULL;
  }
  return ret;
}

void asd_free(asd_tree_t *tree)
{
  if (tree != NULL){
    int i;
    for (i = 0; i < tree->number_of_children; i++){
      asd_free(tree->children[i]);
    }
    free(tree->children);
    free(tree->label);
    free(tree);
  }
}

void asd_add_child(asd_tree_t *tree, asd_tree_t *child)
{
  if (tree != NULL && child != NULL){
    tree->number_of_children++;
    tree->children = realloc(tree->children, tree->number_of_children * sizeof(asd_tree_t*));
    tree->children[tree->number_of_children-1] = child;
  }
}

static void _print_labels(asd_tree_t *tree){
  int i;
  if (tree != NULL){
    printf("%p [label=\"%s\"];\n", tree, tree->label);
    for (i = 0; i < tree->number_of_children; i++){
      _print_labels(tree->children[i]);
    }
  }
}

static void _print_tree(asd_tree_t *tree){
  int i;
  if (tree != NULL){
    for (i = 0; i < tree->number_of_children; i++)
      printf("%p, %p\n", tree, tree->children[i]);

    for (i = 0; i < tree->number_of_children; i++)
      _print_tree(tree->children[i]);
  }
}

void exporta(asd_tree_t *tree){
  _print_tree(tree);
  _print_labels(tree);
}
