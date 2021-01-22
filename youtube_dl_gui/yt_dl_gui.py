import sys
from pytube import *
from tkinter import *
from tkinter.filedialog import *
from tkinter.messagebox import *
from threading import *

file_size = 0

def progess(chunk, file_handle,bytes_remaining):
    file_downloaded = (file_size - bytes_remaining)
    per = (file_downloaded/file_size)*100
    btn.config(text=f'{per:.2f} %')
    
def getVideo():
    global file_size
    try:
        btn.config(text="Please wait ...")
        btn.config(state=DISABLED)
        path_to_save_video = askdirectory()
        if path_to_save_video is None:
            return
        ob = YouTube(url.get(),on_progress_callback=progess)
        video = ob.streams.first()
        file_size = video.filesize
        title.config(text=video.title)
        title.pack(side=TOP,pady=10)
        video.download(path_to_save_video)
        btn.config(text="Start Download")
        btn.config(state=NORMAL)
        showinfo("Download Finished","Success")
        url.delete(0,END)
        title.pack_forget( )

    except Exception as e:
        showinfo("Error","Exiting...")
        print(e)
        sys.exit()

def startDownload():
    thread=Thread(target=getVideo)
    thread.start()

gui = Tk()
gui.title("yt_dl_gui")
gui.geometry("500x600")
url=Entry(gui, font=("veranda",18),justify=CENTER)
url.pack(side=TOP,fill=X,padx=10)
btn = Button(gui,text="start download",font=("verdana",18),relief='ridge',command=startDownload)
btn.pack(side=TOP,pady=10)
title = Label(gui,text="",padx=20)
gui.mainloop()