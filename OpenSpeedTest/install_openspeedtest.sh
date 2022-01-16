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

sudo docker pull openspeedtest/latest:latest || error "Failed to pull lastest OpenSpeedTest docker image!"
sudo docker run -d -p 8200:3000 -p 8201:3001 --name openspeedtest --restart=always openspeedtest/latest:latest || error "Failed to run OpenSpeedTest docker image!"