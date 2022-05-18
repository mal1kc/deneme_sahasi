# import tkinter as tk
# from tkinter import messagebox
# import time
# import os
# import ctypes


# class App(tk.Frame):
#     def __init__(self, parent, *args, **kwargs):
#         tk.Frame.__init__(self, parent)

#         self.parent = parent

#         self.initUI()

#     def initUI(self):

#         self.parent.title("naber ? ")
#         self.parent.withdraw()
#         self.pack(fill="both", expand=True, side="top")

#         self.parent.wm_state("zoomed")

#         self.parent.bind("<F11>", self.fullscreen_toggle)
#         self.parent.bind("<Escape>", self.fullscreen_cancel)
#         self.parent.bind("<Alt-F4>", self.agla)

#         self.fullscreen_toggle()

#         self.label = tk.Label(self, text="ne sandın lan", font=("default",120), fg="black")
#         self.label.pack(side="top", fill="both", expand=True)

#     def fullscreen_toggle(self, event="none"):

#         self.parent.focus_set()
#         self.parent.overrideredirect(True)
#         self.parent.overrideredirect(False) #added for a toggle effect, not fully sure why it's like this on Mac OS
#         self.parent.attributes("-fullscreen", True)
#         self.parent.wm_attributes("-topmost", 1)

#     def fullscreen_cancel(self, event="none"):

#         self.parent.overrideredirect(False)
#         self.parent.attributes("-fullscreen", False)
#         self.parent.wm_attributes("-topmost", 0)

#         self.centerWindow()

#     def centerWindow(self):

#         sw = self.parent.winfo_screenwidth()
#         sh = self.parent.winfo_screenheight()

#         w = sw*0.7
#         h = sh*0.7

#         x = (sw-w)/2
#         y = (sh-h)/2

#         self.parent.geometry("%dx%d+%d+%d" % (w, h, x, y))
    
#     def deneme(self):
#         cur_time = time.localtime()

#         print(cur_time.tm_hour)
#         if cur_time.tm_hour < 14:
#             os.system("shutdown -L")
#         else:
#             ctypes.windll.user32.MessageBoxW(0,"Vaktinde Oturdun","Helal")
#             self.parent.destroy()
#             # self.destroy()
            
#     def agla(self,event="none"):
#         m = messagebox.showinfo("ağlıyor musun","ağlamaya devam ediyor musunuz?")
#         # self.parent.withdraw()
#         # time.sleep(10)
#         # self.parent.deiconify()

# if __name__ == "__main__":
#     root = tk.Tk()
#     ap = App(root)
#     ap.pack(side="top", fill="both", expand=True)
#     ap.deneme()
#     root.mainloop()
    