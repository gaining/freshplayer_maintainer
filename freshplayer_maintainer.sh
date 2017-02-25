#!/bin/bash
# ----------------------------------
# Author: gaining
# Must run as root
# find out more at  https://github.com/gaining/freshplayer_maintainer
# This script facilitates the installation and maintenance of freshplayer plugin on Debian based systems
# Fresh player wrapper is mainly developed by i-rinat https://github.com/i-rinat/freshplayerplugin
# Version 2.1
# To run this scrip, open the terminal type: chmod +x freshplayer_maintainer.sh; sudo ./freshplayer_maintainer.sh
# Contact me at: gaining7@outlook.com
# Updated version of file can also be downloaded using my dropbox link with the command: wget -O freshplayer_maintainer.sh https://db.tt/rHEJ2e0l

FRESHWRAP=~/freshplayerplugin/build/libfreshwrapper-pepperflash.so;
FRESHCONF=~/.config/freshwrapper.conf;
FRESHFF=/usr/lib/mozilla/plugins/libfreshwrapper-pepperflash.so;
FRESHFF2=~/.mozilla/plugins/libfreshwrapper-pepperflash.so;
FRESHOPERA=/usr/lib/opera/plugins/libfreshwrapper-pepperflash.so;
PEPFLASH=/opt/google/chrome/PepperFlash/libpepflashplayer.so;
FFDIR=/usr/lib/mozilla/plugins;
FFDIR2=~/.mozilla/plugins;
OPERADIR=/usr/lib/opera/plugins



function install_plugin(){
  echo "Getting dependencies..."
  if [ -f $PEPFLASH ];then
     apt-get install libv4l2rds0 libv4l-dev build-essential git cmake pkg-config libglib2.0-dev libasound2-dev libx11-dev libgl1-mesa-dev libgles2-mesa-dev liburiparser-dev libcairo2-dev libpango1.0-dev libpangocairo-1.0-0 libpangoft2-1.0-0 libfreetype6-dev libgtk2.0-dev libxinerama-dev libconfig-dev libevent-dev libssl-dev;
  else
     add-apt-repository -y ppa:skunk/pepper-flash;
     apt-get update;
     apt-get install --no-install-recommends pepflashplugin-installer ;
     apt-get install libv4l2rds0 libv4l-dev build-essential git cmake pkg-config libglib2.0-dev libasound2-dev libx11-dev libgl1-mesa-dev libgles2-mesa-dev liburiparser-dev libssl-dev libcairo2-dev libpango1.0-dev libpangocairo-1.0-0 libpangoft2-1.0-0 libfreetype6-dev libgtk2.0-dev libxinerama-dev libconfig-dev libevent-dev ragel;
     mkdir -p /opt/google/chrome/PepperFlash;
     ln -s /usr/lib/pepflashplugin-installer/libpepflashplayer.so /opt/google/chrome/PepperFlash;
  fi
  
  cd;
  
  git clone https://github.com/i-rinat/freshplayerplugin.git;
  
  cd freshplayerplugin; mkdir build; cd build; cmake ..; make;
  
  echo ""
  
  while true
  do
    read -p "Install plugin system wide? [Y/N] " yn
    
    case "$yn" in
      y|Y)   ln -fs $FRESHWRAP $FFDIR;
         ln -fs $FRESHWRAP $FFDIR;
      break;;
      n|N)  mkdir -p $FFDIR2;
        ln -s $FRESHWRAP $FFDIR2;
      break;;
      * ) echo  -e "$RED" "Invalid Choice";;
    esac
  done
  
  echo ""
  echo "Installation complete!"
  echo ""
  
}

function uninstall_plugin(){
  rm -rf ~/freshplayerplugin;
   rm -f $FRESHCONF $FRESHFF $FRESHFF2 $FRESHOPERA;
}

function update_plugin(){
  cd ~/freshplayerplugin; git pull; cd build; cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..; make;
}

function switch_HWA(){
  if [ -f $FRESHCONF ];
  then
    rm  $FRESHCONF;
    printf "Hardware acceleration DISABLED \n\n"
  else
    echo enable_3d = 1 > $FRESHCONF;
    echo "flash_command_line = \"enable_hw_video_decode=1,enable_stagevideo_auto=1\"" >>$FRESHCONF
    printf "Hardware acceleration ENABLED \n\n"
    
  fi
}


function switch_plugin(){
  
  if [[ -f $FRESHFF || -f $FRESHFF2 || -f $FRESHOPERA ]]; then
     rm -f $FRESHFF $FRESHFF2 $FRESHOPERA;
    printf "fresh player plugin DISABLED \n\n"
  else
    while true
    do
      read -p "Enable system wide? (includes Opera browser)[Y/N]: " yn
      case "$yn" in
        y|Y) ln -sf $FRESHWRAP $FFDIR;
           ln -sf $FRESHWRAP $OPERADIR;
        break;;
        n|N)  ln -s $FRESHWRAP $FFDIR2
        break;;
        * ) echo  -e "$RED" "Invalid choice";;
      esac
    done
    printf "fresh player plugin ENABLED \n\n"
    
  fi
}

k=1

clear

printf "Welcome to fresh player plugin Maintainer v2.1 \n\n"

PS3='Choose an option: '

options=("Install freshplayer plugin" "enable or disable hardware acceleration" "enable or disable plugin" "update plugin" "uninstall plugin" "Quit")

select items in "${options[@]}"

do
  case $items in
    "Install freshplayer plugin")
      install_plugin;
    ;;
    "enable or disable hardware acceleration")
      switch_HWA
    ;;
    "enable or disable plugin")
      switch_plugin
    ;;
    "update plugin")
      echo "Updating fresh player plugin..."
      update_plugin
      echo ""
    ;;
    "uninstall plugin")
      echo "uninstalling plugin..."
      uninstall_plugin
      echo ""
      echo "fresh player plugin has been successfully removed from your system"
      echo ""
    ;;
    "Quit")
      break
    ;;
    *) echo  -e "$RED" "invalid option";;
  esac
  
  for i in "${options[@]}"
  do
    echo $((k++))")$i"
    
  done
  k=1;
  
done
clear
