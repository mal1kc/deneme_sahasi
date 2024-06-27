#ifdef __unix__
#elif defined(_WIN32) || defined(WIN32)
#define OS_Windows
#endif
#ifdef OS_Windows
#include <conio.h>
#else
#include <cstdlib>
#endif

int main(int argc, char const *argv[]) {
  std::system("echo hello world");
  return 0;
}
