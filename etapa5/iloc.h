#ifndef _ILOC_H_
#define _ILOC_H_

// Enum que representa o nome das instrucoes (mnemonico)
enum Opcode{loadAI, add, sub, mult, _div, rsubI, and, or, storeAI, cmp_GE, cmp_LE, cmp_GT, cmp_LT, cmp_NE, cmp_EQ, cbr, jumpI};
#define div _div  // gambiarra
// div ja ta declarado na stdlib.h

// Funcao inline que retorna o mnemonico da instrucao em string
static inline char* getOpName(enum Opcode op){
  const char* opNames[] = {"loadAI", "add", "sub", "mult", "div", "rsubI", "and", "or", "storeAI", "cmp_GE", "cmp_LE", "cmp_GT", "cmp_LT", "cmp_NE", "cmp_EQ", "cbr", "jumpI"};

  return (char*) opNames[op]; // o cast (char*) eh pra resolver um warning
}

// Estrutura que define uma operação ILOC
typedef struct{
  char* label;
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

// Insere um novo nodo na lista de instrucoes
// Rotulo (NULL se nao tiver rotulo)
// Mnemonico da instrucao
// Operandos (podem admitir NULL)
ILOC_Node* ilocNewNode(char* rotulo, enum Opcode instrucao, char* operando1, char* operando2, char* operando3);
ILOC_Node* ilocInsertNode(ILOC_Node* list, ILOC_Node* newNode);
void ilocFreeList(ILOC_Node* list);
void ilocPrintList(ILOC_Node* list);

// traduz o enum para o nome da instrucao
char* getOpName(enum Opcode op);

#endif //_ILOC_H_