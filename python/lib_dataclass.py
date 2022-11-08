"""
example of python dataclass decorator and property method
"""

from dataclasses import dataclass

# dataclass is for creating class with data attributes
# for creating dataclass we use @dataclass decorator and it adds automatically __init__ and __repr__ methods for our class


@dataclass  # decorator for dataclass
class Book:
    title: str  # str type data attribute of Book class
    author: str  # str type data attribute of Book class
    pages: int  # int type data attribute of Book class
    price: float = (
        2.99  # float type data attribute of Book class with default value 2.99
    )
    quantity: int = 1  # int type data attribute of Book class with default value 1

    # bool type data attribute of Book class with default value True
    is_available: bool = True

    # def total_price(self):
    #     return self.price * self.quantity

    # for creating property for total price
    total_price = property(lambda self: self.price * self.quantity)

    def set_book_info(self, value):
        # raise exception for setter book_info method
        raise Exception("Book info cannot be set")

    def get_book_info(self) -> dict[str, object]:
        return {
            "title": self.title,
            "author": self.author,
            "pages": self.pages,
            "price": self.price,
            "quantity": self.quantity,
            "is_available": self.is_available,
        }

    # dict data type attribute of Book class with only getter method

    # created book_info property for Book class with property function and used getter and setter methods of book_info property that we created earlier
    book_info = property(get_book_info, set_book_info, doc="info about the book object")


def main() -> None:
    book1 = Book(
        "Dune", "Frank Herbert", 432, 5.99, 2, True
    )  # creating object from Book class
    print("data of book1: \n", book1.book_info, end="\n\n")

    book2 = Book("Martian", "Andy Weir", 200, 2.99, 50, False)  # create book2 object
    print("data of book2: \n", book2.book_info, end="\n\n")

    book3 = Book("I, Robot", "Isaac Asimov", 200, 2.99, 3, False)  # create book3 object
    print("data of book3: \n", book3.book_info, end="\n\n")
    print(f" book1;{book1}\n book2;{book2}\n book3;{book3}")


if __name__ == "__main__":
    main()
