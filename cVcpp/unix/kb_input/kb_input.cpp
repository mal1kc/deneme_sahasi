#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>
#include <termios.h>
#include <unistd.h>

int main() {
  // Save the current terminal settings
  struct termios oldSettings;
  tcgetattr(fileno(stdin), &oldSettings);

  // Create a new terminal settings object and disable canonical mode and local
  // echo
  struct termios newSettings = oldSettings;
  newSettings.c_lflag &= (~ICANON & ~ECHO);

  // Set the new terminal settings
  tcsetattr(fileno(stdin), TCSANOW, &newSettings);

  // Initialize the file descriptor set
  fd_set set;
  FD_ZERO(&set);

  struct timeval tv;
  // Set a timeout of 10 seconds
  tv.tv_sec = 10;
  tv.tv_usec = 0;
  int res = 0;

  int wait_sec = 4;

  // Infinite loop to wait for user input
  while (1) {

    // Clear the file descriptor set and add stdin to it
    FD_ZERO(&set);
    FD_SET(fileno(stdin), &set);

    // Wait for input to become available on stdin for up to 10 seconds
    res = select(fileno(stdin) + 1, &set, NULL, NULL, &tv);

    if (res > 0) {
      // Input is available, read a single character
      char c;
      if (read(fileno(stdin), &c, 1) > 0) {
        tv.tv_sec = wait_sec;
        tv.tv_usec = 0;
        printf("Input available: %c\n - %d\n", c, c);
      }
    } else if (res < 0) {
      // An error occurred
      perror("select error");
      break;
    } else {
      // The timeout expired
      printf("No input after %d seconds, trying again...\n", wait_sec);
    }
  }

  // Restore the original terminal settings
  tcsetattr(fileno(stdin), TCSANOW, &oldSettings);

  return 0;
}
