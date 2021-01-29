<p align="center"><img src="https://github.com/ahampriyanshu/scripts_101/raw/metadata/logo/youtube.png"></p>

<h1 align="center">youtube_dl_gui</h1>

# Installation

## Linux

```bash
cd && wget https://github.com/ahampriyanshu/scripts_101/files/5870156/yt_dl_gui.tar.gz
tar -xzvf yt_dl_gui.tar.gz && cd yt_dl_gui
mv yt_dl_gui.desktop  ~/.local/share/applications && cd ..
sudo mv yt_dl_gui /usr/bin
```

## Windows

* Download the executable file by clicking [here]()

## Mac

* Download the .dmg file by clicking [here]()


# Setup

```bash
mkdir yt_dl_gui && cd yt_dl_gui
wget -q https://raw.githubusercontent.com/ahampriyanshu/scripts_101/master/youtube_dl_gui/script.py
wget -q https://github.com/ahampriyanshu/scripts_101/files/5872404/requirements.txt
pip3 install -r requirements.txt
chmod +x script.py
./script.py
```

# Dependencies

| Dependency | Version |
| --- | --- | 
| [pytube](https://pypi.org/project/pytube/)  | 10.4.1 | 
| [tkinter](https://wiki.python.org/moin/TkInter) | 1.3.2 |
| [ffmpeg](https://ffmpeg.org/)  | 1.4 |

# Special thanks to

* [FlatIcon](http://www.flaticon.com)