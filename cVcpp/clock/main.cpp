#include <ctime>
#include <iomanip>
#include <iostream>
#include <string>
#include <unistd.h>
int main() {
  using namespace std;
  const string digits[7][11] = {
      {"┏━┓ ", "  ╻  ", " ┏━┓ ", " ┏━┓ ", " ╻ ╻ ", " ┏━┓ ", " ┏   ", " ┏━┓ ",
       " ┏━┓ ", " ┏━┓ ", "   "},
      {"┃ ┃ ", "  ┃  ", "   ┃ ", "   ┃ ", " ┃ ┃ ", " ┃   ", " ┃   ", "   ┃ ",
       " ┃ ┃ ", " ┃ ┃ ", " ╻ "},
      {"┃ ┃ ", "  ┃  ", "   ┃ ", "   ┃ ", " ┃ ┃ ", " ┃   ", " ┃   ", "   ┃ ",
       " ┃ ┃ ", " ┃ ┃ ", "   "},
      {"┃ ┃ ", "  ┃  ", " ┏━┛ ", " ┣━┫ ", " ┗━┫ ", " ┗━┓ ", " ┣━┓ ", "   ┃ ",
       " ┣━┫ ", " ┗━┫ ", "   "},
      {"┃ ┃ ", "  ┃  ", " ┃   ", "   ┃ ", "   ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ",
       " ┃ ┃ ", "   ┃ ", "   "},
      {"┃ ┃ ", "  ┃  ", " ┃   ", "   ┃ ", "   ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ",
       " ┃ ┃ ", "   ┃ ", " ╹ "},
      {"┗━┛ ", "  ╹  ", " ┗━━ ", " ┗━┛ ", "   ╹ ", " ┗━┛ ", " ┗━┛ ", "   ╹ ",
       " ┗━┛ ", " ┗━┛ ", "   "},
  };
  string output_buffer[7][8] = {
      {"┏━┓ ", "┏━┓ ", "┏━┓ ", "┏━┓ ", "┏━┓ ", "┏━┓ ", "┏━┓ ", "┏━┓ "},
      {"┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ "},
      {"┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ "},
      {"┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ "},
      {"┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ "},
      {"┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ ", "┃ ┃ "},
      {"┗━┛ ", "┗━┛ ", "┗━┛ ", "┗━┛ ", "┗━┛ ", "┗━┛ ", "┗━┛ ", "┗━┛ "},
  };

  for (int i = 0; i < 11; i++) {
    for (int j = 0; j < 7; j++) {
      cout << digits[j][i] << "\n";
    }
  }

  time_t now = time(0);
  tm *ltm = localtime(&now);

  cout << put_time(ltm, "%a %b %d %H:%M:%S %Y") << "\n";
  cout << ltm->tm_hour << "\n";

  tm *zaman = ltm;
  while (true) {

    now = time(0);
    zaman = localtime(&now);
    for (size_t i = 0; i < 7; i++) {
      output_buffer[i][0] = digits[i][(zaman->tm_hour) / 10];
      output_buffer[i][1] = digits[i][(zaman->tm_hour) % 10];
    }

    for (size_t i = 0; i < 7; i++) {
      output_buffer[i][2] = digits[i][10];
    }

    for (size_t i = 0; i < 7; i++) {
      output_buffer[i][3] = digits[i][(zaman->tm_min) / 10];
      output_buffer[i][4] = digits[i][(zaman->tm_min) % 10];
    }

    for (size_t i = 0; i < 7; i++) {
      output_buffer[i][5] = digits[i][10];
    }
    for (size_t i = 0; i < 7; i++) {
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
  }
  // cout << digits[0][0] << "\n";
  // cout << digits[1][0] << "\n";
  // cout << digits[2][0] << "\n";
  // cout << digits[3][0] << "\n";
  // cout << digits[4][0] << "\n";
  // cout << digits[5][0] << "\n";
  // cout << digits[6][0] << "\n";
  return 0;
}
