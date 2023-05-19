# Steps to automate

Make sure you are ssh'd to your app terminal and create a file using:

```touch <name of file>``` or ```sudo nano <name of file>```

Ive called mine "provisions-app.sh" and "provisions-db.sh"

Transfer the commands from your local provision files to the bash one on the VM:

#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y

# Install nginx web server
sudo apt-get install nginx -y

# Start nginx web server 
sudo systemctl start nginx

# Display nginx web server status to check it is running
sudo systemctl status nginx

# Reverse proxy
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

sudo nginx -t - this checks all syntax is correct

sudo systemctl reload nginx

sudo systemctl enable ngix

# install app dependencies

sudo apt-get install python-software-properties

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

sudo apt-get install nodejs -y

cd app

sudo apt-get install npm

npm install

sudo npm install pm2 -g

node seeds/seed.js

pm2 start app.js --update-env



Save and exit:

```Ctrl + x```
```y```
```Enter```


Test the file by running it ```./provisions-app.sh```

If there are no errors then the script runs correctly (you may have to run it with sudo)

The script below is the reverse proxy:

```sudo bash -c 'cat <<EOF > /etc/nginx/sites-available/default
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
EOF' ```

```sudo bash -c 'cat <<EOF > /etc/nginx/sites-available/default```

sudo: Executes the subsequent command with superuser (root) privileges.

```bash -c '...'```: Starts a new Bash shell and executes the given command(s) within it.

```cat <<EOF > /etc/nginx/sites-available/default``` command is using a "Here Document" syntax in Bash. It allows you to input multiple lines of text into a command and redirect it to a file. In this case, the content between <<EOF and EOF is the input, and it will be written to the ```/etc/nginx/sites-available/default file. EOF = "End OF File"```

A simplified way of doing the same thing is using the sed command:

```sudo sed -i 's@try_files $uri $uri/=404;@location /posts {\n    proxy_pass http://localhost:3000/posts;\n}\n\n    location / {\n        proxy_pass http://localhost:3000;\n    }@g' /etc/nginx/sites-available/default ```

@: The delimiter character used in the sed command. In this case, @ is used as an alternative to the more commonly used / delimiter. It avoids conflicts with forward slashes in the pattern and replacement text.

```location /posts {\n proxy_pass http://localhost:3000/posts;\n}\n\n location / {\n proxy_pass http://localhost:3000;\n }```: This is the replacement text. It consists of multiple lines representing the desired NGINX configuration.

```location /posts {\n proxy_pass http://localhost:3000/posts;\n}```: It defines the new location block for /posts. The proxy_pass directive is set to ```http://localhost:3000/posts```, ensuring that requests to /posts are proxied to ```http://localhost:3000/posts```.

```location / {\n proxy_pass http://localhost:3000;\n}```: It defines the existing location block for /. The proxy_pass directive is set to ```http://localhost:3000```, which proxies all other requests to ```http://localhost:3000```.

Now we do the same for the database without the revesrse proxy.

The code is as follows :

```sudo apt-get update -y```
```sudo apt-get upgrade -y```
```sudo apt install -y mongodb```
```sudo apt-get install -y mongodb-org=3.6.8 mongodb-org-server=3.6.8 mongodb-org->```
```sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5>```
```echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongo>```
```sudo apt-get update -y```
```sudo apt-get upgrade -y```
```sudo systemctl start mongodb```
```sudo systemctl enable mongodb```
```sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf``` - this overwrites the bind ip to what we need
```sudo systemctl restart mongod```
```sudo systemctl enable mongod```

### Automate environment variable

Add this to your provisions-app.sh:

```echo 'export DB_HOST=mongodb://192.168.10.150:27017/posts' >> ~/.bashrc``` - This uses ```echo``` to repeat what has and ```>>``` means append whatever has bee written to the .bashrc file.

make sure the IP is your mongodb current IP.

Refresh the file to implement changes:

```source ~/.bashrc```


### Automate Bind ip

```sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf``` - This uses ```sed``` which means stream editor and is used for text manipulation. ```i``` is an option for ```sed``` and means it will directly modify the file. ```'s``` means substitution. ```g'``` is the global flag. The numbers before the / are to be replaced witht the numbers after the /.
