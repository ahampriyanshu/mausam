#!/usr/bin/python3
import sys
from pytube import *
from tkinter import *
from tkinter.filedialog import *
from tkinter.messagebox import *
import tkinter.font as tkfont
from threading import *
from tkinter import ttk 
import ffmpeg
import re
regex = re.compile(
        r'^(?:http|ftp)s?://'
        r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|' 
        r'localhost|'
        r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'
        r'(?::\d+)?'
        r'(?:/?|[/?]\S+)$', re.IGNORECASE)


file_size = 0
downloadqueue = []
resolution = []
choices = ("2160p","1440p","1080p", "720p","360p","144p","mp3")

def convert(seconds): 
    min, sec = divmod(int(seconds), 60) 
    return "%02d:%02d" % (min, sec) 

def progess(chunk, file_handle, bytes_remaining):
    file_downloaded = (file_size - bytes_remaining)
    per = (file_downloaded/file_size)*100
    progess.config(text=f'{per:.2f} %')
    size.config(text=f'{file_downloaded/(1024*1024):.2f}/{file_size/(1024*1024):.2f} mb')

def getName(url):
    tube = YouTube(url)
    video = tube.streams.first()
    return video.title


def getVideo():
    global file_size
    i = 1
    task = len(downloadqueue)
    while not downloadqueue == [] :
        url = downloadqueue.pop()
        res = resolution.pop()
        try:
            Download_B.config(text=f'Downloading {i} out of {task}')
            Download_B.config(state=DISABLED)
            path_to_save_video = location.get()
            if path_to_save_video is None:
                showinfo("Error","Invalid Path")
                return
            tube = YouTube(url, on_progress_callback=progess)
            video = tube.streams.first()
            file_size = video.filesize
            duration.config(text=convert(tube.length))
            channel.config(text=tube.author.lower())
            video.download(path_to_save_video)

        except Exception as e:
            print(e)
        listbox.delete(END)
        i+1

    Download_B.config(text="Start Download")
    Download_B.config(state=NORMAL)


def startDownload():
    thread = Thread(target=getVideo)
    thread.start()


def pickfolder():
    filename = askdirectory()
    location.set(filename)

def checkadd():
    add_B.config(text="Adding...")
    add_B.config(state=DISABLED)
    link = linkText.get()
    if re.match(regex, link) is not None:
        if link in downloadqueue:
            showinfo("Error","link already exists")
        else:
            listbox.insert(END, getName(link))
            downloadqueue.append(link)
            resolution.append(monthchoosen.get())
            linkText.delete(0, END)
    else:
        showinfo("Error","Invalid URL")
    add_B.config(text="Add")
    add_B.config(state=NORMAL)
        

def add():
    thread = Thread(target=checkadd)
    thread.start()


root = Tk()
root.title("Youtube Video Downloader")
root.geometry("600x500")
root.resizable(False, False)
root.config(background="#ffffff")
video_Link = StringVar()
location = StringVar()

# create all of the main containers
top_frame = Frame(root,bg="#ffffff")
middle_frame = Frame(root,bg="#ffffff")
bottom_frame = Frame(root,bg="#ffffff")
bottom2_frame = Frame(root,bg="#ffffff")

top_frame.grid(row=0)
middle_frame.grid(row=3)
bottom_frame.grid(row=6)
bottom2_frame.grid(row=7)

my_font = tkfont.Font(family = "Helvetica", size = 12)
link_label = Label(top_frame, text="Video url",font = my_font, bg="#ffffff",pady=10)
link_label.grid(row=1, column=0, pady=5, )
linkText = Entry(top_frame, width=25)
linkText.grid(row=1, column=1, pady=5, sticky=W)
monthchoosen = ttk.Combobox(top_frame, values=choices, width=8, background="#273239", foreground="black")
monthchoosen.place(x=330, y=15)
monthchoosen.current(3)  
add_B = Button(top_frame, text="Add", command=add,   width=10, fg="#ffffff",  bg="#273239")
add_B.grid(row=1,  column=3,   pady=1,)
destination_label = Label(top_frame,  text="Location",font = my_font, bg="#ffffff",pady=10)
destination_label.grid(row=2,  column=0, pady=5, padx=5)
destinationText = Entry( top_frame,   width=40,   textvariable=location)
destinationText.grid(row=2,   column=1, pady=5,  padx=5)
browse_B = Button(top_frame, text="Browse", command=pickfolder,   width=10, fg="#ffffff",  bg="#273239")
browse_B.grid(row=2,  column=3,   pady=1, padx=5)

listbox = Listbox(middle_frame, width=70)
listbox.grid(column=0, row=3, columnspan=5,padx=10, sticky=W+E)
yscroll = Scrollbar(command=listbox.yview, orient=VERTICAL)
yscroll.grid(row=3, column=5, sticky='ns')
listbox.configure(yscrollcommand=yscroll.set)
xscroll = Scrollbar(command=listbox.xview, orient=HORIZONTAL)
xscroll.grid(row=4, column=0, columnspan=5, padx=10, pady=10, sticky=W+E)
listbox.configure(xscrollcommand=xscroll.set)


Download_B = Button(bottom_frame, text="Download", command=startDownload, width=20, fg="#ffffff",   bg="#273239")
Download_B.grid(row=5,column=2,pady=3,padx=3)

m_font = tkfont.Font(family = "verdana", size = 12, weight="bold")
Label(bottom2_frame, width=10, font = my_font , text="channel", bg="#fff").grid(row=0, column=0, padx=10, pady=10)
Label(bottom2_frame, width=10, font = my_font , text="quality", bg="#fff").grid(row=0, column=1, padx=10, pady=10)
Label(bottom2_frame, width=10, font = my_font , text="duration", bg="#fff").grid(row=0, column=2, padx=10, pady=10)
Label(bottom2_frame, width=10, font = my_font , text="progress", bg="#fff").grid(row=0, column=3, padx=10, pady=10)
Label(bottom2_frame, width=10, font = my_font , text="size", bg="#fff").grid(row=0, column=5, padx=10, pady=10)

m_font = tkfont.Font(family = "verdana", size = 10)
channel = Label(bottom2_frame, width=10, font = my_font , text="", bg="#fff")
channel.grid(row=1, column=0, padx=10, pady=10)
quality = Label(bottom2_frame, width=10, font = my_font , text="", bg="#fff")
quality.grid(row=1, column=1, padx=10, pady=10)
duration = Label(bottom2_frame, width=10, font = my_font , text="", bg="#fff")
duration.grid(row=1, column=2, padx=10, pady=10)
progress = Label(bottom2_frame, width=10, font = my_font , text="", bg="#fff")
progress.grid(row=1, column=3, padx=10, pady=10)
size = Label(bottom2_frame, width=10, font = my_font , text="", bg="#fff")
size.grid(row=1, column=5, padx=10, pady=10)

root.mainloop()