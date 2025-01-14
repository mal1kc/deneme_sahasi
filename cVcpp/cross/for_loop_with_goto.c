#include <stdio.h>

int main() {
  int i = 0;
  unsigned short int j = 3;

  // a basic for loop
  for (unsigned short int i = 0; i < j; i++) {
    printf("working %d \n",j-i);
    printf("wait\n");
  }

  // reset vars
  i = 0;
  j = 3;

  // same shit with goto
loop_start:
  if (i < j) {
    printf("working %d \n",j-i);
    printf("wait \n");
    i = i + 1;
    goto loop_start;
  }
  return 0;
}
