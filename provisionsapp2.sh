#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y

# Install nginx web server
sudo apt-get install nginx -y

# install sed
sudo apt install sed -y

#install git
sudo apt install git

# Start nginx web server
sudo systemctl start nginx

# Display nginx web server status to check if it is running
sudo systemctl status nginx

# Install app dependencies
sudo apt-get install -y python-software-properties
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
cd app
sudo apt-get install -y npm
sudo npm install
sudo npm install -g pm2

# Copy files using using git
git clone https://github.com/shalekabh/app.git

# Set the environment variable
echo 'export DB_HOST=mongodb://192.168.10.150:27017/posts' >> ~/.bashrc

# Refresh the current shell session to apply the changes
source ~/.bashrc


# Configure nginx

#sudo sed -s "s+try_files $uri $uri/=404+proxy_pass httpe://localhost:3000;@g"
#sudo sed -i 's@try_files $uri $uri/=404;@proxy_pass http://localhost:3000;@g' /etc/nginx/sites-available/default
sudo sed -i 's@try_files $uri $uri/=404;@location /posts {\n    proxy_pass http://localhost:3000/posts;\n}\n\n    location / {\n        proxy_pass http://localhost:3000;\n    }@g' /etc/nginx/sites-available/default

# sudo bash -c 'cat <<EOF > /etc/nginx/sites-available/default
# server {
#     listen 80 default_server;
#     listen [::]:80 default_server;
#     root /var/www/html;
#     server_name 192.168.10.100;

#     location / {
#         proxy_pass http://localhost:3000;
#         proxy_http_version 1.1;
#         proxy_set_header Upgrade \$http_upgrade;
#         proxy_set_header Connection 'upgrade';
#         proxy_set_header Host \$host;
#         proxy_cache_bypass \$http_upgrade;
#     }
#     location /posts {
#         proxy_pass http://localhost:3000;
#         proxy_http_version 1.1;
#         proxy_set_header Upgrade \$http_upgrade;
#         proxy_set_header Connection 'upgrade';
#         proxy_set_header Host \$host;
#         proxy_cache_bypass \$http_upgrade;
#     }
# }
# EOF'

sudo nginx -t

sudo systemctl reload nginx

#stop the app if its running 
pm2 stop app.js

# Start the app using PM2
pm2 start app.js

# Save the PM2 configuration to automatically start the app on system reboot
pm2 save
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu

# Make sure app is started on system reboot
sudo systemctl enable pm2-ubuntu

# Restart the server to apply all changes
sudo systemctl reboot

sudo npm start








# sudo apt-get update -y
# sudo apt-get upgrade -y
# sudo apt-get install nginx -y
# sudo apt install sed -y
# sudo apt install git
# echo 'export DB_HOST=mongodb://18.203.95.206:27017/posts' >> ~/.bashrc
# source .bashrc
# sudo sed -i 's@try_files $uri $uri/=404;@location /posts {\n    proxy_pass http://localhost:3000/posts;\n}\n\n    location / {\n        proxy_pass http://localhost:3000;\n    }@g' /etc/nginx/sites-available/default
# sudo systemctl start nginx
# sudo systemctl enable nginx
# sudo apt-get install -y git
# sudo apt-get install -y python-software-properties
# curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
# sudo apt-get install -y nodejs
# git clone https://github.com/shalekabh/app.git
# cd app
# sudo apt-get install -y npm
# sudo npm install
# sudo npm install -g pm2
# sudo nginx -t
# sudo systemctl restart nginx
# sudo systemctl enbale nginx
# node seeds/seed.js
# pm2 stop app.js
# pm2 start app.js --update-env

