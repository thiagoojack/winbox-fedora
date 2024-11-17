#!/bin/bash
#
# setup.sh - Install Mikrotik Winbox on Fedora
#
# site  : https://github.com/thiagojolv/winbox-fedora
# Author: Thiago Jack <thiagoojack@gmail.com>
#
# TODO: ask user where to install WinBox

sudo dnf check-update
sudo dnf upgrade -y
sudo dnf -y install unzip wget

mkdir /tmp/winbox-fedora && cd /tmp/winbox-fedora
URL_MIKROTIK_DOWNLOADS_PAGE="https://mikrotik.com/download"
URL_DOWNLOAD_FOR_LINUX="$(lynx -dump -listonly -nonumbers -source "$URL_MIKROTIK_DOWNLOADS_PAGE" | grep 'WinBox_Linux.zip' | grep -Po '(?<=href=")[^"]*')"
wget -c $URL_DOWNLOAD_FOR_LINUX

unzip -d ~/.winbox WinBox_Linux.zip

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
