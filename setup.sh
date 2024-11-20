#!/bin/bash
#
# setup.sh - Install Mikrotik Winbox on Fedora
#
# site  : https://github.com/thiagojolv/winbox-fedora
# Author: Thiago Jack <thiagoojack@gmail.com>
#
# TODO: search for an existing WinBox installer
# TODO: create uninstaller

INSTALLATION_DIRECTORY="$HOME/.winbox"
URL_MIKROTIK_DOWNLOADS_PAGE="https://mikrotik.com/download"
URL_DOWNLOAD_FOR_LINUX="$(lynx -dump -listonly -nonumbers -source "$URL_MIKROTIK_DOWNLOADS_PAGE" | grep 'WinBox_Linux.zip' | grep -Po '(?<=href=")[^"]*')"

sudo dnf check-update
sudo dnf upgrade -y
sudo dnf -y install unzip wget

mkdir /tmp/winbox-fedora
cd /tmp/winbox-fedora
wget -c $URL_DOWNLOAD_FOR_LINUX

clear
echo "Default installation location is $HOME/.winbox."
echo -n "Do you want to change it? (N) No / (y) yes: "
read YesOrNo

if [ "$YesOrNo" = Y -o "(" "$YesOrNo" = y ")" ]
then
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

touch ~/.local/share/applications/winbox.desktop
cat << EOF >> ~/.local/share/applications/winbox.desktop
[Desktop Entry]
Name=Winbox
GenericName=Configuration tool for RouterOS
Comment=Configuration tool for RouterOS
Exec=/opt/winbox/WinBox
Icon=/opt/winbox/assets/img/winbox.png
Terminal=false
Type=Application
StartupNotify=true
Categories=Network;RemoteAccess;
Keywords=winbox;mikrotik;
EOF

xdg-desktop-menu forceupdate --mode system
