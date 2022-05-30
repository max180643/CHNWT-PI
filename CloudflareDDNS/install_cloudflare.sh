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

sudo docker pull oznu/cloudflare-ddns:latest || error "Failed to pull lastest Cloudflare DDNS docker image!"
sudo docker run -d --name cloudflare --restart=always -e PUID=1000 -e PGID=1000 -e API_KEY=xxxxxxx -e ZONE=example.com -e SUBDOMAIN=subdomain -e PROXIED=true oznu/cloudflare-ddns:latest || error "Failed to run Cloudflare DDNS docker image!"