import os
import sys
import re
from tkinter import *
import subprocess
from threading import *
import tkinter.font as tkFont

downloadQueue = []

class Error(Exception):
    """Base class for other exceptions"""
    pass


class DownloadError(Error):
    """Raised when error occurs while downloading"""
    pass

class DuplicateUrlError(Error):
    """Raised when duplicate url is entered"""
    pass


class EmptyStringError(Error):
    """Raised when an empty string is entered"""
    pass


def filterQuery(rawQuery):
    return "'{}'".format(rawQuery)

def getSong():
    downloadBtn.config(state=DISABLED)
    addBtn.config(state=DISABLED)
    i = 0
    totalTask = len(downloadQueue)
    while not downloadQueue == []:
        alert.config(text="Connected to spotify")
        query = downloadQueue.pop()
        try:
            downloadBtn.config(text=f'Downloading {i+1} out of {totalTask}')
            cmd = subprocess.run(f'spotdl "{query}"', shell=True)
            if cmd.returncode:
                raise DownloadError
        except DownloadError:
            alert.config(text="Error occured while downloading")
        except Exception as e:
            print(e)
            alert.config(text="Unknown Error! maybe your internet connection")
        finally:
            alert.config(text="Downloading next track")
        listbox.delete(END)
        downloadBtn.config(text="Download")
        downloadBtn.config(state=NORMAL)
        addBtn.config(state=NORMAL)
        i+1


def startDownload():
    if downloadQueue == []:
        downloadBtn.config(text="Download queue is empty!")
        addBtn.config(bg="red")
        return
    downloadThread = Thread(target=getSong)
    downloadThread.start()


def addQuery():
    addBtn.config(bg="#273239")
    query = querEntry.get()
    querEntry.delete(0, END)
    try:
        if(not (query and not query.isspace())):
            raise EmptyStringError
        if not re.compile("^(spotify:|https://[a-z]+\.spotify\.com/)").match(query):
            query = filterQuery(query)
        if query in downloadQueue:
            raise DuplicateUrlError
    except EmptyStringError:
        alert.config(text="Empty String!")

    except DuplicateUrlError:
        alert.config(text="Task already exist")
    
    except Exception as e:
        print(e)
        alert.config(text="Unknown Error!")

    else:        
        listbox.insert(END, query)
        downloadQueue.append(query)
        alert.config(text="Task added successfully")

if __name__ == "__main__":
    root = Tk()
    root.title("Spotify Downloader")
    root.geometry("600x450")
    root.resizable(width=False, height=False)


    ft = tkFont.Font(family='Agency FB', size=14)
    querEntry = Entry(root, borderwidth="1px", font=ft, fg="#273239", justify="center")
    querEntry.place(x=50, y=30, width=380, height=50)

    ft = tkFont.Font(family='Agency FB', size=10)
    addBtn = Button(root,activeforeground="#ffffff", activebackground="#666666", bg="#273239",
    command=addQuery, font=ft, fg="#ffffff", justify="center", text="Add", relief="flat")
    addBtn.place(x=450, y=30, width=100, height=50)

    listbox = Listbox(root)
    listbox.place(x=50, y=110, width=500, height=200)

    ft = tkFont.Font(family='Agency FB', size=10)
    downloadBtn = Button(root,activeforeground="#ffffff", activebackground="#666666",
    command=startDownload, bg="#273239", font=ft, fg="#ffffff", justify="center", text="Download", relief="flat")
    downloadBtn.place(x=200, y=340, width=200, height=50)

    ft = tkFont.Font(family='Helvetica', size=10)
    alert = Label(root, font=ft, fg="#000000", justify="center", text="")
    alert.place(x=50, y=410, width=500)
    
    root.mainloop()