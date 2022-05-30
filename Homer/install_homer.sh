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

sudo docker pull b4bz/homer:latest || error "Failed to pull lastest Homer docker image!"
sudo docker run -d -p 8400:8080 --name homer --restart=always -e UID=1000 -e GID=1000 -v ~/homer/assets:/www/assets b4bz/homer:latest || error "Failed to run Homer docker image!"