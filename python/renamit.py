import argparse
import os

pathh_ = os.walk("C:/Users/malik kokcan/Downloads/temp")

parser = argparse.ArgumentParser(description='Rename files in a directory')
parser.add_argument("-e","--echo", help="echo the string you use here")
parser.add_argument("--verbose", help="increase output verbosity", action="store_true")
parser.add_argument("--folder-location", help="specify the folder location")

if __name__=="__main__":
    
    not completeddddddddddd
    print("renamit.py is running")
    # print(f"argv: {parser.parse_args().folder_location}")
    for root,dir,files in pathh_:
        for file, enum in zip(files, range(1, len(files) + 1)):
            # if file.startswith("elden_ring"):
            print("\t" + file)
            old_name = root + "//" + file
            new_name = root + "//" + "elden_ring" + str(enum) + file
            os.rename(old_name, new_name)
                
    print("renamit.py is done")
    

# def rename_file(old_name:str,new_name:str):
    