#!/usr/bin/python3
import os
import sys
import math
import subprocess
from threading import *
from pytube import YouTube
from pytube import Playlist
import pytube
from tkinter import *
from tkinter import ttk
from tkinter.filedialog import *
from tkinter.messagebox import *
import tkinter.font as tkfont
import ffmpeg


file_size = 0
downloadqueue = []
resolution = []
symbols = ['', ' K', ' M', ' B']
choices = ("2160p", "1440p", "1080p", "720p", "360p",
           "240p", "144p", "160kbps", "128kbps", "70kbps", "50kbps")


def getViews(views):
    millidx = max(0, min(len(symbols)-1,
                         int(math.floor(0 if views == 0 else math.log10(abs(views))/3))))

    return '{:.2f}{} views'.format(views / 10**(3 * millidx), symbols[millidx])


def getDuration(seconds):
    min, sec = divmod(int(seconds), 60)
    return "%02d:%02d" % (min, sec)


def updateProgress(chunk, file_handle, bytes_remaining):
    file_downloaded = (file_size - bytes_remaining)
    percentage = (file_downloaded/file_size)*100
    progress.config(text=f'{percentage:.2f} %')
    size.config(
        text=f'{file_downloaded/(1024*1024):.2f}/{file_size/(1024*1024):.2f} MB')


def mergeFile(video_name, audio_name, output_name):
    alert.config(text="Merging video and audio")
    subprocess.run(
        f'ffmpeg -i "{video_name}" -i "{audio_name}" -c copy "{output_name}"', shell=True)
    alert.config(text="Deleting temp files")
    os.remove(video_name)
    os.remove(audio_name)


def getVideo():
    global file_size
    i = 0
    task = len(downloadqueue)
    downloadBtn.config(state=DISABLED)
    while not downloadqueue == []:
        url = downloadqueue.pop()
        res = resolution.pop()
        try:
            downloadBtn.config(text=f'Downloading {i+1} out of {task}')
            path_to_save_video = location.get()
            if path_to_save_video is None:
                downloadBtn.config(
                    text="Invalid path! downloading in the directory")
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
                        alert.config(
                            text=f'No match found for {res}! Downloading 720p instead')
                        yt = tube.streams.first()
                        file_size = yt.filesize
                        yt.download(path_to_save_video)
                    else:
                        alert.config(text=f'Downloading video in {res}')
                        video_name = 'video'+str(i)
                        audio_name = 'audio'+str(i)
                        file_size = vi.filesize
                        vi.download(path_to_save_video, filename=video_name)
                        au = tube.streams.get_audio_only()
                        file_size = au.filesize
                        alert.config(text="Now downloading audio file")
                        au.download(path_to_save_video, filename=audio_name)
                        output_name = str(vi.default_filename).rstrip()+'.mp4'
                        video_name += '.mp4'
                        audio_name += '.mp4'
                        mergeThread = Thread(target=mergeFile, args=[
                                             video_name, audio_name, output_name])
                        mergeThread.start()
                else:
                    alert.config(
                        text=f'Downloading video in {res}')
                    file_size = vi.filesize
                    vi.download(path_to_save_video)
            else:
                au = tube.streams.filter(only_audio=True, abr=res).first()
                if au is None:
                    alert.config(
                        text=f'No match found for {res}! Downloading in 128kbps instead')
                    au = tube.streams.get_audio_only()
                    file_size = au.filesize
                    au.download(path_to_save_video)
                else:
                    alert.config(text=f'Downloading audio in {res}')
                    file_size = au.filesize
                    au.download(path_to_save_video)

            caption = tube.captions['en']
            if caption is not None:
                open(tube.title + '.srt',
                     'w').write(caption.generate_srt_captions())
        except Exception as e:
            print(e)
        finally:
            alert.config(text="Video Downloaded Successfully")
            listbox.delete(END)
            i+1
    downloadBtn.config(text="Download")
    downloadBtn.config(state=NORMAL)
    folderText.delete(0, END)
    alert.config(text="Thank you for using this script")
    duration.config(text="")
    views.config(text="")
    quality.config(text="")
    progress.config(text="")
    size.config(text="")


def startDownload():
    if downloadqueue == []:
        alert.config(text="Download queue is empty !")
        addBtn.config(bg="red")
    elif not location.get():
        alert.config(text="Choose valid folder path")
        folderBtn.config(bg="red")
    else:
        downloadThread = Thread(target=getVideo)
        downloadThread.start()


def insertQueue(url, quality):
    try:
        alert.config(text="Adding task to queue")
        listbox.insert(END, YouTube(url).title)
        downloadqueue.append(url)
        resolution.append(quality)
        alert.config(text="Task Added successfully")
    except Exception as e:
        return e


def validateUrl():
    addBtn.config(text="Adding...")
    addBtn.config(state=DISABLED)
    url = urlText.get()
    quality = monthchoosen.get()
    alert.config(text="Validating url")
    try:
        playlist = Playlist(url)
        totalVideos = len(playlist.video_urls)
        downloadBtn.config(state=DISABLED)
        videoIndex = 1
        for video in playlist:
            insertQueue(video, quality)
            downloadBtn.config(
                text=f'Adding {videoIndex} out of {totalVideos}')
            videoIndex += 1

    except KeyError:
        insertQueue(url, quality)

    except pytube.exceptions.RegexMatchError:
        alert.config(text="Given url doesn't contain valid data")

    except (pytube.exceptions.MembersOnly, pytube.exceptions.RecordingUnavailable, pytube.exceptions.LiveStreamError):
        alert.config(text="Video is either livestream or members-only")

    except (pytube.exceptions.ExtractError, pytube.exceptions.HTMLParseError):
        alert.config(text="Error occured while extracting/parsing data")

    except (pytube.exceptions.VideoPrivate, pytube.exceptions.VideoRegionBlocked, pytube.exceptions.VideoUnavailable):
        alert.config(
            text="Video is regionally-blocked/unavailable or private-only")

    except Exception as e:
        print(e)
        alert.config(text="Unknown Error! maybe your internet connection")
    finally:
        monthchoosen.current(3)
        urlText.delete(0, END)
        addBtn.config(text="Add")
        addBtn.config(state=NORMAL)
        downloadBtn.config(text="Download")
        downloadBtn.config(state=NORMAL)


def addUrl():
    addBtn.config(bg="#273239")
    addThread = Thread(target=validateUrl)
    addThread.start()


def pickfolder():
    folderBtn.config(bg="#273239")
    filename = askdirectory()
    location.set(filename)


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
    urlLabel = Label(entry_frame, text="Enter url",
                     font=btnFont, bg="#fff", pady=10).grid(row=1, column=0, pady=5)
    urlText = Entry(entry_frame, width=29)
    urlText.place(x=93, y=15)
    monthchoosen = ttk.Combobox(entry_frame, state="readonly",  values=choices,
                                width=7, background="#273239")
    monthchoosen.place(x=345, y=15)
    monthchoosen.current(3)
    addBtn = Button(entry_frame, text="Add", command=addUrl, relief=FLAT,
                    width=10, fg="#fff",  bg="#273239",
                    activebackground="#666", activeforeground="#fff")
    addBtn.grid(row=1,  column=3,   pady=1,)
    folderLabel = Label(
        entry_frame,  text="Enter Path", font=btnFont, bg="#fff", pady=10).grid(row=2,  column=0, pady=5, padx=5)
    folderText = Entry(entry_frame,   width=40,   textvariable=location)
    folderText.grid(row=2,   column=1, pady=5,  padx=5)
    folderBtn = Button(entry_frame, text="Browse", relief=FLAT, command=pickfolder,
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

    downloadBtn = Button(message_frame, text="Download", font=("Agency FB", 10), relief=FLAT, command=startDownload,
                         width=20, fg="#fff", bg="#273239",
                         activebackground="#666", activeforeground="#fff")
    downloadBtn.grid(row=0, column=2, pady=10, padx=3)
    alertFont = tkfont.Font(family="Helvetica", size=10)
    alert = Label(message_frame, text="",
                  width=60, font=alertFont, bg="#fff", pady=10)
    alert.grid(row=1, column=2)
    infoFont = tkfont.Font(family="Helvetica", size=10)
    views = Label(info_frame, width=15, font=infoFont, text="", bg="#fff")
    views.grid(row=1, column=0, padx=10, pady=10)
    quality = Label(info_frame, width=8, font=infoFont, text="", bg="#fff")
    quality.grid(row=1, column=1, padx=10, pady=10)
    duration = Label(info_frame, width=8, font=infoFont, text="", bg="#fff")
    duration.grid(row=1, column=2, padx=10, pady=10)
    progress = Label(info_frame, width=10, font=infoFont, text="", bg="#fff")
    progress.grid(row=1, column=3, padx=10, pady=10)
    size = Label(info_frame, width=20, font=infoFont, text="", bg="#fff")
    size.grid(row=1, column=5, padx=10, pady=10)
    root.mainloop()
