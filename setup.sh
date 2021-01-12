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

menu=( essential ide web utilities multimedia )
essential=( wget curl git pip npm go nodejs nvm )
ide=( vscode sublimetext vim emacs gvim pycharm intellij )
web=( LAMP MEAN apache ngnix phpmyadmin chrome chromium brave firefox )
utilities=( libreoffice uget qBitorrent krita inkscape gimp telegram discord signal )
multimedia=( vlc gragonplayer kdenlive )

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
    echo -e "${BGreen}Quiting ..."
    echo "Bye"
    exit;
}

displayInfo(){
    echo ""
    echo -e "${IGreen}---------------------------------"
    echo "      Distro Information           "
    echo "---------------------------------"
    echo ""
    
    if [[ $1 -eq 0 ]]
    then
        cat $2
    else
        $2
    fi
    
    echo -e "${Reset}"
    # countdown 3 Installation starting
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
    echo "But you can contribute in making this script even better!"
    echo -e "${UGreen}https://github.com/ahampriyanshu/scripts_101"
    echo -e "${Reset}"
            ;;
            
            *) echo "Wow! You have reached a new milestone."
        esac
}

start(){
    echo ""
    echo -e "${IGreen}Installing latest version of $1."
    echo -e "${Reset}"
}

check(){
    echo ""
    if [ $1 -eq 0 ]; then
        echo -e "${IGreen}Installation complete."
    else
        echo -e "${IRed}Installation failed!"
        echo -e "${IRed}Some error occurred during installation or installation was aborted manually."
    echo "Please check your internet connection or system conf and then retry."
    echo "If the error persists, please report the issue."
    echo -e "${UGreen}https://github.com/ahampriyanshu/scripts_101/issues/new"
    echo -e "${Reset}"
    fi
    echo -e "${Reset}"
    sleep 3
}

chrome(){
echo "hello"
}

firefox(){
echo "hello"
}

chromium(){
echo "hello"
}

brave(){
echo "hello"
}

firefox(){
echo "hello"
}

vlc(){
echo "hello"
}

vim(){
echo "hello"
}

emacs(){
echo "hello"
}

lamp(){
echo "hello"
}

mean(){
echo "hello"
}

nginx(){
echo "hello"
}

apache(){
echo "hello"
}

clang(){
echo "hello"
}

vscode(){
echo "hello"
}

sublime(){
echo "hello"
}

gimp(){
echo "hello"
}

uget(){
echo "hello"
}

sub_menu(){
array=("$@")
total=${#array[*]}
while :
do

clear

for (( i=1; i<=$(( $total - 1 )); i++ ))
do 
    echo -e "${LYellow}$i) ${LBlue}${array[$i]}"
done

read -p "Enter your choice [1-$(($total - 1))] : " input

for elem in ${input[@]}
do 
${array[$elem]} ${array[0]}
done

done
}

main_menu(){
array=("$@")
total=${#array[*]}
while :
do



for (( i=1; i<=$(( $total - 1 )); i++ ))
do 
    echo -e "${LYellow}$i) ${LBlue}${array[$i]}"
done

read -r -p "Enter your choice [1-$(($total - 1))] : " input
if [ "$input" -ge 1 ] && [ "$input" -lt $total ]; then
sub=${array[$input]}[@];
sub_menu ${array[0]} ${!sub};
elif [[ $input = "q" ]] || [[ $input = "Q" ]] ; then quit
else clear ;
fi


done
}

# mac(){
#     displayInfo 1 $1
#     helpme 1
# }

# slackware(){
#     displayInfo 0 $1
#     helpme 1
# }

# mandriva(){
#     displayInfo 0 $1
#     helpme 1
# }

# suse(){
#     displayInfo 0 $1
#     helpme 1
# }

# gentoo(){
#     displayInfo 0 $1
#     helpme 1
# }

# fedora(){
#     displayInfo 0 $1
#     helpme 1
# }

        # echo ""
        # echo -e "${IWhite}---------------------------------"
        # echo "      Installation Menu            "
        # echo "---------------------------------"
        # echo "1. Clang"
        # echo "2. VS Code"
        # echo "3. Sublime Text"
        # echo "4. Libre Office"
        # echo "5. LAMP Stack"
        # echo "6. MEAN Stack"
        # echo "7. NodeJS"
        # echo "8. Golang"
        # echo "9. Virtual Box"
        # echo "10. Kazam"
        # echo "11. qBittorrent"
        # echo "12. Chrome"
        # echo "13. Chromium"
        # echo "14. Mozilla Firefox"
        # echo "15. Brave"
        # echo "16. VLC"
        # echo "17. Vim"
        # echo "18. Emacs"
        # echo "19. Gnome-tweaks"
        # echo "20. Pycharm"
        # echo "21. Anaconda"
        # echo "22. uGet"
        # echo "23. Signal Messenger"
        # echo "24. Telegram"
        # echo "25. Discord"
        # echo "26. GIMP"
        # echo "27. Inkscape"
        # echo "28. Git"
        # echo "29. NGNIX"
        # echo "30. Krita"
        # echo -e "Enter ${URed}quit${Reset} or ${URed}Ctrl+C${Reset} to exit"
        # echo "============================"
        
        
        # case $c in
        #     1)
        #         start "Clang"
        #         sudo apt install clang
        #         check $?
                
        #     ;;
            
        #     2)
        #         start "VS Code"
        #         sudo apt install software-properties-common apt-transport-https wget
        #         wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
        #         sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
        #         sudo apt update
        #         sudo apt install code
        #         check $?
        #     ;;
            
        #     3)
        #         start "Sublime Text"
        #         sudo apt install apt-transport-https ca-certificates curl software-properties-common
        #         curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
        #         sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
        #         sudo apt update
        #         sudo apt install sublime-text
        #         check $?
        #     ;;
            
        #     4)
        #         start "Libre Office"
        #         sudo add-apt-repository ppa:libreoffice/ppa
        #         sudo apt update
        #         sudo apt install libreoffice
        #         check $?
        #     ;;
            
        #     5)
        #         start "LAMP Stack"
        #         echo "Installing Apache2"
        #         sudo apt update
        #         sudo apt install apache2 -y
        #         sudo apache2ctl configtest
                
        #         echo "Adjusting Firewall"
        #         sudo ufw app list
        #         sudo ufw app info "Apache Full"
        #         sudo ufw allow in "Apache Full"
                
        #         echo "Installing Mysql"
        #         sudo apt install mysql-server -y
                
        #         echo "Installing PHP"
        #         sudo apt install php libapache2-mod-php php-mcrypt php-mysql -y
                
        #         echo "Inastalling phpmyadmin..."
        #         sudo apt update
        #         sudo apt install phpmyadmin php-mbstring php-gettext
        #         sudo phpenmod mcrypt
        #         sudo phpenmod mbstring
        #         sudo systemctl restart apache2
                
        #         sudo systemctl start apache2
        #         echo "Installation complete"
        #         sudo systemctl status apache2
        #         check $?
        #     ;;
            
        #     6)
        #         start "MEAN Stack"
        #         sudo apt install gnupg -y
        #         wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
        #         sudo apt update
        #         echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
        #         sudo apt install -y mongodb-org
        #         sudo systemctl start mongod
        #         service mongod status
        #         echo "MEAN stack Installed."
        #     ;;
            
        #     7)
        #         start "NodeJS"
        #         curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash –
        #         sudo apt install -y nodejs
        #         sudo apt install build-essential
        #         check $?
        #     ;;
            
        #     8)
        #         start "Go"
        #         wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz
        #         tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz
        #         export PATH=$PATH:/usr/local/go/bin
        #         check $?
        #     ;;
            
        #     9)
        #         start "Virtual Box"
        #         sudo apt update
        #         sudo apt install virtualbox
        #         sudo apt install virtualbox—ext–pack
        #         check $?
        #     ;;
            
        #     10)
        #         start "Kazam"
        #         sudo apt install kazam
        #         check $?
        #     ;;
            
        #     11)
        #         start "qBitorrent"
        #         sudo apt install qbittorrent
        #         check $?
        #     ;;
            
            
        #     12)
        #         start "Chrome"
        #         wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        #         sudo dpkg -i google-chrome-stable_current_amd64.deb
        #         check $?
        #     ;;
            
        #     13)
        #         start "Chromium"
        #         sudo apt install -y chromium-browser
        #     check $?;;
            
            
        #     14)
        #         start "Firefox"
        #         sudo apt install -y firefox
        #     check $?;;
            
        #     15)
        #         start "Brave"
        #         sudo apt install apt-transport-https curl
        #         curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
        #         echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        #         check $?
        #     ;;
            
        #     16)
        #         start "VLC"
        #         sudo apt install vlc
        #     check $?
        #     ;;
            
        #     17)
        #         start "VIM"
        #         sudo apt install vim
        #     check $?
        #     ;;
            
        #     18)
        #         start "EMACS"
        #         sudo add-apt-repository ppa:kelleyk/emacs
        #         sudo apt update
        #         sudo apt install emacsVERSION
        #     check $?
        #     ;;
            
        #     19)
        #         start "gnome tweaks"
        #         sudo apt install gnome-tweaks
        #     check $?
        #     ;;
            
        #     20)
        #         start "pyCharm"
        #         wget -q https://download.jetbrains.com/python/pycharm-community-2020.3.2.tar.gz?_ga=2.51716457.1746728834.1610096895-1594661800.1610096895
        #         tar -xzf pycharm-community-2020.1.1.tar.gz
        #         cd pycharm-community-2020.1.1
        #         cd bin
        #         chmod u+x pycharm.sh
        #         check $?
        #     ;;
            
        #     21)
        #         start "Anaconda"
        #         cd /tmp
        #         curl -O https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
        #         bash Anaconda3-2019.03-Linux-x86_64.sh
        #         source ~/.bashrc
        #     check $?
        #     ;;
            
        #     22)
        #         start "uGet"
        #         sudo add-apt-repository ppa:plushuang-tw/uget-stable
        #         sudo apt update
        #         sudo apt install uget
        #     check $?
        #     ;;
            
        #     23)
        #         start "Signal"
        #         wget -O- https://updates.signal.org/desktop/apt/keys.asc |\
        #         sudo apt-key add -
        #         echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" |\
        #         sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
        #         sudo apt update && sudo apt install signal-desktop
        #     check $?
        #     ;;
            
        #     24)
        #         start "Telegram"
        #         wget -O- https://telegram.org/dl/desktop/linux | sudo tar xJ -C /opt/
        #         sudo ln -s /opt/Telegram/Telegram /usr/local/bin/telegram-desktop
        #     check $?
        #     ;;
            
        #     25)
        #         start "Discord"
        #         sudo apt update
        #         $ sudo apt install gdebi-core wget
        #         sudo gdebi ~/discord.deb -y
        #     check $?
        #     ;;
            
        #     26)
        #         start "GIMP"
        #         sudo add-apt-repository ppa:otto-kesselgulasch/gimp
        #         sudo apt update
        #         sudo apt install gimp
        #     check $?
        #     ;;
            
        #     27)
        #         start "Inkscape"
        #         sudo add-apt-repository ppa:inkscape.dev/stable
        #         sudo apt update
        #         sudo apt install inkscape
        #     check $?;;
            
        #     28)
        #         start "Git"
        #         sudo apt install git-all
        #     check $?
        #     ;;
            
        #     29)
        #         start "Ngnix"
        #         sudo apt update
        #         sudo apt install nginx

        #         echo "Adjusting Firewall"
        #         sudo ufw allow 'Nginx HTTP'

        #         echo "Enabling Ngnix"
        #         systemctl enable nginx
        #         systemctl restart nginx
        #         systemctl status nginx
        #     check $?
        #     ;;
            
        #     30)
        #         start "Krita"
        #         sudo add-apt-repository ppa:kritalime/ppa
        #         sudo apt update
        #         sudo apt-get install krita
        #     check $?
        #     ;;
            
        #     quit)
        #         echo -e "${BGreen}Quiting ..."
        #         echo "Bye"
        #     break;;
            
        #     *) Pause "Select between 1 to 30 only."
        # esac
    

echo ""
echo -e "${ICyan} ========================================================= "
echo " |                                                       | "
echo " |           Installation Script in Bash                 | "
echo " |                                                       | "
echo " ========================================================= "
echo ""
echo -e "${UGreen}https://ahampriyanshu.github.io"
echo "mailto:ahampriyanshu@gmail.com"
echo -e "${Reset}"
echo -e "${BYellow}Detecting System Configuration"
echo -e "${Reset}"
# progressbar
echo "" 
        

if [ -f /etc/lsb-release ]; then displayInfo 0 "/etc/lsb-release" debian 
    elif [ -f /etc/debian_version ]; then debian "/etc/debian_version"
    elif [ -f /etc/fedora-release ]; then fedora "/etc/fedora-release"
    elif [ -f /etc/redhat-release ]; then fedora "/etc/redhat-release"
    elif [ -f /etc/centos-release ]; then fedora "/etc/centos-release"
    elif [ -f /etc/gentoo-release ]; then gentoo "/etc/gentoo-release"
    elif [ -f /etc/SuSE-release ];   then suse   "/etc/SuSE-release"
    elif [ -f /etc/slackware-version ]; then slackware "/etc/slackware-version"
    elif [ -f /etc/mandriva-release ]; then mandriva "/etc/mandriva-release"
    elif system_profiler SPSoftwareDataType; then mac "system_profiler SPSoftwareDataType"
else helpme 2
fi
