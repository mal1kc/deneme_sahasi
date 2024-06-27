#include <stdio.h>

int main() {
  long long unsigned int i = 0;
  short int check1, check2, check3, check4;
  double pi;

  check1 = check2 = check3 = check4 = 0;

  while (1) {
    i++;

    if (i % 2 == 0) {
      pi -= (double)(4) / (2 * i - 1);
    }

    else {
      pi += (double)(4) / (2 * i - 1);
    }

    if (pi >= 3.14f && pi < 3.15f && check1 == 0) {
      printf("To get 3.14, we have to use %llu terms.\n", i);
      check1 = 1;
    }
    if (pi >= 3.141f && pi < 3.142f && check2 == 0) {
      printf("To get 3.141, we have to use %llu terms.\n", i);
      check2 = 1;
    }
    if (pi >= 3.1415f && pi < 3.1416f && check3 == 0) {
      printf("To get 3.1415, we have to use %llu terms.\n", i);
      check3 = 1;
    }
    if (pi >= 3.14159f && pi < 3.14160f && check4 == 0) {
      printf("To get 3.14159, we have to use %llu terms.", i);
      check4 = 1;
    }
    if (check1 == 1 && check2 == 1 && check3 == 1 && check4 == 1) {
      break;
    }
  }
  return 0;
}
