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

sudo docker pull linuxserver/qbittorrent:arm64v8-latest || error "Failed to pull lastest qBittorrent docker image!"
sudo docker run -d -p 8110:8080 -e WEBUI_PORT=8080 -p 6882:6881 -p 6882:6881/udp -v ~/qbittorrent/config:/config -v ~/myTorrent/downloads:/downloads --name qBittorrent --restart=always -e PUID=1000 -e PGID=1000 -e TZ=Asia/Bangkok linuxserver/qbittorrent:arm64v8-latest || error "Failed to run qBittorrent docker image!"