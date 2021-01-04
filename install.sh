#!/bin/bash
#install

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

echo ""
	echo -e "${Yellow} ========================================================= "
	echo " |                                                       | "
	echo " |           Installation Script in Bash                 | "
	echo " |                 ahampriyanshu                         | "
	echo " |                                                       | "
	echo " ========================================================= "
	echo ""
	echo -e "${UGreen}https://www.ahampriyanshu.github.io"
	echo "ahampriyanshu@gmail.com"
	echo -e "${Reset}"
echo -e "${BPurple} Enter your choice [vlc,chrome,chromium,lamp,firefox,brave,vim,pip] ?${Reset}"

read input

if [ $input == "lamp" ]; then
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

elif [ $input == "chrome" ]; then
	echo "Installing latest version of Chrome"
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	echo "Installation completed"

elif [ $input == "chromium" ] ; then
	echo "Installing latest version of Chromium"
	sudo apt install -y chromium-browser
	echo "Installation completed"

elif [ $input == "firefox" ]; then
	echo "Installing latest version of firefox"
	sudo apt install -y firefox
	echo "Installation completed"

elif [ $input == "brave" ]; then
	echo "Installing latest version of Brave"
	echo "But firstly installling the prequisites"
	sudo apt install apt-transport-https curl
	curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
	echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list


elif [ $input == "vlc" ]; then
	echo "Installing latest version of VLC"
	sudo apt-get install vim
	echo "Installation completed"

elif [ $input == "vim" ]; then
	echo "Installing latest version of VIM"
	sudo apt-get install vim
	echo "Installation completed"

elif [ $input == "pip" ]; then

	echo "Installing pip3"
	sudo apt install python3-pip
	echo "Installation successfully completed"

else 

	echo -e "${BGreen}Quiting ..."
	echo "Tschüss"

fi
