import os
import sys
import re
from tkinter import *
import tkinter.font as tkFont

url = input()

if not re.compile("^(spotify:|https://[a-z]+\.spotify\.com/)").match(url):
    url = "'"+url+"'"

print(url)

if __name__ == "__main__":
    root = Tk()
    root.title("Spotify Downloader")
    root.geometry("600x500")
    root.resizable(width=False, height=False)

    ft = tkFont.Font(family='Times', size=10)
    downloadBtn = Button(root,activeforeground="#ffffff", activebackground="#008500", bg="#008000", font=ft, fg="#ffffff", justify="center", text="Download", relief="flat")
    downloadBtn.place(x=230, y=260, width=127, height=50)

    ft = tkFont.Font(family='Times', size=14)
    urlEntry = Entry(root, borderwidth="1px", font=ft, fg="#333333", justify="center", text="Enter the link")
    urlEntry.place(x=50, y=180, width=508, height=60)

    ft = tkFont.Font(family='Times', size=52)
    GLabel_977 = Label(root, font=ft, fg="#333333", justify="center", text="spodlgui")
    GLabel_977.place(x=90, y=70, width=403, height=65)


    root.mainloop()
