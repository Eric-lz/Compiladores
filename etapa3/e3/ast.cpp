#include <iostream>
#include <vector>
#include <string>
#include <memory>
#include "ast.h"

using std::vector;
using std::string;
using std::shared_ptr;
using std::make_shared;
using std::cout, std::endl;

AST::AST(){
  root = make_shared<Node>();
}

void AST::addChild(string label){
  shared_ptr<Node> child(new Node);
  child->label = label;
  root->children.push_back(move(child));
}

void AST::addParent(string label){
  if(root->label.empty()){
    root->label = label;
  }
  else{
    shared_ptr<Node> newParent(new Node);
    newParent->label = label;
    newParent->children.push_back(move(root));
    root = move(newParent);
  }
}

void AST::exporta(){
  _print_tree(root);
  _print_labels(root);
}

void AST::_print_labels(shared_ptr<Node> tree){
  const string label = " [label=\"" + tree->label + "\"];";
  cout << tree;
  cout << label << endl;
  
  for (auto child : tree->children){
    _print_labels(child);
  }
}

void AST::_print_tree(shared_ptr<Node> &tree){
  for (auto child : tree->children){
    cout << tree << ", ";
    cout << child << endl;
  }

  for (auto child : tree->children){
    _print_tree(child);
  }
}

// EXAMPLE
int main(){
  AST ast;

  ast.addParent("*");
  ast.addChild("3");
  ast.addChild("4");

  ast.addParent("+");
  ast.addChild("5");

  ast.exporta();
}