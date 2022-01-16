#!/bin/bash

error() {
  echo "\\e[91m$1\\e[39m"
  exit 1
}

checkInternet() {
  echo "Checking internet connection..."
  wget -q --spider https://www.google.com/
  if [ $? -eq 0 ]; then
    echo "Online. Continuing..."
  else
    error "Offline. Please connect to internet then run the script again."
  fi
}

checkInternet

sudo docker pull dperson/samba:latest || error "Failed to pull lastest Samba docker image!"
sudo docker run -d -p 139:139 -p 445:445 --name samba --restart=always -e USERID=1001 -e GROUPID=1001 -e TZ=Asia/Bangkok -v ~/myTorrent:/mount1 -v ~/myData:/mount2 dperson/samba:latest -p -u "${USER};${PASWORD}" -s "chnwtPI-Torrent;/mount1;no;no;no;max180643" -s "chnwtPI-Data;/mount2;no;no;no;max180643" || error "Failed to run Samba docker image!"