import os
# import numpy as np
# import pandas as pd
search_dir = os.walk("G:\\")
# corrupt = pd.DataFrame(columns=["filename","file_size","full_path"])
i = 0
fileList = list()
print("hi")
for root, dirc, files in search_dir:
    try:
        # print(files)
        for file in files:
            # print("file : %s" % root+"//"+file)
            fileList.append("filename : "+root+"//"+file)
        with open("files.txt","w") as f:
            for fil in fileList:
                f.write("\t \n" + fil + "\n")
                
    except Exception as err:
        print(err)
