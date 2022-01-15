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

sudo docker pull jacobalberty/unifi:latest || error "Failed to pull lastest UniFi docker image!"
sudo docker run -d --init --network=host --name unifi --restart=always -e TZ=Asia/Bangkok -e JVM_MAX_THREAD_STACK_SIZE=1280k -v ~/unifi:/unifi jacobalberty/unifi:latest || error "Failed to run UniFi docker image!"