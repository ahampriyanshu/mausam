#!/usr/bin/python3
import sys
from pytube import *
from tkinter import *
from tkinter.filedialog import *
from tkinter.messagebox import *
import tkinter.font as tkfont
from threading import *
import re
regex = re.compile(
        r'^(?:http|ftp)s?://'
        r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|' 
        r'localhost|'
        r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'
        r'(?::\d+)?'
        r'(?:/?|[/?]\S+)$', re.IGNORECASE)


file_size = 0


def progess(chunk, file_handle, bytes_remaining):
    file_downloaded = (file_size - bytes_remaining)
    per = (file_downloaded/file_size)*100
    per_com.config(text=f'{per:.2f} %')
    byte_com.config(text=f'{file_downloaded/(1024*1024):.2f}/{file_size/(1024*1024):.2f} MiB')

def getName(linkk):
    tube = YouTube(linkk)
    video = tube.streams.first()
    return video.title


def getVideo():
    global file_size
    while not downloadqueue == [] :
        url = downloadqueue.pop()
        try:
            Download_B.config(text="Please wait ...")
            Download_B.config(state=DISABLED)
            path_to_save_video = chosenfolder.get()
            if path_to_save_video is None:
                return
            tube = YouTube(url, on_progress_callback=progess)
            video = tube.streams.first()
            file_size = video.filesize
            title_label.config(text=video.title)
            video.download(path_to_save_video)
            Download_B.config(text="Start Download")
            Download_B.config(state=NORMAL)
            title_label.pack_forget()

        except Exception as e:
            print(e)


def startDownload():
    thread = Thread(target=getVideo)
    thread.start()


def pickfolder():
    filename = askdirectory()
    chosenfolder.set(filename)

def add():
    link = linkText.get()
    if re.match(regex, link) is not None:
        listbox.insert(END, link)
        downloadqueue.append(link)
        linkText.delete(0, END)
    else:
        showinfo("Error","Invalid URL")



root = Tk()
root.title("Youtube Video Downloader")
root.geometry("600x400")
root.resizable(False, False)
root.config(background="#ffffff")
video_Link = StringVar()
chosenfolder = StringVar()
my_font = tkfont.Font(family = "Helvetica", size = 12)
link_label = Label(root, text="YouTube link",font = my_font, bg="#ffffff",pady=10)
link_label.grid(row=1, column=0, pady=5,  padx=5)
linkText = Entry(root, width=40)
linkText.grid(row=1, column=1, pady=5,  padx=5, columnspan=2)
add_B = Button(root, text="Add", command=add,   width=10, fg="#ffffff",  bg="#273239")
add_B.grid(row=1,  column=3,   pady=1, padx=5)


destination_label = Label(root,  text="Destination",font = my_font, bg="#ffffff",pady=10)
destination_label.grid(row=2,  column=0, pady=5, padx=5)
destinationText = Entry( root,   width=40,   textvariable=chosenfolder)
destinationText.grid(row=2,   column=1,     pady=5,  padx=5, columnspan=2)
browse_B = Button(root, text="Browse", command=pickfolder,   width=10, fg="#ffffff",  bg="#273239")
browse_B.grid(row=2,  column=3,   pady=1, padx=5)

listbox = Listbox(root )
vsb = Scrollbar(root, orient="vertical", command=listbox.yview)
vsb.grid(row=0, column=1, sticky='ns')
listbox.configure(yscrollcommand=vsb.set)

downloadqueue = []
listbox.grid(column=0, row=3, columnspan=6)
delBtn = Button(root, text = "delete", command = lambda listbox=listbox: listbox.delete(ANCHOR)) 
delBtn.grid(row=5,column=1,pady=3,padx=3) 
Download_B = Button(root, text="Download", command=startDownload,    width=20, fg="#ffffff",   bg="#273239")
Download_B.grid(row=5,column=2,pady=3,padx=3)
# my_font = tkfont.Font(family = "Helvetica", size = 18,weight = "bold")
# label1 = Label(root,text = "Enter URL",width = 10,fg = "#273239", bg = "#ffffff")
# label1.config(font = my_font)
# label1.pack(side=TOP,fill=BOTH,pady=20)
# url=Entry(root, font=("veranda",18),justify=CENTER)
# url.pack(side=TOP,fill=X,padx=30)
# Download_B = Button(root,text="Download",font=("verdana",18),fg = "white",bg = "#273239",relief='ridge',command=startDownload)
# Download_B.pack(side=TOP,pady=20)
m_font = tkfont.Font(family = "Helvetica", size = 10)
title_label = Label(root,width=15, text="Title fjdsjfldsjf fmdklfjlkds ndskfdsklfj",font = m_font, bg="#ffffff",pady=5)
title_label.grid(row=6, column=0, pady=5,  padx=5, sticky=W)
per_com = Label(root, text="",font = m_font, bg="#ffffff")
per_com.grid(row=6, column=2, pady=5,  padx=5)
byte_com = Label(root, text="",font = m_font, bg="#ffffff")
byte_com.grid(row=6, column=3, pady=5,  padx=5)
root.mainloop()