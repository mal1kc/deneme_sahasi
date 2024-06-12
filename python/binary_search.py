import time
from random import randint
def binary_search(numbers: list, target: int) -> int | None:
    lower = 0
    higher = len(numbers)
    while lower <= higher:
        mid = (lower + higher) // 2
        if mid >= len(numbers):
            break
        if numbers[mid] == target:
            return mid
        if target < numbers[mid]:
            higher = mid - 1
        else:
            lower = mid + 1
    return None



def main() -> None:
    # test cases
    numbers = list(range(1, 101))
    print(" start testing with numbers from 1 to 100")
    assert binary_search(numbers, 1) == 0
    assert binary_search(numbers, 100) == 99
    assert binary_search(numbers, 50) == 49
    assert binary_search(numbers, 101) is None
    assert binary_search(numbers, 0) is None
    print(" test passed")



    bigger_numbers = list(range(1, 1001))
    print(" start testing with numbers from 1 to 1000")
    assert binary_search(bigger_numbers, 1) == 0
    assert binary_search(bigger_numbers, 1000) == 999
    assert binary_search(bigger_numbers, 500) == 499
    assert binary_search(bigger_numbers, 1001) is None
    assert binary_search(bigger_numbers, 0) is None
    print(" test passed")

    random_sorted_numbers = sorted([randint(x, 10001) for x in range(1000)])
    print(" start testing with random sorted numbers")
    assert binary_search(random_sorted_numbers, random_sorted_numbers[0]) == 0
    assert (
        binary_search(random_sorted_numbers, random_sorted_numbers[-1])
        == len(random_sorted_numbers) - 1
    )
    assert binary_search(random_sorted_numbers,  random_sorted_numbers[500]) == 500
    print(" test passed")

    # i want to be sure it works without failing
    # very_very_long_list = list(range(1, 1_000_000_001))
    # print(" start testing with numbers from 1 to 1_000_000_000")
    # assert binary_search(very_very_long_list, 1) == 0
    # assert binary_search(very_very_long_list, 1_000_000_000) == 999_999_999
    # assert binary_search(very_very_long_list, 500_000_000) == 499_999_999
    # assert binary_search(very_very_long_list, 1_000_000_001) is None
    # assert binary_search(very_very_long_list, 0) is None
    # print(" test passed")


if __name__ == "__main__":
    try:
        start = time.time()
        main()
        print("tests completed  in " + str(time.time() - start) + " seconds")
        exit(0)
    except AssertionError:
        print("Test failed")
        exit(1)
