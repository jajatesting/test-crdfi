#!/bin/bash

#sudo apt-get -y update && sudo apt -y install nginx awscli
#mkdir -p .aws
#touch .aws/credentials
#touch .aws/config
#echo "[default]" > .aws/credentials

#echo  "[default]">.aws/config
#echo "region = eu-west-1" >>.aws/config
#aws s3 cp s3://webpage-nay/index.html index.html && sudo cp index.html /var/www/html/index.html
sudo echo " server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /home/ubuntu/;
        server_name _;
        location / {
                try_files $uri $uri/ =404;
        }
}" >/etc/nginx/sites-available/probizit.cfg
cd /etc/nginx/sites-enabled/ && sudo ln -s /etc/nginx/sites-available/probizit.cfg .

sudo service nginx restart
