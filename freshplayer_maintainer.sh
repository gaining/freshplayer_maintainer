#!/bin/bash
# ----------------------------------
# Author: gaining
# This script facilitates the installation and maintenance of freshplayer plugin on Debian based systems
# Fresh player wrapper is mainly developed by i-rinat https://github.com/i-rinat/freshplayerplugin 
# Version 2.0
# To run this scrip, open the terminal type: chmod +x freshplayer_maintainer.sh; ./freshplayer_maintainer.sh
# Contact me at: gaining77@outlook.com


function install_plugin(){
  echo "Getting dependencies..."
  HWFILE=/opt/google/chrome/PepperFlash/libpepflashplayer.so;
    
  if [ -f $HWFILE ];then
     sudo apt-get install build-essential git cmake pkg-config libglib2.0-dev libasound2-dev libx11-dev libgl1-mesa-dev libgles2-mesa-dev liburiparser-dev libcairo2-dev libpango1.0-dev libpangocairo-1.0-0 libpangoft2-1.0-0 libfreetype6-dev libgtk2.0-dev libxinerama-dev libconfig-dev libevent-dev libssl-dev;
  else 
     sudo add-apt-repository -y ppa:skunk/pepper-flash;
     sudo apt-get update;
     sudo apt-get install --no-install-recommends pepflashplugin-installer ;
     sudo apt-get install build-essential git cmake pkg-config libglib2.0-dev libasound2-dev libx11-dev libgl1-mesa-dev libgles2-mesa-dev liburiparser-dev libssl-dev libcairo2-dev libpango1.0-dev libpangocairo-1.0-0 libpangoft2-1.0-0 libfreetype6-dev libgtk2.0-dev libxinerama-dev libconfig-dev libevent-dev ragel;    
     sudo mkdir -p /opt/google/chrome/PepperFlash; 
     sudo ln -s /usr/lib/pepflashplugin-installer/libpepflashplayer.so /opt/google/chrome/PepperFlash;
  fi
  
  cd;
 
  git clone https://github.com/i-rinat/freshplayerplugin.git;
  
  cd freshplayerplugin; mkdir build; cd build; cmake ..; make; 
  
  echo ""

  while true
  do
  read -p "Install plugin system wide? [Y/N] " yn

    case "$yn" in
            y|Y)  sudo ln -s ~/freshplayerplugin/build/libfreshwrapper-pepperflash.so /usr/lib/mozilla/plugins
		break;;
            n|N)  mkdir -p ~/.mozilla/plugins; ln -s ~/freshplayerplugin/build/llibfreshwrapper-pepperflash.so ~/.mozilla/plugins
		break;;
             * ) echo  -e $RED "Invalid Choice";;
    esac
  done

  echo ""
  echo "Installation complete!"
  echo ""

}

function uninstall_plugin(){
  rm -rf ~/freshplayerplugin;
  HWFILE=~/.config/freshwrapper.conf;
  FRESHFILE=/usr/lib/mozilla/plugins/libfreshwrapper-pepperflash.so;
  FRESHFILE2=~/.mozilla/plugins/libfreshwrapper-pepperflash.so;
  sudo rm -f $HWFILE $FRESHFILE $FRESHFILE2;
}

function update_plugin(){
  cd ~/freshplayerplugin; git pull; cd build; cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..; make;
}
function enable_disable_hW(){
  HWFILE=~/.config/freshwrapper.conf;
    
  if [ -f $HWFILE ];
  then
     rm  $HWFILE;
    printf "Hardware acceleration DISABLED \n\n"
  else 
    echo enable_3d = 1 > $HWFILE;
    echo "flash_command_line = \"enable_hw_video_decode=1,enable_stagevideo_auto=1\"" >>$HWFILE
    printf "Hardware acceleration ENABLED \n\n"
    
  fi
}


function enable_disable(){
  FILELOC1=~/freshplayerplugin/build/libfreshwrapper-pepperflash.so;
  FILELOC2=/usr/lib/mozilla/plugins/libfreshwrapper-pepperflash.so;
  FILELOC3=~/.mozilla/plugins/libfreshwrapper-pepperflash.so;
  

   if [[ -f $FILELOC2 || -f $FILELOC3 ]]; then
    sudo rm -f $FILELOC2 $FILELOC3;
    printf "fresh player plugin DISABLED \n\n"
    
  else 
  while true
   do
     read -p "Enable system wide or not [Y/N]: " yn
    case "$yn" in
            y|Y)sudo ln -s $FILELOC1 /usr/lib/mozilla/plugins 
		break;;
            n|N)  ln -s $FILELOC1 ~/.mozilla/plugins
		break;;
             * ) echo  -e $RED "Invalid choice";;
      esac
    done
    printf "fresh player plugin ENABLED \n\n"
    
  fi
}

k=1

clear

printf "Welcome to fresh player plugin Maintainer v2.0 \n\n"

PS3='Choose an option: '

options=("Install freshplayer plugin" "enable or disable hardware acceleration" "enable or disable plugin" "update plugin" "uninstall plugin" "Quit")

select items in "${options[@]}"

do
  case $items in
    "Install freshplayer plugin")
      install_plugin;
    ;;
    "enable or disable hardware acceleration")
      enable_disable_hW
    ;;
    "enable or disable plugin")
      enable_disable
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
    *) echo  -e $RED "invalid option";;
  esac
  
  for i in "${options[@]}"
  do
    echo $((k++))")$i"
    
  done
  k=1;
  
done
clear



