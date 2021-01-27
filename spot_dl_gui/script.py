import os
import sys
import re
from tkinter import *
import tkinter.font as tkFont

downloadqueue = []

def searchQuery(s1):
    return "'{}'".format(s1)

url = 'dfsdfsadfds'

if not re.compile("^(spotify:|https://[a-z]+\.spotify\.com/)").match(url):
    url = searchQuery(url)

def getVideo():
    downloadBtn.config(state=DISABLED)
    global file_size
    i = 0
    task = len(downloadqueue)
    filePath = askdirectory()
    if filePath is None:
        downloadBtn.config(text="Invalid path! downloading in the directory")
        return
    operating_system = platform.system()
    ffmpeg = 'ffmpeg'
    if operating_system == 'Windows':
        ffmpeg = 'C:\ffmpeg\bin\ffmpeg.exe'
    elif operating_system == 'Darwin':
        ffmpeg = '/usr/local/bin/ffmpeg'
    while not downloadqueue == []:
        url = downloadqueue.pop()
        res = resolution.pop()
        try:
            downloadBtn.config(text=f'Downloading {i+1} out of {task}')
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
                        yt.download(filePath)
                    else:
                        alert.config(text=f'Downloading video in {res}')
                        file_size = vi.filesize
                        vi.download(filePath, filename='video')
                        alert.config(text="Now downloading audio file")
                        au = tube.streams.get_audio_only()
                        file_size = au.filesize
                        au.download(filePath, filename='audio')
                        outputVideo =filePath+'/'+str(vi.default_filename)
                        inputVideo = filePath+'/video.mp4'
                        inputAudio = filePath+'/audio.mp4'
                        alert.config(text="Merging video and audio")
                        ffmpegCmd = subprocess.run(
                            f'"{ffmpeg}" -i "{inputVideo}" -i "{inputAudio}" -c copy "{outputVideo}"', shell=True)
                        alert.config(text="Deleting temp files")
                        if not ffmpegCmd:
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
    else:
        downloadThread = Thread(target=getVideo)
        downloadThread.start()


def insertQueue(url, quality):
    try:
        listbox.insert(END, YouTube(url).title)
        downloadqueue.append(url)
        resolution.append(quality)
    except Exception as e:
        return e


def validateUrl():
    addBtn.config(text="Adding...")
    addBtn.config(state=DISABLED)
    url = urlEntry.get()
    quality = optedResolution.get()
    alert.config(text="Validating url")
    try:
        playlist = Playlist(url)
        alert.config(text="this may take a while")
        downloadBtn.config(state=DISABLED)
        totalVideos = len(playlist.video_urls)
        videoIndex = 1
        for video in playlist:
            insertQueue(video, quality)
            downloadBtn.config(
                text=f'Adding {videoIndex} out of {totalVideos}')
            videoIndex += 1
    except KeyError:
        alert.config(text="Adding video to queue")
        insertQueue(url, quality)

    except pytube.exceptions.RegexMatchError:
        alert.config(text="Given url doesn't contain valid data")

    except (pytube.exceptions.MembersOnly, pytube.exceptions.RecordingUnavailable, pytube.exceptions.LiveStreamError):
        alert.config(text="Video is either a livestream or a members-only")

    except (pytube.exceptions.ExtractError, pytube.exceptions.HTMLParseError):
        alert.config(text="Error occured while extracting/parsing the data")

    except (pytube.exceptions.VideoPrivate, pytube.exceptions.VideoRegionBlocked, pytube.exceptions.VideoUnavailable):
        alert.config(
            text="Video is either regionally-blocked/unavailable or private-only")

    except Exception as e:
        print(e)
        alert.config(text="Unknown Error! maybe your internet connection")
    finally:
        alert.config(text="Task added successfully")
        optedResolution.current(3)
        urlEntry.delete(0, END)
        addBtn.config(text="Add")
        addBtn.config(state=NORMAL)
        downloadBtn.config(text="Download")
        downloadBtn.config(state=NORMAL)


def addUrl():
    addBtn.config(bg="#273239")
    addThread = Thread(target=validateUrl)
    addThread.start()

if __name__ == "__main__":
    root = Tk()
    root.title("Spotify Downloader")
    root.geometry("600x450")
    root.resizable(width=False, height=False)


    ft = tkFont.Font(family='Times', size=14)
    urlEntry = Entry(root, borderwidth="1px", font=ft, fg="#333333", justify="center")
    urlEntry.place(x=50, y=30, width=380, height=50)

    ft = tkFont.Font(family='Times', size=10)
    addBtn = Button(root,activeforeground="#ffffff", activebackground="#008500", bg="#008000", font=ft, fg="#ffffff", justify="center", text="Add", relief="flat")
    addBtn.place(x=450, y=30, width=100, height=50)

    listbox = Listbox(root, width=60)
    listbox.place(x=50, y=110, width=500, height=200)

    ft = tkFont.Font(family='Times', size=10)
    downloadBtn = Button(root,activeforeground="#ffffff", activebackground="#008500", bg="#008000", font=ft, fg="#ffffff", justify="center", text="Download", relief="flat")
    downloadBtn.place(x=230, y=340, width=150, height=50)
    
    root.mainloop()
