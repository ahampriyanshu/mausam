#!/usr/bin/python3
import sys
import os
import re
from pytube import YouTube
from tkinter import *
from tkinter import ttk
from tkinter.filedialog import *
from tkinter.messagebox import *
import tkinter.font as tkfont
from threading import *
import subprocess
import ffmpeg
import math


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
symbols = ['',' K',' M',' B']
choices = ("2160p", "1440p", "1080p", "720p", "360p",
           "240p", "144p", "160kbps", "128kbps", "50kbps")

def getViews(views):
    millidx = max(0,min(len(symbols)-1,
                        int(math.floor(0 if views == 0 else math.log10(abs(views))/3))))

    return '{:.2f}{} views'.format(views / 10**(3 * millidx), symbols[millidx])

def getDuration(seconds):
    min, sec = divmod(int(seconds), 60)
    return "%02d:%02d" % (min, sec)


def updateProgress(chunk, file_handle, bytes_remaining):
    file_downloaded = (file_size - bytes_remaining)
    per = (file_downloaded/file_size)*100
    progress.config(text=f'{per:.2f} %')
    size.config(
        text=f'{file_downloaded/(1024*1024):.2f}/{file_size/(1024*1024):.2f} mb')


def getVideo():
    global file_size
    i = 0
    task = len(downloadqueue)
    while not downloadqueue == []:
        url = downloadqueue.pop()
        res = resolution.pop()
        listbox.activate(0)
        try:
            downloadBtn.config(text=f'Downloading {i+1} out of {task}')
            downloadBtn.config(state=DISABLED)
            path_to_save_video = location.get()
            if path_to_save_video is None:
                path_to_save_video = ""
            tube = YouTube(url, on_progress_callback=updateProgress)
            duration.config(text=getDuration(tube.length))
            views.config(text=getViews(float(tube.views)))
            quality.config(text=res)
            index = choices.index(res)
            if index < 7:
                vi = tube.streams.filter(res=res, progressive=True).first()
                if vi is None:
                    vi = tube.streams.filter(
                        res=res, adaptive=True, subtype="mp4").first()
                    if vi is None:
                        alert.config(text="Downloading progressive file in 720p")
                        yt = tube.streams.first()
                        file_size = yt.filesize
                        yt.download(path_to_save_video)
                    else:
                        alert.config(text="Downloading dash video")
                        file_size = vi.filesize
                        vi.download(path_to_save_video, filename='video')
                        au = tube.streams.get_audio_only()
                        file_size = au.filesize
                        alert.config(text="Downloading dash audio")
                        au.download(path_to_save_video, filename='audio')
                        lin = str(vi.title).rstrip()
                        lin2 = (lin+'.mp4')
                        alert.config(text="Merging")
                        subprocess.run(
                            f'ffmpeg -i video.mp4 -i audio.mp4 -c copy "{lin2}"', shell=True)
                        alert.config(text="Deleting temp files")
                        os.remove('video.mp4')
                        os.remove('audio.mp4')
                else:
                    alert.config(text="Progressive stream found for given data")
                    file_size = vi.filesize
                    vi.download(path_to_save_video)
            else:
                au = tube.streams.filter(only_audio=True, abr=res)
                if au is None:
                    alert.config(text="Downloading default highest quality audio")
                    au = tube.streams.get_audio_only()
                    file_size = au.filesize
                    au.download(path_to_save_video)
                else:
                    alert.config(text="Downloading audio")
                    file_size = au.filesize
                    au.download(path_to_save_video)

            # caption = source.captions.get_by_language_code('en')
            # caption_convert_to_srt =(en_caption.generate_srt_captions())
            caption = tube.captions['en']
            if caption is not None:
                open(tube.title + '.srt', 'w').write(caption.generate_srt_captions())
        except Exception as e:
            print(e)
        else:
            alert.config(text="Video Downloaded Successfully")
        listbox.delete(END)
        i+1
    downloadBtn.config(text="Download")
    downloadBtn.config(state=NORMAL)
    alert.config(text="Thank you for using this script")
    duration.config(text="")
    views.config(text="")
    quality.config(text="")
    progress.config(text="")
    size.config(text="")



def pickfolder():
    folderBtn.config(bg="#273239")
    filename = askdirectory()
    location.set(filename)


def validateUrl():
    addBtn.config(text="Adding...")
    addBtn.config(state=DISABLED)
    link = linkText.get()
    alert.config(text="Validating given url")
    try:
        re.match(regex, link)
        if link in downloadqueue:
            alert.config(text="Task already exist")
        else:
            alert.config(text="Fetching details")
            listbox.insert(END, YouTube(link).title)
            downloadqueue.append(link)
            resolution.append(monthchoosen.get())
            linkText.delete(0, END)
            alert.config(text="Added successfully")
    except Exception as e:
        print(e)
        alert.config(text="No data found for given url")
    finally:
        monthchoosen.current(3)
        addBtn.config(text="Add")
        addBtn.config(state=NORMAL)


def startDownload():
    if downloadqueue == []:
        alert.config(text="Download Queue is Empty")
        addBtn.config(bg="red")
    elif not location.get():
        alert.config(text="Choose file path")
        folderBtn.config(bg="red")
    else:
        thread = Thread(target=getVideo)
        thread.start()


def addUrl():
    addBtn.config(bg="#273239")
    thread = Thread(target=validateUrl)
    thread.start()


if __name__ == '__main__':
    root = Tk()
    root.title("Youtube Video Downloader")
    root.geometry("600x500")
    root.resizable(False, False)
    root.config(background="#fff")
    video_Link = StringVar()
    location = StringVar()

    entry_frame = Frame(root, bg="#fff")
    listbox_frame = Frame(root, bg="#fff")
    message_frame = Frame(root, bg="#fff")
    info_frame = Frame(root, bg="#fff")

    entry_frame.grid(row=0)
    listbox_frame.grid(row=3)
    message_frame.grid(row=6)
    info_frame.grid(row=7)

    btnFont = tkfont.Font(family="Helvetica", size=12)
    link_label = Label(entry_frame, text="Video url",
                       font=btnFont, bg="#fff", pady=10)
    link_label.grid(row=1, column=0, pady=5)
    linkText = Entry(entry_frame, width=29)
    linkText.place(x=80, y=15)
    monthchoosen = ttk.Combobox(entry_frame, state="readonly",  values=choices,
                                width=7, background="#273239")
    monthchoosen.place(x=334, y=15)
    monthchoosen.current(3)
    addBtn = Button(entry_frame, text="Add", command=addUrl,
                   width=10, fg="#fff",  bg="#273239",	
activebackground="#666", activeforeground="#fff")
    addBtn.grid(row=1,  column=3,   pady=1,)
    destination_label = Label(
        entry_frame,  text="File Path", font=btnFont, bg="#fff", pady=10)
    destination_label.grid(row=2,  column=0, pady=5, padx=5)
    destinationText = Entry(entry_frame,   width=40,   textvariable=location)
    destinationText.grid(row=2,   column=1, pady=5,  padx=5)
    folderBtn = Button(entry_frame, text="Browse", command=pickfolder,
                      width=10, fg="#fff",  bg="#273239",	
activebackground="#666", activeforeground="#fff")
    folderBtn.grid(row=2,  column=3,   pady=1, padx=5)

    listbox = Listbox(listbox_frame, width=70)
    listbox.grid(column=0, row=3, columnspan=5, padx=10, sticky=W+E)
    yscroll = Scrollbar(command=listbox.yview, orient=VERTICAL)
    yscroll.grid(row=3, column=5, sticky='ns')
    listbox.configure(yscrollcommand=yscroll.set)
    xscroll = Scrollbar(command=listbox.xview, orient=HORIZONTAL)
    xscroll.grid(row=4, column=0, columnspan=5, padx=10, pady=10, sticky=W+E)
    listbox.configure(xscrollcommand=xscroll.set)

    downloadBtn = Button(message_frame, text="Download",font=("Agency FB",10),relief='ridge', command=startDownload,
                        width=20, fg="#fff", bg="#273239",	
activebackground="#666", activeforeground="#fff")
    downloadBtn.grid(row=0, column=2, pady=10, padx=3)
    alertFont = tkfont.Font(family="Helvetica", size=10)
    alert = Label(message_frame, text="Thank you for using this script",
                 width=60, font=alertFont, bg="#fff", pady=10)
    alert.grid(row=1, column=2)

    infoFont = tkfont.Font(family="Helvetica", size=10)
    views = Label(info_frame, width=10, font=infoFont, text="", bg="#fff")
    views.grid(row=1, column=0, padx=10, pady=10)
    quality = Label(info_frame, width=10, font=infoFont, text="", bg="#fff")
    quality.grid(row=1, column=1, padx=10, pady=10)
    duration = Label(info_frame, width=10, font=infoFont, text="", bg="#fff")
    duration.grid(row=1, column=2, padx=10, pady=10)
    progress = Label(info_frame, width=10, font=infoFont, text="", bg="#fff")
    progress.grid(row=1, column=3, padx=10, pady=10)
    size = Label(info_frame, width=10, font=infoFont, text="", bg="#fff")
    size.grid(row=1, column=5, padx=10, pady=10)
    root.mainloop()
