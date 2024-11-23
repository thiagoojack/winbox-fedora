#!/bin/bash
#
# setup.sh - Install Mikrotik Winbox on Fedora
#
# site  : https://github.com/thiagojolv/winbox-fedora
# Author: Thiago Jack <thiagoojack@gmail.com>
#
# TODO: search for an existing WinBox installer

INSTALLATION_DIRECTORY="$HOME/.winbox"
URL_MIKROTIK_DOWNLOADS_PAGE="https://mikrotik.com/download"
USAGE_MESSAGE="Usage: $0 [OPTIONS]... [DIRECTORY]...
Install WinBox 4 latest version on Fedora Linux using
.zip file on $URL_MIKROTIK_DOWNLOADS_PAGE.
 -h, --help              Show this help message and exit
 --uninstall             Uninstall Cisco Packet Tracer
"

install () {
    sudo dnf check-update
    sudo dnf upgrade -y
    sudo dnf -y install unzip wget

    mkdir /tmp/winbox-fedora
    cd /tmp/winbox-fedora

    URL_DOWNLOAD_FOR_LINUX="$(lynx -dump -listonly -nonumbers -source "$URL_MIKROTIK_DOWNLOADS_PAGE" | grep 'WinBox_Linux.zip' | grep -Po '(?<=href=")[^"]*')"
    wget -c $URL_DOWNLOAD_FOR_LINUX

    clear
    echo "Default installation location is $HOME/.winbox."
    echo -n "Do you want to change it? (N) No / (y) yes: "
    read YesOrNo

    if [ "$YesOrNo" = Y -o "(" "$YesOrNo" = y ")" ]; then
        while true
        do
            clear
            echo -n "Enter the directory path: "
            read INSTALLATION_DIRECTORY
            echo -n -e "The selected directory is: $INSTALLATION_DIRECTORY\n"
            echo -n "Is this correct? (Y) yes / (n) (no): "
            read YesOrNo

            if [ "$YesOrNo" = N -o "(" "$YesOrNo" = n ")" ]
            then
                continue
            else
                break
            fi
        done
    fi

    unzip -d $INSTALLATION_DIRECTORY WinBox_Linux.zip

    touch $HOME/.local/share/applications/winbox.desktop
    cat > $HOME/.local/share/applications/winbox.desktop << EOF
[Desktop Entry]
Name=Winbox
GenericName=Configuration tool for RouterOS
Comment=Configuration tool for RouterOS
Exec=$HOME/.winbox/WinBox
Icon=$HOME/.winbox/assets/img/winbox.png
Terminal=false
Type=Application
StartupNotify=true
Categories=Network;RemoteAccess;
Keywords=winbox;mikrotik;
EOF
    
    xdg-desktop-menu forceupdate --mode system
}

uninstall () {
    if [ -e $INSTALLATION_DIRECTORY ]; then
        echo "Are you sure to uninstall WinBox?"
        echo -n "Is this correct? (y) yes / (N) No: "
        read YesOrNo

        if [ "$YesOrNo" = Y -o "(" "$YesOrNo" = y ")" ]
        then
            echo "Uninstalling WinBox 4..."
            rm -rf $INSTALLATION_DIRECTORY
            rm -rf $HOME/.local/share/applications/winbox.desktop
            xdg-desktop-menu forceupdate --mode system
        fi
    fi
}

case "$1" in
    -h | --help)
        echo "$USAGE_MESSAGE"
        exit 0
    ;;

    --uninstall)
        uninstall
    ;;

esac

if [ "$1" = "" ]; then
    install
fi