#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y

# Install nginx web server
sudo apt-get install nginx -y

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

# Define the line to add to .bashrc
line="export DB_HOST=mongodb://192.168.10.150:27017/posts"

# Append the line to .bashrc if it doesn't already exist
grep -qxF "$line" ~/.bashrc || echo "$line" >> ~/.bashrc

source .bashrc
# Configure nginx
sudo bash -c 'cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/html;
    server_name 192.168.10.100;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
    location /posts {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF'

sudo nginx -t

sudo systemctl reload nginx

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
