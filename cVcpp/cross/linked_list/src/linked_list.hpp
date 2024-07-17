#include <cstdint>
#include <string>
#include <sys/types.h>

class LLNode {
public:
  LLNode *prevNode = nullptr;
  LLNode *nextNode = nullptr;
  std::string ID;
  std::string name;
  uint8_t value;
  LLNode(std::string id, std::string name, uint8_t value) {
    this->prevNode = nullptr;
    this->nextNode = nullptr;
    this->ID = id;
    this->name = name;
    this->value = value;
  }
  ~LLNode() {}

  void RemoveLinks() {
    if (prevNode != nullptr) {
      prevNode->nextNode = nextNode;
    }
    if (nextNode != nullptr) {
      nextNode->prevNode = prevNode;
    }
  }

private:
};

class LinkedList {
public:
  LLNode *head = nullptr;
  LLNode *tail = nullptr;
  LinkedList() {}
  ~LinkedList() {}
  bool addNode(LLNode *node) {
    if (head == nullptr || tail == nullptr) {
      head = node;
      tail = node;
      head->nextNode = nullptr;
      head->prevNode = nullptr;
      return true;
    }
    tail->nextNode = node;
    node->prevNode = tail;
    tail = node;
    return true;
  }

  bool addNodeHead(LLNode *node) {
    if (head == nullptr) {
      return addNode(node);
    }
    head->prevNode = node;
    node->nextNode = head;
    head = node;
    return true;
  }

  bool rmNode(LLNode *node) {
    if (node == head && node == tail) {
      head = nullptr;
      tail = nullptr;
    }
    if (node == head) {
      head = node->nextNode;
      head->prevNode = nullptr;
    } else if (node == tail) {
      tail = node->prevNode;
      tail->nextNode = nullptr;
    }
    node->RemoveLinks();
    return true;
  }

  bool rmNode() { return rmNode(tail); }
};
