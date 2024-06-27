// C program to implement
// command-line arguments
#include <stdio.h>

// Command Line Arg
int main(int argc, char *argv[]) {
  int i;

  // it needs to be start from 0 not 1 for testing it starts with 1
  for (i = 1; i < argc; i++) {
    // Printing all the Arguments
    printf("%s,", argv[i]);
  }
  printf("\n");
  return 0;
}
