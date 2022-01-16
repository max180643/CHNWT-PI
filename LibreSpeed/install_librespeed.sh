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

sudo docker pull linuxserver/librespeed:latest || error "Failed to pull lastest LibreSpeed docker image!"
sudo docker run -d -p 8200:80 --name librespeed --restart=always -e PUID=1001 -e PGID=1001 -e TZ=Asia/Bangkok linuxserver/librespeed:latest || error "Failed to run LibreSpeed docker image!"