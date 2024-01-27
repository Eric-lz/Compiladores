#include <stdio.h>
#include <stdlib.h>
#include "iloc.h"

ILOC_Node* ilocNewNode(enum Opcode instrucao, char* operando1, char* operando2, char* operando3){
  // Cria nova operacao
  ILOC_Instruction operacao = {
    instrucao,
    operando1,
    operando2,
    operando3
  };
  
  // Aloca novo node
  ILOC_Node* node = malloc(sizeof(ILOC_Node));
  node->code = operacao;
  node->next = NULL;

  return node;
}

ILOC_Node* ilocInsertNode(ILOC_Node* list, ILOC_Node* newNode){
  // Cria um node auxiliar para percorrer até o final da lista
  ILOC_Node* node = list;
  while(node->next != NULL)
    node = node->next;

  node->next = newNode;

  return list;
}

void ilocFreeList(ILOC_Node* list){
  ILOC_Node* node = list;
  ILOC_Node* next = NULL;
  
  while(node != NULL){
    next = node->next;
    free(node);
    node = next;
  }
}

void ilocPrintList(ILOC_Node* list){
  // Cria um node auxiliar para percorrer até o final da lista
  ILOC_Node* node = list;
  int count = 0;

  while(node != NULL){
    char* opname = getOpName(node->code.instrucao);

    switch(node->code.instrucao){
      case add:
      case sub:
        printf("%d: %s %s, %s => %s\n", count++, opname, node->code.op1, node->code.op2, node->code.op3);
        break;

      case load:
      case store:
        printf("%d: %s %s => %s\n", count++, opname, node->code.op1, node->code.op2);
        break;

      case loadAI:
      case storeAI:
        printf("%d: %s %s, %s => %s\n", count++, opname, node->code.op1, node->code.op2, node->code.op3);
        break;
    }
    node = node->next;
  }
}

char* getOpName(enum Opcode op){
  switch(op){
  case add:
    return "add";
  case sub:
    return "sub";
  case load:
    return "load";
  case loadAI:
    return "loadAI";
  case store:
    return "store";
  case storeAI:
    return "storeAI";
  }

  return "OPCODE_ERR";
}


/* --------------------------------------------- */
/* Programa de exemplo para testar as estruturas */
/* --------------------------------------------- */

// gcc iloc.c -o iloc
// ./iloc

/* <-------- remover para testar

// cria uma lista ILOC, insere nodos, printa a lista
int main(){
  ILOC_Node* list = NULL;
  ILOC_Node* novo = NULL;

  // cria nova lista de istrucoes ILOC
  list = ilocNewNode(add, "r1", "r2", "r3");

  // adiciona novas instrucoes na lista
  novo = ilocNewNode(sub, "r4", "r5", "r6");
  ilocInsertNode(list, novo);

  novo = ilocNewNode(load, "r1", "r2", NULL);
  ilocInsertNode(list, novo);

  novo = ilocNewNode(store, "r1", "r2", NULL);
  ilocInsertNode(list, novo);

  novo = ilocNewNode(loadAI, "r1", "c2", "r3");
  ilocInsertNode(list, novo);

  novo = ilocNewNode(storeAI, "r1", "c2", "r3");
  ilocInsertNode(list, novo);

  // imrpime lista
  ilocPrintList(list);

  // libera memoria
  ilocFreeList(list);
  
  return 0;
}

*/ // <-------- remover para testar