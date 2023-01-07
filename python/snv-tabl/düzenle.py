import json
from pprint import pprint

def main():
    n_data = list()
    print("started\n"+"-"*50+"\n")
    json_data = get_json_data()
    # check_dict_data(json_data[0])
    
    print("started\n"+"-"*50+"\n")
    for i in json_data:
        j = update_dict_data(i)
        if check_dict_data(j):
            n_data.append(j)
    print('cleaned data\n'+"-"*50+'\n')
    save_json_data(n_data)
    
    print("\n"+"-"*50+"\nended")
    
def save_json_data(data:list):
    with open("snv-tbl-finished.json",mode="w",encoding="utf8") as f:
        json.dump(data,f)

def get_json_data():
    with open("snv-tbl.json",mode="r+",encoding="utf8") as f:
        json_data = json.load(f)
    # print(json_data[0])
    return json_data
    
def update_dict_data(d:dict):
    try:
        try:
            if (d['Bilgisayar Programcılığı-II'] == " " )or (len(str(d['Bilgisayar Programcılığı-II']))==0):
                d['Bilgisayar Programcılığı-II'] = None
        except KeyError:
            # print(d)
            return None
        print({False:f'\nremoved {d["Bilgisayar Programcılığı-I"]}\n\n',True:""}[(d['Bilgisayar Programcılığı-I'] == " ")or (len(str(d['Bilgisayar Programcılığı-I']))==0)],end="")
        d.pop("Bilgisayar Programcılığı-I",None)
        return d
    except KeyError:
        return d
    
def check_dict_data(d:dict):
    if d is not None:
        try:
            if d['Bilgisayar Programcılığı-II'] == None:
                # print("bos")
                return False
            else:
                # print("dolu")
                return True
        except Exception as Er:
            print(f"{'*'*5}\n{str(Er)}\n{'*'*5}\n{str(d)}\n{'*'*5}")
            return False
    else:
        return False
if __name__=="__main__":
    main()