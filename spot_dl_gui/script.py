import os
import sys
import re
from tkinter import *
import subprocess
from threading import *
import tkinter.font as tkFont

downloadQueue = []

def filterQuery(rawQuery):
    return "'{}'".format(rawQuery)

def getSong():
    downloadBtn.config(state=DISABLED)
    i = 0
    totalTask = len(downloadQueue)
    while not downloadQueue == []:
        query = downloadQueue.pop()
        try:
            downloadBtn.config(text=f'Downloading {i+1} out of {totalTask}')
            subprocess.run(f'spotdl "{query}"', shell=True)
        except Exception as e:
            print(e)
        finally:
            alert.config(text="Video Downloaded Successfully")
            listbox.delete(END)
            downloadBtn.config(text="Download")
            downloadBtn.config(state=NORMAL)
            alert.config(text="Thank you for using this script")
            i+1


def startDownload():
    if downloadQueue == []:
        downloadBtn.config(text="Download queue is empty !")
        addBtn.config(bg="red")
    else:
        downloadThread = Thread(target=getSong)
        downloadThread.start()


def addQuery():
    addBtn.config(bg="#008500")
    query = querEntry.get()
    if query in downloadQueue or(not (query and not query.isspace())):
        alert.config(text='task already exists')
    else:
        if not re.compile("^(spotify:|https://[a-z]+\.spotify\.com/)").match(query):
            query = filterQuery(query)
        querEntry.delete(0, END)
        listbox.insert(END, query)
        downloadQueue.append(query)

if __name__ == "__main__":
    root = Tk()
    root.title("Spotify Downloader")
    root.geometry("600x450")
    root.resizable(width=False, height=False)


    ft = tkFont.Font(family='Times', size=14)
    querEntry = Entry(root, borderwidth="1px", font=ft, fg="#333333", justify="center")
    querEntry.place(x=50, y=30, width=380, height=50)

    ft = tkFont.Font(family='Times', size=10)
    addBtn = Button(root,activeforeground="#ffffff", activebackground="#296b28", bg="#008000",
    command=addQuery, font=ft, fg="#ffffff", justify="center", text="Add", relief="flat")
    addBtn.place(x=450, y=30, width=100, height=50)

    listbox = Listbox(root)
    listbox.place(x=50, y=110, width=500, height=200)

    ft = tkFont.Font(family='Times', size=10)
    downloadBtn = Button(root,activeforeground="#ffffff", activebackground="#296b28",
    command=startDownload, bg="#008000", font=ft, fg="#ffffff", justify="center", text="Download", relief="flat")
    downloadBtn.place(x=200, y=340, width=200, height=50)

    ft = tkFont.Font(family='Helvetica', size=10)
    alert = Label(root, font=ft, fg="#333333", justify="center", text="This may take a while")
    alert.place(x=50, y=410, width=500)
    
    root.mainloop()
