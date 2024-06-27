CXX = c++
CXXFLAGS = -Wall -Werror -Wpedantic -Wextra -O2 -pthread
LDLIBS =

all: kb_input

kb_input: kb_input.cpp
	$(CXX) $(CXXFLAGS) $< -o $@ $(LDLIBS)

clean:
	rm -f kb_input
