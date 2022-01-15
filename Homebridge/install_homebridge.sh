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

sudo docker pull oznu/homebridge:latest || error "Failed to pull lastest HomeBridge docker image!"
sudo docker run -d --network=host --name homebridge --restart=always -e TZ=Asia/Bangkok -e HOMEBRIDGE_CONFIG_UI=1 -e HOMEBRIDGE_CONFIG_UI_PORT=8500 -v ~/homebridge:/homebridge oznu/homebridge:latest || error "Failed to run HomeBridge docker image!"