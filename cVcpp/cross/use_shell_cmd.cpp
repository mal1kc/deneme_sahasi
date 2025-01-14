#include <iostream>
#include <cstdio>
#include <memory>
#include <array>

#ifdef __unix__
#elif defined(_WIN32) || defined(WIN32)
#define OS_Windows
#endif

#ifdef OS_Windows
#include <conio.h>
#else
#include <cstdlib>
#endif

std::string exec(const char* cmd) {
    // Create a pipe to read the output of the command
    std::array<char, 128> buffer;
    std::string result;

    // Open the command for reading
    std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd, "r"), pclose);
    if (!pipe) {
        throw std::runtime_error("popen() failed!");
    }

    // Read the output a line at a time - output it.
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        result += buffer.data();
    }

    return result;
}

int main(int argc, char const *argv[]) {
#ifdef OS_Windows
    // Execute the Windows command and read output
    std::string output = exec("winver");
    std::cout << "Windows version output:\n" << output << std::endl;
#else
    // Execute the Unix command and read output
    std::string output = exec("uname -a");
    std::cout << "Unix version output:\n" << output << std::endl;
#endif
    return 0;
}

