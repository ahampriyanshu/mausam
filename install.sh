#!/bin/bash
#lamp

echo "Hallo"
echo "You need to install  ?"

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
	echo "Installing latest version of Chromium"
	sudo apt install -y firefox
	echo "Installation completed"

elif [ $input == "brave" ]; then
	echo "Installing latest version of Brave"
	echo "But firstly installling the prequisites"
	sudo apt install apt-transport-https curl
	curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
	echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list


elif [ $input == "vlc" ]; then
	echo "Installing latest version of VLC
	sudo apt-get install vim
	echo "Installation completed"

elif [ $input == "vim" ]; then
	echo "Installing latest version of VIM"
	sudo apt-get install vim
	echo "Installation completed"

elif [ $input== "pip" ]

	echo "Installing pip3"
	sudo apt install python3-pip
	echo "Installation successfully completed"
	
else 
	echo "Guten Tag"
	echo "Tschüss"
fi
