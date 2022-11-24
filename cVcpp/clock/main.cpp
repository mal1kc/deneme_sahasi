#include <ctime>
#include <iomanip>
#include <iostream>
#include <string>
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

  // for (int i = 0; i < 11; i++) {
  //   for (int j = 0; j < 7; j++) {
  //     cout << digits[j][i] << "\n";
  //   }
  // }

  time_t now = time(0);
  tm *ltm = localtime(&now);
  time_t oglen = time(0);
  tm *ogln = localtime(&oglen);
  ogln->tm_hour = 13;
  ogln->tm_min = 13;

  cout << put_time(ltm, "%a %b %d %H:%M:%S %Y") << "\n";
  cout << ltm->tm_hour << "\n";

  tm *zaman = ogln;

  if (zaman->tm_hour < 10) {
    for (int i = 0; i < 7; i++)
      cout << digits[i][zaman->tm_hour] << "\n";
  } else if ((zaman->tm_hour >= 10) && (zaman->tm_hour < 20)) {
    for (size_t i = 0; i < 7; i++) {
      cout << digits[i][1] << digits[i][(zaman->tm_hour) % 10] << "\n";
    }
  } else if ((zaman->tm_hour >= 20)) {
    for (size_t i = 0; i < 7; i++) {
      cout << digits[i][2] << digits[i][(zaman->tm_hour) % 10] << "\n";
    }
  }
  for (size_t i = 0; i < 7; i++) {
    cout << digits[i][10] << "\n";
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
