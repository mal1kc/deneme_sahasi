#include <stdio.h>

int main() {
  int i = 0;
  unsigned short int j = 3;

  for (unsigned short int i = 0; i < j; i++) {
    printf("led yaniyor\n");
    printf("bekle\n");
    printf("led sonuyor\n");
    printf("bekle\n");
  }

baslangic:
  if (i < j) {
    printf("led yaniyor\n");
    printf("bekle 5 sn\n");
    printf("led sonuyor\n");
    printf("bekle 5 sn\n");
    i = i + 1;
    goto baslangic;
  }
  return 0;
}
