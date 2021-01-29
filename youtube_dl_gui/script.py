#!/usr/bin/python3
import os
import sys
from math import floor, log10
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


file_size = 0
downloadQueue = []
resolutionQueue = []
symbols = ['', ' K', ' M', ' B']
resolutions = ("2160p", "1440p", "1080p", "720p", "360p",
           "240p", "144p", "160kbps", "128kbps", "70kbps", "50kbps")


class Error(Exception):
    """Base class for other exceptions"""
    pass


class DuplicateUrlError(Error):
    """Raised when duplicate url is entered"""
    pass


class EmptyStringError(Error):
    """Raised when an empty string is entered"""
    pass


class MergeError(Error):
    """Raised when error occurs while merging"""
    pass


def getViews(views):
    millidx = max(0, min(len(symbols)-1,
                         int(floor(0 if views == 0 else log10(abs(views))/3))))

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


def getSrt(tube):
    try:
        caption = tube.captions['en']
    except:
        return False
    else:
        return True


def getData():
    addBtn.config(state=DISABLED)
    addBtn.config(bg="#273239")
    downloadBtn.config(state=DISABLED)
    global file_size
    i = 0
    task = len(downloadQueue)
    filePath = askdirectory()
    if filePath is None:
        downloadBtn.config(text="Directory inaccessible")
        return
    while not downloadQueue == []:
        url = downloadQueue.pop()
        res = resolutionQueue.pop()
        try:
            downloadBtn.config(text=f'Downloading {i+1} out of {task}')
            tube = YouTube(url, on_progress_callback=updateProgress)
            duration.config(text=getDuration(tube.length))
            views.config(text=getViews(float(tube.views)))
            quality.config(text=res)
            index = resolutions.index(res)
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
                        yt.download(filePath)
                    else:
                        alert.config(text=f'Downloading video in {res}')
                        file_size = vi.filesize
                        vi.download(filePath, filename='video')
                        alert.config(text="Downloading audio file now")
                        au = tube.streams.get_audio_only()
                        file_size = au.filesize
                        au.download(filePath, filename='audio')
                        outputVideo = os.path.join(
                            filePath, vi.default_filename)
                        inputVideo = os.path.join(filePath, 'video.mp4')
                        inputAudio = os.path.join(filePath, 'audio.mp4')
                        alert.config(text="Merging video and audio")
                        ffmpegCmd = subprocess.run(
                            f'ffmpeg -i "{inputVideo}" -i "{inputAudio}" -c copy -y "{outputVideo}"', shell=True)
                        if ffmpegCmd.returncode:
                            raise MergeError
                        alert.config(text="Deleting temp files")
                        os.remove(inputVideo)
                        os.remove(inputAudio)
                else:
                    alert.config(
                        text=f'Downloading video in {res}')
                    file_size = vi.filesize
                    vi.download(filePath)
            else:
                au = tube.streams.filter(only_audio=True, abr=res).first()
                if au is None:
                    alert.config(
                        text=f'No match found for {res}! Downloading in 128kbps instead')
                    au = tube.streams.get_audio_only()
                    file_size = au.filesize
                    au.download(filePath)
                else:
                    alert.config(text=f'Downloading audio in {res}')
                    file_size = au.filesize
                    au.download(filePath)
            if getSrt(tube):
                open(tube.default_filename + '.srt',
                     'w').write(tube.captions['en'].generate_srt_captions())
            alert.config(text="Download complete")
        except MergeError:
            alert.config(text="Unknown error occured while merging")
        except PermissionError:
            alert.config(text="Directory inaccessible")
        except MemoryError:
            alert.config(text="Out of memroy")
        except:
            alert.config(text="Unknown error occured while downloading")
        finally:
            listbox.delete(END)
            i+1
    downloadBtn.config(text="Download")
    downloadBtn.config(state=NORMAL)
    addBtn.config(state=NORMAL)
    duration.config(text="")
    views.config(text="")
    quality.config(text="")
    progress.config(text="")
    size.config(text="")


def startDownload():
    if downloadQueue == []:
        alert.config(text="Download queue is empty!")
        addBtn.config(bg="red")
        return
    downloadThread = Thread(target=getData)
    downloadThread.start()


def insertQueue(url, quality):
    try:
        listbox.insert(END, YouTube(url).title)
        downloadQueue.append(url)
        resolutionQueue.append(quality)
    except:
        alert.config(text="The url contain invalid data")
    else:
        alert.config(text="Added Successfully")


def validateUrl():
    addBtn.config(state=DISABLED)
    addBtn.config(text="Adding...")
    url = urlEntry.get()
    urlEntry.delete(0, END)
    quality = optedResolution.get()
    optedResolution.current(3)
    alert.config(text="Validating url")
    try:
        if url in downloadQueue:
            raise DuplicateUrlError
        if(not (url and not url.isspace())):
            raise EmptyStringError
        playlist = Playlist(url)
        alert.config(text="This may take a while")
        downloadBtn.config(state=DISABLED)
        totalVideos = len(playlist.video_urls)
        videoIndex = 1
        for video in playlist:
            insertQueue(video, quality)
            downloadBtn.config(
                text=f'Adding {videoIndex} out of {totalVideos}')
            videoIndex += 1
    except KeyError:
        alert.config(text="Adding task to queue")
        insertQueue(url, quality)

    except EmptyStringError:
        alert.config(text="Empty String!")

    except DuplicateUrlError:
        alert.config(text="Task already exists")

    except pytube.exceptions.RegexMatchError:
        alert.config(text="Given url contains invalid data")

    except (pytube.exceptions.MembersOnly, pytube.exceptions.RecordingUnavailable, pytube.exceptions.LiveStreamError):
        alert.config(text="Video is either a livestream or a member-only")

    except (pytube.exceptions.ExtractError, pytube.exceptions.HTMLParseError):
        alert.config(text="Error occured while extracting/parsing the data")

    except (pytube.exceptions.VideoPrivate, pytube.exceptions.VideoRegionBlocked, pytube.exceptions.VideoUnavailable):
        alert.config(
            text="Video is either regionally-blocked/unavailable or private-only")

    except Exception as e:
        print(e)
        alert.config(text="Unknown error! perhaps your internet connection")
    else:
        startDownload()
    addBtn.config(text="Add")
    addBtn.config(state=NORMAL)
    downloadBtn.config(text="Download")
    downloadBtn.config(state=NORMAL)


def addUrl():
    addBtn.config(bg="#273239")
    addThread = Thread(target=validateUrl)
    addThread.start()


if __name__ == '__main__':
    root = Tk()
    root.title("Youtube Video Downloader")
    root.geometry("600x400")
    root.resizable(False, False)
    root.config(background="#fff")

    url_frame = Frame(root, bg="#fff")
    res_frame = Frame(root, bg="#fff")
    listbox_frame = Frame(root, bg="#fff")
    message_frame = Frame(root, bg="#fff")
    info_frame = Frame(root, bg="#fff")

    url_frame.grid(row=1)
    res_frame.grid(row=2)
    listbox_frame.grid(row=3)
    message_frame.grid(row=6)
    info_frame.grid(row=7)

    btnFont = tkfont.Font(family="Helvetica", size=12)
    urlEntry = Entry(url_frame, width=50)
    urlEntry.grid(row=1, column=0, padx=10, pady=5)
    optedResolution = ttk.Combobox(url_frame, state="readonly",  values=resolutions,
                                   width=7, background="#273239")
    optedResolution.grid(row=1, column=3, pady=10)
    optedResolution.current(3)
    addBtn = Button(res_frame, text="Add", command=addUrl, relief=FLAT,
                    width=10, fg="#fff",  bg="#273239",
                    activebackground="#666", activeforeground="#fff")
    addBtn.grid(row=1,  column=3, pady=10,)
    listbox = Listbox(listbox_frame, width=60)
    listbox.grid(column=0, row=3, columnspan=5, padx=10, pady=10, sticky=W+E)
    yscroll = Scrollbar(command=listbox.yview, orient=VERTICAL)
    yscroll.grid(row=3, column=5, sticky='ns')
    listbox.configure(yscrollcommand=yscroll.set)
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
