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

sudo docker pull linuxserver/rutorrent:arm64v8-latest || error "Failed to pull lastest ruTorrent docker image!"
sudo docker run -d -p 8100:80 -p 5000:5000 -p 6881:6881 -p 6881:6881/udp --name rutorrent --restart=always -e USERID=1000 -e GROUPID=1000 -e TZ=Asia/Bangkok -v ~/rutorrent/config:/config -v ~/myTorrent/downloads:/downloads linuxserver/rutorrent:arm64v8-latest || error "Failed to run ruTorrent docker image!"