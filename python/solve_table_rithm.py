#
# multiple solution of problems/p_0.jpeg

class Table:
    def __repr__(self):
        return f"Table: {self.name}\n Size: {len(self.rows)}x{len(self.columns)} \n table : {self.print_table(self)}"

    def __init__(self, name: str, rows: int, columns: int, guides_toggle=False):
        self.name = name
        self.columns = []
        self.rows = []
        self.guides_toggle = guides_toggle

        self.columns = self.columns + ["_"] * columns

        for i in range(rows):
            self.rows.append(list(self.columns))

        if guides_toggle:
            self.create_guides()

    def __str__(self):
        table = ""
        if self.guides_toggle:
            for i in range(len(self.rows)):
                table += str(self.left_guide[i]) + " "
                for j in range(len(self.rows[0])):
                    table += self.rows[i][j] + " "
                table += "\n"
            table += "  " + " ".join(map(chr, self.bottom_guide[: len(self.columns)]))
        else:
            for i in self.rows:
                for j in i:
                    table += j + " "
                table += "\n"
        return table

    def __len__(self):
        if len(self.rows) == len(self.columns):
            return len(self.rows)
        else:
            return ("Table is not square : ", (len(self.rows), len(self.columns)))

    def get_tile(self, row, col, with_guides=False) -> str:
        if with_guides:
            return self.rows[-row][ord(col) - ord("a")]
        else:
            return self.rows[row][col]

    def get_column(self, col: str):
        return [self.get_tile(row, col) for row in range(len(self.rows))]
    def change_tile(self, row, col, new_tile, with_guides=False):
        if with_guides:
            self.rows[-row][ord(col) - ord("a")] = new_tile
        else:
            self.rows[row][col] = new_tile

    def move_tile(self, row, col, new_row, new_col, with_guides=False):
        if with_guides:
            self.rows[-new_row][ord(new_col) - ord("a")] = self.rows[-row][
                ord(col) - ord("a")
            ]
            self.rows[-row][ord(col) - ord("a")] = "_"
        else:
            self.rows[new_row][new_col] = self.rows[row][col]
            self.rows[row][col] = "_"

    def print_table(self, with_guides=False):
        if with_guides:
            print(self.__str__())
        else:
            self.guides_toggle = False
            # for check toggle in __str__ method
            print(self.__str__())
            self.guides_toggle = True

    def create_guides(self):
        self.bottom_guide = range(ord("a"), ord("z") + 1)
        self.left_guide = range(len(self.rows), 0, -1)

    def change_guides(self, toggle: bool):
        self.guides_toggle = toggle

    def coordinates_guided_to_standart(self, row: int, col: str):
        return (-row, ord(col) - ord("a"))

    def coordinates_standart_to_guided(self, row: int, col: int):
        return (-row, chr(col + ord("a")))



def main():
    table_0 = get_filled_table_w_rule(Table("table_0", 4, 180))
    # print(table_0)
    # print(table_0)
    # table_0.print_table()
    result = get_columns_with_multiple_filled_tiles(get_filled_tiles(table_0),3)
    print(len(result))
    file_ = open("table_0.txt", "w")
    file_.write(str(table_0))
    file_.write(f"\n{result}")
    file_.close()
    print(f"\n{result}" )
    # print(table_0.get_column(59))
    for i in result:
        print(table_0.get_column(i))
    
    result = [x+1 for x in result]

    
    # floors = [x-1 for x in floors]
    # print(floors)
    # difference = [x for x in floors if x not in result]
    # print(difference)

def solution():
    print("solution")
    floors = []
    floors.append(get_all_floors_with_range(5,180))
    floors.append(get_all_floors_with_range(4,180))
    floors.append(get_all_floors_with_range(3,180))
    floors.append(get_all_floors_with_range(2,180))
    results = []
    checker = [0,0,0,0]
    for i in range(180):
        if i in floors[0]:
            checker[0]+=1
        if i in floors[1]:
            checker[1]+=1
        if i in floors[2]:
            checker[2]+=1
        if i in floors[3]:
            checker[3]+=1
        if checker.count(1) == 3:
            results.append(i)
        checker = [0,0,0,0]
    print(f'{results}-{len(results)}')

def get_filled_table_w_rule(table: Table):
    for i in range(1, table.__len__()[1][1]):
        for j in range(0, table.__len__()[1][0]):
            if j == 0 and ((i % 5) == 0):
                table.change_tile(j, i - 1, "A")
            elif j == 1 and ((i % 4) == 0):
                table.change_tile(j, i - 1, "A")
            elif j == 2 and ((i % 3) == 0):
                table.change_tile(j, i - 1, "A")
            elif j == 3 and ((i % 2) == 0):
                table.change_tile(j, i - 1, "A")
    return table

def get_filled_tiles(table: Table)->set:
    # filled_tile_cors = [[x,y]]
    filled_tile_cors = []
    for i in range(1, table.__len__()[1][1]):
        for j in range(0, table.__len__()[1][0]):
            if table.get_tile(j,i)=="A":
                if [j,i] not in filled_tile_cors:
                    filled_tile_cors.append([j,i])
    return filled_tile_cors

def remove_items(list_, item_):
     
    # using list comprehension to perform the task
    res = [i for i in list_ if i != item_]
 
    return res

def get_columns_with_multiple_filled_tiles(filled_tiles:list[list],row_count:int)->set:
    columns = []
    checked_columns = []
    if len(filled_tiles)>0:
        for t in filled_tiles:
            checked_columns.append(t[1])

    length_checked_columns = len(checked_columns)
    for i in range(length_checked_columns):
        for t in filled_tiles:
            if checked_columns.count(t[1])==row_count:
                columns.append(t[1])
                checked_columns = remove_items(checked_columns,t[1])
                
    return columns

def get_all_floors_with_range(number:int , range_:int)->list:
    floors = []
    for j in range(1,range_+1):
        if j % number == 0:
            floors.append(j)
    return floors

if __name__ == "__main__":
    main()
    # solution()
    
