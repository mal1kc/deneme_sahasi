CXX = clang++
CXXFLAGS = -g -Wall -Werror

SRCS = $(wildcard src/*.cpp)
OBJS = $(SRCS:.cpp=.o)

BIN = bin/main

all: $(BIN)

release: CXXFLAGS=-Wall -O2 -DNDEBUG
release: $(BIN)

$(BIN): $(OBJS)
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $^ -o $@

src/%.o: src/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

.PHONY: all release clean dry-run
clean:
ifeq ($(MAKECMDGOALS),clean)
	$(RM) $(OBJS) $(BIN)
endif

dry-run:
	@echo "Dry run: would remove $(OBJS) $(BIN)"
