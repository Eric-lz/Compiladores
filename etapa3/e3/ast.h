// Arquivo header da classe AST
#pragma once
#include <string>
#include <vector>
#include <memory>

using std::vector;
using std::string;
using std::shared_ptr;

typedef struct node_t{
  string label; // placeholder
  vector<shared_ptr<struct node_t>> children;
} Node;

class AST{
  // Attributes
  shared_ptr<Node> root;

public:
  // Constructors
  AST();

  // Methods
  void addChild(string label);
  void addParent(string label);
  void exporta();

private:
  static void _print_labels(shared_ptr<Node> tree);
  static void _print_tree(shared_ptr<Node> &tree);
};