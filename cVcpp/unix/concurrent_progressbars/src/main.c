#include <pthread.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define ESC "\033"
#define CSI "["
#define PREVIOUSLINE "F"

const int PROG_BAR_LENGHT = 30;
const int NUMTHREADS = 5;

typedef struct {
  int count_val;
  int progress;
  pthread_t thread;
} thread_info;

void update_bar(thread_info *tinfo) {
  int num_chars =
      (tinfo->progress * 100 / tinfo->count_val) * PROG_BAR_LENGHT / 100;
  printf("[");
  for (int i = 0; i < num_chars; i++) {
    printf("-");
  }
  for (int i = 0; i < PROG_BAR_LENGHT - num_chars; i++) {
    printf(" ");
  }
  printf("]\n");
}

void *my_thread_func(void *arg) {
  // count up to something;
  thread_info *tinfo = arg;
  for (tinfo->progress = 0; tinfo->progress < tinfo->count_val;
       tinfo->progress++) {
    usleep(1000);
  }
  return NULL;
}

int main(int argc, char *argv[]) {
  thread_info threads[NUMTHREADS];
  for (int i = 0; i < NUMTHREADS; i++) {
    threads[i].count_val = rand() % 10000;
    threads[i].progress = 0;
    pthread_create(&threads[i].thread, NULL, my_thread_func, &threads[i]);
  }
  bool done = false;
  while (!done) {
    done = true;

    for (int i = 0; i < NUMTHREADS; i++) {
      update_bar(&threads[i]);
      if (threads[i].progress < threads[i].count_val) {
        done = false;
      }
    }
    if (!done) {
      printf(ESC CSI "%d" PREVIOUSLINE, NUMTHREADS);
    }
    usleep(1000);
  }

  printf("\nDONE!\n");
  return EXIT_SUCCESS;
}
