#ifndef _ILOC_H_
#define _ILOC_H_

// Enum que representa o nome das instrucoes (mnemonico)
// coloquei alguns aleatorios soh pra testar
enum Opcode{add, sub, load, loadAI, store, storeAI};

// Estrutura que define uma operação ILOC
typedef struct{
  enum Opcode instrucao;
  char* op1;
  char* op2;
  char* op3;
} ILOC_Instruction;

// Lista encadeada de operações ILOC
typedef struct ILOC_Node{
  ILOC_Instruction code;
  struct ILOC_Node* next;
} ILOC_Node;

// Funcoes da lista encadeada
ILOC_Node* ilocNewNode(enum Opcode instrucao, char* operando1, char* operando2, char* operando3);
ILOC_Node* ilocInsertNode(ILOC_Node* list, ILOC_Node* newNode);
void ilocFreeList(ILOC_Node* list);
void ilocPrintList(ILOC_Node* list);

// traduz o enum para o nome da instrucao
char* getOpName(enum Opcode op);

#endif //_ILOC_H_