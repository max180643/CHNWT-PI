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

sudo docker pull filebrowser/filebrowser:latest || error "Failed to pull lastest FileBrowser docker image!"
sudo docker run -d -p 8300:80 --name filebrowser --restart=always -e PUID=1000 -e PGID=1000 -v ~/drive:/srv -v ~/filebrowser/filebrowser.db:/database/filebrowser.db -v ~/filebrowser/settings.json:/config/settings.json filebrowser/filebrowser:latest || error "Failed to run FileBrowser docker image!"