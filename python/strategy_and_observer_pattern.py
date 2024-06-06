# Observer Pattern

class Counter:
    def __init__(self):
        self._observers = []
        self._state = 0

    def attach(self, observer):
        self._observers.append(observer)

    def notify(self):
        for observer in self._observers:
            observer.update(self._state)

    def increment(self):
        self._state += 1
        self.notify()

class Observer:
    def __init__(self, id):
        self._id = id

    def update(self, state):
        print(f"Observer {self._id}: Counter state is now {state}")

# Strategy Pattern

class Printer:
    def __init__(self, print_strategy=None):
        if print_strategy:
            self.print = print_strategy

    def print(self, text):
        print(text)

def print_uppercase(text):
    print(text.upper())

def print_lowercase(text):
    print(text.lower())

# Application
counter = Counter()
observers = [Observer(i) for i in range(3)]

for observer in observers:
    counter.attach(observer)

printer = Printer()

for i in range(5):
    counter.increment()
    if i % 2 == 0:
        printer = Printer(print_uppercase)
    else:
        printer = Printer(print_lowercase)
    printer.print(f"End of iteration {i}")
