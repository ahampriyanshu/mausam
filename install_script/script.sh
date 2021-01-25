#!/bin/bash

Reset='\033[0m'           # Text Reset

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

LBlue='\033[36m'
LYellow='\033[33m'

menu=( essential language framework editor web utilities multimedia )
essential=( clang wget curl git pip npm nvm )
language=( gcc java go python scala php node  )
framework=( django flask scrappy reactjs laravel LAMP MEAN apache ngnix phpmyadmin anaconda )
editor=( vscode sublimetext vim gvim emacs pycharm )
web=( chrome chromium brave firefox telegram discord signal slack uGet qBitorrent youtube-dl )
utilities=( libreoffice krita inkscape gimp virtualbox gParted steam )
multimedia=( vlc dragonplayer kdenlive obs kazam handbrake audacity clementine )

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

quit(){
    echo -e "${BGreen}Please star this repo if you found this script usefull"
    echo -e "${BGreen}Quiting ..."
    echo "Bye"
    exit;
}

displayInfo(){
    echo -e "${IGreen}"
    echo "---------------------------------"
    echo "      Distro Information         "
    echo "---------------------------------"
    echo ""
    
    if [[ $1 -eq 0 ]]
    then
        cat $2
    else
        $2
    fi
    
    echo -e "${Reset}"
    countdown 3 Installation starting
    main_menu $3 ${menu[@]}
}

helpme(){
    echo -e "${IBlue}|=======================================|"
    echo    "|  Would you mind helping me, please?   |"
    echo    "|=======================================|"
    echo -e "${Reset}"
    
    case $1 in
        1)
            echo -e "${IRed}Your OS isn't supported yet."
            echo "But you can contribute in making this script even better!"
            echo -e "${UGreen}https://github.com/ahampriyanshu/scripts_101"
            echo -e "${Reset}"
        ;;
        
        2)
            echo -e "${IRed}Sorry! We couldn't recognize your OS."
            echo "Please report this issue."
            echo -e "${UGreen}https://github.com/ahampriyanshu/scripts_101/issues/new"
            echo -e "${Reset}"
        ;;
        
        3)
            echo -e "${IRed}This installation isn't supported yet."
            echo "But you can contribute in making this script even better by appending the installation commands"
            echo -e "${UGreen}https://github.com/ahampriyanshu/scripts_101"
            echo -e "${Reset}"
        ;;
        
        4)
            echo -e "${IRed}Something went wrong"
            echo "If you know what that is then please report this issue."
            echo -e "${UGreen}https://github.com/ahampriyanshu/scripts_101"
            echo -e "${Reset}"
        ;;
        
        *) echo "Wow! You have reached a new milestone."
    esac
}

start(){
    echo ""
    echo -e "${IGreen} Installing the latest version of $1 for $2 ${Reset}"
    echo ""
}

check(){
    echo ""
    if [ $1 -eq 0 ]; then
        echo -e "${IGreen}Installation complete."
    else
        echo -e "${IRed}Installation failed!"
        echo "Some error occurred during installation or installation was aborted manually."
        echo "Please check your internet connection or system conf and then retry."
        echo "If the error persists, please report the issue."
        echo -e "${UGreen}https://github.com/ahampriyanshu/scripts_101/issues/new${Reset}"
    fi
    echo ""
    sleep 3
}

mac(){
    start $1 "mac"
    case $1 in
        clang) helpme 3 ;;
        wget) helpme 3 ;;
        curl) helpme 3 ;;
        git) helpme 3 ;;
        pip) helpme 3 ;;
        npm) helpme 3 ;;
        nvm) helpme 3 ;;
        gcc) helpme 3 ;;
        java) helpme 3 ;;
        go) helpme 3 ;;
        python) helpme 3 ;;
        scala) helpme 3 ;;
        php) helpme 3 ;;
        node) helpme 3 ;;
        django) helpme 3 ;;
        flask) helpme 3 ;;
        scrappy) helpme 3 ;;
        reactjs) helpme 3 ;;
        laravel) helpme 3 ;;
        LAMP) helpme 3 ;;
        MEAN) helpme 3 ;;
        apache) helpme 3 ;;
        ngnix) helpme 3 ;;
        phpmyadmin) helpme 3 ;;
        anaconda) helpme 3 ;;
        vscode) helpme 3 ;;
        sublimetext) helpme 3 ;;
        vim) helpme 3 ;;
        gvim) helpme 3 ;;
        emacs) helpme 3 ;;
        pycharm) helpme 3 ;;
        chrome) helpme 3 ;;
        chromium) helpme 3 ;;
        brave) helpme 3 ;;
        firefox) helpme 3 ;;
        telegram) helpme 3 ;;
        discord) helpme 3 ;;
        signal) helpme 3 ;;
        slack) helpme 3 ;;
        uGet) helpme 3 ;;
        qBitorrent) helpme 3 ;;
        youtube-dl) helpme 3 ;;
        libreoffice) helpme 3 ;;
        krita) helpme 3 ;;
        inkscape) helpme 3 ;;
        gimp) helpme 3 ;;
        virtualbox) helpme 3 ;;
        gParted) helpme 3 ;;
        steam) helpme 3 ;;
        vlc) helpme 3 ;;
        dragonplayer) helpme 3 ;;
        kdenlive) helpme 3 ;;
        obs) helpme 3 ;;
        kazam) helpme 3 ;;
        handbrake) helpme 3 ;;
        audacity) helpme 3 ;;
        clementine) helpme 3 ;;
        *) helpme 4
    esac
}

slackware(){
    start $1 "slackware"
    case $1 in
        clang) helpme 3 ;;
        wget) helpme 3 ;;
        curl) helpme 3 ;;
        git) helpme 3 ;;
        pip) helpme 3 ;;
        npm) helpme 3 ;;
        nvm) helpme 3 ;;
        gcc) helpme 3 ;;
        java) helpme 3 ;;
        go) helpme 3 ;;
        python) helpme 3 ;;
        scala) helpme 3 ;;
        php) helpme 3 ;;
        node) helpme 3 ;;
        django) helpme 3 ;;
        flask) helpme 3 ;;
        scrappy) helpme 3 ;;
        reactjs) helpme 3 ;;
        laravel) helpme 3 ;;
        LAMP) helpme 3 ;;
        MEAN) helpme 3 ;;
        apache) helpme 3 ;;
        ngnix) helpme 3 ;;
        phpmyadmin) helpme 3 ;;
        anaconda) helpme 3 ;;
        vscode) helpme 3 ;;
        sublimetext) helpme 3 ;;
        vim) helpme 3 ;;
        gvim) helpme 3 ;;
        emacs) helpme 3 ;;
        pycharm) helpme 3 ;;
        chrome) helpme 3 ;;
        chromium) helpme 3 ;;
        brave) helpme 3 ;;
        firefox) helpme 3 ;;
        telegram) helpme 3 ;;
        discord) helpme 3 ;;
        signal) helpme 3 ;;
        slack) helpme 3 ;;
        uGet) helpme 3 ;;
        qBitorrent) helpme 3 ;;
        youtube-dl) helpme 3 ;;
        libreoffice) helpme 3 ;;
        krita) helpme 3 ;;
        inkscape) helpme 3 ;;
        gimp) helpme 3 ;;
        virtualbox) helpme 3 ;;
        gParted) helpme 3 ;;
        steam) helpme 3 ;;
        vlc) helpme 3 ;;
        dragonplayer) helpme 3 ;;
        kdenlive) helpme 3 ;;
        obs) helpme 3 ;;
        kazam) helpme 3 ;;
        handbrake) helpme 3 ;;
        audacity) helpme 3 ;;
        clementine) helpme 3 ;;
        *) helpme 4
    esac
}

mandriva(){
    start $1 "mandriva"
    case $1 in
        clang) helpme 3 ;;
        wget) helpme 3 ;;
        curl) helpme 3 ;;
        git) helpme 3 ;;
        pip) helpme 3 ;;
        npm) helpme 3 ;;
        nvm) helpme 3 ;;
        gcc) helpme 3 ;;
        java) helpme 3 ;;
        go) helpme 3 ;;
        python) helpme 3 ;;
        scala) helpme 3 ;;
        php) helpme 3 ;;
        node) helpme 3 ;;
        django) helpme 3 ;;
        flask) helpme 3 ;;
        scrappy) helpme 3 ;;
        reactjs) helpme 3 ;;
        laravel) helpme 3 ;;
        LAMP) helpme 3 ;;
        MEAN) helpme 3 ;;
        apache) helpme 3 ;;
        ngnix) helpme 3 ;;
        phpmyadmin) helpme 3 ;;
        anaconda) helpme 3 ;;
        vscode) helpme 3 ;;
        sublimetext) helpme 3 ;;
        vim) helpme 3 ;;
        gvim) helpme 3 ;;
        emacs) helpme 3 ;;
        pycharm) helpme 3 ;;
        chrome) helpme 3 ;;
        chromium) helpme 3 ;;
        brave) helpme 3 ;;
        firefox) helpme 3 ;;
        telegram) helpme 3 ;;
        discord) helpme 3 ;;
        signal) helpme 3 ;;
        slack) helpme 3 ;;
        uGet) helpme 3 ;;
        qBitorrent) helpme 3 ;;
        youtube-dl) helpme 3 ;;
        libreoffice) helpme 3 ;;
        krita) helpme 3 ;;
        inkscape) helpme 3 ;;
        gimp) helpme 3 ;;
        virtualbox) helpme 3 ;;
        gParted) helpme 3 ;;
        steam) helpme 3 ;;
        vlc) helpme 3 ;;
        dragonplayer) helpme 3 ;;
        kdenlive) helpme 3 ;;
        obs) helpme 3 ;;
        kazam) helpme 3 ;;
        handbrake) helpme 3 ;;
        audacity) helpme 3 ;;
        clementine) helpme 3 ;;
        *) helpme 4
    esac
}

suse(){
    start $1 "openSuSe"
    case $1 in
        clang) helpme 3 ;;
        wget) helpme 3 ;;
        curl) helpme 3 ;;
        git) helpme 3 ;;
        pip) helpme 3 ;;
        npm) helpme 3 ;;
        nvm) helpme 3 ;;
        gcc) helpme 3 ;;
        java) helpme 3 ;;
        go) helpme 3 ;;
        python) helpme 3 ;;
        scala) helpme 3 ;;
        php) helpme 3 ;;
        node) helpme 3 ;;
        django) helpme 3 ;;
        flask) helpme 3 ;;
        scrappy) helpme 3 ;;
        reactjs) helpme 3 ;;
        laravel) helpme 3 ;;
        LAMP) helpme 3 ;;
        MEAN) helpme 3 ;;
        apache) helpme 3 ;;
        ngnix) helpme 3 ;;
        phpmyadmin) helpme 3 ;;
        anaconda) helpme 3 ;;
        vscode) helpme 3 ;;
        sublimetext) helpme 3 ;;
        vim) helpme 3 ;;
        gvim) helpme 3 ;;
        emacs) helpme 3 ;;
        pycharm) helpme 3 ;;
        chrome) helpme 3 ;;
        chromium) helpme 3 ;;
        brave) helpme 3 ;;
        firefox) helpme 3 ;;
        telegram) helpme 3 ;;
        discord) helpme 3 ;;
        signal) helpme 3 ;;
        slack) helpme 3 ;;
        uGet) helpme 3 ;;
        qBitorrent) helpme 3 ;;
        youtube-dl) helpme 3 ;;
        libreoffice) helpme 3 ;;
        krita) helpme 3 ;;
        inkscape) helpme 3 ;;
        gimp) helpme 3 ;;
        virtualbox) helpme 3 ;;
        gParted) helpme 3 ;;
        steam) helpme 3 ;;
        vlc) helpme 3 ;;
        dragonplayer) helpme 3 ;;
        kdenlive) helpme 3 ;;
        obs) helpme 3 ;;
        kazam) helpme 3 ;;
        handbrake) helpme 3 ;;
        audacity) helpme 3 ;;
        clementine) helpme 3 ;;
        *) helpme 4
    esac
}

gentoo(){
    start $1 "gentoo"
    case $1 in
        clang) helpme 3 ;;
        wget) helpme 3 ;;
        curl) helpme 3 ;;
        git) helpme 3 ;;
        pip) helpme 3 ;;
        npm) helpme 3 ;;
        nvm) helpme 3 ;;
        gcc) helpme 3 ;;
        java) helpme 3 ;;
        go) helpme 3 ;;
        python) helpme 3 ;;
        scala) helpme 3 ;;
        php) helpme 3 ;;
        node) helpme 3 ;;
        django) helpme 3 ;;
        flask) helpme 3 ;;
        scrappy) helpme 3 ;;
        reactjs) helpme 3 ;;
        laravel) helpme 3 ;;
        LAMP) helpme 3 ;;
        MEAN) helpme 3 ;;
        apache) helpme 3 ;;
        ngnix) helpme 3 ;;
        phpmyadmin) helpme 3 ;;
        anaconda) helpme 3 ;;
        vscode) helpme 3 ;;
        sublimetext) helpme 3 ;;
        vim) helpme 3 ;;
        gvim) helpme 3 ;;
        emacs) helpme 3 ;;
        pycharm) helpme 3 ;;
        chrome) helpme 3 ;;
        chromium) helpme 3 ;;
        brave) helpme 3 ;;
        firefox) helpme 3 ;;
        telegram) helpme 3 ;;
        discord) helpme 3 ;;
        signal) helpme 3 ;;
        slack) helpme 3 ;;
        uGet) helpme 3 ;;
        qBitorrent) helpme 3 ;;
        youtube-dl) helpme 3 ;;
        libreoffice) helpme 3 ;;
        krita) helpme 3 ;;
        inkscape) helpme 3 ;;
        gimp) helpme 3 ;;
        virtualbox) helpme 3 ;;
        gParted) helpme 3 ;;
        steam) helpme 3 ;;
        vlc) helpme 3 ;;
        dragonplayer) helpme 3 ;;
        kdenlive) helpme 3 ;;
        obs) helpme 3 ;;
        kazam) helpme 3 ;;
        handbrake) helpme 3 ;;
        audacity) helpme 3 ;;
        clementine) helpme 3 ;;
        *) helpme 4
    esac
}

fedora(){
    start $1 "fedora"
    case $1 in
        clang) helpme 3 ;;
        wget) helpme 3 ;;
        curl) helpme 3 ;;
        git) helpme 3 ;;
        pip) helpme 3 ;;
        npm) helpme 3 ;;
        nvm) helpme 3 ;;
        gcc) helpme 3 ;;
        java) helpme 3 ;;
        go) helpme 3 ;;
        python) helpme 3 ;;
        scala) helpme 3 ;;
        php) helpme 3 ;;
        node) helpme 3 ;;
        django) helpme 3 ;;
        flask) helpme 3 ;;
        scrappy) helpme 3 ;;
        reactjs) helpme 3 ;;
        laravel) helpme 3 ;;
        LAMP) helpme 3 ;;
        MEAN) helpme 3 ;;
        apache) helpme 3 ;;
        ngnix) helpme 3 ;;
        phpmyadmin) helpme 3 ;;
        anaconda) helpme 3 ;;
        vscode) helpme 3 ;;
        sublimetext) helpme 3 ;;
        vim) helpme 3 ;;
        gvim) helpme 3 ;;
        emacs) helpme 3 ;;
        pycharm) helpme 3 ;;
        chrome) helpme 3 ;;
        chromium) helpme 3 ;;
        brave) helpme 3 ;;
        firefox) helpme 3 ;;
        telegram) helpme 3 ;;
        discord) helpme 3 ;;
        signal) helpme 3 ;;
        slack) helpme 3 ;;
        uGet) helpme 3 ;;
        qBitorrent) helpme 3 ;;
        youtube-dl) helpme 3 ;;
        libreoffice) helpme 3 ;;
        krita) helpme 3 ;;
        inkscape) helpme 3 ;;
        gimp) helpme 3 ;;
        virtualbox) helpme 3 ;;
        gParted) helpme 3 ;;
        steam) helpme 3 ;;
        vlc) helpme 3 ;;
        dragonplayer) helpme 3 ;;
        kdenlive) helpme 3 ;;
        obs) helpme 3 ;;
        kazam) helpme 3 ;;
        handbrake) helpme 3 ;;
        audacity) helpme 3 ;;
        clementine) 
        su -c "dnf install gcc-c++ taglib-devel gettext boost-devel \
    qt-devel cmake gstreamer1-devel gstreamer1-plugins-base-devel glew-devel \
    libgpod-devel qjson-devel libplist-devel \
    libusbmuxd-devel libmtp-devel protobuf-devel protobuf-compiler cryptopp-devel \
    libcdio-devel fftw-devel sparsehash-devel sqlite-devel \
    pulseaudio-libs-devel libchromaprint-devel cmake git"
    git clone https://github.com/clementine-player/Clementine.git
cd Clementine/bin
cmake ../
make
sudo make install
 ;;
        *) helpme 4
    esac
}

debian(){
    start $1 "debian"
    case $1 in
        clang) sudo apt install clang
        check $?;;
        wget) sudo apt update
              sudo apt install wget
        check $?;;
        curl) sudo apt update
              sudo apt install curl
        check $?;;
        git) sudo apt install git-all
        check $?;;
        pip) sudo apt install python3-pip
        check $?;;
        npm) sudo apt install nodejs npm
        check $?;;
        nvm) helpme 3
        check $?;;
        gcc) sudo apt install gcc g++
        check $?;;
        java) sudo apt install default-jre
              sudo apt install default-jdk
        check $?;;
        go)
            wget -q https://golang.org/dl/go1.15.6.linux-amd64.tar.gz
            tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz
            export PATH=$PATH:/usr/local/go/bin
        check $?;;
        python) sudo apt update
                sudo apt install python

        check $?;;
        scala) sudo apt install default-jdk
               echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
               curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
               sudo apt update
               sudo apt install sbt
        check $?;;
        php)
            sudo apt install php libapache2-mod-php php-mcrypt php-mysql -y
        check $?;;
        node)
            curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash –
            sudo apt install -y nodejs
        check $?;;
        django) sudo apt update
                sudo apt install python3 python3-pip
                pip3 install django
        check $?;;
        flask) sudo apt update
                sudo apt install python3 python3-pip
               pip3 install flask
        check $?;;
        scrappy) sudo apt update
                 sudo apt install --assume-yes python3-scrapy
        check $?;;
        reactjs) helpme 3
        check $?;;
        laravel) sudo apt update
                 sudo apt install mariadb-server mariadb-client
                 sudo systemctl start mariadb
                 sudo systemctl enable mariadb
                 sudo mysql_secure_installation
                 sudo mydql -u root -p
                 sudo apt install php php-bcmath php-json php-mbstring php-mysql php-tokenizer php-xml php-zip
                 sudo apt install composer
                 composer global require laravel/installer
                 echo "export PATH=$PATH:~/.config/composer/vendor/bin" >> ~/.bashrc
        check $?;;
        LAMP)
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
            sudo apt update
            sudo apt install phpmyadmin php-mbstring php-gettext
            sudo phpenmod mcrypt
            sudo phpenmod mbstring
            sudo systemctl restart apache2
            sudo systemctl enable apache2
        check $?;;
        MEAN)
            echo "Installing MongoDB"
            sudo apt install gnupg -y
            wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
            sudo apt update
            echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
            sudo apt install -y mongodb-org
            sudo systemctl start mongod
            service mongod status
            echo "Installing NodeJS"
            curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash –
            sudo apt install -y nodejs
            sudo apt install build-essential
        check $?;;
        apache)
            sudo apt update
            sudo apt install apache2 -y
            sudo apache2ctl configtest
            
            echo "Adjusting Firewall"
            sudo ufw app list
            sudo ufw app info "Apache Full"
            sudo ufw allow in "Apache Full"
        check $?;;
        ngnix)
            sudo apt update
            sudo apt install nginx
            
            echo "Adjusting Firewall"
            sudo ufw allow 'Nginx HTTP'
            
            echo "Enabling Ngnix"
            systemctl enable nginx
            systemctl restart nginx
            systemctl status nginx
        check $?;;
        phpmyadmin)
            sudo apt update
            sudo apt install phpmyadmin php-mbstring php-gettext
            sudo phpenmod mcrypt
            sudo phpenmod mbstring
            sudo systemctl restart apache2
            sudo systemctl enable apache2
        check $?;;
        anaconda)
            cd ~/tmp
            curl -O https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
            bash Anaconda3-2019.03-Linux-x86_64.sh
            source ~/.bashrc
        check $?;;
        vscode)
            sudo apt install software-properties-common apt-transport-https wget
            wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
            sudo apt update
            sudo apt install code
        check $?;;
        sublimetext)
            sudo apt install apt-transport-https ca-certificates curl software-properties-common
            curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
            sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
            sudo apt update
            sudo apt install sublime-text
        check $?;;
        vim) sudo apt install vim
        check $?;;
        gvim) sudo apt install vim-gtk3
        check $?;;
        emacs)
            sudo add-apt-repository ppa:kelleyk/emacs
            sudo apt update
            sudo apt install emacsVERSION
        check $?;;
        pycharm)
            wget -q https://download.jetbrains.com/python/pycharm-community-2020.3.2.tar.gz?_ga=2.51716457.1746728834.1610096895-1594661800.1610096895
            tar -xzf pycharm-community-2020.1.1.tar.gz
            cd pycharm-community-2020.1.1
            cd bin
            chmod u+x pycharm.sh
        check $?;;
        chrome)
            wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
            sudo dpkg -i google-chrome-stable_current_amd64.deb
        check $?;;
        chromium)  sudo apt install -y chromium-browser
        check $?;;
        brave)
            sudo apt install apt-transport-https curl
            curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
            echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        check $?;;
        firefox)
        sudo apt install -y firefox
        check $?;;
        telegram)
            wget -O- https://telegram.org/dl/desktop/linux | sudo tar xJ -C /opt/
            sudo ln -s /opt/Telegram/Telegram /usr/local/bin/telegram-desktop
            
        check $?;;
        discord)
            sudo apt update
            $ sudo apt install gdebi-core wget
            sudo gdebi ~/discord.deb -y
        check $?;;
        signal)
            curl https://updates.signal.org/desktop/apt/keys.asc |\
            sudo apt-key add -
            echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" |\
            sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
            sudo apt update && sudo apt install signal-desktop
        check $?;;
        slack)
        wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.12.2-amd64.deb
        sudo dpkg -i slack-desktop-*.deb
        check $?;;
        uGet)
            sudo add-apt-repository ppa:plushuang-tw/uget-stable
            sudo apt update
            sudo apt install uget
        check $?;;
        qBitorrent) sudo apt install qbittorrent
        check $?;;
        youtube-dl) sudo apt install youtube-dl
        check $?;;
        libreoffice)
            sudo add-apt-repository ppa:libreoffice/ppa
            sudo apt update
            sudo apt install libreoffice
        check $?;;
        krita)
            sudo add-apt-repository ppa:kritalime/ppa
            sudo apt update
            sudo apt-get install krita
        check $?;;
        inkscape)
            sudo add-apt-repository ppa:inkscape.dev/stable
            sudo apt update
            sudo apt install inkscape
        check $?;;
        gimp)
            sudo add-apt-repository ppa:otto-kesselgulasch/gimp
            sudo apt update
            sudo apt install gimp
        check $?;;
        virtualbox)
            sudo apt update
            sudo apt install virtualbox
            sudo apt install virtualbox—ext–pack
        check $?;;
        gParted)
        sudo apt install gparted
        check $?;;
        steam) 
        sudo apt update
        sudo apt install steam
        check $?;;
        vlc)  sudo apt install vlc
        check $?;;
        dragonplayer)
        sudo apt update
sudo apt install dragonplayer        
        check $?;;
        kdenlive)
        sudo add-apt-repository ppa:kdenlive/kdenlive-stable
         sudo apt update
          sudo apt install kdenlive
        check $?;;
        obs) 
        sudo apt update
        sudo apt install obs-studio
        check $?;;
        kazam) sudo apt install kazam
        check $?;;
        handbrake) 
        sudo apt install handbrake
        check $?;;
        audacity) 
        sudo apt update
        sudo apt install audacity
        check $?;;
        clementine) 
        sudo add-apt-repository ppa:me-davidsansome/clementine
        sudo apt update
        sudo apt install clementine
        check $?;;
        *) helpme 4
    esac
}


sub_menu(){
    array=("$@")
    total=${#array[*]}
    while :
    do
        
        clear
        
        for (( i=1; i<=$(( $total - 1 )); i++ ))
        do
            echo -e "${LYellow}$i) ${LBlue}${array[$i]^}"
        done
        echo -e "${Red}.) ${LBlue}Back"
        echo -e "${Red}q) ${LBlue}Quit"
        read -p "Enter your choice [1-$(($total - 1))] : " input
        
        for elem in ${input[@]}
        do
            if [[ "$elem" -ge 1 && "$elem" -lt $total ]] ; then ${array[0]} ${array[$elem]};
                elif [[ $elem = "q" ]] || [[ $elem = "Q" ]] ; then quit
                elif [[ $elem = "." ]] ; then main_menu ${array[0]} ${menu[@]}
            else clear ;
            fi
            
        done
        
    done
}

main_menu(){
    array=("$@")
    total=${#array[*]}
    while :
    do
        clear
        for (( i=1; i<=$(( $total - 1 )); i++ ))
        do
            echo -e "${LYellow}$i) ${LBlue}${array[$i]^}"
        done
        echo -e "${Red}q) ${LBlue}Quit"
        read -r -p "Enter your choice [1-$(($total - 1))] : " input
        if [[ "$input" -ge 1 && "$input" -lt $total ]] ; then sub=${array[$input]}[@]; sub_menu ${array[0]} ${!sub};
            elif [[ $input = "q" ]] || [[ $input = "Q" ]] ; then quit
        else clear ;
        fi
        
    done
}

echo -e "${ICyan}"
echo " ========================================================= "
echo " |                                                       | "
echo " |           Installation Script in Bash                 | "
echo " |                                                       | "
echo " ========================================================= "
echo ""
echo -e "${UGreen}https://ahampriyanshu.github.io"
echo "mailto:ahampriyanshu@gmail.com"
echo ""
echo -e "${BYellow}Detecting System Configuration${Reset}"
echo ""
progressbar
echo ""


if [ -f /etc/lsb-release ]; then displayInfo 0 "/etc/lsb-release" debian
    elif [ -f /etc/debian_version ]; then displayInfo 0 "/etc/debian_version" debian
    elif [ -f /etc/fedora-release ]; then displayInfo 0 "/etc/fedora-release" fedora
    elif [ -f /etc/redhat-release ]; then displayInfo 0 "/etc/redhat-release" fedora
    elif [ -f /etc/centos-release ]; then displayInfo 0 "/etc/centos-release" fedora
    elif [ -f /etc/gentoo-release ]; then displayInfo 0 "/etc/gentoo-release" gentoo
    elif [ -f /etc/SuSE-release ];   then displayInfo 0 "/etc/SuSE-release" suse
    elif [ -f /etc/slackware-version ]; then displayInfo 0 "/etc/slackware-version" slackware
    elif [ -f /etc/mandriva-release ]; then displayInfo 0 "/etc/mandriva-release" mandriva
    elif system_profiler SPSoftwareDataType; then displayInfo 0 "system_profiler SPSoftwareDataType" mac
else helpme 2
fi