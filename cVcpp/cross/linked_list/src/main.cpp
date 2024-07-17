#include "linked_list.hpp"
#include <cassert>
#include <cstdlib>
#include <iostream>

void testAddNode() {
  LinkedList list;
  LLNode node1("1", "name1", 1);
  LLNode node2("2", "name2", 2);
  LLNode node3("3", "name3", 3);

  list.addNode(&node1);
  list.addNode(&node2);
  list.addNodeHead(&node3);

  assert(list.head->ID == "3");
  assert(list.head->name == "name3");
  assert(list.head->value == 3);

  std::cout << "OK:addNodeHead" << "\n";

  assert(list.tail->ID == "2");
  assert(list.tail->name == "name2");
  assert(list.tail->value == 2);

  std::cout << "OK:addNode" << "\n";
}

void testRemoveNode1() {
  LinkedList list;
  LLNode node1("1", "name1", 1);
  LLNode node2("2", "name2", 2);
  LLNode node3("3", "name3", 3);

  list.addNodeHead(&node1);
  list.addNode(&node2);
  list.addNode(&node3);

  list.rmNode(&node1);

  assert(list.head->ID == "2");
  assert(list.head->name == "name2");
  assert(list.head->value == 2);

  assert(list.tail->ID == "3");
  assert(list.tail->name == "name3");
  assert(list.tail->value == 3);

  std::cout << "OK:rmNode1" << "\n";
}

void testRemoveNode2() {
  LinkedList list;
  LLNode node1("1", "name1", 1);
  LLNode node2("2", "name2", 2);
  LLNode node3("3", "name3", 3);

  list.addNodeHead(&node1);
  list.addNode(&node2);
  list.addNode(&node3);

  list.rmNode(&node2);

  assert(list.head->ID == "1");
  assert(list.head->name == "name1");
  assert(list.head->value == 1);

  assert(list.tail->ID == "3");
  assert(list.tail->name == "name3");
  assert(list.tail->value == 3);

  std::cout << "OK:rmNode2" << "\n";
}

void testRemoveNode3() {
  LinkedList list;
  LLNode node1("1", "name1", 1);
  LLNode node2("2", "name2", 2);
  LLNode node3("3", "name3", 3);

  list.addNodeHead(&node1);
  list.addNode(&node2);
  list.addNode(&node3);

  list.rmNode(&node3);

  assert(list.head->ID == "1");
  assert(list.head->name == "name1");
  assert(list.head->value == 1);

  assert(list.tail->ID == "2");
  assert(list.tail->name == "name2");
  assert(list.tail->value == 2);

  std::cout << "OK:rmNode3" << "\n";
}

int main(int argc, char *argv[]) {
  testAddNode();
  testRemoveNode1();
  testRemoveNode2();
  testRemoveNode3();
  return EXIT_SUCCESS;
}
