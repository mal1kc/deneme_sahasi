#include <cstddef>
#include <ctime>
#include <iomanip>
#include <iostream>
#include <ostream>
#include <string>
#include <unistd.h>
int main() {
  using namespace std;
  const string digits[7][10] = {
      {"┏━┓ ", "  ╻  ", " ┏━┓ ", " ┏━┓ ", " ╻ ╻ ", " ┏━┓ ", " ┏   ", " ┏━┓ "," ┏━┓ ", " ┏━┓ "},// "   "},
      {"┃ ┃ ", "  ┃  ", "   ┃ ", "   ┃ ", " ┃ ┃ ", " ┃   ", " ┃   ", "   ┃ "," ┃ ┃ ", " ┃ ┃ "},// " ╻ "},
      {"┃ ┃ ", "  ┃  ", "   ┃ ", "   ┃ ", " ┃ ┃ ", " ┃   ", " ┃   ", "   ┃ "," ┃ ┃ ", " ┃ ┃ "},// "   "},
      {"┃ ┃ ", "  ┃  ", " ┏━┛ ", " ┣━┫ ", " ┗━┫ ", " ┗━┓ ", " ┣━┓ ", "   ┃ "," ┣━┫ ", " ┗━┫ "},// "   "},
      {"┃ ┃ ", "  ┃  ", " ┃   ", "   ┃ ", "   ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ "," ┃ ┃ ", "   ┃ "},// "   "},
      {"┃ ┃ ", "  ┃  ", " ┃   ", "   ┃ ", "   ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ "," ┃ ┃ ", "   ┃ "},// " ╹ "},
      {"┗━┛ ", "  ╹  ", " ┗━━ ", " ┗━┛ ", "   ╹ ", " ┗━┛ ", " ┗━┛ ", "   ╹ "," ┗━┛ ", " ┗━┛ "},// "   "},
  };
  string output_buffer[7][8] = {
      {"┏━┓ ", "┏━┓ ", "   ", "┏━┓ ", "┏━┓ ", "   ", "┏━┓ ", "┏━┓ "},
      {"┃ ┃ ", "┃ ┃ ", " ╻ ", "┃ ┃ ", "┃ ┃ ", " ╻ ", "┃ ┃ ", "┃ ┃ "},
      {"┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ "},
      {"┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ "},
      {"┃ ┃ ", "┃ ┃ ", " ╹ ", "┃ ┃ ", "┃ ┃ ", " ╹ ", "┃ ┃ ", "┃ ┃ "},
      {"┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ ", "   ", "┃ ┃ ", "┃ ┃ "},
      {"┗━┛ ", "┗━┛ ", "   ", "┗━┛ ", "┗━┛ ", "   ", "┗━┛ ", "┗━┛ "},
  };


  time_t now = time(0);
  tm *ltm = localtime(&now);

  tm *zaman = ltm;
  while (true) {

    now = time(0);
    zaman = localtime(&now);
    for (size_t i = 0; i < 7; i++) {
      output_buffer[i][0] = digits[i][(zaman->tm_hour) / 10];
      output_buffer[i][1] = digits[i][(zaman->tm_hour) % 10];
      output_buffer[i][3] = digits[i][(zaman->tm_min) / 10];
      output_buffer[i][4] = digits[i][(zaman->tm_min) % 10];
      output_buffer[i][6] = digits[i][(zaman->tm_sec) / 10];
      output_buffer[i][7] = digits[i][(zaman->tm_sec) % 10];
    }

    for (size_t i = 0; i < 7; i++) {
      for (size_t j = 0; j < 8; j++) {
        cout << output_buffer[i][j];
      }
      cout << "\n";
    }
    sleep(1);
    for (size_t i = 0; i < 7; i++) {
      for (size_t j = 0; j < 8; j++) {
        cout << "\r";
      }
      cout << "\033[A";
    }
  }
  return 0;
}
