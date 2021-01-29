<p align="center"><img src="https://github.com/ahampriyanshu/scripts_101/raw/metadata/logo/youtube.png"></p>

<h1 align="center">youtube_dl_gui</h1>

<p align="center"><img src="https://raw.githubusercontent.com/ahampriyanshu/scripts_101/metadata/snaps/yt_linux.png"></p>

# Installation

* Note : This application depends on [ffmpeg](https://ffmpeg.org) to merge audio and video of files downloaded above 720p.If you don't want to install ffmpeg then either download till 360p/720p or select audio track seperately while playing the video.

## Linux

### Install ffmpeg(skip if already installed)

* Debian-based : ``sudo apt install ffmpeg``
* Fedora-based : ``yum install ffmpeg ffmpeg-devel``
* Arch-based : ``sudo pacman -S ffmpeg``

### Setup

* Download the AppImage file by clicking [here](https://github.com/ahampriyanshu/scripts_101/releases/download/v1.1/youtube_dl.AppImage)


## Windows

### Install ffmpeg(skip if already installed)

* Download the zipped file by clicking [here](https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z)
* Extract the file
* Rename the extracted folder to **ffmpeg**
* Move the folder to **C:** drive
* Open cmd and run ``setx /m PATH "C:\ffmpeg\bin;%PATH%"``
* To verify the installation run ``ffmpeg -version``

### Install pip(skip if already installed)
```
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
```

### Setup

* Open cmd and paste

```
mkdir youtube_dl_gui && cd youtube_dl_gui
curl -O https://raw.githubusercontent.com/ahampriyanshu/scripts_101/master/youtube_dl_gui/script.py
curl -O https://raw.githubusercontent.com/ahampriyanshu/scripts_101/metadata/txt/yt_re.txt
pip install -r yt_re.txt
python script.py
```

## Mac

### Install ffmpeg(skip if already installed)

```bash
brew install ffmpeg
```

### Install pip(skip if already installed)
```
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
```

### Setup

* Open cmd and paste

```
mkdir youtube_dl_gui && cd youtube_dl_gui
curl -O https://raw.githubusercontent.com/ahampriyanshu/scripts_101/master/youtube_dl_gui/script.py
curl -O https://raw.githubusercontent.com/ahampriyanshu/scripts_101/metadata/txt/yt_re.txt
pip3 install -r yt_re.txt
python3 script.py
```

# Dependencies

| Dependency | Version |
| --- | --- | 
| [pytube](https://pypi.org/project/pytube/)  | 10.4.1 | 
| [tkinter](https://wiki.python.org/moin/TkInter) | 1.3.2 |
| [ffmpeg](https://ffmpeg.org/)  | 1.4 |


# Special thanks

* [FlatIcon](http://www.flaticon.com)

# Contribution

* If possible can someone provide a single one-click executable file(just like AppImage for Linux) for MacOS and windows.
* Is there any method by which video and audio files can be merged without relying on external dependencies.
* Please report any bugs/issue or suggest any improvement.