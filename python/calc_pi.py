i = 0
pi = float(0)
check1 = False
check2 = False
check3 = False
check4 = False

while True:
    i += 1
    if i % 2 == 0:
        pi -= (4) / (2 * i - 1)
    else:
        pi += (4) / (2 * i - 1)

    if pi >= 3.14 and pi < 3.15 and check1 == 0:

        print(f"To get 3.14, we have to use {i} terms.\n")
        check1 = 1
    if pi >= 3.141 and pi < 3.142 and check2 == 0:

        print(f"To get 3.141, we have to use {i} terms.\n")
        check2 = 1
    if pi >= 3.14159 and pi < 3.14160 and check3 == 0:

        print(f"To get 3.1415, we have to use {i} terms.\n")
        check3 = 1
    if pi >= 3.14159 and pi < 3.14160 and check4 == 0:

        print(f"To get 3.14159, we have to use {i} terms.")
        check4 = 1
    if check1 == 1 and check2 == 1 and check3 == 1 and check4 == 1:
        break
    # if(check1 and check2 and check3):
    #     print(f"\n-----\ndebug line i:{i}  pi:{pi}\n-----\n")
