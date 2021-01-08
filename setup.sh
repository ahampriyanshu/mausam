#!/bin/bash
#setup
#The MIT License (MIT)

#Copyright (c) 2020 Priyanshu Tiwari

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

Reset='\033[0m'       # Text Reset

Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White


progressbar() {
local duration
local columns
local space_available
local fit_to_screen
local space_reserved

space_reserved=6
duration=20
columns=$(tput cols)
space_available=$(( columns-space_reserved ))

if (( duration < space_available )); then
fit_to_screen=1;
else
fit_to_screen=$(( duration / space_available ));
fit_to_screen=$((fit_to_screen+1));
fi

already_done() { for ((done=0; done<(elapsed / fit_to_screen) ; done=done+1 )); do printf "▇"; done }
remaining() { for (( remain=(elapsed/fit_to_screen) ; remain<(duration/fit_to_screen) ; remain=remain+1 )); do printf " "; done }
percentage() { printf "| %s%%" $(( ((elapsed)*100)/(duration)*100/100 )); }
clean_line() { printf "\r"; }

for (( elapsed=1; elapsed<=duration; elapsed=elapsed+1 )); do
already_done; remaining; percentage
sleep 0.1
clean_line
done
clean_line
}

countdown() {
secs=$1
shift
msg=$@
while [ $secs -gt 0 ]
do
printf "\r\033[K${IRed}$msg in %.d seconds" $((secs--))
sleep 1
done
}

helpme(){
echo -e "${IGreen}|---------------------------------------|"
echo    "|  Would you mind helping me, please?   |"
echo    "|---------------------------------------|"
echo -e "${IRed}Your OS isn't supported yet"
echo "You can contribute and make this script even better"
echo -e "${UGreen}https://github.com/ahampriyanshu/scripts_101"
echo -e "${Reset}"
}

mac(){
echo -e "${IGreen}---------------------------------"
echo "      Distro Information           "
echo "---------------------------------"
echo ""
system_profiler SPSoftwareDataType
echo -e "${Reset}"

helpme
}

kali(){
echo -e "${IGreen}---------------------------------"
echo "      Distro Information           "
echo "---------------------------------"
echo ""
cat /etc/debian_version
echo -e "${Reset}"

helpme
}

ubuntu(){

echo -e "${IGreen}---------------------------------"
echo "      Distro Information           "
echo "---------------------------------"
echo ""
cat /etc/lsb-release
echo -e "${Reset}"

countdown 3 Installation starting

while :
do

clear
echo -e "${IWhite}---------------------------------"
echo "      Installation Menu            "
echo "---------------------------------"
echo "1. Clang"
echo "2. VS Code"
echo "3. Sublime Text"
echo "4. Libre Office"
echo "5. LAMP Stack"
echo "6. MEAN Stack"
echo "7. NodeJS"
echo "8. Golang"
echo "9. Virtual Box"
echo "10. qBittorrent"
echo "11. Kazam"
echo "12. Chrome"
echo "13. Chromium"
echo "14. Mozilla Firefox"
echo "15. Brave"
echo "16. VLC"
echo "17. Vim"
echo "18. Emacs"
echo "19. Gnome-tweaks"
echo "20. Pycharm"
echo "21. Anaconda"
echo -e "Enter ${URed}quit${Reset} or Ctrl+C to exit"
echo "---------------------------------"
read -r -p "Enter your choice [1-18] : " c
# take action
case $c in
1)
echo -e "${IGreen}Installing latest version of Clang"
echo -e "${Reset}"
sudo apt install clang
echo -e "${IGreen}Installation completed"

;;

2)
echo -e "${IGreen}Installing latest version of VS Code"
echo -e "${Reset}"
sudo apt install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code
echo -e "${IGreen}Installation completed"
;;

3)
echo -e "${IGreen}Installing latest version of Sublime Text"
echo -e "${Reset}"

sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
sudo apt update
sudo apt install sublime-text
echo -e "${IGreen}Installation completed"
;;

4)
echo -e "${IGreen}Installing latest version of Libre Office"
echo -e "${Reset}"
sudo add-apt-repository ppa:libreoffice/ppa
sudo apt update
sudo apt install libreoffice


echo -e "${IGreen}Installation completed"
;;

5)
echo -e "${IGreen}Installing latest version of LAMP"
echo -e "${Reset}"
echo "Installing Apache2"
sudo apt update
sudo apt install apache2 -y
sudo apache2ctl configtest

echo "Adjusting Firewall"
sudo ufw app list
sudo ufw app info "Apache Full"
sudo ufw allow in "Apache Full"

echo "Installing Mysql"
sudo apt install mysql-server -y

echo "Installing PHP"
sudo apt install php libapache2-mod-php php-mcrypt php-mysql -y

echo "Inastalling phpmyadmin..."
sudo apt-get update
sudo apt-get install phpmyadmin php-mbstring php-gettext
sudo phpenmod mcrypt
sudo phpenmod mbstring
sudo systemctl restart apache2

sudo systemctl start apache2
echo "Installation completed"
sudo systemctl status apache2
echo -e "${IGreen}Installation completed"
;;

6)
echo -e "${IGreen}Installing MongoDB ]"
echo -e "${Reset}"
sudo apt-get install gnupg -y
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
sudo apt update
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
service mongod status

echo -e "${IGreen}Installing NodeJS "
echo -e "${Reset}"
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash –
sudo apt install -y nodejs
sudo apt install build-essential

echo "MEAN stack Installed";;

7)
echo -e "${IGreen}Installing latest version of fffff"
echo -e "${Reset}"

echo -e "${IGreen}Installation completed"
;;

8)
echo -e "${IGreen}Installing latest version of Golang"
echo -e "${Reset}"
wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo -e "${IGreen}Installation completed"
;;

9)
echo -e "${IGreen}Installing latest version of Virtual Box"
echo -e "${Reset}"
sudo apt-get update
sudo apt-get install virtualbox
sudo apt-get install virtualbox—ext–pack
echo -e "${IGreen}Installation completed"
;;

10)
echo -e "${IGreen}Installing latest version of Kazam"
echo -e "${Reset}"
sudo apt install kazam
echo -e "${IGreen}Installation completed"
;;

11)
echo -e "${IGreen}Installing latest version of qBittorrent"
echo -e "${Reset}"
sudo apt install qbittorrent
echo -e "${IGreen}Installation completed"
;;


12)
echo -e "${IGreen}Installing latest version of Chrome"
echo -e "${Reset}"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
echo -e "${IGreen}Installation completed"
;;

13)
echo -e "${IGreen}Installing latest version of Chromium"
echo -e "${Reset}"
sudo apt install -y chromium-browser
echo -e "${IGreen}Installation completed";;


14)
echo -e "${IGreen}Installing latest version of firefox"
echo -e "${Reset}"
sudo apt install -y firefox
echo -e "${IGreen}Installation completed";;

15)
echo -e "${IGreen}Installing latest version of Brave"
echo "But firstly installling the prequisites"
echo -e "${Reset}"
sudo apt install apt-transport-https curl
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
;;

16)
echo -e "${IGreen}Installing latest version of VLC"
echo -e "${Reset}"
sudo apt-get install vim
echo -e "${IGreen}Installation completed";;

17)
echo -e "${IGreen}Installing latest version of VIM"
echo -e "${Reset}"
sudo apt-get install vim
echo -e "${IGreen}Installation completed";;

18)
echo -e "${IGreen}Installing latest version of EMACS"
echo -e "${Reset}"
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt-get update
sudo apt install emacsVERSION
echo -e "${IGreen}Installation completed";;

19)
echo -e "${IGreen}Installing latest version of gnome-tweaks"
echo -e "${Reset}"
sudo apt install gnome-tweaks
echo -e "${IGreen}Installation completed";;

20)
echo -e "${IGreen}Installing latest version of pyCharm"
echo -e "${Reset}"
wget -q https://download.jetbrains.com/python/pycharm-community-2020.3.2.tar.gz?_ga=2.51716457.1746728834.1610096895-1594661800.1610096895
tar -xzf pycharm-community-2020.1.1.tar.gz
cd pycharm-community-2020.1.1
cd bin
chmod u+x pycharm.sh
echo -e "${IGreen}Installation completed";;

21)
echo -e "${IGreen}Installing latest version of Conda"
echo -e "${Reset}"
cd /tmp
curl -O https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
bash Anaconda3-2019.03-Linux-x86_64.sh
source ~/.bashrc
echo -e "${IGreen}Installation completed";;


quit)
echo -e "${BGreen}Quiting ..."
echo "Bye"
break;;
*) Pause "Select between 1 to 21 only"
esac
done

}

echo ""
echo -e "${ICyan} ========================================================= "
echo " |                                                       | "
echo " |           Installation Script in Bash                 | "
echo " |               by ahampriyanshu                        | "
echo " |                                                       | "
echo " ========================================================= "
echo ""
echo -e "${UGreen}https://ahampriyanshu.github.io"
echo "mailto:ahampriyanshu@gmail.com"
echo -e "${Reset}"
echo -e "${BYellow}Detecting System Configuration"
echo -e "${Reset}"
progressbar
echo -e ""
(test -f /etc/lsb-release && ubuntu) || (test -f /etc/debian_version && kali) || (mac)
