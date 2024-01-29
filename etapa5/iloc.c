#include <stdio.h>
#include <stdlib.h>
#include "iloc.h"

ILOC_Node* ilocNewNode(char* rotulo, enum Opcode instrucao, char* operando1, char* operando2, char* operando3){
  // Cria nova operacao
  ILOC_Instruction operacao = {
    rotulo,
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

  while(node != NULL){
    char* opname = getOpName(node->code.instrucao);

    if(node->code.label != NULL)
      printf("%s: ", node->code.label);

    switch(node->code.instrucao){
      case loadAI:
      case add:
      case sub:
      case mult:
      case div:
      case rsubI:
      case and:
      case or:
      // case 0 ... 7:  // (isso funciona tbm)
        printf("%s %s, %s => %s\n", opname, node->code.op1, node->code.op2, node->code.op3);
        break;

      case storeAI:
        printf("%s %s => %s, %s\n", opname, node->code.op1, node->code.op2, node->code.op3);
        break;

      case cmp_GE:
      case cmp_LE:
      case cmp_GT:
      case cmp_LT:
      case cmp_NE:
      case cmp_EQ:
      // case cmp_GE ... cmp_NE:  // (isso tbm)
        printf("%s %s, %s -> %s\n", opname, node->code.op1, node->code.op2, node->code.op3);
        break;

      case cbr:
        printf("%s %s -> %s, %s\n", opname, node->code.op1, node->code.op2, node->code.op3);
        break;

      case jumpI:
        printf("%s -> %s\n", opname, node->code.op1);
        break;
    }
    node = node->next;
  }
}

// tem alguns jeitos de fazer uma funcao pra retornar o nome do enum
// um deles eh esse aqui:
/*
char* getOpName(enum Opcode op){
  const char* opNames[] = {"add", "sub", "load", "loadAI", "store", "storeAI"};
  return (char*) opNames[op]; // o cast (char*) eh pra resolver um warning
}
*/

/* tem esse aqui tbm mas acho q prefiro o de primeiro kkk

char* getOpName(enum Opcode op){
  switch(op){
    case add: return "add";
    case sub: return "sub";
    case load: return "load";
    case loadAI: return "loadAI";
    case store: return "store";
    case storeAI: return "storeAI";
  }

  // nunca deve chegar aqui
  return "OPCODE_ERR";
}
*/



/* --------------------------------------------- */
/* Programa de exemplo para testar as estruturas */
/* --------------------------------------------- */

// compilar com:
// gcc iloc.c -o iloc

/*

// cria uma lista ILOC, insere nodos, printa a lista
int main(){
  ILOC_Node* list = NULL;
  ILOC_Node* novo = NULL;

  // cria nova lista de istrucoes ILOC
  list = ilocNewNode(NULL, add, "r1", "r2", "r3");

  // adiciona novas instrucoes na lista
  novo = ilocNewNode("L3", sub, "r4", "r5", "r6");
  ilocInsertNode(list, novo);

  novo = ilocNewNode(NULL, mult, "r4", "r5", "r6");
  ilocInsertNode(list, novo);

  novo = ilocNewNode(NULL, jumpI, "L1", NULL, NULL);
  ilocInsertNode(list, novo);

  novo = ilocNewNode(NULL, cbr, "r1", "L2", "L3");
  ilocInsertNode(list, novo);

  novo = ilocNewNode("L1", loadAI, "r1", "5", "r3");
  ilocInsertNode(list, novo);

  novo = ilocNewNode("L2", storeAI, "r1", "r6", "1");
  ilocInsertNode(list, novo);

  // imrpime lista
  ilocPrintList(list);

  // libera memoria
  ilocFreeList(list);
  
  return 0;
}

*/