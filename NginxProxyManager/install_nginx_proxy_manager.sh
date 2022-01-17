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

sudo docker pull jc21/nginx-proxy-manager:latest || error "Failed to pull lastest Nginx Proxy Manager docker image!"
sudo docker run -d -p 80:80 -p 81:81 -p 443:443 --name nginx-proxy-manager --restart=always -v ~/nginx-proxy-manager/data:/data -v ~/nginx-proxy-manager/letsencrypt:/etc/letsencrypt jc21/nginx-proxy-manager:latest || error "Failed to run Nginx Proxy Manager docker image!"