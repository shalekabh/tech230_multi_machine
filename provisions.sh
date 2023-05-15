#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
cd tech230_app_deployment
cd app
sudo apt-get install nodejs -y
sudo apt-get install python-software-properties
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo apt-get install npm -y
sudo npm install pm2 -g
npm start
