from pytube import *

url = "https://www.youtube.com/watch?v="
path_to_save_video ="/home/priyanshu/Downloads/"
ob = YouTube(url)

strm = ob.streams.first()
print(f'{strm.filesize/(1024):.2f} KiB')
print(strm.title)
strm.download(path_to_save_video)
print("video downloaded")