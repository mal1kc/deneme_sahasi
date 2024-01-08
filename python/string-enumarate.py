gird1 = input("giriniz :")
gird12 = int(input("gir 2 : "))
liste = list()
print(gird12)
for i in range(0, gird12):
    if i >= 10:
        girdi = gird1 + "00" + str(i)
        liste.append(girdi)
    elif i >= 100:
        girdi = gird1 + "000" + str(i)
        liste.append(girdi)
for i in liste:
    print(i + "\n")
